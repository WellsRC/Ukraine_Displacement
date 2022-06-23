load('Load_Data_MCMC.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % Run Fitting
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[lb,ub]=ParameterBounds;

load('MCMC_out-k=2331.mat','L_V','Parameter_V','Sigma_J','a_V','k','lambda_J')
MCMC_Parameters.x0=Parameter_V(L_V==max(L_V(L_V<0)),:);
MCMC_Parameters.p=0.25;
MCMC_Parameters.alpha_F=0.23;
MCMC_Parameters.Size=5.*10^4;
MCMC_Parameters.Last_Sample_COV=1000;
MCMC_Parameters.Last_Sample_LAMBDA=100;
MCMC_Parameters.lambda_J=lambda_J;
MCMC_Parameters.Sigma_J=Sigma_J;

[Parameter_V,L_V,a_V] = MCMC_UKR_Kernel(MCMC_Parameters,vLat_C,vLon_C,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,Pop_MACRO,Number_Displacement,Date_Displacement,RC,Time_Switch,Time_Sim,ML_Indx,day_W_fix,L_V,Parameter_V,a_V,k);

save(['Kernel_Paremeter-Window_Conflict=' num2str(day_W_fix) '_days_MCMC.mat'],'Parameter_V','L_V','a_V');