function B = orthonormal_basis(V, W)
% ORTHONORMAL_BASIS creates an orthonormal basis from a pure quaternion V,
% and an optional pure quaternion W, which need not be perpendicular to V,
% but must not be parallel.
%
% The result is represented as a 3 by 3 orthogonal matrix, which may be
% complex if V and/or W are complex pure quaternions.

% Copyright © 2005 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

error(nargchk(1, 2, nargin)), error(nargoutchk(0, 1, nargout))

if ~isscalar(V)
    error('V must not be a vector or matrix.');
end

if ~isa(V, 'quaternion') || ~ispure(V)
    error('V must be a pure quaternion.')
end

V = unit(V); % Ensure that V is a unit pure quaternion.

if nargin == 1
    W = orthogonal(V);
else
    W = orthogonal(V, W);
end

X = orthogonal(V, W);

B = [x(V), y(V), z(V); x(W), y(W), z(W); x(X), y(X), z(X)];

% It is possible for the result to be inaccurate, and therefore we check
% that B is sufficiently orthogonal before returning. Error is particularly
% likely in the complex case if V and/or W is not defined accurately.
% (See the discussion note in the function unit.m.)

if norm(B * B.' - eye(3)) > 5 * eps
    warning('The basis matrix is not accurately orthogonal.');
end
