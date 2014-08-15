function y = axis(x)
% AXIS  Axis of quaternion.
% If Q = A + mu .* B where A and B are real/complex, and mu is a unit pure
% quaternion, then axis(Q) = mu.

% Copyright © 2005 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

error(nargchk(1, 1, nargin)), error(nargoutchk(0, 1, nargout))

% In the warning check that follows, abs is used twice in order to handle
% complexified quaternions with a complex modulus.

undefined = abs(abs(v(x))) < eps;

if any(undefined(:))
    warning('At least one element may have an undefined axis.');
end

% Make a unit version of x before taking the vector part. This is essential
% in the case where x is a complex quaternion, but has no effect when x is
% a real quaternion. SJS 20 September 2005.

z = v(unit(x));

% z is now the vector part of x, but in some cases this value may be zero.
% These cases will correspond to the entries in undefined (maybe some
% others with very small modulus). We set all these undefined values to a
% safe temporary value, then replace the temporary value with a zero vector
% after evaluating the unit function.

z(undefined) = quaternion(1,1,1);
y = unit(z);
y(undefined) = quaternion(0,0,0);
