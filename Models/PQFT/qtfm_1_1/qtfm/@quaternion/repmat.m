function b = repmat(a, m, n)
% REPMAT Replicate and tile an array.
% (Quaternion overloading of standard Matlab function.)

% Copyright © 2005 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

error(nargchk(2, 3, nargin)), error(nargoutchk(0, 1, nargout)) 

if nargin == 2
    if ispure_internal(a)
        b = class(compose(repmat(exe(a), m), ...
                          repmat(wye(a), m), ...
                          repmat(zed(a), m)), 'quaternion');
    else
        b = class(compose(repmat(ess(a), m), ...
                          repmat(vee(a), m)), 'quaternion');
    end
else
    if ispure_internal(a)
        b = class(compose(repmat(exe(a), m, n), ...
                          repmat(wye(a), m, n), ...
                          repmat(zed(a), m, n)), 'quaternion');
    else
        b = class(compose(repmat(ess(a), m, n), ...
                          repmat(vee(a), m, n)), 'quaternion');
    end
end
