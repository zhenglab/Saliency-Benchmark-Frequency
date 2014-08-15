function n = numel(q, varargin)
% NUMEL   Number of elements in an array or subscripted array expression.
% (Quaternion overloading of standard Matlab function.)

% Copyright © 2005 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

error(nargchk(1, inf, nargin)), error(nargoutchk(0, 1, nargout))

% The built-in function numel, if applied to a quaternion array, always
% returns 1. Clearly, the function should return the number of quaternions
% in the array. Therefore, this is what we compute if this function is
% called with a single argument (which can only be a quaternion array).

if isempty(q) n = 0; end % Return zero for an empty quaternion array.

if nargin == 1
    n = prod(size(q)); % This gives the number of quaternions in q.
else
    % We have more than one argument. This means varargin represents a
    % list of index values. See the Matlab help documentation on the
    % numel function for a detailed (if unclear!) explanation of what
    % numel has to do. It appears that this function should never be
    % called with this parameter profile (Matlab calls the built-in
    % function instead), so we trap a call with an error.

    error('Quaternion numel function called with varargin, unexpected.');

    % If we do have to handle this case, here is how it could be done:

    % n = numel(x(q), varargin);
end
