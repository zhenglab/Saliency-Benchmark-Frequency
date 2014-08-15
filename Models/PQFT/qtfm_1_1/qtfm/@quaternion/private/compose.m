function q = compose(a,b,c,d)
% Private function to compose a quaternion from four components.

% Copyright © 2005 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

% The rationale for using this function is that it, and the five private
% functions ess(), exe(), wye(), zed() and vee() should be the only
% functions that have knowledge of the underlying representation of a
% quaternion in order to minimise the changes necessary to use a different
% representation. In particular, the class constructor function uses this
% function to make a quaternion, so that even the constructor does not
% know how a quaternion is represented.

switch nargin
case 3
  q.w = []; q.x = a; q.y = b; q.z = c;
case 4
  q.w = a;  q.x = b; q.y = c; q.z = d;
otherwise
  error('Internal error in use of private function compose')
end
