clear;

rng shuffle;
load('MCMC_out-k=160.mat','L_V','Parameter_V')

Parameter_V=Parameter_V(L_V<0,:);
L_V=L_V(L_V<0);
Parameter_V=Parameter_V(end-9999:end,:);
L_V=L_V(end-9999:end);


NS=1000;

rr=randi(10^4,NS,1);
Parameter_Samp=Parameter_V(rr,:);
L_V_Samp=L_V(rr);

save('MCMC_Sample_Forcible_Displacement_Parameters.mat','Parameter_Samp','L_V_Samp');