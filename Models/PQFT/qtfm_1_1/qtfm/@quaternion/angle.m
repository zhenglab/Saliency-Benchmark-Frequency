function theta = angle(q, a)
% ANGLE or phase of quaternion.
% (Quaternion overloading of standard Matlab function.)
%
% The second parameter is optional. If omitted, the result will always be
% in the range (0, pi), that is, the quaternion q is regarded as being in
% the upper half of a complex plane defined by the axis of q. A reference
% unit quaternion defining the direction of the positive imaginary axis of
% q may be supplied as the second parameter, in which case the result may
% be in the full range from -pi to +pi.
%
% The optional argument must be either the same size as q or be a scalar
% (in which case the same value is used for all elements of q).

% Copyright © 2005 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

error(nargchk(1, 2, nargin)), error(nargoutchk(0, 1, nargout))

if nargin == 2
    if ~isa(a, 'quaternion')
        error('Second argument must be a quaternion (array).');
    end
    if ~isreal(a)
        error('Second argument must be a real quaternion (array).');
    end
    if ~ispure_internal(a) || any(any(abs(a) - 1 > eps))
        error('Second argument must be a pure unit quaternion (array).');
    end
    if ~(all(size(q) == size(a)) || all(size(a) == [1, 1]))
        error(['The two parameters must be the same size,' ...
               ' or the second one must be a scalar.']);
    end
end

if ispure_internal(q)
    
    % q is a pure quaternion, with no scalar part, and by definition, the
    % angle is a right-angle, even for complexified quaternions. Return a
    % matrix of the same size as q, with pi/2 at every position.
    % Rationale : we can construct an exact result in this case with
    % minimal calculation, whereas if we use the algorithm below for full
    % quaternions, the result may be subject to small errors.
    
    theta = ones(size(q)) .* (pi ./ 2);
    
else
    
    % q is a full quaternion. We adopt two methods here, depending on
    % whether q is a real quaternion or a complexified quaternion.
 
    if isreal(q)

        % All elements of q are real. Therefore we can use the simple
        % method of constructing a complex value from q and using the
        % Matlab angle function to compute the angle.

        if nargin == 2
            theta = angle(isocomplex(q, a));
        else
            theta = angle(isocomplex(q));
        end
    else
        
        % One or more elements of q is/are complex. We cannot construct an
        % isomorphic complex array in this case, so we have to resort to a
        % more fundamental method using the complex scalar and vector parts
        % of q. We extract these from unit(q) because the argument or angle
        % of unit(q) is the same as the argument of q, and having unit
        % modulus simplifies the formula in the complex case. See the
        % appendix below for details of the derivation of the formula used.

        u =  unit(q);
        x =     s(u);
        y = abs(v(u));
       
        theta = - i .* log(x + i.*y);
    end
end

% Appendix: calculation of arctangent(y, x) when y and x are complex.
%
% Algorithms for computing the arctangent (or arcsin/arccos) of a complex
% value are given in some books on complex analysis. For example:
%
% John H. Mathews,
% 'Basic Complex Variables for Mathematics and Engineering',
% Allyn and Bacon, Boston, 1982. ISBN 0-205-07170-8.
%
% The algorithm used here can be derived using the method given in Mathews'
% book, as follows. We are given x and y, both complex, and these are the
% sine and cosine of theta (also complex), respectively.
% Therefore, tan(theta) = y/x. The sine and cosine of a complex angle can
% be written in terms of complex exponentials as (using mathematical
% notation with implicit multiplication, rather than Matlab notation):
%
% sin(theta) = (1/2i)[exp(i theta) - exp(-i theta)]
% cos(theta) = (1/2) [exp(i theta) + exp(-i theta)]
%
% Therefore, we can write:
%
% y/x = sin(theta)/cos(theta)
%     = [exp(i theta) - exp(-i theta)]/i[exp(i theta) + exp(-i theta)]
%
% Multiplying numerator and denominator on the right by exp(i theta)
% this simplifies to:
%
% y/x = [exp(2i theta) - 1]/i[exp(2i theta) + 1]
%
% and cross multiplying and gathering all terms on the left, and
% multiplying through by -1, we get:
%
% => exp(2i theta)[x - iy] - [x + iy] = 0
%
% => exp(2i theta) = [x + iy]/[x - iy]
%
% Rationalizing the right-hand side we obtain:
%
% exp(2i theta) = [x+iy]^2 / [x^2 + y^2]
%
% Taking the square root of both sides:
%
% exp(i theta) = [x + iy]/sqrt[x^2 + y^2]
%
% Finally, taking the natural logarithm of both sides and multiplying
% throughout by i, we get:
%
% theta = -i ln[(x + iy)/sqrt(x^2 + y^2)]
%
% If we normalise the quaternion before computing x and y, we can ensure
% that sqrt(x^2 + y^2) = 1, and therefore we can simplify the formula to
% that used in the code above.
