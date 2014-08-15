function C = conv(A, B)
% CONV Convolution and polynomial multiplication.
% (Quaternion overloading of standard Matlab function.)

% Copyright © 2006 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

% This function operates in the same way as the standard Matlab function
% apart from supporting both left and right coefficients. (Since quaternion
% multiplication is not commutative, the general case requires both left
% and right multiplication in the convolution product/summation.) To supply
% left and right coefficients, use the calling profile conv({L,R},v) where
% L and R are vectors of the same length and orientation. If the first
% parameter is not a cell array, it is taken to be a left coefficient and
% the right coefficient array is implicitly ones.

error(nargchk(2, 2, nargin)), error(nargoutchk(0, 1, nargout))

if iscell(A)
    % The first parameter must be a cell array of two elements, and the
    % elements must have the same size (therefore orientation).
    
    if length(A) ~= 2
        error('If a cell array, the first parameter must have two elements.')
    end
    
    L = A{1}; R = A{2}; % Separate the cell array into two vectors.

    if ~all(size(L) == size(R))
        error('The elements of the cell array must have the same size.')
    end
else
    L = A;
    R = ones(size(L)); % Supply the implicit right coefficients.
end

if ~isvector(L) || ~isvector(B)
    error('Parameters must be vectors.')
end

m = length(L);
n = length(B);

% Construct a result vector C matching the orientation of the longer of
% L or B in order to return a result compatible with the standard Matlab
% conv function.

if m > n
    % w must have the same orientation as u.
    if size(L, 1) == 1
        C = quaternion(zeros(1, m + n - 1));
    else
        C = quaternion(zeros(m + n - 1, 1));
    end
end
if m < n
    % w must have the same orientation as q.
    if size(B, 1) == 1
        C = quaternion(zeros(1, m + n - 1));
    else
        C = quaternion(zeros(m + n - 1, 1));
    end
end
if m == n
    % The two parameters are of equal length. In this case Matlab's conv
    % function seems to return a column vector unless both parameters are
    % row vectors.
    if size(L, 1) == 1 && size(B, 1) == 1
        C = quaternion(zeros(1, m + n - 1));
    else
        C = quaternion(zeros(m + n - 1, 1));        
    end
end

% To ensure that we can multiply L .* B .* R we need them to have the same
% orientation (row, column). If B doesn't match the orientation of L,
% transpose it.

if (size(L, 1) == 1 && size(B, 1) ~= 1) || (size(L, 2) == 1 && size(B, 2) ~= 1)
    B = B.';
end

for k = 1:length(C) % For each element of the output array.
    
    % This code is vectorized: the two arrays are sliced to extract the
    % parts that must be multiplied element by element and summed to give
    % the current element of the output array. This is complicated by the
    % cases where one array overlaps the end of the other.
    
    j1 = max(1, k + 1 - n); % These two indices select a region of the L
    j2 = min(k, m);         % and R arrays (the whole of, in the general
                            % case).
    
    % We need to use indexing here, but since this is a class method,
    % normal array indexing doesn't work. See the comment in the file
    % svd.m where the same problem and solution occurs. The commented
    % statement below is what we would write if array indexing worked
    % here as per normal.
    % C(k) = sum(L(j1 : j2) .* B(k + 1 - j1 : k + 1 - j2) .* R(j1 : j2));

    s = substruct('()',{k});
    t = substruct('()',{j1:j2});
    C = subsasgn(C, s, ...
        sum(subsref(L, t) .* ...
            flipud(fliplr(subsref(B, substruct('()', {k + 1 - j2 : k + 1 - j1})))) .* ...
            subsref(R, t)));
end

% Implementation note: the use of ones(size(u)) for v in the case where v
% is omitted is a crude hack and it would be better not to multiply by the
% right coefficients at all. Also if only two parameters are given it would
% be better to assign the longer of the two to q, and the shorter to u or v
% according as to whether it should be multiplied on the left or right.

% The code also needs to be sorted out to tidy up the mess caused by trying
% to return a result with the same orientation as Matlab's built-in in
% conv. One of the consequences of this is the need to do flipud and
% fliplr, one of which is a no-operation, but which one depends on the
% orientation of the vector.
