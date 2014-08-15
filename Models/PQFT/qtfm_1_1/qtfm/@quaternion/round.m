function a = round(q)
% ROUND Round towards nearest integer.
% (Quaternion overloading of standard Matlab function.)

% Copyright © 2006 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

error(nargchk(1, 1, nargin)), error(nargoutchk(0, 1, nargout)) 

if ispure_internal(q)
    a = class(compose(round(exe(q)), ...
                      round(wye(q)), ...
                      round(zed(q))), 'quaternion');
else
    a = class(compose(round(ess(q)), ...
                      round(exe(q)), ...
                      round(wye(q)), ...
                      round(zed(q))), 'quaternion');
end
