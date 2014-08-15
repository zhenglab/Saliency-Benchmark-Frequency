function x = ispure_internal(q)
% Determines whether q is pure. This function has to know the
% representation of a quaternion, whereas the function ispure
% does not.

% Copyright © 2005 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

x = isempty(q.w); % This is a call on the standard Matlab function
                  % isempty() since q.w is not a quaternion.
