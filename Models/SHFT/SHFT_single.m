%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                           %
%          A matlab implementation for "Detecting Salient Objects           %
%            via Automatic Adaptive Amplitude Spectrum Analysis"            %
%                                                                           %
%           CVBIOUC. July, 2014. Email: zhenghaiyong@gmail.com              %
%                                                                           %
%                                                                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function SMresult=SHFT_single(imgfile)

%% Set path
%rootInfo = what;root = rootInfo.path;root=strcat(root,'/functions/'); addpath(root)
param=callHFTParams;

%% Load image
%ids=dir(fullfile((INPUTDATASET),EXTENSION));
    %imgfile=fullfile(INPUTDATASET,strcat(ids(numImg).name(1:end)));
    img=double(imread(imgfile));
    [p1,p2,p3]=size(img);
    img1 = imresize(img, [256, 256], 'bilinear');
    
    %% Compute input feature maps
    r = img1(:,:,1);g = img1(:,:,2);b = img1(:,:,3);
    I = mean(img1,3);
    R = r-(g+b)/2;G = g-(r+b)/2;B = b-(r+g)/2;Y = (r+g)/2-abs(r-g)/2-b;Y(Y<0) = 0;
    RG = double(R - G);BY =double(B - Y);
    
    %% Compute the Hypercomplex representation
    f = quaternion(0.25*RG, 0.25*BY, 0.5*I);  % the default weigthed for each feature map is 0.25 0.25 0.5
    %% Compute the Scale space in frequency domain
    [M,N]=size(r);S=MSQF(img1,f,M,N);  
    %% Find the optimal scale
    [H,W,Ch]=size(img1);
    SalMap=mat2gray(S);
    
    clear f
    clear S
    sgm=W*param.SmoothingValue;
    SalMap = imfilter(SalMap, fspecial('gaussian',[round(4*sgm) round(4*sgm)],sgm));
    SalMap = imresize(SalMap, [p1,p2], 'bilinear');
    %-------------
    if param.setCenterBias == 1
        SalMap=CenterBias(SalMap,param.CenterBiasValue);
    end
    
    SMresult=mat2gray(SalMap);
     
     
     
