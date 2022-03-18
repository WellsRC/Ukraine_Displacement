function [Pop_Displace_Day,Pop_Displace]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Lat_P,Lon_P,Pop,Random_Sample)

nDays=length(vLat_C);
Pop_Displace=zeros(length(Lon_P),nDays);
PC=ones(length(Lat_P),1);
for jj=1:nDays
    P = Kernel_Displacement(vLat_C{jj},vLon_C{jj},Lat_P,Lon_P,Parameter);
    PC=PC.*(1-P);
    [Pop,Pop_Displace(:,jj)] = Population_Adjustment_Displacement(Pop,Parameter.w.*P+(1-Parameter.w).*Parameter.ScaleC.*(1-PC),Random_Sample); %false implies only the average is being returned
end

Pop_Displace_Day=sum(Pop_Displace,1)';
end