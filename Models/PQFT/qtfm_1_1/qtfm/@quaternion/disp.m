function disp(q)
% DISP Display array.
% (Quaternion overloading of standard Matlab function.)

% Copyright © 2005 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

error(nargchk(1, 1, nargin)), error(nargoutchk(0, 0, nargout)) 

% The argument is not checked, since this function is called by Matlab only if
% the argument is a quaternion.  There are three cases to be handled: empty, a
% pure quaternion, a full quaternion.  In the latter two cases, the fields may
% be arrays.

[r,c] = size(q);
if isempty(q)
    disp('   []')
elseif r == 1 && c == 1
    disp(['   ' char(q)])
elseif ispure_internal(q)
    if isreal(q)
        disp(['   ' num2str(r) 'x' num2str(c) ' pure quaternion array'])
    else
        disp(['   ' num2str(r) 'x' num2str(c) ' pure complex quaternion array'])
    end
else
    if isreal(q)
        disp(['   ' num2str(r) 'x' num2str(c) ' quaternion array'])
    else
        disp(['   ' num2str(r) 'x' num2str(c) ' complex quaternion array'])
    end
end
