clear;clc;close all;

filename = '97.jpg';

% read the input image
I = im2double(imread(filename));
[rsize, csize, lsize] = size(I);

% resize the image to a proper scale according to the image's aspect ratio.
img = imresize(I, [64 85]); 

% calculate the saliency map
smp = PQFT(img, img); 
smp = imresize(smp,[rsize csize]);

% show the result
subplot(1,2,1); imshow(I); title('Input image');
subplot(1,2,2); imshow(smp); title('Saliency map');

% save the saliency map
imwrite(smp,['smp.jpg'],'jpg');