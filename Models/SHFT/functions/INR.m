function [K,DD]=INR(inImg1)
inImg=inImg1;
inImg=inImg/max(inImg(:));
[m,n,nn]=size(inImg);

if nn==3
    inImg=rgb2gray(inImg);
end
A=double(inImg);
% A=A-min(A(:));
% A=A/max(A(:));

%A=A+.05*randn(size(A));

[x,y]=gradient(A);

Div=divergence(x,y);


Div=Div-min(Div(:));
Div=Div/max(Div(:));
DD=Div;
Div=255*Div;
Div=uint8(Div);

H=imhist(Div);

K=kurtosis(H);