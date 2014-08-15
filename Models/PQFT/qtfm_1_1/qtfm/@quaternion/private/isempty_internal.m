function x = isempty_internal(q)
% Determines whether q is empty. This function has to know the
% representation of a quaternion, whereas the function isempty()
% does not.

% Copyright © 2005 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

error(nargchk(1, 1, nargin)), error(nargoutchk(0, 1, nargout))

x = isempty(q.w) & isempty(q.x) & isempty(q.y) & isempty(q.z);

% Implementation note. Since a quaternion cannot have a mix of empty and
% non-empty components (apart from the case of a pure quaternion, where the
% scalar part is empty), it is not necessary to test all three of the x, y,
% z components. So, maybe it would be OK here to code this as:
%
%       x = isempty(q.x);
