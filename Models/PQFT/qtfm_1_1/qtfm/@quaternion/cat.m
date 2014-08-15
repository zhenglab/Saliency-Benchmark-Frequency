function r = cat(dim, varargin)
% CAT Concatenate arrays.
% (Quaternion overloading of standard Matlab function.)

% Copyright © 2005 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

error(nargchk(3, inf, nargin)), error(nargoutchk(0, 1, nargout))

a = varargin{1}; 
b = varargin{2};

if ispure_internal(a) ~= ispure_internal(b)
    error('Cannot concatenate mixture of pure and full quaternion arrays');
end

if ispure_internal(a)
    r = class(compose(cat(dim, exe(a), exe(b)), ...
                      cat(dim, wye(a), wye(b)), ...
                      cat(dim, zed(a), zed(b))), 'quaternion');
else
    r = class(compose(cat(dim, ess(a), ess(b)), ...
                      cat(dim, exe(a), exe(b)), ...
                      cat(dim, wye(a), wye(b)), ...
                      cat(dim, zed(a), zed(b))), 'quaternion');
end

if nargin > 3
    r = cat(dim, r, varargin{3:end});    
end
