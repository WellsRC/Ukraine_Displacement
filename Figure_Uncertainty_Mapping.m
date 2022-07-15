clear;
close all;

load('Load_Data_MCMC_Mapping.mat');
load('Macro_Oblast_Map.mat','Macro_Map');
[Number_Displacement,Date_Displacement,vLat_C,vLon_C,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,Pop_MACRO,Pop_raion,Pop_oblast,Time_Sim,ML_Indx,RC,Time_Switch]=LoadData;
load('Merge_Parameter_Uncertainty.mat')
day_W_fix=7;

NS=length(Par_KD(:,1));

Dist_Refugee=zeros(NS,8);
Dist_IDP=zeros(NS,7);

load('Load_Data_MCMC_Mapping.mat');


for ii=1:NS

[Parameter_Map_Refugee,Parameter_Map_IDP]=Parameter_Return_Mapping(Par_Map(ii,:));

w_tot_ref=Determine_Weights_Refugee(Parameter_Map_Refugee,Mapping_Data);
w_tot_idp=Determine_Weights_IDP(Parameter_Map_IDP,Mapping_Data);

[Parameter,STDEV_Displace]=Parameter_Return(Par_KD(ii,:),RC,Time_Switch,day_W_fix);
[Pop_Displace,Pop_IDP,Pop_Refugee]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Time_Sim,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,ML_Indx);

Daily_Refugee=squeeze(sum(Pop_Refugee,[1 3]));
Daily_IDP_Origin=Parameter.w_IDP.*squeeze(sum(Pop_Displace,[1 3])); % Need to examine the new idp only


[Est_Daily_Refugee]=Country_Refuge_Displaced(w_tot_ref,Daily_Refugee);
[Est_Daily_IDP]=IDP_Refuge_Displaced(w_tot_idp,Daily_IDP_Origin,Time_Sim,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Parameter,Macro_Map);

Dist_Refugee(ii,:)=[Est_Daily_Refugee.Poland(end) Est_Daily_Refugee.Slovakia(end) Est_Daily_Refugee.Hungary(end) Est_Daily_Refugee.Moldova(end) Est_Daily_Refugee.Romania(end) Est_Daily_Refugee.Belarus(end) Est_Daily_Refugee.Russia(end) Est_Daily_Refugee.Europe_Other(end)];

end