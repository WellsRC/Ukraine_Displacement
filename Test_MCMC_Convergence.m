clear;
close all;

load('Kernel_Paremeter-Window_Conflict=12_days_MCMC.mat')
Parameter_Vt=Parameter_V;
L_Vt=L_V;
% Close all;

load('MCMC_out-k=244.mat')

testp=[Parameter_Vt;Parameter_V(L_V<0,:)];

test_L=[L_Vt;L_V];
NN=length(testp(:,1));

SS=10^4;

for mmm=1:12
figure(mmm)
h=histogram(testp(NN-SS.*2+[0:(SS-1)],mmm),'normalization','probability');
hold on;
temp_bin=h.BinEdges;
histogram(testp(end-(SS-1):end,mmm),temp_bin,'normalization','probability')
end