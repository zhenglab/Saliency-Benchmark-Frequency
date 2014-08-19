function GetHumanSeg()
%% Settings
InputDBpath='./obj';
SysType='unix';
OutputGTpath='./obj_GroundTruth/';
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
    if (Lpath(i,1).name(1)=='.')
        continue;
    end
    Hmask=GetHSeg(strcat(InputDBpath,Sep,Lpath(i,1).name),Lpath(i,1).name,OutputGTpath);
end;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             Get the Human binary segmentation                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [mask]=GetHSeg(Hpath,GTname,OutputGTpath)

im=im2double(imread(Hpath));
if (exist('mask','var'))
    mask=mask+double((im(:,:,1)==1)&(im(:,:,2)==0)&(im(:,:,3)==0));
else
    mask=double((im(:,:,1)==1)&(im(:,:,2)==0)&(im(:,:,3)==0));
end;
imwrite(mask,strcat(OutputGTpath,GTname(1:end-4), '.jpg'));
end

