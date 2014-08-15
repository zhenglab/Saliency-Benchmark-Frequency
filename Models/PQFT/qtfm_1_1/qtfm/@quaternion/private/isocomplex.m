function z = isocomplex(q, a)
% ISOCOMPLEX    Construct a complex number from a quaternion, with the same
%               modulus and argument as those of the quaternion. The result
%               will be in the upper half of the complex plane unless the
%               second (optional) parameter is supplied - in this case, the
%               optional parameter is a reference unit quaternion defining
%               the direction of the positive imaginary axis of q.
%               The optional argument must be either the same size as q or
%               be a scalar (in which case the same value is used for all
%               elements of q).
%
% Copyright © 2006 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

error(nargchk(1, 2, nargin)), error(nargoutchk(0, 1, nargout))

if nargin == 2
    if ~isa(a, 'quaternion')
        error(['Second argument to private function isocomplex ' ...
               'must be a quaternion (array).']);
    end
    if ~isreal(a)
        error(['Second argument to private function isocomplex ' ...
               'must be a real quaternion (array).']);
    end
    if ~ispure(a) || any(any(abs(a) - 1 > eps))
        error(['Second argument to private function isocomplex ' ...
               'must be a pure unit quaternion (array).']);
    end
    if ~(all(size(q) == size(a)) || all(size(a) == [1, 1]))
        error(['The two parameters to private function isocomplex ' ...
               'must be the same size, or the second one must be a scalar.']);
    end
end

s = scalar(q);
v = vector(q); m = abs(v);

% Either of both of s and m may be complex, in which case we cannot create
% an isomorphic complex number.

if ~isreal(s) || ~isreal(m)
    error(['Private function isocomplex is undefined ' ...
           'for complex quaternion arguments.'])
end;

if nargin == 1
    
    % The second parameter was not supplied, so the result defaults to the
    % upper half of the complex plane (because m = abs(v) will be positive).
    
    z = complex(s, m);
else
    
    % The second parameter was supplied, so we can provide a result in the
    % full complex plane dependent on the direction of v relative to a.
    
    t = sign(scalar_product(v, a)); % The scalar product works for the case
                                    % where a is scalar, so we need not do
                                    % anything explicit to make an array
                                    % the same size as v.
    if any(any(t == 0))
        warning(['Some elements of the first parameter to private '    ...
                 'function isocomplex have axis perpendicular to the ' ...
                 'axis of the second parameter and results may be '    ...
                 'incorrect in these elements.']);
    end
    z = complex(s, m .* t);
end

% Implementation note: the warning at line 63 could be eliminated if we
% could substitute for the sign function a function that would not deliver
% a zero result, but would return arbitrarily +1 or -1 in this case. This
% is not difficult to do, but it may be the case that the usage of the
% second parameter is limited to the case where a is actually parallel to
% the axes of elements of v. Therefore this has not been dealt with at the
% moment. Steve Sangwine 29 March 2007.