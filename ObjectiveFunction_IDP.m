function L = ObjectiveFunction_IDP(x,Parameter,vLat_C,vLon_C,Lat_P,Lon_P,Pop_Remain,Lat_IDP,Lon_IDP,SCI_IDP,Site_Oblast,Num_IDP)
    Parameter_IDP.ScaleSite=10.^x(1);
    Parameter_IDP.BreadthSite=10.^x(2);
    
    Parameter_IDP.ScaleDistance=10.^x(3);
    Parameter_IDP.BreadthDistance=10.^x(4);
    
    Parameter_IDP.ScaleConflict=10.^x(5);
    
    Parameter_IDP.BreadthSCI=10.^x(6);
    
    [Num_IDP_Location]=Estimate_IDP_Displacement(Parameter_IDP,Parameter,vLat_C,vLon_C,Lat_P,Lon_P,Pop_Remain,Lat_IDP,Lon_IDP,SCI_IDP,Site_Oblast);
    
    
    L=log10(Num_IDP)-log10(Num_IDP_Location); %using lsqnonlin to estimate the parameters for the kernel function
        
end

