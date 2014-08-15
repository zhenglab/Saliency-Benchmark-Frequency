function [U, B, V] = bidiagonalize2(A)
% Bidiagonalize A,  such that U * A * V = B and U' * B * V' = A. B is the
% same size as A, has no vector part, and is upper or lower bidiagonal
% depending on its shape. U and V are unitary quaternion matrices. 

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

% This is an improved version of the reference implementation. It does not
% use explicit Householder matrices but instead computes the equivalent
% matrix update as detailed in section 5.1.4. [p196] of :
%
% Gene H. Golub and Charles F. van Loan, 'Matrix Computations',
% Johns Hopkins University Press, 2nd edition, 1989.
%
% This code has not replaced the code in bidiagonalize.m because it is
% actually slower! It is intended to integrate this code into
% bidiagonalize.m at a later date, as it will work for matrices where the
% explicit Householder matrix would be too big.

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
B = check(B); % Verify the result and convert to exactly bidiagonal real form.

% ----------------------------------------------------------------------------

function [U, B, V] = internal_bidiagonalizer(A)

[r, c] = size(A);

% Compute and apply a Householder transformation to the first column of A.
    
% Old code using explicit Householder matrix:
% U = householder_matrix(A(:, 1), eye(r, 1));

[u, zeta] = householder_vector(A(:, 1), eye(r, 1)); % New code;

% Old matrix product using explicit Householder matrix U:
% B = U * A;

B = (1./zeta) .* (A - u * (A' * u)'); % New code.

V = quaternion(eye(c));

% If there is more than one column, we now need to transform the first row (excluding the
% first element). A recursive call on the transposed conjugate matrix does this. The left
% and right unitary results are interchanged.

if c > 1
    [V(2 : end, 2 : end), T, W] = internal_bidiagonalizer(B(:, 2 : end)');
    B(:, 2 : end) = T.';

    % Old code, involving explicit Householder matrix:
    % U = W * U;

    W = W .* (1./zeta);   % New code, step 1: premultiply zeta into W.
    U = W - (W * u) * u'; % New code.
else
    % c must be 1. We have to form the Householder matrix explicitly in this case.
    % Since c is 1, the matrix has only one element, so this is easy and fast.
    U = (1 ./ zeta) .* (quaternion(1,0,0,0) - u .* conj(u));
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

T1 = max(max(abs(O))); % Find the modulus of the largest off bidiagonal element.
T2 =     max(abs(D));  % Find the modulus of the largest     bidiagonal element.

% Note that T1 and T2 may be complex, if A was a complexified quaternion matrix. Therefore we
% take the modulus of each before comparing them. This has no effect if T1 and 2 are real. NB
% T2 and/or T1 could be exactly zero (example, if A was zero, or an identity matrix).
% Therefore we do not divide one by the other, but instead multiply by eps.

if abs(T1) > abs(T2) * eps * 2
    warning('Result of bidiagonalization was not accurate.');
    disp('Information: largest on- and off-bidiagonal moduli were:');
    disp(abs(T2));
    disp(abs(T1));
end

% Verify that the diagonal elements have neglible vector parts.

T1 = max(abs(s(D))); % The largest scalar modulus of the bidiagonal result
T2 = max(abs(v(D))); % The largest vector modulus of the bidiagonal result.

if abs(T2) > abs(T1) * eps
    warning('Result of bidiagonalization was not accurate.')
    disp('Information: largest on-diagonal vector and scalar moduli were:');
    disp(abs(T2));
    disp(abs(T1));
end

if r == 1 || c == 1
    R = s(B); % The diagonal has only one element, so we can just forget the off-diagonal.
else
    R = s(B - O); % Subtract the off-diagonal part and take the scalar part of the result.
end

