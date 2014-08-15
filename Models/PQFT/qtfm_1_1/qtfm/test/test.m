% Test script for the Quaternion Toolbox for Matlab.

% Copyright © 2005, 2006 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

% This script runs a series of other test scripts, each designed to test
% one or more functions in the toolbox. No errors should be generated and
% the script should run to completion.

% Check that quaternion function dot.m has been deleted. (This function
% was renamed scalar_product after release 1.0, because the dot function
% in Matlab computes an inner product of two vectors, and QTFM should be
% consistent with this.)

if dot(qi,qj) == 0
    error('QTFM file dot.m from previous releases must be deleted.');
end;

display('Testing quaternion fundamentals ...');
test_fundamentals;
display('Testing square root function ...')
test_sqrt
display('Testing exponential function ...')
test_exp
display('Testing trigonometric functions ...');
test_trigonometric
display('Testing inverse trigonometric functions ...');
test_inverse_trig
display('Testing hyperbolic functions ...');
test_hyperbolic
display('Testing inverse hyperbolic functions ...');
test_inverse_hyperbolic
display('Testing discrete quaternion Fourier transforms ...')
test_qdft
display('Testing fast quaternion Fourier transforms ...')
test_qfft
test_fft
display('Testing singular value decompositions ...')
test_svd
test_svdj
display('Testing eigenvalue decomposition ...')
test_eig
display('Testing convolutions 1D and 2D ...')
test_conv

display('All tests completed without error.')
