clear;clc;close all;

%% CVBIOUC_Settings
INPUTDATASET='./DATASET_STIMULI/';
EXTENSION='*.jpg';
OUTPUTSM='./DATASET_SaliencyMaps/';
%% END CVBIOUC_Settings
rootInfo = what;root = rootInfo.path;root=strcat(root,'/qtfm_1_1/qtfm/'); addpath(root) %CVBIOUC%
ids=dir(fullfile((INPUTDATASET),EXTENSION)); %CVBIOUC%
for q=1:numel(ids) %CVBIOUC%
    %CVBIOUC% filename = '97.jpg';
    filename=fullfile(INPUTDATASET,ids(q).name); %CVBIOUC%
    
    % read the input image
    I = im2double(imread(filename));
    [rsize, csize, lsize] = size(I);
    
    % resize the image to a proper scale according to the image's aspect ratio.
    img = imresize(I, [64 85]);
    
    % calculate the saliency map
    smp = PQFT(img, img);
    smp = imresize(smp,[rsize csize]);
    
    % show the result
    %CVBIOUC% subplot(1,2,1); imshow(I); title('Input image');
    %CVBIOUC% subplot(1,2,2); imshow(smp); title('Saliency map');
    
    % save the saliency map
    %CVBIOUC% imwrite(smp,['smp.jpg'],'jpg');
    SM{q,1}=smp; %CVBIOUC%
    imwrite(SM{q,1},strcat(OUTPUTSM,ids(q).name)); %CVBIOUC%
end %CVBIOUC%