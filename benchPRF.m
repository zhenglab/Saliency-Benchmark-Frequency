function benchPRF()
%% Settings
InputGroundTruth = './Datasets/GroundTruth/';
InputSaliencyMap = './SaliencyMaps/';
OutputResults = './Results/prf/';
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
        series=regexp(OutputResults, '/');
        DatasetsName=OutputResults((series(end-1)+1):(series(end)-1));
        DatasetsTxt = fopen(strcat(OutputResults, 'prf-', DatasetsName, '.txt'), 'w');
        fprintf(DatasetsTxt, '%s\t%s\t%s\t%s\n', 'Model', 'Precision', 'Recall', 'F-measure');
        subidsSaliencyMap = dir(InputSaliencyMap);
        for curAlgNum = 3:length(subidsSaliencyMap)
            fprintf(DatasetsTxt, '%s\t', subidsSaliencyMap(curAlgNum, 1).name);
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
            Fmeasure = cell(1, imgNum);
            
            for curImgNum = 3:(imgNum+2)
                if ~isempty(strfind(InputGroundTruth, 'PASCAL'))
                    curGroundTruth = im2double(imread(strcat(InputGroundTruth, idsGroundTruth(curImgNum, 1).name)));
                    gtThreshold = 0.5;
                    curGroundTruth = curGroundTruth>=gtThreshold;
                else
                    curGroundTruth = imread(strcat(InputGroundTruth, idsGroundTruth(curImgNum, 1).name));
                end
                [pathstrGroundTruth, nameGroundTruth, extGroundTruth] = fileparts(strcat(InputGroundTruth, idsGroundTruth(curImgNum, 1).name));
                [pathstrSaliencyMap, nameSaliencyMap, extSaliencyMap] = fileparts(strcat(InputSaliencyMap, subidsSaliencyMap(curAlgNum, 1).name, '/', subsubidsSaliencyMap(curImgNum, 1).name));
                if strcmp(nameGroundTruth, nameSaliencyMap)
                    curSaliencyMap = double(imread(strcat(InputSaliencyMap, subidsSaliencyMap(curAlgNum, 1).name, '/', subsubidsSaliencyMap(curImgNum, 1).name)));
                    [curPrecision, curRecall, curFmeasure] = prfCount(curGroundTruth, curSaliencyMap);
                    precision{curImgNum-2} = curPrecision;
                    recall{curImgNum-2} = curRecall;
                    Fmeasure{curImgNum-2} = curFmeasure;
                else
                    error('The name of GroundTruth and SaliencyMap must be the same');
                end
            end
            precision = mean(cell2mat(precision), 2);
            savePrecision = strcat('precision', '_', subidsSaliencyMap(curAlgNum).name);
            eval([savePrecision, '=', 'precision']);
            
            recall = mean(cell2mat(recall), 2);
            saveRecall = strcat('recall', '_', subidsSaliencyMap(curAlgNum).name);
            eval([saveRecall, '=', 'recall']);
            
            Fmeasure = mean(cell2mat(Fmeasure), 2);
            saveFmeasure = strcat('Fmeasure', '_', subidsSaliencyMap(curAlgNum).name);
            eval([saveFmeasure, '=', 'Fmeasure']);
            
            save(outFileName, savePrecision, saveRecall, saveFmeasure);
            fprintf(DatasetsTxt, '%f\t%f\t%f\n', precision, recall, Fmeasure);
        end
    end
    break;
end
