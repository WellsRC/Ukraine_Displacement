clear;
load('Calibration_Conflict_Kernel.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % Run Fitting
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


L=zeros(8,1);
k=zeros(8,1);
for ii=1:8
    load(['Calibration_Kernel_Conflict_Window-Conflcit_Radius_Model=' num2str(ii) '.mat']);
    L(ii)=-min(fval);
    k(ii)=length(x0(1,:));
end
aics=aicbic(L,k);

daics=aics-min(aics);

AIC_model_num=find(daics==0);

load('Calibration_Conflict_Kernel.mat');
load(['Calibration_Kernel_Conflict_Window-Conflcit_Radius_Model=' num2str(AIC_model_num) '.mat']);
[LB,UB]=ParameterBounds(AIC_model_num);

RC=RC(fval==min(fval));
day_W_fix=day_W_fix(fval==min(fval));
load('MCMC_out-k=200.mat','Parameter_V','Sigma_J','lambda_J','L_V')
Parameter_V=Parameter_V(L_V<0,:);
MCMC_Parameters.x0=Parameter_V(end,:);
MCMC_Parameters.p=0.25;
MCMC_Parameters.alpha_F=0.23;
MCMC_Parameters.Size=5.*10^4;
MCMC_Parameters.Last_Sample_COV=5000;
MCMC_Parameters.Last_Sample_LAMBDA=1000;
MCMC_Parameters.lambda_J=lambda_J;
MCMC_Parameters.Sigma_J=Sigma_J;
k=200;

L_V=zeros(MCMC_Parameters.Size,1);
a_V=zeros(MCMC_Parameters.Size,1);
Parameter_V=zeros(MCMC_Parameters.Size,length(MCMC_Parameters.x0));

[Parameter_V,L_V,a_V] = MCMC_UKR_Kernel(MCMC_Parameters,vLat_C,vLon_C,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,Pop_MACRO,Pop_SES,Number_Displacement,Date_Displacement,RC,Time_Switch,Time_Sim,day_W_fix,L_V,Parameter_V,a_V,k,AIC_model_num);

save(['Kernel_Paremeter-Window_Conflict=' num2str(day_W_fix) '_days_MCMC.mat'],'Parameter_V','L_V','a_V');