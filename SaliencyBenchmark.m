function SaliencyBenchmark()
%% Settings
InputDatasets = './Datasets/Images/';
InputModels = './Models/';
OutputSaliencyMaps = './SaliencyMaps/';
%% END Settings
bianli(InputDatasets, InputModels, OutputSaliencyMaps);
end

function bianli(InputDatasets, InputModels, OutputSaliencyMaps)
idsDatasets = dir(InputDatasets);
idsModels = dir(InputModels);
for i = 1:length(idsDatasets)
    if idsDatasets(i, 1).name(1)=='.'
        continue;
    end
    if idsDatasets(i, 1).isdir==1
        if ~isdir(strcat(OutputSaliencyMaps, idsDatasets(i, 1).name, '/'));
            mkdir(strcat(OutputSaliencyMaps,idsDatasets(i, 1). name, '/'));
        end
            bianli(strcat(InputDatasets, idsDatasets(i, 1).name, '/'), InputModels, strcat(OutputSaliencyMaps, idsDatasets(i, 1).name, '/'));
    else
        if strcmp(idsDatasets(i, 1).name((end-2):end), 'jpg' )||...
                strcmp(idsDatasets(i, 1).name((end-2):end), 'png' )||...
                strcmp(idsDatasets(i, 1).name((end-2):end), 'bmp' )
            for j = 1:length(idsModels)
                if idsModels(j, 1).name(1)=='.'
                    continue;
                end
                if ~isdir(strcat(OutputSaliencyMaps, idsModels(j, 1).name, '/'));
                    mkdir(strcat(OutputSaliencyMaps, idsModels(j, 1).name, '/'));
                end
                addpath(genpath(strcat(InputModels,idsModels(j, 1).name)));
                imgfile = fullfile(InputDatasets, idsDatasets(i, 1).name);
                SMresult = eval(strcat(idsModels(j, 1).name, '_single', '(', 'imgfile', ')'));
                rmpath(genpath(strcat(InputModels, idsModels(j, 1).name)));
                imwrite(SMresult, strcat(OutputSaliencyMaps, idsModels(j, 1).name, '/', idsDatasets(i, 1).name));
            end
        end
    end
end
end
