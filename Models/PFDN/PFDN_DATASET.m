clear;clc;close all;

%% CVBIOUC_Settings
INPUTDATASET='./DATASET_STIMULI/';
EXTENSION='*.jpg';
OUTPUTSM='./DATASET_SaliencyMaps/';
%% END CVBIOUC_Settings

ids=dir(fullfile((INPUTDATASET),EXTENSION)); 
for q=1:numel(ids) 
    filename=fullfile(INPUTDATASET,ids(q).name); 
    smap=pfdn(filename);
    SM{q,1}=255*mat2gray(smap);
    imwrite(SM{q,1},gray(256),strcat(OUTPUTSM,ids(q).name));
end
