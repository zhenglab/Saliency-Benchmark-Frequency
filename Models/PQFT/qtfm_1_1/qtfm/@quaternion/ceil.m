function a = ceil(q)
% CEIL   Round towards plus infinity.
% (Quaternion overloading of standard Matlab function.)

% Copyright © 2006 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

error(nargchk(1, 1, nargin)), error(nargoutchk(0, 1, nargout)) 

if ispure_internal(q)
    a = class(compose(ceil(exe(q)), ...
                      ceil(wye(q)), ...
                      ceil(zed(q))), 'quaternion');
else
    a = class(compose(ceil(ess(q)), ...
                      ceil(exe(q)), ...
                      ceil(wye(q)), ...
                      ceil(zed(q))), 'quaternion');
end
