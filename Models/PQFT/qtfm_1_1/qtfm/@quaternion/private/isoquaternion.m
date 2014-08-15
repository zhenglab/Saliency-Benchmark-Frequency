function q = isoquaternion(z, a)
% ISOQUATERNION  Construct a quaternion from a complex number, preserving
%                the modulus and argument, and using the axis of the second
%                argument as the axis of the result.
%
% Copyright © 2006 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

error(nargchk(2, 2, nargin)), error(nargoutchk(0, 1, nargout))

if ~isa(a, 'quaternion')
    error('Second argument to private function isocomplex must be a quaternion.');
end;

if isa(z,'quaternion')
    error('First argument to private function isocomplex must not be a quaternion.');
end;

if ~isnumeric(z)
    error('First argument to private function isocomplex must be numeric.');
end

if isreal(z)
    
    % The imaginary part of z is zero, therefore so must be the vector part
    % of the result. We use special code for this case to avoid calling the
    % axis function, because axis(a) may be undefined, and we don't need it
    % in any case.
    
    q = quaternion(real(z)); % The vector part will be supplied as zero.
else
    q = quaternion(real(z), imag(z) .* axis(a));
end;

% Note: the complex argument z may be in any of the four quadrants of the
% plane, and so may the quaternion result. This means that if the axis is
% extracted from the quaternion result, it may point in the opposite
% direction to the axis of the second argument, a.