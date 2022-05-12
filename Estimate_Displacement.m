function [Pop_Displace,Pop_IDP,Pop_Refugee]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age)

nDays=length(vLat_C);
PC=ones(length(Lat_P),1);
    
Pop_Displace=zeros(2,length(Lon_P),length(Pop_M_Age(1,:)),nDays);
Pop_IDP=zeros(2,length(Lon_P),length(Pop_M_Age(1,:)),nDays);
Pop_Refugee=zeros(2,length(Lon_P),length(Pop_M_Age(1,:)),nDays);

for jj=1:nDays
    P = Kernel_Displacement(vLat_C{jj},vLon_C{jj},Lat_P,Lon_P,Parameter);
    PC=PC.*(1-P);
    [Pop_F_Age,Pop_M_Age,Pop_Displace(:,:,:,jj)] = Population_Adjustment_Displacement(Pop_F_Age,Pop_M_Age,Parameter.w.*P+(1-Parameter.w).*Parameter.ScaleC.*(1-PC),W_Gender_Age); 
    
    if(jj>1)
        Pop_IDP(:,:,:,jj)=(1-Parameter.w_IDP_Refugee).*Pop_IDP(:,:,:,jj-1)+Parameter.w_IDP.*Pop_Displace(:,:,:,jj);
        Pop_Refugee(:,:,:,jj)=Parameter.w_IDP_Refugee.*Pop_IDP(:,:,:,jj-1)+(1-Parameter.w_IDP).*Pop_Displace(:,:,:,jj);
    else
        Pop_IDP(:,:,:,jj)=Parameter.w_IDP.*Pop_Displace(:,:,:,jj);
        Pop_Refugee(:,:,:,jj)=(1-Parameter.w_IDP).*Pop_Displace(:,:,:,jj);        
    end
end
