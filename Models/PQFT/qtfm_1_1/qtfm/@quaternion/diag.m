function d = diag(v, k)
% DIAG Diagonal matrices and diagonals of a matrix.
% (Quaternion overloading of standard Matlab function.)

% Copyright © 2005 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

error(nargchk(1, 2, nargin)), error(nargoutchk(0, 1, nargout)) 

if nargin == 1
    if ispure_internal(v)
        d = class(compose(diag(exe(v)), ...
                          diag(wye(v)), ...
                          diag(zed(v))), 'quaternion');
    else
        d = class(compose(diag(ess(v)), diag(exe(v)), ...
                          diag(wye(v)), diag(zed(v))), 'quaternion');
    end
else
    if ispure_internal(v)
        d = class(compose(diag(exe(v), k), ...
                          diag(wye(v), k), ...
                          diag(zed(v), k)), 'quaternion');
    else
        d = class(compose(diag(ess(v), k), diag(exe(v), k), ...
                          diag(wye(v), k), diag(zed(v), k)), 'quaternion');
    end
end
