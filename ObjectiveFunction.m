function L = ObjectiveFunction(x,vLat_C,vLon_C,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,Number_Displacement,RC)
    Parameter.Scale=10.^x(1);
    Parameter.Breadth=RC;
    Parameter.w=x(2);
    Parameter.ScaleC=x(3);
    
    [~,Pop_IDP,Pop_Refugee]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age);
    
    Daily_Refugee=squeeze(sum(Pop_Refugee,[1:3]));
    Daily_IDP=squeeze(sum(Pop_IDP,[1:3]));
    
    L_1=log10(Number_Displacement.Refugee)-log10(Daily_Refugee); %using lsqnonlin to estimate the parameters for the kernel function
    L_2=log10(Number_Displacement.IDP)-log10(Daily_IDP(Number_Displacement.IDP_Index_Eval));
end

