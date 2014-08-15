function e = end(a, k, n)
% End indexing for quaternion arrays.

% Copyright © 2005 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

if n > ndims(a)
    error('Too many indices in expression');
end

e = size(a, k);
