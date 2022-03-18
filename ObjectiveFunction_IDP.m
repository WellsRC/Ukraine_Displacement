function L = ObjectiveFunction_IDP(x,vLat_C,vLon_C,Lat_P,Lon_P,Pop_Remain,Lat_R,Lon_R,Num_IDP)
    Parameter_IDP.ScaleSite=10.^x(1);
    Parameter_IDP.BreadthSite=10.^x(2);
    
    Parameter_IDP.ScaleDistance=10.^x(3);
    Parameter_IDP.ScaleDistance=10.^x(4);
    
    Parameter_IDP.ScaleConflict=10.^x(5);
    Parameter_IDP.ScaleConflict=10.^x(6);
    
    [Num_IDP_Location]=Estimate_IDP_Displacement(Parameter_IDP,vLat_C,vLon_C,Lat_P,Lon_P,Pop_Remain,Lat_R,Lon_R);
    
    
    L=log10(Num_IDP)-log10(Num_IDP_Location); %using lsqnonlin to estimate the parameters for the kernel function
        
end

