function benchPR()
%% Settings
InputGroundTruth = './Datasets/GroundTruth/';
InputSaliencyMap = './SaliencyMaps/';
OutputResults = './Results/pr/';
traverse(InputGroundTruth, InputSaliencyMap, OutputResults)
%% END Settings

function traverse(InputGroundTruth, InputSaliencyMap, OutputResults)
idsGroundTruth = dir(InputGroundTruth);
for i = 1:length(idsGroundTruth)
    if idsGroundTruth(i, 1).name(1)=='.'
        continue;
    end
    if idsGroundTruth(i, 1).isdir==1
        if ~isdir(strcat(OutputResults, idsGroundTruth(i, 1).name, '/'))
            mkdir(strcat(OutputResults, idsGroundTruth(i, 1).name, '/'));
        end
        traverse(strcat(InputGroundTruth, idsGroundTruth(i, 1).name, '/'), strcat(InputSaliencyMap, idsGroundTruth(i, 1).name, '/'), strcat(OutputResults, idsGroundTruth(i, 1).name, '/'));
    else
        subidsSaliencyMap = dir(InputSaliencyMap);
        for curAlgNum = 3:length(subidsSaliencyMap)
            outFileName = strcat(OutputResults, subidsSaliencyMap(curAlgNum, 1).name, '.mat');
            subsubidsSaliencyMap = dir(strcat(InputSaliencyMap, subidsSaliencyMap(curAlgNum, 1).name, '/'));
            %% compute the number of images in the dataset
            imgNum = 0;
            for curImgNum = 3:length(subsubidsSaliencyMap)
                try
                    imread(strcat(InputSaliencyMap, subidsSaliencyMap(curAlgNum, 1).name, '/', subsubidsSaliencyMap(curImgNum, 1).name));
                    imread(strcat(InputGroundTruth, idsGroundTruth(curImgNum, 1).name));
                    imgNum = imgNum+1;
                catch err
                    error('The input SaliencyMap and GroundTruth must be image format');
                end
            end
            %%
            precision = cell(1, imgNum);
            recall = cell(1, imgNum);
            
            [pathstrGroundTruth, nameGroundTruth, extGroundTruth] = fileparts(strcat(InputGroundTruth, idsGroundTruth(curImgNum, 1).name));
            [pathstrSaliencyMap, nameSaliencyMap, extSaliencyMap] = fileparts(strcat(InputSaliencyMap, subidsSaliencyMap(curAlgNum, 1).name, '/', subsubidsSaliencyMap(curImgNum, 1).name));
            if strcmp(nameGroundTruth, nameSaliencyMap)
                for curImgNum = 3:(imgNum+2)
                    if ~isempty(strfind(InputGroundTruth,'PASCAL'))
                        curGroundTruth = im2double(imread(strcat(InputGroundTruth, idsGroundTruth(curImgNum, 1).name)));
                        gtThreshold = 0.5;
                        curGroundTruth = curGroundTruth>=gtThreshold;
                    else
                        curGroundTruth = imread(strcat(InputGroundTruth, idsGroundTruth(curImgNum, 1).name));
                    end
                    curSaliencyMap = double(imread(strcat(InputSaliencyMap, subidsSaliencyMap(curAlgNum, 1).name, '/', subsubidsSaliencyMap(curImgNum, 1).name)));
                    [curPrecision, curRecall] = prCount(curGroundTruth, curSaliencyMap);
                    precision{curImgNum-2} = curPrecision;
                    recall{curImgNum-2} = curRecall;
                end
                precision = mean(cell2mat(precision), 2);
                recall = mean(cell2mat(recall), 2);
                save(outFileName, 'precision', 'recall');
            else
                error('The name of GroundTruth and SaliencyMap must be the same');
            end
        end
        break;
    end
end

 
