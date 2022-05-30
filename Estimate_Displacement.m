function [Pop_Displace,Pop_IDP,Pop_Refugee]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Time_Sim,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,ML_Indx)

nDays=length(vLat_C);
PC_W=zeros(length(Lat_P),Parameter.day_W);
    
Pop_Displace=zeros(2,length(Lon_P),length(Pop_M_Age(1,:)),nDays);
Pop_IDP=zeros(2,length(Lon_P),length(Pop_M_Age(1,:)),nDays);
Pop_Refugee=zeros(2,length(Lon_P),length(Pop_M_Age(1,:)),nDays);

for jj=1:nDays
    if(Time_Sim(jj)<Parameter.Switch)
        P = Kernel_Displacement(vLat_C{jj},vLon_C{jj},Lat_P,Lon_P,Parameter);
        
    else
        P = Parameter.Switch_Scaled.*Kernel_Displacement(vLat_C{jj},vLon_C{jj},Lat_P,Lon_P,Parameter);
        
    end
    % Cumulative probability
    PC_W(:,2:Parameter.day_W)=PC_W(:,1:(Parameter.day_W-1));    
    PC_W(:,1)=P;
    PC=1-prod(1-PC_W(:,[1:min(jj,Parameter.day_W)]),2);
    
    szData=size(Pop_F_Age);
    Prob_Displace=Probability_Forcible_Displacement(PC,Parameter,szData,ML_Indx);
    [Pop_F_Age,Pop_M_Age,Pop_Displace(:,:,:,jj)] = Population_Adjustment_Displacement(Pop_F_Age,Pop_M_Age,Prob_Displace); 
    
    if(jj>1)
        Pop_IDP(:,:,:,jj)=(1-Parameter.w_IDP_Refugee).*Pop_IDP(:,:,:,jj-1)+Parameter.w_IDP.*Pop_Displace(:,:,:,jj);
        Pop_Refugee(:,:,:,jj)=Parameter.w_IDP_Refugee.*Pop_IDP(:,:,:,jj-1)+(1-Parameter.w_IDP).*Pop_Displace(:,:,:,jj);
    else
        Pop_IDP(:,:,:,jj)=Parameter.w_IDP.*Pop_Displace(:,:,:,jj);
        Pop_Refugee(:,:,:,jj)=(1-Parameter.w_IDP).*Pop_Displace(:,:,:,jj);        
    end
end
