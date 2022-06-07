function [Est_Daily_IDP]=IDP_Refuge_Displaced(w_tot_idp,Daily_IDP_Origin,Time_Sim,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Parameter,Macro_Map)


% Raion level
IDP=zeros(length(Shapefile_Raion_Name),length(Time_Sim));

for dd=1:length(Time_Sim)
    if(dd==1)
        IDP(:,dd)=squeeze(w_tot_idp(:,:,dd))*Daily_IDP_Origin(:,dd);
    else
        IDP(:,dd)=(1-Parameter.w_IDP_Refugee).*IDP(:,dd-1)+squeeze(w_tot_idp(:,:,dd))*Daily_IDP_Origin(:,dd);
    end
end
Est_Daily_IDP.raion=IDP;
Est_Daily_IDP.raion_name=Shapefile_Raion_Name;
% Oblast
IDP_t=zeros(length(Shapefile_Oblast_Name),length(Time_Sim));
for jj=1:length(Shapefile_Oblast_Name)
    tf=strcmp(Shapefile_Oblast_Name{jj},Shapefile_Raion_Oblast_Name);
    IDP_t(jj,:)=sum(IDP(tf,:),1);
end
Est_Daily_IDP.oblast=IDP_t;
Est_Daily_IDP.oblast_name=Shapefile_Oblast_Name;
% Macro

IDP_t2=zeros(length(unique(Macro_Map(:,3))),length(Time_Sim));
N_Macro=unique(Macro_Map(:,3));
N_Macro_Oblast=Macro_Map(:,3);
for jj=1:length(IDP_t2(:,1))
    tf=strcmp(N_Macro_Oblast,N_Macro{jj});
    IDP_t2(jj,:)=sum(IDP_t(tf,:),1);    
end

Est_Daily_IDP.macro=IDP_t2;
Est_Daily_IDP.macro_name=N_Macro;
end