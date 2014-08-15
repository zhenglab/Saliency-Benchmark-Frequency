function n = modsquared(q)
% Modulus squared of a quaternion.

% Copyright © 2005 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

error(nargchk(1, 1, nargin)), error(nargoutchk(0, 1, nargout))

% Implementation note. We do not use q .* conj(q) because this would give
% a quaternion result with a zero vector part. It is better not to compute
% the vector part.

if ispure_internal(q)
    n =              exe(q).^2 + wye(q).^2 + zed(q).^2;
else
    n = ess(q).^ 2 + exe(q).^2 + wye(q).^2 + zed(q).^2;
end
