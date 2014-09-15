function drawPRF()
InputResults = './Results/prf/';
traverse(InputResults);

function traverse(InputResults)
idsResults = dir(InputResults);
for i = 3:length(idsResults)
    if idsResults(i, 1).isdir==1
        traverse(strcat(InputResults, idsResults(i, 1).name,'/'));
    else
        numModel = 1;
        numMat = dir(fullfile(InputResults, '*.mat'));
        modelCell = cell(1, numel(numMat));
        for curMatNum = 3:length(idsResults)
            if strcmp(idsResults(curMatNum, 1).name((end-3):end), '.mat')
                load(strcat(InputResults, idsResults(curMatNum, 1).name));
                [pathstr, name, ext] = fileparts(strcat(InputResults, idsResults(curMatNum, 1).name));
                modelCell{1,numModel} = name;
                eval(['bar_all(numModel, 1)' '=precision_' name]);
                eval(['bar_all(numModel, 2)' '=recall_' name]);
                eval(['bar_all(numModel, 3)' '=Fmeasure_' name]);
                numModel = numModel+1;
            else
                continue;
            end
        end
        figure;
        bar(bar_all,'group');
        series=regexp(InputResults, '/');
        titlename=InputResults((series(end-1)+1):(series(end)-1));
        title(titlename, 'FontName', 'Times');
        legend_handle=legend('Precision', 'Recall', 'F-measure');
        set(legend_handle, 'Location','SouthWest', 'FontName','Times');
        set(gca,'XGrid', 'on', 'XTickLabel', modelCell, 'FontName', 'Times');
        set(gcf, 'paperpositionmode', 'auto');
        grid;
        print('-dtiff', '-r1000', [InputResults, strcat('prf-', titlename, '.tif')]);
        break;
    end
end
