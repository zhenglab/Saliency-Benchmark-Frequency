function x = scalar(q)
% SCALAR   Quaternion scalar part.
%
% This function returns zero in the case of pure quaternions,
% whereas the function S gives an error if q is pure.

% Copyright © 2005 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

error(nargchk(1, 1, nargin)), error(nargoutchk(0, 1, nargout))

% A possible problem here: zeros will return a double array
% and if Q has some other type, the result will not be of the
% same type.

if ispure_internal(q)
    x = zeros(size(q));
else
    x = ess(q);
end
