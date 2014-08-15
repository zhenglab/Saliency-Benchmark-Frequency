function [r, c] = size(q, dim)
% SIZE   Size of matrix.
% (Quaternion overloading of standard Matlab function.)

% Copyright © 2005 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

% In what follows, we use the size of the x component of the quaternion,
% not the size of the scalar part, since this could be empty. The choice of
% x, y or z is arbitrary, since they must all be the same size - if not the
% error lies in the code that constructed q. Earlier versions of this code
% did check the sizes, but the time taken to do this is significant and the
% check was eliminated in the interests of greater speed.

switch nargout
    case 0
        switch nargin
            case 1
                size(exe(q))
            case 2
                size(exe(q), dim)
            otherwise
                error('Incorrect number of input arguments.')
        end
    case 1
        switch nargin
            case 1
                r = size(exe(q));
            case 2
                r = size(exe(q), dim);
            otherwise
                error('Incorrect number of input arguments.')
        end
    case 2
        switch nargin
            case 1
                [r, c] = size(exe(q));
            case 2
                [r, c] = size(exe(q), dim);
            otherwise
                error('Incorrect number of input arguments.')
        end
    otherwise
        error('Incorrect number of output arguments.')
end
