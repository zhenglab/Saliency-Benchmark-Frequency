%% Test code for the quaternion conv function.

% Copyright © 2006 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

T = 1e-10;

%% Test the 1D conv function.
% The method is to construct real vectors and compare the Matlab conv
% function on them with the quaternion conv function operating on
% quaternions with zero vector parts.

A = randn(1,13);
B = randn(1,5);
C = randn(13,1);

compare(conv(A, B), s(conv(quaternion(A), quaternion(B))), T, ...
        'quaternion/conv failed test 1')
    
compare(conv(B, A), s(conv(quaternion(B), quaternion(A))), T, ...
        'quaternion/conv failed test 2')

compare(conv(B, C), s(conv(quaternion(B), quaternion(C))), T, ...
        'quaternion/conv failed test 3')

compare(conv(C, B), s(conv(quaternion(C), quaternion(B))), T, ...
        'quaternion/conv failed test 4')

compare(conv(A, C), s(conv(quaternion(A), quaternion(C))), T, ...
        'quaternion/conv failed test 5')
    
% To test that the right coefficients of quaternion/conv works we supply a
% vector of ones for the first parameter.

compare(conv(A, B), s(conv({quaternion(ones(size(B))), quaternion(B)}, ...
        quaternion(A))), T, 'quaternion/conv failed test 6')
    
compare(conv(B, A), s(conv({quaternion(ones(size(A))), quaternion(A)}, ...
        quaternion(B))), T, 'quaternion/conv failed test 7')

compare(conv(B, C), s(conv({quaternion(ones(size(C))), quaternion(C)}, ...
        quaternion(B))), T, 'quaternion/conv failed test 8')

clear A B C

%% Test the 2D conv function.
% The method is to construct real matrices and compare the Matlab conv
% function on them with the quaternion conv function operating on
% quaternions with zero vector parts.

A = randn(4,3);
B = randn(6,7);
C = randn(3,4);

compare(conv2(A, B), s(conv2(quaternion(A), quaternion(B))), T, ...
        'quaternion/conv failed test 9')
    
compare(conv2(B, A), s(conv2(quaternion(B), quaternion(A))), T, ...
        'quaternion/conv failed test 10')

compare(conv2(B, C), s(conv2(quaternion(B), quaternion(C))), T, ...
        'quaternion/conv failed test 11')

compare(conv2(C, B), s(conv2(quaternion(C), quaternion(B))), T, ...
        'quaternion/conv failed test 12')

compare(conv2(A, C), s(conv2(quaternion(A), quaternion(C))), T, ...
        'quaternion/conv failed test 13')
    
% Test the function with left and right coefficient arrays.

compare(conv2(A .* C', B), s(conv2({quaternion(A), quaternion(C')}, ...
                                    quaternion(B))), T,...
        'quaternion/conv failed test 14')

clear A B C T
