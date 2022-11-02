function L = ObjectiveFunction(x,vLat_C,vLon_C,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,Pop_SES,Pop_MACRO,Number_Displacement,Date_Displacement,RC,Time_Switch,Time_Sim,day_W_fix,Model_Num)
    [Parameter,STDEV_Displace]=Parameter_Return(x,RC,Time_Switch,day_W_fix,Model_Num);
    
    [~,Pop_IDP,Pop_Refugee]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Time_Sim,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,Pop_SES);
    
    Daily_Refugee=squeeze(sum(Pop_Refugee,[1:3]));
    Daily_IDP_Origin_Macro=Calc_Macro_Displacement(squeeze(sum(Pop_IDP,[1 3])),Pop_MACRO);
    Daily_IDP_Age=Calc_Age_Displacement(squeeze(sum(Pop_IDP,[1 2])));
    Daily_IDP_Female=Calc_Gender_Displacement(squeeze(sum(Pop_IDP,[2 3])));
    
    L1=Refugee_Log_Likelihood(Number_Displacement.Refugee,Date_Displacement.Refugee,Daily_Refugee,Time_Sim,STDEV_Displace.Refugee);
    L2=IDP_Log_Likelihood(Number_Displacement.IDP_Origin,Date_Displacement.IDP_Origin,Daily_IDP_Origin_Macro,Time_Sim,STDEV_Displace.IDP);
    L3=IDP_Origin_Log_Likelihood(Number_Displacement.IDP_Origin,Date_Displacement.IDP_Origin,Daily_IDP_Origin_Macro,Time_Sim,STDEV_Displace.IDP);
    L4=IDP_Age_Log_Likelihood(Number_Displacement.Proportion_IDP_Age,Date_Displacement.Proportion_IDP_Age,Number_Displacement.IDP_Origin,Daily_IDP_Age,Daily_IDP_Origin_Macro,Time_Sim,STDEV_Displace.IDP);
    L5=IDP_Female_Log_Likelihood(Number_Displacement.Proportion_IDP_Female,Date_Displacement.Proportion_IDP_Female,Number_Displacement.IDP_Origin,Daily_IDP_Female,Daily_IDP_Origin_Macro,Time_Sim,STDEV_Displace.IDP);
    
    L=-(sum(L1(:))+sum(L2(:))+sum(L3(:))+sum(L4(:))+sum(L5(:)));
    
end

