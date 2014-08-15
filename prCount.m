function [precision, recall] = prCount(GroundTruth, SaliencyMap)

% for the ground truth of dataset ASD: convert rgb to gray
    gtsize=size(GroundTruth);
    if numel(gtsize)>2
        GroundTruth = rgb2gray(GroundTruth);
    end
    smsize=size(SaliencyMap);
    if numel(smsize)>2
        SaliencyMap = rgb2gray(SaliencyMap);
    end
% make the size of GroungTruth and SaliencyMap the same
[gtH, gtW] = size(GroundTruth);
[algH, algW] = size(SaliencyMap);
if gtH~=algH || gtW~=algW
	SaliencyMap = imresize(SaliencyMap, [gtH, gtW]);
end

SaliencyMap  =  SaliencyMap(:);
GroundTruth = GroundTruth(:);

[nx,ny]=size(SaliencyMap);
if (nx~=1 && ny~=1)
    error('first argument must be a vector');
end

[mx,my]=size(GroundTruth);
if (mx~=1 && my~=1)
    error('second argument must be a vector');
end

if (length(GroundTruth) ~= length(SaliencyMap))
    error('score and target must have same length');
end

    instance_count = ones(length(SaliencyMap),1); 

thresh=0:255;
total_positive = sum(GroundTruth);
%total_negative = sum(instance_count - GroundTruth);

if total_positive==0
	precision = [];
	recall = [];
	return;
end

precision  = zeros(length(thresh),1);
recall  = zeros(length(thresh),1);

for i = 1:256
    idx   = (SaliencyMap >= (i-1));
    precision(i) = sum(GroundTruth(idx)) / (sum(instance_count(idx))+eps);
    recall(i)  = sum(GroundTruth(idx)) / total_positive; 
end


