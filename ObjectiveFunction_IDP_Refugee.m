function L = ObjectiveFunction_IDP_Refugee(x,Daily_Refugee,Daily_IDP_Origin,Mapping_Data,Refugee_Displacement,IDP_Displacement,Time_Sim,Parameter,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Tot_Refugee_Data,Macro_Map)

[Parameter_Map_Refugee,Parameter_Map_IDP]=Parameter_Return_Mapping(x);

w_tot_ref=Determine_Weights_Refugee(Parameter_Map_Refugee,Mapping_Data);
w_tot_idp=Determine_Weights_IDP(Parameter_Map_IDP,Mapping_Data,w_tot_ref(:,1:end-1)./(1-Parameter_Map_Refugee.weight_Europe));


% [Est_Daily_Refugee]=Country_Refuge_Displaced(w_tot_ref,Daily_Refugee);
[Est_Daily_IDP]=IDP_Refuge_Displaced(w_tot_idp,Daily_IDP_Origin,Time_Sim,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Parameter,Macro_Map);

% L1=Refugee_Country_Log_Likelihood(Est_Daily_Refugee,Refugee_Displacement,Time_Sim,Parameter_Map_Refugee,Tot_Refugee_Data);
L2=IDP_Macro_Log_Likelihood(Est_Daily_IDP,IDP_Displacement,Time_Sim,Parameter_Map_IDP);
L3=IDP_Oblast_Log_Likelihood(Est_Daily_IDP,IDP_Displacement,Time_Sim,Parameter_Map_IDP);
L4=IDP_Raion_Log_Likelihood(Est_Daily_IDP,IDP_Displacement,Time_Sim,Parameter_Map_IDP);


L=-(sum(L2(:))+sum(L3(:))+sum(L4(:)));%-(sum(L1(:))+sum(L2(:))+sum(L3(:))+sum(L4(:)));
end

