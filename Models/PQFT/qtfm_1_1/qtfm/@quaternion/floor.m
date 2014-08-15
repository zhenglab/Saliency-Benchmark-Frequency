function a = floor(q)
% FLOOR  Round towards minus infinity.
% (Quaternion overloading of standard Matlab function.)

% Copyright © 2006 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

error(nargchk(1, 1, nargin)), error(nargoutchk(0, 1, nargout)) 

if ispure_internal(q)
    a = class(compose(floor(exe(q)), ...
                      floor(wye(q)), ...
                      floor(zed(q))), 'quaternion');
else
    a = class(compose(floor(ess(q)), ...
                      floor(exe(q)), ...
                      floor(wye(q)), ...
                      floor(zed(q))), 'quaternion');
end
