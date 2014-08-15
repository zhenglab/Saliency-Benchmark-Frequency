function x = reshape(y)
% RESHAPE Change size.
% (Quaternion overloading of standard Matlab function.)

% Copyright © 2005 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

unimplemented(mfilename);

% This file will not get called unless the reshape is 1 by 1.
% It appears that Matlab is not using the numel function to
% find the number of elements, or is using it incorrectly.
% Most attempts to reshape a quaternion array will result in
% the following error:
%
% To RESHAPE the number of elements must not change.
%
% This requires further study before reshape can be coded.
