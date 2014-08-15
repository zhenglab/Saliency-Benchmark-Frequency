% Test code for the fundamental quaternion functions.

% Copyright © 2005, 2006 Stephen J. Sangwine and Nicolas Le Bihan.
% See the file : Copyright.m for further details.

check(qi == q1, 'qi and q1 are not equal.');
check(qj == q2, 'qj and q2 are not equal.');
check(qk == q3, 'qk and q3 are not equal.');

check(qi .* qj .* qk == -1, 'ijk is not -1.');

check(i.^2 == -1, 'i^2 is not -1, perhaps been redefined?');

check(abs(qi) == 1, 'abs(qi) is not 1');
check(abs(qj) == 1, 'abs(qj) is not 1');
check(abs(qk) == 1, 'abs(qk) is not 1');

check(quaternion(1,1,1,1) == 1 + qi + qj + qk, 'Constructor error.');
check(abs(quaternion(1,1,1,1)) == 2, 'abs(1,1,1,1) is not 2.');
check(abs(quaternion(1,1,1,1)+quaternion(1,1,1,1).*i) == 2 + 2.*i,...
                                     'abs error on complex value.');

check(quaternion(5, 6, 7, 8) .* (1 + 2 .* qi + 3 .* qj + 4 .* qk) ...
    - quaternion(-60,20,14,32) == 0, 'Error in simple multiplication.');

compare(axis(quaternion(42,1,1,1)), axis(quaternion(3,3,3)), 1e-14,...
    'Error in axis comparison.');
                                                    
% To be continued....
