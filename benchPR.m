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
        if strcmp(idsGroundTruth(i, 1).name((end-2):end), 'jpg' )||...
                strcmp(idsGroundTruth(i, 1).name((end-2):end), 'png' )||...
                strcmp(idsGroundTruth(i, 1).name((end-2):end), 'bmp' )
            
            subidsSaliencyMap = dir(InputSaliencyMap);
            for curAlgNum = 3:length(subidsSaliencyMap)
                outFileName = strcat(OutputResults, subidsSaliencyMap(curAlgNum, 1).name, '.mat');
                subsubidsSaliencyMap = dir(strcat(InputSaliencyMap, subidsSaliencyMap(curAlgNum, 1).name, '/'));
                %% compute the number of images in the dataset
                imgNum = 0;
                for curImgNum = 3:length(subsubidsSaliencyMap)
                    if strcmp(subsubidsSaliencyMap(curImgNum, 1).name((end-2):end), 'jpg' )||...
                            strcmp(subsubidsSaliencyMap(curImgNum, 1).name((end-2):end), 'png' )||...
                            strcmp(subsubidsSaliencyMap(curImgNum, 1).name((end-2):end), 'bmp' )
                        imgNum = imgNum+1;
                    end
                end
                %%
                precision = cell(1, imgNum);
                recall = cell(1, imgNum);
                
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
            end
        end
        break;
    end
end

 
