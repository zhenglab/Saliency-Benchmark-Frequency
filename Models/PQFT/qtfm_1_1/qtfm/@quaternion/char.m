function str = char(q)
% CHAR Create character array (string).
% (Quaternion overloading of standard Matlab function.)

% Note: the Matlab char function converts arrays of numeric values into
% character strings. This is not what this function does, but the Matlab
% guidance on user-defined classes suggests writing a char function and
% a disp/display function. This advice has been followed.

% Copyright © 2005 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

error(nargchk(1, 1, nargin)), error(nargoutchk(0, 1, nargout)) 

[r, c] = size(q);
if r > 1 || c > 1
    error('Argument cannot be a vector or a matrix.')
end

% There are three cases to be handled.
% The argument is one of: empty, a pure quaternion, a full quaternion.
% The format is similar to the built in Matlab format for complex numbers.

if isempty(q)
    str = '[]';
elseif ispure_internal(q)
    str = [num2str(x(q)) ' I + ' num2str(y(q)) ' J + ' num2str(z(q)) ' K'];
else
    str = [num2str(s(q)) ' + ' ...
           num2str(x(q)) ' I + ' num2str(y(q)) ' J + ' num2str(z(q)) ' K'];
end

