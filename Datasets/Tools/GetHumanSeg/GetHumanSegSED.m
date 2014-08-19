function GetHumanSegSED()
%% Settings
InputDBpath='./1obj';
SysType='unix';
OutputGTpath = './1obj_GroundTruth/';
%% END Settings
Lpath=dir(InputDBpath); 
switch lower(SysType)
    case 'win' 
        Sep='\';
    case 'unix' 
        Sep='/';
    otherwise 
        Sep='\';
end;      
for i=1:length(Lpath)
    if (Lpath(i,1).name(1)=='.')||(Lpath(i,1).isdir==0)
        continue;
    end
    GetHSeg(strcat(InputDBpath,Sep,Lpath(i,1).name,Sep,'human_seg',Sep),Lpath(i,1).name,OutputGTpath); 
end;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Get the Human binary segmentation                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function GetHSeg(Hpath,GTname,OutputGTpath) 
l=dir(Hpath); 
for k=1:length(l)
    if (l(k).isdir)
        continue;
    end;
    im=im2double(imread(strcat(Hpath,l(k).name))); 
    if (exist('mask','var'))
        mask=mask+double((im(:,:,1)==1)&(im(:,:,2)==0));
    else
        mask=double((im(:,:,1)==1)&(im(:,:,2)==0));
    end;
end;
if (~exist('mask') || max(mask(:))<2)
    error('Error reading human segmentations please check path.');
end;
mask=mask>=2;
imwrite(mask,strcat(OutputGTpath,GTname,'.png'));
end


