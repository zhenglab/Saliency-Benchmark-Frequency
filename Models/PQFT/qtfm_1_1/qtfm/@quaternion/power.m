function Z = power(X, Y)
% .^   Array power.
% (Quaternion overloading of standard Matlab function.)

% Copyright © 2005, 2006 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

error(nargchk(2, 2, nargin)), error(nargoutchk(0, 1, nargout)) 

% This function is implemented using two methods. For a small set of
% integer powers, an equivalent operation is used. E.g. for Y == -1, the
% elementwise inverse is used, for Y == 2, elementwise squaring is used.

% For a power of ± 1/2, the sqrt function is used, with or without a
% reciprocal.

% For powers which are not handled in this way a general formula using
% logarithms is used.


if ~isscalar(Y)
    error('Quaternion .^ is not implemented for matrix exponents.');
else
    
    % Y is a scalar. Check for and handle the various powers that are dealt
    % with as special cases.
    
    if     Y == -2
        Z = (X .* X) .^ -1; % Use the next case recursively.
    elseif Y == -1
        Z = conj(X) ./ modsquared(X); % I.e. elementwise inverse. If X has
                                      % zero norm this will result in a
                                      % NaN.
    elseif Y == 0
        Z = ones(size(X));
    elseif Y == 1
        Z = X;
    elseif Y == 2
        Z = X .* X;
    elseif Y == 1/2
        Z = sqrt(X);
    elseif Y == -1/2
        Z = sqrt(X .^ -1);
    else
        
        % The general case. The formula used here is taken from
        % A quaternion algebra tool set, Doug Sweetser,
        % http://www.theworld.com/~sweetser/quaternions/intro/tools/tools.html
        
        Z = exp(log(X) .* Y); % NB log(X) is the natural logarithm of X.
                              % (Matlab convention.)
    end
end
