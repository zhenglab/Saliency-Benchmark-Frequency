function [h, o, e] = hyperanalytic(f, mu)
% HYPERANALYTIC Constructs the hyperanalytic signal of a complex vector f.
%               The second parameter is the quaternion axis used to compute
%               the hyperanalytic signal.  If omitted, a default is used.
%               The algorithm used depends on the axis: if this parameter
%               is a real quaternion, the algorithm is based on the
%               quaternion FFT, if it is a complex quaternion, the
%               algorithm is based on the biquaternion FFT. Note that mu is
%               not the axis used to compute the transform: this is chosen
%               arbitrarily perpendicular to mu. The results returned are h
%               (the hyperanalytic signal), o (an orthogonal signal), and e
%               (the complex envelope). The second and third results may be
%               omitted.
%
% Copyright © 2007 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

error(nargchk(1, 2, nargin)), error(nargoutchk(0, 3, nargout))

if ~isvector(f) || isscalar(f)
    error('Input parameter must be a vector.');
end

if ~isnumeric(f)
    error('Input parameter must be a complex vector.');
    
    % Actually, we allow f to be real, because this should not be a problem,
    % although the complex envelope may be undefined, and the quadrature
    % signal will be real.
end

if nargin == 2
    if ~isscalar(mu)
        error('The axis cannot be a matrix or vector.');
    end

    if ~isa(mu, 'quaternion') || ~ispure(mu)
        error('The axis must be a pure quaternion.');
    end
end

if nargin == 1
    
   % Supply the default axis: this is a complex quaternion so that the
   % simple biquaternion algorithm will be used, yielding the envelope from
   % the modulus of the hyperanalytic signal.
   
   mu = complex(quaternion(1,1,1), quaternion(0,1,-1));
end

% Construct the coefficient array that is used to suppress the negative
% frequencies in the Fourier spectrum of f. This array has the form
% [1, 2 ... 2, 1, 0 ... 0] or its transpose, the central 1 being omitted
% if the length of f is odd (it corresponds to the Nyquist frequency).

N = length(f);
M = floor((N - 1)/2);
m = [1, ones(1, M) .* 2, ones(1, N - 2 .* M - 1), zeros(1, M)];

if all(size(f) == fliplr(size(m)))
    m = m'; % Transpose m to match f. The result will match this too.
end

if isreal(mu)
    % Make a quaternion signal isomorphic to f, with axis mu.
    g = quaternion(real(f), imag(f) .* mu); 
else
    g = quaternion(f); % Place the complex signal f in the scalar part of
                       % the quaternion used to compute the hyperanalytic
                       % signal. The imaginary part is zero.
end

% Compute the hyperanalytic signal. The method used depends on whether the
% axis is real or complex quaternion-valued, because the FFT functions work
% differently according to the axis supplied. The choice of 'L' for the
% handedness of the transform is arbitrary.

nu = orthogonal(mu);

h = iqfft(qfft(g, nu, 'L') .* m, nu, 'L');

% Now extract the orthogonal signal and envelope, if demanded.

if nargout > 1 % We must create the orthogonal signal. Both cases (real and
               % complex) involve projection and in both cases the vector
               % part of the hyperanalytic signal is taken to avoid
               % needlessly multiplying the scalar part by zero (because mu
               % and nu are pure quaternions).
               % Orthogonal here means dot(f, o) == 0.

    if isreal(mu)
        o = complex(scalar_product(v(h), nu), ...
                    scalar_product(v(h), mu .* nu));
    else
        % In the complex case, we need the conjugate of the projection onto
        % nu in order to obtain an orthogonal signal. Why this should be is
        % unknown.
        
        o = conj(scalar_product(v(h), nu)); % This must be nu and not mu or
                                            % mu .* nu, either of which
                                            % gives a null signal.
    end
end

if nargout == 3 % We must create the envelope.
    if isreal(mu)
        
        % Quaternion case. The complex envelope is constructed from the
        % modulus of the hyperanalytic signal and the angle of the original
        % signal with appropriate unwrapping. The multiplication and
        % division by 2 is required to bring the discontinuities in the
        % phase below the threshold for the unwrap function to correct
        % them.
        
        %e = abs(h) .* exp(i .* (unwrap(angle(f).*2)./2+pi));
        e = -abs(h) .* exp(i .* (unwrap(angle(f).*2)./2));
        % e = abs(h) .* exp(-i .* (unwrap(angle(o).*2)./2)); % Same result,
        % but with some spikes where o has a zero crossing.
else
        
        % Biquaternion case. The complex envelope is essentially abs(h),
        % but we have to compute this with phase unwrapping in order to get
        % a result without phase discontinuities using the whole complex
        % plane. The algorithm therefore computes the (complex) semi-norm
        % of the hyperanalytic signal, then computes its square root using
        % polar form: the square root of the modulus times a complex
        % exponential with half the unwrapped angle.
        
        n = s(h).^2 + x(h).^2 + y(h).^2 + z(h).^2; % This is the semi-norm.
        e = sqrt(abs(n)) .* exp(i .* unwrap(angle(n)) ./2 );
    end
end
