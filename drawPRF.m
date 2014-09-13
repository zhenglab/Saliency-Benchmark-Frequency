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
        figure;
        bar(bar_all,'group');
        series=regexp(InputResults,'/');
        titlename=InputResults((series(end-1)+1):(series(end)-1));
        title(titlename,'FontName','Times');
        legend_handle=legend('Precision','Recall','F-measure');
        set(legend_handle,'Location','SouthWest','FontName','Times');
        set(gca,'XGrid','on','XTickLabel',{'SR','PQFT','PFDN','SIG','HFT','Ours'},'FontName','Times');
        set(gcf,'paperpositionmode','auto');
        grid;
        print('-dtiff','-r1000',[InputResults, strcat('prf-',titlename,'.tif')]);
        break;
    end
end
