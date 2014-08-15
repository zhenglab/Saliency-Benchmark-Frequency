function SMresult=SR_single(imgfile)

    %% Read image from file
    %CVBIOUC% inImg = im2double(rgb2gray(imread('yourImage.jpg')));
    inImg = im2double(rgb2gray(imread(imgfile))); %CVBIOUC%
    inImg = imresize(inImg, 64/size(inImg, 2));
    
    %% Spectral Residual
    myFFT = fft2(inImg);
    myLogAmplitude = log(abs(myFFT));
    myPhase = angle(myFFT);
    mySpectralResidual = myLogAmplitude - imfilter(myLogAmplitude, fspecial('average', 3), 'replicate');
    saliencyMap = abs(ifft2(exp(mySpectralResidual + i*myPhase))).^2;
    
    %% After Effect
    saliencyMap = mat2gray(imfilter(saliencyMap, fspecial('gaussian', [10, 10], 2.5)));
    SMresult=saliencyMap; %CVBIOUC%
    %CVBIOUC% imshow(saliencyMap);
