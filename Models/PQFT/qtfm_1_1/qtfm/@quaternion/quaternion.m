function q = quaternion(a0, a1, a2, a3)
% QUATERNION   Construct quaternions from components.
% Accepts the following possible arguments, which may be scalars, vectors or matrices:
%
% No argument               - returns an empty quaternion scalar, vector or matrix.
% A quaternion argument     - returns the argument unmodified.
% A non-quaternion argument - returns the argument in the scalar part and supplies
%                             a zero vector part.
% Two arguments             - returns a quaternion, provided the first argument
%                             is numeric and the second is a pure quaternion.
% Three arguments           - returns a pure quaternion scalar, vector or matrix,
%                             with an empty scalar part.
% Four arguments            - returns a full quaternion scalar, vector or matrix.

% Copyright © 2005 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

% The internal representation of a quaternion is defined in private
% functions, particularly private/compose in order to make it possible to
% alter the representation with minimal impact on the rest of the toolbox.

error(nargoutchk(0, 1, nargout)) % The number of input arguments is checked
                                 % as part of the switch statement below.
switch nargin
case 0

   % Construct an empty quaternion.

   q = class(compose([],[],[],[]), 'quaternion');

case 1

   if isa(a0, 'quaternion')
       q = a0; % a0 is already a quaternion, so return it.
   else
       % a0 is not a quaternion.
       if isnumeric(a0)
           zero = a0 - a0; % Construct zeros of the same type and size as a0. Note 1.
           q = class(compose(a0, zero, zero, zero), 'quaternion');
       else
           error('Cannot construct a quaternion with a non-numeric in the scalar part.');
       end
   end

case 2

   if any(size(a0) ~= size(a1))
      error('Arguments must have the same dimensions')
   end
   
   if isnumeric(a0) && isa(a1, 'quaternion')
       if ispure_internal(a1)
           q = class(compose(a0, exe(a1), wye(a1), zed(a1)), 'quaternion');
       else
           error('The second argument must be a pure quaternion.');
       end
   else
       error('First argument must be numeric and the second must be a pure quaternion.');
   end

case 3

   % Construct a pure quaternion.

   s0 = size(a0);
   if any(s0 ~= size(a1)) || any(s0 ~= size(a2))
       error('Arguments must have the same dimensions')
   end
   
   if isnumeric(a0) && isnumeric(a1) && isnumeric(a2)
       q = class(compose(a0, a1, a2), 'quaternion');
   else
       error('All three arguments must be numeric.');
   end

case 4 % Return a full quaternion.

   s0 = size(a0);
   if any(s0 ~= size(a1)) || any(s0 ~= size(a2)) || any(s0 ~= size(a3))
       error('Arguments must have the same dimensions')
   end

   if isnumeric(a0) && isnumeric(a1) && isnumeric(a2) && isnumeric(a3)
       q = class(compose(a0, a1, a2, a3), 'quaternion');
   else
       error('All four arguments must be numeric.');
   end

otherwise
   error('Quaternion constructor takes from 0 to 4 arguments.');
end

% Note 1
%
% At the point where zeros are constructed by subtracting a0 from a0, there
% is a minor issue with NaNs and Infinities. If the function is called with
% quaternion(NaN), the result will have NaN in the scalar and vector parts.
% Similarly with Inf, since Inf-Inf yields NaN. This doesn't seem an
% important issue to resolve for the moment. Steve Sangwine 31 May 2005.
