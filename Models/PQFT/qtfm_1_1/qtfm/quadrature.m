function a = quadrature(f, A)
% QUADRATURE Constructs a quadrature signal, for the case of a real or
%            complex vector. The second parameter is the quaternion axis
%            used to compute the quadrature signal in the complex case (it
%            is not allowed in the real case). It may be omitted (a default
%            is supplied internally).
%
% Copyright © 2007 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

error(nargchk(1, 2, nargin)), error(nargoutchk(0, 1, nargout))

if ~isvector(f) || isscalar(f)
    error('Input parameter must be a vector.');
end

if ~isnumeric(f)
    error('Input parameter must be a real or complex vector.');
end

if nargin == 2
    if ~isscalar(A)
        error('The axis cannot be a matrix or vector.');
    end

    if ~isa(A, 'quaternion') || ~ispure(A)
        error('The axis must be a pure quaternion.');
    end
    
    if isreal(f)
        error('An axis is not permitted because the input is real.');
    end
end

if nargin == 1 && ~isreal(f)
   A = complex(quaternion(1,1,1), quaternion(0,1,-1));
end

% Construct the coefficient array that is used to suppress the negative
% frequencies in the Fourier spectrum of f. This array has the form
% [1, 2 ... 2, 1, 0 ... 0] or its transpose, the central 1 being omitted
% if the length of f is odd (it corresponds to the Nyquist frequency).

N = length(f);
M = floor((N - 1)/2);
m = [[0], ones(1, M), zeros(1, N - 2 .* M - 1), -ones(1, M)];

if all(size(f) == fliplr(size(m)))
    m = m'; % Transpose m to match f.
end

if isreal(f)
    
    % In this case, we can compute the analytic signal using a complex FFT
    % and suppression of the negative frequency components. The result is
    % complex because the inverse FFT gives a complex result since its
    % input lacks Hermitian symmetry.
    
    a = ifft(fft(f) .* m);
else
    
    % In this case, f is complex, and the analytic signal is biquaternion-valued.
    
    a = iqfft(qfft(quaternion(f), A, 'L') .* m, A, 'L'); % The choice of 'L' is arbitrary.
    a = scalar_product(a, A); % This gives the quadrature component.
end
