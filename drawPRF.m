function drawPRF()
InputResults = './Results/prf/';
traverse(InputResults);

function traverse(InputResults)
idsResults = dir(InputResults);
for i = 3:length(idsResults)
    if idsResults(i, 1).isdir==1
        traverse(strcat(InputResults, idsResults(i, 1).name,'/'));
    else
        for curMatNum = 3:length(idsResults)
            if strcmp(idsResults(curMatNum, 1).name((end-3):end), '.mat')
                load(strcat(InputResults, idsResults(curMatNum, 1).name));
            else
                continue;
            end
        end
        bar_all=[precision_SR,recall_SR,Fmeasure_SR;precision_PQFT,recall_PQFT,Fmeasure_PQFT;...
            precision_PFDN,recall_PFDN,Fmeasure_PFDN;precision_SIG,recall_SIG,Fmeasure_SIG;...
            precision_HFT,recall_HFT,Fmeasure_HFT;precision_SHFT,recall_SHFT,Fmeasure_SHFT];
        bar(bar_all,'group');
        set(gca,'XTickLabel',{'SR','PQFT','PFDN','SIG','HFT','Ours'});
        legend('Precision','Recall','F-measure',2);
        set(gca,'xgrid','on');
        grid;
        saveas(gcf, [InputResults, 'prf.png']);
        break;
    end
end
