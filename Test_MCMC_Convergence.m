clear;
load('MCMC_out-k=160.mat')
% Close all;

testp=Parameter_V(L_V<0,:);

for mmm=1:12
figure(mmm)
h=histogram(testp(20000+[0:4999],mmm),'normalization','probability');
hold on;
temp_bin=h.BinEdges;
% histogram(testp(25000+[0:4999],mmm),temp_bin,'normalization','probability')
histogram(testp(end-4999:end,mmm),temp_bin,'normalization','probability')
end