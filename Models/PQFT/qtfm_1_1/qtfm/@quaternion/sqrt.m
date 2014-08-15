function Y = sqrt(X)
% SQRT   Square root.
% (Quaternion overloading of standard Matlab function.)

% Copyright © 2005, 2006 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

error(nargchk(1, 1, nargin)), error(nargoutchk(0, 1, nargout))

if isreal(X)
    
    % X is a real quaternion, and we compute the square root of an
    % isomorphic complex number using the standard Matlab square root
    % function, then construct a quaternion with the same axis as the
    % original quaternion.
    
    Y = isoquaternion(sqrt(isocomplex(X)), X);
else
    
    % X is a complex quaternion, and therefore we cannot use the method
    % above for real quaternions, because it is not possible to construct
    % an isomorphic complex number. Therefore we use polar form and halve
    % the argument. Note that the modulus and argument here are complex,
    % so the square root of the modulus is complex.
    
    Y = sqrt(abs(X)) .* exp(axis(X) .* angle(X) ./ 2);
end;

% Note: in the second case (complex quaternion) there is an issue when the
% vector part is zero. This will cause a warning that at least one element
% may have an undefined axis, when in fact it is possible to calculate the
% square root without a warning: the answer is just the square root of the
% scalar part, with a null vector part added. To be determined how best to
% fix this problem. NB The axis function has already been modified to
% prevent a divide-by-zero in this particular case, which previously caused
% this function to return NaNs when the vector part was zero.