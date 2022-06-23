function [Est_Daily_IDP]=Table_Return_IDP(w_tot_idp,Daily_IDP_Origin,Time_Sim,Shapefile_Raion_Name,Parameter)


% Raion level
Est_Daily_IDP=zeros(length(Shapefile_Raion_Name),1);

for dd=1:length(Time_Sim)
    if(dd==1)
        Est_Daily_IDP=squeeze(w_tot_idp(:,:,dd))*Daily_IDP_Origin(:,dd);
    else
        Est_Daily_IDP=(1-Parameter.w_IDP_Refugee).*Est_Daily_IDP+squeeze(w_tot_idp(:,:,dd))*Daily_IDP_Origin(:,dd);
    end
end
end