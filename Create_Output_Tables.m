% clear;
% 
% load('Ukraine_Population_Reduced.mat','Ukraine_Pop')
% Mapped_Raion_Name=Ukraine_Pop.map_raion;
% clear Ukraine_Pop
% load('Melding_Parameter_Mapping.mat');
% 
% age_class_v={'0-4','5-9','10-14','15-19','20-24','25-29','30-34','35-39','40-44','45-49','50-54','55-59','60-64','65-69','70-74','75-79','80+'};
% gender_v={'m','f'};
% 
% Pop_Total=zeros(length(gender_v),length(Pop_raion),length(age_class_v));
% Pop_Total(1,:,:)=Pop_F_Age;
% Pop_Total(2,:,:)=Pop_M_Age;
% 
% [Pop_Displace,~,Pop_Refugee]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Time_Sim,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,ML_Indx);
% Pop_Refugee_Origin=squeeze(sum(Pop_Refugee,[4]));
% Daily_IDP_Origin=Parameter.w_IDP.*Pop_Displace;
% 
% [Parameter_Map_Refugee,Parameter_Map_IDP]=Parameter_Return_Mapping(x0_map(L_0==max(L_0(L_0<0)),:));
% 
% w_tot_ref=Determine_Weights_Refugee(Parameter_Map_Refugee,Mapping_Data);
% w_tot_idp=Determine_Weights_IDP(Parameter_Map_IDP,Mapping_Data,w_tot_ref(:,1:end-1)./(1-Parameter_Map_Refugee.weight_Europe));
% % 


tic;
Disease_Burden_Displacement(Daily_IDP_Origin,Pop_Refugee_Origin,Pop_Total,Mapped_Raion_Name,Shapefile_Raion_Name,Pop_raion,Shapefile_Raion_Oblast_Name,Pop_oblast,w_tot_idp,w_tot_ref,Parameter,Time_Sim,1);
toc;
