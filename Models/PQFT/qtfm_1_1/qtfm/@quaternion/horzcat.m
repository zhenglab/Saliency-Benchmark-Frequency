function c = horzcat(varargin)
% HORZCAT Horizontal concatenation.
% (Quaternion overloading of standard Matlab function.)

% Copyright © 2005 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

if length(varargin) == 1
    c = varargin{1}; % We have been passed one argument, nothing to do!
    return
end

% This is implemented recursively for simplicity, as it is unlikely to be
% used for more than a few arguments.

a = varargin{1};
b = varargin{2};

if isempty(b)
    c = a; return;
elseif isempty(a)
    c = b; return;
end

if ~isa(a, 'quaternion') || ~isa(b, 'quaternion')
    % We probably could handle this but for now we don't ...
    error('Cannot concatenate quaternion with non-quaternion arrays.')
end

if xor(ispure(a), ispure(b))
    % Again, we could do it, but the code would be more complex ...
    error('Arrays to be concatenated must be both pure or both full.');
end

if ispure(a) && ispure(b)
    c = quaternion(             [x(a) x(b)], [y(a) y(b)], [z(a) z(b)]);
else
    c = quaternion([s(a) s(b)], [x(a) x(b)], [y(a) y(b)], [z(a) z(b)]);
end

if length(varargin) == 2
    return
else
    c = horzcat(c, varargin{3:end});
end
