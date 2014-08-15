function t = sum(a, dim)
% SUM Sum of elements.
% (Quaternion overloading of standard Matlab function.)

% Copyright © 2005 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

error(nargchk(1, 2, nargin)), error(nargoutchk(0, 1, nargout)) 

if nargin == 1
    if ispure_internal(a)
        t = class(compose(sum(exe(a)), ...
                          sum(wye(a)),....
                          sum(zed(a))), 'quaternion');
    else
        t = quaternion(sum(ess(a)), sum(vee(a)));
    end
else
    if strcmp(dim, 'double') || strcmp(dim, 'native')
        error('Parameters ''double'' or ''native'' are not implemented.');
    else
        if ispure_internal(a)
            t = class(compose(sum(exe(a), dim), ...
                              sum(wye(a), dim), ...
                              sum(zed(a), dim)), 'quaternion');
        else
            t = class(compose(sum(ess(a), dim), ...
                              sum(vee(a), dim)), 'quaternion');
        end
    end
end
