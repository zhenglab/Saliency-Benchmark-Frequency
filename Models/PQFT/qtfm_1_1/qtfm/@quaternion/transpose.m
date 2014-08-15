function t = transpose(a)
% .'  Transpose.
% (Quaternion overloading of standard Matlab function.)

% Copyright © 2005 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

error(nargchk(1, 1, nargin)), error(nargoutchk(0, 1, nargout)) 

if ispure_internal(a)
    t = class(compose(transpose(exe(a)), ...
                      transpose(wye(a)), ...
                      transpose(zed(a))), 'quaternion');
else
    t = class(compose(transpose(ess(a)), ...
                      transpose(exe(a)), ...
                      transpose(wye(a)), ...
                      transpose(zed(a))), 'quaternion');
end
