clear
clc

%% CVBIOUC_Settings
INPUTDATASET='./DATASET_STIMULI/';
EXTENSION='*.jpg';
OUTPUTSM='./DATASET_SaliencyMaps/';
%% END CVBIOUC_Settings

ids=dir(fullfile((INPUTDATASET),EXTENSION)); %CVBIOUC%
for q=1:numel(ids) %CVBIOUC%
    filename=fullfile(INPUTDATASET,ids(q).name); %CVBIOUC%
    %% Read image from file
    %CVBIOUC% inImg = im2double(rgb2gray(imread('yourImage.jpg')));
    inImg = im2double(rgb2gray(imread(filename))); %CVBIOUC%
    inImg = imresize(inImg, 64/size(inImg, 2));
    
    %% Spectral Residual
    myFFT = fft2(inImg);
    myLogAmplitude = log(abs(myFFT));
    myPhase = angle(myFFT);
    mySpectralResidual = myLogAmplitude - imfilter(myLogAmplitude, fspecial('average', 3), 'replicate');
    saliencyMap = abs(ifft2(exp(mySpectralResidual + i*myPhase))).^2;
    
    %% After Effect
    saliencyMap = mat2gray(imfilter(saliencyMap, fspecial('gaussian', [10, 10], 2.5)));
    SM{q,1}=saliencyMap; %CVBIOUC%
    %CVBIOUC% imshow(saliencyMap);
    imwrite(SM{q,1},strcat(OUTPUTSM,ids(q).name)); %CVBIOUC%
end %CVBIOUC%
