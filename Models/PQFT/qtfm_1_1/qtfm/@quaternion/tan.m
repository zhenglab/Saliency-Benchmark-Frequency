function Y = tan(X)
% TAN    Tangent.
% (Quaternion overloading of standard Matlab function.)

% Copyright © 2006 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

Y = sin(X) ./ cos(X);

% Note. This may not be the best way to implement tan,
% but it has the merit of simplicity and will work for
% all cases for which sin and cos work.