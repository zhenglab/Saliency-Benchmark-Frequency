function C = adjoint(A, F)
% ADJOINT   Computes the adjoint of the quaternion matrix A.
%
% adjoint(A) or
% adjoint(A, 'complex') returns a complex adjoint matrix.
% adjoint(A, 'real')    returns a real    adjoint matrix.
%
% The definition of the adjoint matrix is not unique (several permutations
% of the layout are possible). Both adjoints are valid for complex as well
% as real quaternions.

% Copyright © 2005 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

error(nargchk(1, 2, nargin)), error(nargoutchk(0, 1, nargout))

if nargin == 1
    F = 'complex'; % Supply the default parameter value.
end

if ~strcmp(F, 'real') && ~strcmp(F, 'complex')
    error('Second parameter value must be ''real'' or ''complex''.')
end

% Extract the components of A. We use scalar() and not s() so that we
% get zero if A is pure.

W = scalar(A); X = x(A); Y = y(A); Z = z(A);

if strcmp(F, 'complex')

    % Reference:
    %
    % F. Z. Zhang, Quaternions and Matrices of Quaternions,
    % Linear Algebra and its Applications, 251, January 1997, 21-57.

    % Zhang's paper does not consider the case where the elements of the
    % quaternion are complex, but the adjoint definition is valid in this
    % case, although the four components of the quaternion are mixed among
    % the elements of the adjoint: this means that they must be unmixed by
    % the corresponding function unadjoint (using sums and differences).
    
    A1 = W + i .* X;
    A2 = Y + i .* Z;
    
    C = [[ W + i .* X, Y + i .* Z]; ...
         [-Y + i .* Z, W - i .* X]];

else % F must be 'real', since we checked it above.
    
    % Reference:
    %
    % Todd A. Ell, 'Quaternion Notes', 1993-1999, unpublished, defines the
    % layout for a single quaternion. The extension to matrices of
    % quaternions follows easily in similar manner to Zhang above.

    % An equivalent matrix representation for a single quaternion is noted
    % by Ward, J. P., 'Quaternions and Cayley numbers', Kluwer, 1997, p91.
    % It is the transpose of the representation used here.

    C = [[ W,  X,  Y,  Z]; ...
         [-X,  W, -Z,  Y]; ...
         [-Y,  Z,  W, -X]; ...
         [-Z, -Y,  X,  W]];
end
