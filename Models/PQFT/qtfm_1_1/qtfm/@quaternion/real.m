function p = real(q)
% REAL   Real part of a quaternion.
% (Quaternion overloading of standard Matlab function.)
%
% This function returns the quaternion that is the real
% part of q.

% Copyright © 2005 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

error(nargchk(1, 1, nargin)), error(nargoutchk(0, 1, nargout))

if ispure_internal(q)
    p = class(compose(real(exe(q)), ...
                      real(wye(q)), ...
                      real(zed(q))), 'quaternion');
else
    p = class(compose(real(ess(q)), real(vee(q))), 'quaternion');
end

