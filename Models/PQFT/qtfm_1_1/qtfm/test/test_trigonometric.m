% Test code for the quaternion sin and cos functions.

% Copyright © 2006 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

T = 1e-11;

% Test 1. Real quaternion data.

q = quaternion(randn(100,100), randn(100,100), randn(100,100), randn(100,100));

compare(sin(q).^2 + cos(q).^2, ones(100,100), T,...
    'quaternion/sin/cos failed test 1.');

clear q

% Test 2. Complex quaternion data.

b = quaternion(complex(randn(100,100)),complex(randn(100,100)),...
               complex(randn(100,100)),complex(randn(100,100)));

compare(sin(b).^2 + cos(b).^2, ones(100,100), T,...
    'quaternion/sin/cos failed test 2.');

clear b T
