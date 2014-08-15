% Test code for the discrete quaternion Fourier transform.
% This code tests the following functions:
%
%  qdft  qdft2
% iqdft iqdft2
%
% It also verifies indirectly many of the basic quaternion operations
% since the qdft depends on them.

% Copyright © 2005 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

T = 1e-12;

RA =        unit(quaternion(1,1,1));  % Real axis.
CA = complex(RA, quaternion(1,0,-1)); % Complex axis.

if  isreal(CA) error('Complex axis is not complex.'); end
if ~isreal(RA) error('Real axis is complex.'); end

% Test the one-dimensional qdft code for the case of row and column
% vectors. This is a simple test to check that the code handles the
% cases identically, but not a comprehensive test, since the tests on
% the two-dimensional case below also exercise the one-dimensional code.

% Define one real and one complex quaternion vector.

q = quaternion(randn(1,10), randn(1,10), randn(1,10), randn(1,10));
b = quaternion(complex(randn(1,10)),complex(randn(1,10)),...
               complex(randn(1,10)),complex(randn(1,10)));
           
% Tests 1 and 2. Verify that row and column vectors transform identically
% by taking the forward transform of a row vector and the inverse transform
% of the transposed spectrum. The result should be the transpose of the
% original vector.

compare(q.', iqdft(qdft(q, RA, 'L').', RA, 'L'), T, 'qdft failed test 1L.');
compare(q.', iqdft(qdft(q, RA, 'R').', RA, 'R'), T, 'qdft failed test 1R.');

compare(b.', iqdft(qdft(b, CA, 'L').', CA, 'L'), T, 'qdft failed test 2L.');
compare(b.', iqdft(qdft(b, CA, 'R').', CA, 'R'), T, 'qdft failed test 2R.');

% From here on we are testing the one-dimensional code using the
% two-dimensional code.

% Refefine q and b as a real and a complex quaternion matrix.

q = quaternion(randn(10,10), randn(10,10), randn(10,10), randn(10,10));
b = quaternion(complex(randn(10,10)),complex(randn(10,10)),...
               complex(randn(10,10)),complex(randn(10,10)));

% Test 3. Verify correct transform and inverse for a real quaternion
% array with a real quaternion axis.

compare(q, iqdft2(qdft2(q, RA, 'L'), RA, 'L'), T, 'qdft failed test 3L.');
compare(q, iqdft2(qdft2(q, RA, 'R'), RA, 'R'), T, 'qdft failed test 3R.');

% Test 4. Verify correct transform and inverse for a real quaternion
% array with a complex axis.

compare(q, iqdft2(qdft2(q, CA, 'L'), CA, 'L'), T, 'qdft failed test 4L.');
compare(q, iqdft2(qdft2(q, CA, 'R'), CA, 'R'), T, 'qdft failed test 4R.');

% Test 5. Verify correct transform and inverse for a complex quaternion
% array with a complex axis.

compare(b, iqdft2(qdft2(b, CA, 'L'), CA, 'L'), T, 'qdft failed test 5L.');
compare(b, iqdft2(qdft2(b, CA, 'R'), CA, 'R'), T, 'qdft failed test 5R.');

% Test 6. Verify correct transform and inverse for a complex quaternion
% array with a real axis.

compare(b, iqdft2(qdft2(b, RA, 'L'), RA, 'L'), T, 'qdft failed test 6L.');
compare(b, iqdft2(qdft2(b, RA, 'R'), RA, 'R'), T, 'qdft failed test 6R.');

clear q b T RA CA
