% Example script to calculate the colour image edge detector described in:
%
% Sangwine, S. J.,
% Colour image edge detector based on quaternion convolution,
% Electronics Letters, 34(10), May 14 1998, 969-971.
% http://dx.doi.org/10.1049/el:19980697
%
% This script is not intended to demonstrate best use of Matlab - the
% intention is to demonstrate some of the features of the QTFM toolbox
% as an example of how the toolbox can be used to program a quaternion
% algorithm at a high level using vectorized coding, and also to show how
% to convert Matlab image arrays to quaternion matrices and vice versa.
%
% The script reads the file lena.tif from the Waterloo Bragzone website at
% http://links.uwaterloo.ca/bragzone.base.html. If access to this is not
% possible, replace the URL in the imread statement below with a suitable
% local filename and path.
%
% Copyright © : Steve Sangwine, May 2007

% Read the lena image into an array. Because this is a colour image the
% array will have three dimensions, the last of which has three index
% values.

disp('Reading the lena image from http://links.uwaterloo.ca/ ...');

lena = imread('http://links.uwaterloo.ca/ColorSet/Lena/lena.tif');

disp('Processing image with colour edge detector ...');

% Convert the array into a pure quaternion matrix, with the RGB components
% in the x, y and z components of the quaternion matrix. At the same time,
% convert the quaternion components into normalised double form, rather
% than the uint8 form read in from the file.

qlena = convert(quaternion(lena(:,:,1), ...
                           lena(:,:,2), ...
                           lena(:,:,3)), 'double') ./ 256;
                       
% Define a 3x3 quaternion mask pair as defined in the paper cited above.

mu = unit(quaternion(1,1,1)); % Equivalent to quaternion(1,1,1) ./ sqrt(3);

R = exp(mu .* pi ./ 4) ./ sqrt(6); % This is a direct coding of equation 2
                                   % in the paper.

% Create the left mask. Notice that we can supply a 3x1 matrix of zeros to
% the quaternion constructor to construct the (quaternion) zeros in the
% middle row, and we can apply the quaternion conjugate function to a 1x3
% matrix [R R R] to construct the bottom row, and join all three rows
% together using standard Matlab operators (which are overloaded to handle
% quaternions).

left = [R R R; quaternion(zeros(1, 3)); conj([R R R])]; % The left mask.

right = conj(left); % Notice how we apply the conjugate operation to the
                    % whole left mask in order to create the right mask.
                    
% Now convolve the lena image with the mask. This uses the quaternion
% overloading of the standard conv2 function. Warning: this is very slow -
% an alternative is to use a quaternion Fourier transform to compute the
% convolution much faster.

fqlena = conv2({left, right}, qlena); % Notice the argument form {} to
                                      % indicate a left/right convolution
                                      % (special to the quaternion version
                                      % of conv2).
                                  
temp  = convert(fqlena .* 256, 'uint8');

% Create a uint8 array to store the result and load it with the x, y and z
% components of temp. The scalar part of the fqlena/temp arrays are ignored
% but they can be inspected manually after running the script to verify
% that they are close to zero.

edge = zeros(size(temp, 1), size(temp, 2), size(temp, 3), 'uint8');
edge(:,:,1) = x(temp);
edge(:,:,2) = y(temp);
edge(:,:,3) = z(temp);

image(edge) % Display the filtered result in an image window.
axis off
axis image

disp('Writing edge detector result to file ...');
imwrite(edge, 'result.tif');

disp('Finished.');
