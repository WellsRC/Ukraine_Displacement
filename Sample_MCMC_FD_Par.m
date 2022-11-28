clear;

rng shuffle;
load('Kernel_Paremeter-Window_Conflict=12_days_MCMC.mat')
Parameter_Vt=Parameter_V;
L_Vt=L_V;
% Close all;

load('MCMC_out-k=244.mat')

testp=[Parameter_Vt;Parameter_V(L_V<0,:)];

test_L=[L_Vt;L_V];

Parameter_V=testp(test_L<0,:);
L_V=test_L(test_L<0);
Parameter_V=Parameter_V(end-9999:end,:);
L_V=L_V(end-9999:end);


NS=1000;

rr=randi(10^4,NS,1);
Parameter_Samp=Parameter_V(rr,:);
L_V_Samp=L_V(rr);

save('MCMC_Sample_Forcible_Displacement_Parameters.mat','Parameter_Samp','L_V_Samp');