% Test code for the quaternion sqrt function.

% Copyright © 2006 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

T = 1e-13;

% Test 1. Real quaternion data.

q = quaternion(randn(100,100), randn(100,100), randn(100,100), randn(100,100));

compare(q, sqrt(q) .^2, T, 'quaternion/sqrt failed test 1.');

clear q

% Test 2. Complex quaternion data.

b = quaternion(complex(randn(100,100)),complex(randn(100,100)),...
               complex(randn(100,100)),complex(randn(100,100)));

compare(b, sqrt(b) .^2, T, 'quaternion/sqrt failed test 2.');

clear b T
