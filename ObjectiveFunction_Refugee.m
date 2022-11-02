function L = ObjectiveFunction_Refugee(x,Daily_Refugee,Mapping_Data,Refugee_Displacement,Model_Refugee)

[Parameter_Map_Refugee,Refugee_Mv]=Parameter_Return_Mapping_Refugee(x,Model_Refugee);

w_tot_ref=Determine_Weights_Refugee(Parameter_Map_Refugee,Mapping_Data,Refugee_Mv);


[Est_Daily_Refugee]=Country_Refuge_Displaced(w_tot_ref,Daily_Refugee);

L1=Refugee_Country_Log_Likelihood(Est_Daily_Refugee,Refugee_Displacement,Parameter_Map_Refugee);

L=-sum(L1(:));
end

