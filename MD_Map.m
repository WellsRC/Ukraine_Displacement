% % parpool(32);
% % 
% % [Number_Displacement,Date_Displacement,vLat_C,vLon_C,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,Pop_MACRO,Pop_raion,Pop_oblast,Time_Sim,ML_Indx,RC,Time_Switch]=LoadData;
% % day_W_fix=7;
% 
% % load('Load_Data_MCMC.mat');
% 
% % [Mapping_Data,Refugee_Displacement,IDP_Displacement]=LoadData_Destination(Time_Sim,vLat_C,vLon_C);
% % 
clear;
load('Load_Data_MCMC_Mapping.mat');
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % % Run Fitting
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
% % 
% % 
% % load('MCMC_Sigma_Initial.mat','Sigma_J','MLE');
load('MCMC_out-k=1161.mat','L_V','Parameter_V')

f=find(L_V==max(L_V(L_V<0)),1);

S1=shaperead('UKR_ADM_1\UKR_adm1.shp','UseGeoCoords',true);
S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);

Shapefile_Raion_Name={S2.NAME_2};

Shapefile_Raion_Oblast_Name={S2.NAME_1};
Shapefile_Oblast_Name={S1.NAME_1};

Tot_Refugee_Data=sum(Number_Displacement.Refugee);

[Parameter,STDEV_Displace]=Parameter_Return(Parameter_V(f,:),RC,Time_Switch,day_W_fix);

[Pop_Displace,~,Pop_Refugee]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Time_Sim,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,ML_Indx);
Daily_Refugee=squeeze(sum(Pop_Refugee,[1 3]));
Daily_IDP_Origin=Parameter.w_IDP.*squeeze(sum(Pop_Displace,[1 3])); % Need to examine the new idp only

[LB,UB]=ParameterBounds_Mapping;
NS=500;
L_0=zeros(NS,1);
x0_map=LB+lhsdesign(NS,length(LB)).*(UB-LB);


load('Macro_Oblast_Map.mat','Macro_Map');
for ii=1:NS
    L_0(ii)=-ObjectiveFunction_IDP_Refugee(x0_map(ii,:),Daily_Refugee,Daily_IDP_Origin,Mapping_Data,Refugee_Displacement,IDP_Displacement,Time_Sim,Parameter,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Tot_Refugee_Data,Macro_Map);   
end

save('Melding_Parameter_Mapping.mat');