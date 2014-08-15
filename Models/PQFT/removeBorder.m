function [sM] = removeBorder(sM)

[m n] = size(sM);

sM(:,1) = 0;
sM(1,:) = 0;
sM(m,:) = 0;
sM(:,n) = 0;