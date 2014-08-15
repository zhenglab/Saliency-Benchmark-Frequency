%--Piecewise Frequency domain Divisive Normalization (PFDN)----------------
%   Calculates saliency map using PFDN
%
%   Author: Peng Bian
%   E-mail: pengfish@gmail.com
%   
%   Reference:
%   P. Bian, "Visual saliency: a biologically plausible contourlet-like 
%   frequency domain approach," Cognitive Neurodynamics, vol. 4, 2010.
%
%   Usage:
%   SMAP = PFDN(IMAGE) returns the saliency map of IMAGE.
%   
%   Parameters:
%   RSZE is the size of the image (pixel number) to be used for saliency 
%   computation. We retain ratio of the image while keeping area of image
%   relatively equal throughout.
%   FSZE is the frame size.
%   FSKP is the skip size between image patches.
%   SIGM is the sigma parameter from the equation given in the reference.
%   FLTR is the size (variance) of the Gaussian filter used for smoothing.
%   EDGE is the size of the window edge used for removing edge effects.
%
%   Please use the above reference if you use this code for your research.

%CVBIOUC% function pfdn(image)
function smap=pfdn(image) %CVBIOUC%

%--parameters----------------------------------                                                                                                          ----------------------------
    %resize (default 64*48=3072)
    rsze = 3072;
    %frame size (default 24)
    fsze = 24;
    %skip size (default 8)
    fskp = 8;
    %sigma (default 1)
    sigm = 1;
    %filter size (default 2.5)
    fltr = 2.5;
    %window edge (default 2)
    edge = 2;

%--preprocessing-----------------------------------------------------------
    %load image
    if ischar(image) == 1
        image = imread(image);
    end
    if strcmp(class(image),'uint8') == 1
        image = im2double(image);
    end
    %get image info
    [ysze xsze colors] = size(image);
    %resize image to have desired number of pixels
    ratio = sqrt(rsze/(ysze*xsze));
    ydsp = round(ysze*ratio);
    xdsp = round(xsze*ratio);
    ysze = round((ydsp-fsze)/fskp)*fskp+fsze;
    xsze = round((xdsp-fsze)/fskp)*fskp+fsze;
    rimg = imresize(image,[ysze xsze]);
    %get image info
    [ysze xsze colors] = size(rimg);
    %lab colorform
    cfrm = makecform('srgb2lab');
    rimg = applycform(rimg,cfrm);
    %number of bands for decomposition
    bsze = 29;
    %decomposition scheme
    band(1:bsze) = struct;
        for b = 1:bsze
            band(b).band = imread(['band/' int2str(b) '.jpg']);
            band(b).band = imresize(band(b).band,[fsze+1 fsze+1]);
            band(b).band = mean(band(b).band(1:fsze,1:fsze),3)/255;
        end
    %initialize saliency map
    smap = zeros(ysze,xsze);
    %gaussian filter
    h = fspecial('gaussian',[floor(fltr*3)*2+1 floor(fltr*3)*2+1],fltr);
    %windowing function
    pwnd = tukeywin(fsze,edge/fsze)*tukeywin(fsze,edge/fsze)';
    iwnd = tukeywin(ydsp,edge/ydsp)*tukeywin(xdsp,edge/xdsp)';
    
%--compute saliency map----------------------------------------------------
    %cycle through colors
    for c = 1:colors
    %cycle through patches
    for x = 1:floor((xsze-fsze)/fskp)+1
    for y = 1:floor((ysze-fsze)/fskp)+1   
        %get image patch
        ipat = rimg((y-1)*fskp+1:(y-1)*fskp+fsze,...
            (x-1)*fskp+1:(x-1)*fskp+fsze,c);
        %compute amplitude
        fpat = fftshift(fft2(ipat-mean(ipat(:))));
        apat = abs(fpat);
        %compute energy map
        epat = zeros(fsze);
        for b = 1:bsze
            energy = sum(sum(apat.^2.*band(b).band));
            epat = epat + energy.*band(b).band;
        end
        %calculate saliency map
        npat = fpat./sqrt(epat./(ysze*xsze)+sigm^2);
        spat = abs(ifft2(npat));
        %window each patch to remove edge effects
        spat = spat.*pwnd;
        %recombination
        smap((y-1)*fskp+1:(y-1)*fskp+fsze,(x-1)*fskp+1:(x-1)*fskp+fsze)...
            = max(spat,smap((y-1)*fskp+1:(y-1)*fskp+fsze,...
            (x-1)*fskp+1:(x-1)*fskp+fsze));
    end
    end
    end
    %reisze to original aspect ratio
    smap = imresize(smap,[ydsp xdsp]);
    %windowing and smoothing
    smap = imfilter(smap,h).^2.*iwnd;
    
%--display and save--------------------------------------------------------
    %display
    %% CVBIOUC
    %     figure(1)
    %     subplot(1,2,1)
    %     imshow(image)
    %     subplot(1,2,2)
    %     imshow(mat2gray(smap))
    %% END CVBIOUC
    %save, make sure you have a folder named pfdn!
    % imwrite(255*mat2gray(smap),gray(256),['pfdn\' name]);

end