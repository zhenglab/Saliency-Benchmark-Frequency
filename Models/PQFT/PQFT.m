function [sM] = PQFT(inImg1, preImg1)

% Function PQFT is to generate the spatio-temporal saliency map
% if the input is an still image, inImg is the same as preImg.
% Parameter:
% [in] inImg: current image.
% [in] preImg: previous image, two frames before current image.
% [in] scale: the scale of the output saliency map.
% [out] sM: The spatio-temporal saliency map.
%  m and n are the pixel No. of row and column for input image 

% Author: Chenlei Guo (chenlei.guo@gmail.com).

r = inImg1(:,:,1);
g = inImg1(:,:,2);
b = inImg1(:,:,3);
    
I = mean(inImg1,3);
R = r-(g+b)/2;

G = g-(r+b)/2;
B = b-(r+g)/2;
Y = (r+g)/2-abs(r-g)/2-b;
Y(Y<0) = 0;

temp1 = rgb2gray(preImg1);
temp2 = rgb2gray(inImg1);
diff = abs(temp1-temp2);
[m n] = size(diff);

% Generate different channels
S = diff;
a = R-G;
b = B-Y;
c = I;

% Quaternion Fourier Transform
qInImg = quaternion(S, a, b, c);
myFFT = fft2(qInImg); 

myAngle = angle(myFFT);
myAxis = axis(myFFT);

myFFT2 = exp( myAxis .* myAngle);
myIFFT2 = ifft2(myFFT2);

% remove the output of bordline points.
saliencyMap(:,:,1) = removeBorder(x(myIFFT2));
saliencyMap(:,:,2) = removeBorder(y(myIFFT2));
saliencyMap(:,:,3) = removeBorder(z(myIFFT2));
saliencyMap(:,:,4) = removeBorder(s(myIFFT2));

saliencyMap = abs(saliencyMap).^2;

%The selection of the filter depends on the image. Usually I use disk 
% or gussian filters in the first line below.
% The parameter for disk filter is 
% saliencyMap = imfilter(saliencyMap, fspecial('disk', 3));
% The parameters for gaussian filter can choose  
% saliencyMap = imfilter(saliencyMap, fspecial('gaussian', 12, 8));
% or saliencyMap = imfilter(saliencyMap, fspecial('gaussian', 30, 8));
saliencyMap = imfilter(saliencyMap, fspecial('disk', 3));

SaliencyMap = zeros(m,n);
for j=1:4        
    SaliencyMap = SaliencyMap + saliencyMap(:,:,j);
end
%Here is the result.
sM = mat2gray(SaliencyMap);