function c = vector_product(a, b)
% VECTOR (cross) PRODUCT of two pure quaternions.

% Copyright © 2005-7 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

if ~isa(a, 'quaternion') || ~isa(b, 'quaternion')
    error('Vector/cross product is not defined for a quaternion and a non-quaternion.')
end

if ~ispure_internal(a) || ~ispure_internal(b)
    error('Vector/cross product is defined only for pure quaternions.')
end

c = class(compose(wye(a) .* zed(b) - zed(a) .* wye(b), ...
                  zed(a) .* exe(b) - exe(a) .* zed(b), ...
                  exe(a) .* wye(b) - wye(a) .* exe(b)), 'quaternion');
