function L = ObjectiveFunction(x,vLat_C,vLon_C,Lat_P,Lon_P,Pop,Number_Displacement)
    Parameter.Scale=10.^x(1);
    Parameter.Breadth=10.^x(2);
    Parameter.w=x(3);
    
    [Pop_Displace_Day,~]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Lat_P,Lon_P,Pop);
    
    
    L=log10(Number_Displacement)-log10(Pop_Displace_Day); %using lsqnonlin to estimate the parameters for the kernel function
        
end

