function L = ObjectiveFunction(x,vLat_C,vLon_C,Lat_P,Lon_P,Pop,Number_Displacement)
    Parameter.Scale=x(1);
    Parameter.Breadth=x(2);
    nDays=length(vLat_C);
    Pop_Displace_Day=zeros(nDays,1);
    for jj=1:nDays
        P = Kernel_Displacement(vLat_C{jj},vLon_C{jj},Lat_P,Lon_P,Parameter);
        [Pop,Pop_Displace] = Population_Adjustment_Displacement(Pop,P,false); %false implies only the average is being returned
        Pop_Displace_Day(jj)=sum(Pop_Displace);
    end
    
    L=Number_Displacement-Pop_Displace_Day; %using lsqnonlin to estimate the parameters for the kernel function
        
end

