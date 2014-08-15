function r = ne(a, b)
% ~=  Not equal.
% (Quaternion overloading of standard Matlab function.)

% Copyright © 2005 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

error(nargchk(2, 2, nargin)), error(nargoutchk(0, 1, nargout)) 

r = ~(a == b); % Use the quaternion equality operator and invert the result.
