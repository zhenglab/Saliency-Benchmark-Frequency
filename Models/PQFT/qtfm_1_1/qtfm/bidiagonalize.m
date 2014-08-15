function [U, B, V] = bidiagonalize(A)
% Bidiagonalize A,  such that U * A * V = B and U' * B * V' = A. B is the
% same size as A, has no vector part, and is upper or lower bidiagonal
% depending on its shape. U and V are unitary quaternion matrices. 

% Copyright © 2005 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

error(nargchk(1, 1, nargin)), error(nargoutchk(3, 3, nargout))

% References:
%
% Sangwine, S. J. and Le Bihan, N.,
% Quaternion singular value decomposition based on bidiagonalization
% to a real or complex matrix using quaternion Householder transformations,
% Applied Mathematics and Computation, 182(1), 1 November 2006, 727-738, 
% DOI:10.1016/j.amc.2006.04.032.
%
% Sangwine, S. J. and Le Bihan, N.,
% Quaternion Singular Value Decomposition based on Bidiagonalization
% to a Real Matrix using Quaternion Householder Transformations,
% arXiv:math.NA/0603251, 10 March 2006, available at http://www.arxiv.org/

% NB: This is a reference implementation. It uses explicit Householder
% matrices. Golub and van Loan, 'Matrix Computations', 2e, 1989, section
% 5.1.4 discusses efficient calculation of Householder transformations.
% This has been tried (see bidiagonalize2.m), but found to be slower than
% the use of explicit matrices as used here. This requires further study.

[r, c] = size(A);

if prod([r, c]) == 1
    error('Cannot bidiagonalize a matrix of one element.');    
end

if c <= r
    [U, B, V] = internal_bidiagonalizer(A); % Gives an upper bidiagonal result.
else
    % This requires a lower bidiagonal result. We handle this by a recursive
    % call on the Hermitian transpose of A.  The results for U and V must be
    % interchanged and B must be transposed to get the correct result for A.
    
    [V, B, U] = internal_bidiagonalizer(A'); B = B.';
end

V = V';       % Transpose and conjugate V for compatibility with earlier code.
B = check(B); % Verify the result and convert to exactly bidiagonal form.

% ----------------------------------------------------------------------------

function [U, B, V] = internal_bidiagonalizer(A)

[r, c] = size(A);

% Compute and apply a Householder transformation to the first column of A.
    
U = householder_matrix(A(:, 1), eye(r, 1)); B = U * A;
V = quaternion(eye(c));

% If there is more than one column, we now need to transform the first row (excluding the
% first element). A recursive call on the transposed conjugate matrix does this. The left
% and right unitary results are interchanged.

if c > 1
    [V(2 : end, 2 : end), T, W] = internal_bidiagonalizer(B(:, 2 : end)');
    B(:, 2 : end) = T.';
    U = W * U;
end

% ---------------------------------------------------------------------------------------------

function R = check(B)

% Verify results, and convert the result to exactly bidiagonal form with no vector part.

[r, c] = size(B);

if r == 1 || c == 1
    % The matrix is degenerate (a row or column vector) and we have to deal
    % with it differently because the Matlab diag function in this case
    % constructs a matrix instead of extracting the diagonal (how clever to
    % use the same name for both ideas!).
    D = B(1); % The first element is the diagonal. There is no super-diagonal.
    O = B(2 : end); % The rest is the off-diagonal.
elseif c <= r
    D = [diag(B); diag(B, +1)];    % Extract the diagonal and super-diagonal.
    O = tril(B, -1) + triu(B, +2); % Extract the off-diagonal part.
else
    D = [diag(B); diag(B, -1)];    % Extract the diagonal and sub-diagonal.
    O = tril(B, -2) + triu(B, +1); % Extract the off-diagonal part.
end

% Find the largest on and off bidiagonal elements. We use abs twice to
% allow for the case where B is complex (this occurs when A is a complexified
% quaternion matrix).

T1 = max(max(abs(abs(O)))); % Find the largest off bidiagonal element.
T2 =     max(abs(abs(D)));  % Find the largest bidiagonal element.

% NB T2 and/or T1 could be exactly zero (example, if A was zero, or an identity matrix).
% Therefore we do not divide one by the other, but instead multiply by a tolerance.

tolerance = eps .* 1.0e4; % This is empirically determined.

if T1 > T2 * tolerance
    warning('Result of bidiagonalization was not accurately diagonal.');
    disp('Information: largest on- and off-bidiagonal moduli were:');
    disp(T2);
    disp(T1);
end

% Verify that the diagonal elements have neglible vector parts.

T2 = max(abs(abs(s(D)))); % The largest scalar modulus of the bidiagonal result
T1 = max(abs(abs(v(D)))); % The largest vector modulus of the bidiagonal result.

if T1 > T2 * tolerance
    warning('Result of bidiagonalization was not accurately scalar.')
    disp('Information: largest on-diagonal scalar and vector moduli were:');
    disp(T2);
    disp(T1);
end

if r == 1 || c == 1
    R = s(B); % The diagonal has only one element, so we can just forget the off-diagonal.
else
    R = s(B - O); % Subtract the off-diagonal part and take the scalar part of the result.
end

