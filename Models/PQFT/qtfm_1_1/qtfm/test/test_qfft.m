% Test code for the fast quaternion Fourier transform.
% This code tests the following functions:
%
%  qfft  qfft2
% iqfft iqfft2

% Copyright © 2005 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

% We have to test all of the above functions separately, since they do not
% call each other, as is the case with the corresponding dqft functions. In
% addition, we need to verify the results of the FFTs against the DFT code
% in the corresponding qdft functions, e.g. for qfft2, this is qdft2. For
% each transform we need to verify that it inverts correctly for all four
% combinations of real/complex data and real/complex axis, and for left and
% right exponentials, and we need to verify each against the corresponding
% DFT code.

% Define one real and one complex quaternion array.

q = quaternion(randn(10,10), randn(10,10), randn(10,10), randn(10,10));
b = quaternion(complex(randn(10,10)),complex(randn(10,10)),...
               complex(randn(10,10)),complex(randn(10,10)));
T = 1e-12;

RA = unit(quaternion(1,1,1));                        % Real axis.
CA = complex(quaternion(1,1,1), quaternion(0,1,-1)); % Complex axis.

if  isreal(CA) error('Complex axis is not complex.'); end
if ~isreal(RA) error('Real axis is complex.'); end

% 1D FFT code against its own inverse ....

% Test 1. Verify correct transform and inverse for a real quaternion
% array with a real quaternion axis.

compare(q, iqfft(qfft(q, RA, 'L'), RA, 'L'), T, 'qfft failed test 1L.');
compare(q, iqfft(qfft(q, RA, 'R'), RA, 'R'), T, 'qfft failed test 1R.');

% Test 2. Verify correct transform and inverse for a real quaternion
% array with a complex axis.

compare(q, iqfft(qfft(q, CA, 'L'), CA, 'L'), T, 'qfft failed test 2L.');
compare(q, iqfft(qfft(q, CA, 'R'), CA, 'R'), T, 'qfft failed test 2R.');

% Test 3. Verify correct transform and inverse for a complex quaternion
% array with a complex axis.

compare(b, iqfft(qfft(b, CA, 'L'), CA, 'L'), T, 'qfft failed test 3L.');
compare(b, iqfft(qfft(b, CA, 'R'), CA, 'R'), T, 'qfft failed test 3R.');

% Test 4. Verify correct transform and inverse for a complex quaternion
% array with a real axis.

compare(b, iqfft(qfft(b, RA, 'L'), RA, 'L'), T, 'qfft failed test 4L.');
compare(b, iqfft(qfft(b, RA, 'R'), RA, 'R'), T, 'qfft failed test 4R.');

% 2D FFT code against its own inverse ....

% Test 1. Verify correct transform and inverse for a real quaternion
% array with a real quaternion axis.

compare(q, iqfft2(qfft2(q, RA, 'L'), RA, 'L'), T, 'qfft2 failed test 1L.');
compare(q, iqfft2(qfft2(q, RA, 'R'), RA, 'R'), T, 'qfft2 failed test 1R.');

% Test 2. Verify correct transform and inverse for a real quaternion
% array with a complex axis.

compare(q, iqfft2(qfft2(q, CA, 'L'), CA, 'L'), T, 'qfft2 failed test 2L.');
compare(q, iqfft2(qfft2(q, CA, 'R'), CA, 'R'), T, 'qfft2 failed test 2R.');

% Test 3. Verify correct transform and inverse for a complex quaternion
% array with a complex axis.

compare(b, iqfft2(qfft2(b, CA, 'L'), CA, 'L'), T, 'qfft2 failed test 3L.');
compare(b, iqfft2(qfft2(b, CA, 'R'), CA, 'R'), T, 'qfft2 failed test 3R.');

% Test 4. Verify correct transform and inverse for a complex quaternion
% array with a real axis.

compare(b, iqfft2(qfft2(b, RA, 'L'), RA, 'L'), T, 'qfft2 failed test 4L.');
compare(b, iqfft2(qfft2(b, RA, 'R'), RA, 'R'), T, 'qfft2 failed test 4R.');

% 1D FFT code against DFT inverse ....

% Test 5. Verify correct transform and inverse for a real quaternion
% array with a real quaternion axis.

compare(q, iqdft(qfft(q, RA, 'L'), RA, 'L'), T, 'qfft failed test 5L.');
compare(q, iqdft(qfft(q, RA, 'R'), RA, 'R'), T, 'qfft failed test 5R.');

% Test 6. Verify correct transform and inverse for a real quaternion
% array with a complex axis.

compare(q, iqdft(qfft(q, CA, 'L'), CA, 'L'), T, 'qfft failed test 6L.');
compare(q, iqdft(qfft(q, CA, 'R'), CA, 'R'), T, 'qfft failed test 6R.');

% Test 7. Verify correct transform and inverse for a complex quaternion
% array with a complex axis.

compare(b, iqdft(qfft(b, CA, 'L'), CA, 'L'), T, 'qfft failed test 7L.');
compare(b, iqdft(qfft(b, CA, 'R'), CA, 'R'), T, 'qfft failed test 7R.');

% Test 9. Verify correct transform and inverse for a complex quaternion
% array with a real axis.

compare(b, iqdft(qfft(b, RA, 'L'), RA, 'L'), T, 'qfft failed test 8L.');
compare(b, iqdft(qfft(b, RA, 'R'), RA, 'R'), T, 'qfft failed test 8R.');

% 2D FFT code against DFT inverse ....

% Test 5. Verify correct transform and inverse for a real quaternion
% array with a real quaternion axis.

compare(q, iqdft2(qfft2(q, RA, 'L'), RA, 'L'), T, 'qfft2 failed test 5L.');
compare(q, iqdft2(qfft2(q, RA, 'R'), RA, 'R'), T, 'qfft2 failed test 5R.');

% Test 6. Verify correct transform and inverse for a real quaternion
% array with a complex axis.

compare(q, iqdft2(qfft2(q, CA, 'L'), CA, 'L'), T, 'qfft2 failed test 6L.');
compare(q, iqdft2(qfft2(q, CA, 'R'), CA, 'R'), T, 'qfft2 failed test 6R.');

% Test 7. Verify correct transform and inverse for a complex quaternion
% array with a complex axis.

compare(b, iqdft2(qfft2(b, CA, 'L'), CA, 'L'), T, 'qfft2 failed test 7L.');
compare(b, iqdft2(qfft2(b, CA, 'R'), CA, 'R'), T, 'qfft2 failed test 7R.');

% Test 8. Verify correct transform and inverse for a complex quaternion
% array with a real axis.

compare(b, iqdft2(qfft2(b, RA, 'L'), RA, 'L'), T, 'qfft2 failed test 8L.');
compare(b, iqdft2(qfft2(b, RA, 'R'), RA, 'R'), T, 'qfft2 failed test 8R.');

clear q b T RA CA
