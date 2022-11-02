function L = ObjectiveFunction_IDP(x,Daily_IDP_Origin,Mapping_Data,IDP_Displacement,Time_Sim,Parameter,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Macro_Map,Model_IDP)

[Parameter_Map_IDP,IDP_Mv]=Parameter_Return_Mapping_IDP(x,Model_IDP);
w_tot_idp=Determine_Weights_IDP(Parameter_Map_IDP,Mapping_Data,IDP_Mv);


[Est_Daily_IDP]=IDP_Refuge_Displaced(w_tot_idp,Daily_IDP_Origin,Time_Sim,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Parameter,Macro_Map);

L2=IDP_Macro_Log_Likelihood(Est_Daily_IDP,IDP_Displacement,Time_Sim,Parameter_Map_IDP);

L=-sum(L2(:));
end

