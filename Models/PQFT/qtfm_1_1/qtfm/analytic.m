function a = analytic(f)
% ANALYTIC   Constructs the analytic signal, for the case of a real vector.
%            The result is complex. See also: HYPERANALYTIC which works for
%            complex vectors.
%
% Copyright © 2007 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

error(nargchk(1, 1, nargin)), error(nargoutchk(0, 1, nargout))

if ~isvector(f) || isscalar(f)
    error('Input parameter must be a vector.');
end

if ~isnumeric(f) || ~isreal(f)
    error('Input parameter must be real.');
end

% Construct the coefficient array that is used to suppress the negative
% frequencies in the Fourier spectrum of f. This array has the form
% [1, 2 ... 2, 1, 0 ... 0] or its transpose, the central 1 being omitted
% if the length of f is odd (it corresponds to the Nyquist frequency).

N = length(f);
M = floor((N - 1)/2);
m = [[1], ones(1, M) .* 2, ones(1, N - 2 .* M - 1), zeros(1, M)];

if all(size(f) == fliplr(size(m)))
    m = m'; % Transpose m to match f. The result will match because of the
            % way the Matlab fft function works.
end

a = ifft(fft(f) .* m);
