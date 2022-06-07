% parpool(32);
% 
% [Number_Displacement,Date_Displacement,vLat_C,vLon_C,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,Pop_MACRO,Pop_raion,Pop_oblast,Time_Sim,ML_Indx,RC,Time_Switch]=LoadData;
% day_W_fix=7;

 load('Load_Data_MCMC.mat');
% 
 [Mapping_Data,Refugee_Displacement,IDP_Displacement]=LoadData_Destination(Time_Sim,vLat_C,vLon_C);

save('Load_Data_MCMC_Mapping.mat');

load('Load_Data_MCMC_Mapping.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % Run Fitting
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[lb,ub]=ParameterBounds_Mapping;
% 
% 
% load('MCMC_Sigma_Initial.mat','Sigma_J','MLE');
load('MCMC_out-k=251.mat','L_V','Parameter_V')

f=find(L_V==max(L_V(L_V<0)),1);
MCMC_Parameters.x0=Parameter_V(f,:);
MCMC_Parameters.x0_map=(lb+ub)./2;
MCMC_Parameters.p=0.25;
MCMC_Parameters.alpha_F=0.23;
MCMC_Parameters.Size=5.*10^4;
MCMC_Parameters.Last_Sample_COV=1000;
MCMC_Parameters.Last_Sample_LAMBDA=100;
MCMC_Parameters.lambda_J=2.4./sqrt(length(lb));
MCMC_Parameters.Sigma_J=eye(length(lb));

S1=shaperead('UKR_ADM_1\UKR_adm1.shp','UseGeoCoords',true);
S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);

Shapefile_Raion_Name={S2.NAME_2};

Shapefile_Raion_Oblast_Name={S2.NAME_1};
Shapefile_Oblast_Name={S1.NAME_1};

[Parameter_V,L_V,a_V] = MCMC_UKR_Origin(MCMC_Parameters,vLat_C,vLon_C,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,Pop_MACRO,Number_Displacement,Date_Displacement,RC,Time_Switch,Time_Sim,ML_Indx,day_W_fix,Mapping_Data,Refugee_Displacement,IDP_Displacement,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name);
% 
% save(['Kernel_Paremeter-Window_Conflict=' num2str(day_W_fix) '_days_MCMC.mat'],'Parameter_V','L_V','a_V');