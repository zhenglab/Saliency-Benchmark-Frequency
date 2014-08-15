function show(q)
% SHOW   Displays the four components of a quaternion (array).
% Synonym for displayall(q).

% Copyright © 2005 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

% We have to duplicate the code here, otherwise when we pass the
% argument to show, show outputs q = and not the name of the original
% argument as we require.

% Note, there is no easy way to output a quaternion array in the
% same format as a complex array, therefore we resort to displaying
% the s, x, y, z components as real arrays.

disp(' ');
disp([inputname(1) ' =']);
disp(' ');
if ~ispure_internal(q)
    disp(s(q));
    disp(' + I *'); 
else
    disp('   I *'); 
end
disp(' ');
disp(x(q));
disp(' + J *');
disp(' ');
disp(y(q));
disp(' + K *');
disp(' ');
disp(z(q));
