function a = fix(q)
% FIX Round towards zero.
% (Quaternion overloading of standard Matlab function.)

% Copyright © 2006 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

error(nargchk(1, 1, nargin)), error(nargoutchk(0, 1, nargout)) 

if ispure_internal(q)
    a = class_compose(fix(exe(q)), ...
                      fix(wye(q)), ...
                      fix(zed(q))), 'quaternion');
else
    a = class_compose(fix(ess(q)), ...
                      fix(exe(q)), ...
                      fix(wye(q)), ...
                      fix(zed(q))), 'quaternion');
end
