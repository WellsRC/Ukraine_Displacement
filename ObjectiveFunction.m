function L = ObjectiveFunction(x,vLat_C,vLon_C,Lat_P,Lon_P,Pop,Number_Displacement,RC)
    Parameter.Scale=10.^x(1);
    Parameter.Breadth=RC;
    Parameter.w=x(2);
    Parameter.ScaleC=x(3);
    
    [Pop_Displace_Day,~]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Lat_P,Lon_P,Pop);
    
    
    L=log10(Number_Displacement)-log10(Pop_Displace_Day); %using lsqnonlin to estimate the parameters for the kernel function
        
end

