function check(L, E)
% Test function to check a logical condition L, and output an error
% message from the string in the parameter E if false.

% Copyright © 2005 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

error(nargchk(2, 2, nargin)), error(nargoutchk(0, 0, nargout)) 

if ~islogical(L)
    error('First parameter must be logical.');
end

if ~L
    error(E);
end
