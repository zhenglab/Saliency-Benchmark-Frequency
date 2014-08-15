function r = vee(q)
% Extracts the vector component of a quaternion.
% (Actually all it does is set the scalar component to empty, which is more
% efficient and achieves the same effect.)

% Copyright © 2007 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

r = q; r.w = [];
