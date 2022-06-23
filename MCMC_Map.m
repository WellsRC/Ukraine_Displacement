load('Load_Data_MCMC_Mapping.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % Run Fitting
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[lb,ub]=ParameterBounds_Mapping;

load('MCMC_out-k=2821.mat','L_V','Parameter_V')

temp=[Parameter_V(L_V<0,:) L_V(L_V<0)];
temp=temp(end-9999:end,:);
temp2=unique(temp,'rows');

f=find(temp2(:,end)==min(temp2(:,end)),1);
MCMC_Parameters.x0=temp2(f,1:end-1);
MCMC_Parameters.L_0=temp2(f,end);

MCMC_Parameters.Baseline.x=temp2(:,1:end-1);
MCMC_Parameters.Baseline.Likelihood=temp2(:,end);
clear L_V Parameter_V temp temp2

MCMC_Parameters.x0_map=[1.28002277839657,2.80219780031663,4.20104005286396,0.0753034566282208,2.61146699502349,0.0403068705232432,2.70689046521075,0.9373,0.9897,0.6227,0.2502,5.7] ;
MCMC_Parameters.p=0.25;
MCMC_Parameters.alpha_F=0.23;
MCMC_Parameters.Size=5.*10^4;
MCMC_Parameters.Last_Sample_COV=10000;
MCMC_Parameters.Last_Sample_LAMBDA=1000;
MCMC_Parameters.lambda_J=0.24./sqrt(length(lb));
MCMC_Parameters.Sigma_J=eye(length(lb));


Tot_Refugee_Data=sum(Number_Displacement.Refugee);
load('Macro_Oblast_Map.mat','Macro_Map');

[Parameter_V,Parameter_V_Map,L_V,a_V] = MCMC_UKR_Origin(MCMC_Parameters,vLat_C,vLon_C,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,RC,Time_Switch,Time_Sim,ML_Indx,day_W_fix,Mapping_Data,Refugee_Displacement,IDP_Displacement,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Tot_Refugee_Data,Macro_Map);

save(['Mapping_Paremeter-Window_Conflict=' num2str(day_W_fix) '_days_MCMC.mat'],'Parameter_V','L_V','Parameter_V_Map','a_V');