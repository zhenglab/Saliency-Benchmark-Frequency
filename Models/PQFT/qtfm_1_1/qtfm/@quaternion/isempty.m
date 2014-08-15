function tf = isempty(q)
% ISEMPTY True for empty matrix.
% (Quaternion overloading of standard Matlab function.)

% Copyright © 2005 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

error(nargchk(1, 1, nargin)), error(nargoutchk(0, 1, nargout))

% Implementation note. This function uses isempty_internal, so that the knowledge of
% how quaternions are represented is hidden in the private functions.

tf = isempty_internal(q);
