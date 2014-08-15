function display(q)
% DISPLAY Display array.
% (Quaternion overloading of standard Matlab function.)

% Copyright © 2005 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

if isequal(get(0,'FormatSpacing'),'compact')
  disp([inputname(1) ' =']);
  disp(q);
else
  disp(' ');
  disp([inputname(1) ' =']);
  disp(' ');
  disp(q);
  disp(' ');
end
