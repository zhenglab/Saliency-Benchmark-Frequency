function m = mean(X, dim)
% MEAN   Average or mean value.
% (Quaternion overloading of standard Matlab function.)

% Copyright © 2005 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

error(nargchk(1, 2, nargin)), error(nargoutchk(0, 1, nargout)) 

if nargin == 1
    if ispure_internal(X)
        m = class(compose(mean(exe(X)), ...
                          mean(wye(X)), ...
                          mean(zed(X))), 'quaternion');
    else
        m = class(compose(mean(ess(X)), ...
                          mean(vee(X))), 'quaternion');
    end
else
    if ispure_internal(X)
        m = class(compose(mean(exe(X), dim), ...
                          mean(wye(X), dim), ...
                          mean(zed(X), dim)), 'quaternion');
    else
        m = class(compose(mean(ess(X), dim), ...
                          mean(vee(X), dim)), 'quaternion');
    end
end
