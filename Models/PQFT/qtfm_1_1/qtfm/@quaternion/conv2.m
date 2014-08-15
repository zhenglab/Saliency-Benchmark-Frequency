function C = conv2(w, x, y, z)
% CONV2 Two dimensional convolution.
% (Quaternion overloading of standard Matlab function.)

% Copyright © 2006 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

% This function operates in a similar way to the standard Matlab function
% apart from supporting both left and right coefficients. (Since quaternion
% multiplication is not commutative, the general case requires both left
% and right multiplication in the convolution product/summation.) The
% Matlab function allows the first two parameters to be vectors - this is
% not implemented as yet. Acceptable calling profiles are:
%
% C = conv2(A, B)      - A is convolved on the left of B, that is A * B
% C = conv2({L, R}, B) - The convolution is L * B * R. L and R must be of
%                        the same size.
%
% An optional last parameter can specify 'shape' as for the standard Matlab
% function. This is currently not implemented.

error(nargchk(2, 4, nargin)), error(nargoutchk(0, 1, nargout))

if nargin == 4
    error('conv2 does not yet support 4 parameters.')
end

% If two or three parameters are supplied, the first two can be either two
% matrices, or a cell array and a matrix. The cell array must contain two
% matrices of the same size, but they need not be quaternion valued, since
% they could be real or complex.
        
if iscell(w)
    % The first parameter must be a cell array of two elements, and the
    % elements must have the same size.
    
    if length(w) ~= 2
        error('If a cell array, the first parameter must have two elements.')
    end
    
    L = w{1}; R = w{2};
    
    if ~all(size(L) == size(R))
        error('The elements of the cell array must have the same size.')
    end
    
    B = x; % The second parameter must be a matrix.
           % Should we do any checks on it here?
else
    % The first parameter must be a matrix (or vector). It need not
    % be quaternion-valued, since it could be a left matrix of
    % coefficients. We treat the smaller matrix as a coefficient
    % matrix, but put it on the left or right according to its
    % position in the parameter list, and create a matrix of ones
    % of the same size for the coefficient on the opposite side.

    if numel(w) < numel(x) % Is this the best comparison that could be done?
        L = w; B = x; R = ones(size(w));
    else
        L = ones(size(x)); B = w; R = x;
    end
end

if nargin == 3
    
    % The third parameter must be a 'shape' parameter. Check for the
    % legal possibilities.
    
    if ~ischar(y)
        error('Third parameter must be a string.');
    end

    if ~strcmp(y, 'full') && ~strcmp(y, 'same') && ~strcmp(y, 'valid')
        error(['The third parameter must be one of', ...
            '''full'', ''same'', or ''valid'''])
    else
        shape = y;
    end
else
    shape = 'full'; % This wasn't specified, so use a default value.
end

% The variables L, B, R now contain the matrices to be convolved, in the
% order L * B * R.

[ma, na] = size(L); % This is the same as size(R), of course
[mb, nb] = size(B); % (we checked that above).
mc = ma + mb - 1;
nc = na + nb - 1;

C = quaternion(zeros(mc, nc)); % Preconstruct the result array.

for n1 = 1 : mc
    
    % This code is vectorized: the two arrays are sliced to extract the
    % parts that must be multiplied element by element and summed to give
    % the current element of the output array. This is complicated by the
    % cases where one array overlaps the edge(s) of the other.

    k11 = max(1, n1 + 1 - mb); % These index values are invariant inside
    k12 = min(n1, ma);         % the inner loop. Computing them here and
    a1  = n1 + 1 - k12;        % storing the value in a variable saves a
    a2  = n1 + 1 - k11;        % significant amount of time.
    
    for n2 = 1 : nc

        k21 = max(1, n2 + 1 - nb); k22 = min(n2, na);

        % We need to use indexing here, but since this is a class method,
        % normal array indexing doesn't work. See the comment in the file
        % svd.m where the same problem and solution occurs. The commented
        % statement below is what we would write if array indexing worked
        % here as per normal.
        % C(n1, n2) =  ...
        % sum(L(k11:k12, k21:k22) .* B(n1 + 1 - k1, n2 + 1 - k2) .* ...
        %     R(k11:k12, k21:k22));
        
        % The use of flipud and fliplr is for compatibility with the Matlab
        % conv2 function so that a quaternion array with zero scalar part
        % gives the same result as the scalar part convolved with the
        % Matlab function.

        t = substruct('()',{k11:k12, k21:k22});        
        C = subsasgn(C, substruct('()',{n1, n2}), ...
            sum(sum(subsref(L, t) .* ...
                    flipud(fliplr(...
                     subsref(B, ...
                     substruct('()', {a1           : a2, ...
                                      n2 + 1 - k22 : n2 + 1 - k21})))) ...
                    .* subsref(R, t)) ...
            ));
    end
end

if ~strcmp(shape, 'full')
    error('The shape parameter is not implemented.')
end

% Note: a significant speedup might be possible by not slicing L and R for
% the array elements in B where there is no overlap with the edges of B.
% For a large array B, this would be the majority of array elements. To do
% this, the code would be divided into two cases: the inner core of B where
% L and R can be used without slicing, and the outer edge of B where some
% elements of L and R would be outside the edge of B.
