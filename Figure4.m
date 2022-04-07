% close all;
% clear;
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % % Conflict
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% LoadData;
% load('Kernel_Paremeter.mat','Parameter');
% load('Grid_points_UKR.mat');
% 
% H=shaperead('Health/hotosm_ukr_health_facilities_points.shp','UseGeoCoords',true);
% 
% N={H.amenity};
% 
% tfh=strcmp(N,'hospital')|strcmp(N,'cancer');
% Hs=H(tfh);
% 
% HLon=[Hs.Lon];
% HLat=[Hs.Lat];
% 
% tfh=strcmp(N,'pharmacy');
% Ph=H(tfh);
% 
% PhLon=[Ph.Lon];
% PhLat=[Ph.Lat];
% 
% nDays=length(vLat_C);
% 
% PC0=ones(length(HLon),1);
% PC_Hosp=ones(length(HLon),1);
% 
% 
% PC1=ones(length(PhLon),1);
% PC_Pharm=ones(length(PhLon),1);
% 
% PC2=ones(length(cell2mat(vLat_C)),1);
% PC_Con=ones(length(cell2mat(vLat_C)),1);
% 
% 
% 
% 
% [longitude_v,latitude_v]=meshgrid(longitude,latitude);
% LonC=cell2mat(vLon_C);
% LatC=cell2mat(vLat_C);
% P=zeros(length(latitude_v(:)),length(vLon_C));
% PCt=ones(length(latitude_v(:)),1);
% PC_Map=zeros(length(latitude_v(:)),length(vLon_C));
% for jj=1:nDays   
%     P= Kernel_Displacement(vLat_C{jj},vLon_C{jj},latitude_v(:),longitude_v(:),Parameter);
%     PCt=PCt.*(1-P);    
%     Pt=Parameter.w.*P+(1-Parameter.w).*Parameter.ScaleC.*(1-PCt);
%     PC_Map(:,jj)=Pt;
%     
%     
%     P = Kernel_Displacement(vLat_C{jj},vLon_C{jj},HLat,HLon,Parameter);
%     PC0=PC0.*(1-P);
%     Ptemp=(Parameter.w.*P+(1-Parameter.w).*Parameter.Scale.*(1-PC0));
%     PC_Hosp=PC_Hosp.*(1-Ptemp);
%     
%     P = Kernel_Displacement(vLat_C{jj},vLon_C{jj},PhLat,PhLon,Parameter);
%     PC1=PC1.*(1-P);
%     Ptemp=(Parameter.w.*P+(1-Parameter.w).*Parameter.Scale.*(1-PC1));
%     PC_Pharm=PC_Pharm.*(1-Ptemp);
%     
%     
%     P = Kernel_Displacement(vLat_C{jj},vLon_C{jj},cell2mat(vLat_C),cell2mat(vLon_C),Parameter);
%     PC2=PC2.*(1-P);
%     Ptemp=(Parameter.w.*P+(1-Parameter.w).*Parameter.Scale.*(1-PC2));
%     PC_Con=PC_Con.*(1-Ptemp);
% end
% 
% PC_Hosp=1-PC_Hosp;
% PC_Pharm=1-PC_Pharm;
% PC_Con=1-PC_Con;
% 
% PC_Hosp=PC_Hosp./max(PC_Con);
% PC_Pharm=PC_Pharm./max(PC_Con);
% 
% S1=shaperead('UKR_ADM_1\UKR_adm1.shp','UseGeoCoords',true);
% 
% Ps=1-prod(1-PC_Map,2);
% 
% Avg_Con_Oblast=zeros(length(S1),1);
% 
% Oblast_Hosp=zeros(length(S1),2);
% Oblast_Pharm=zeros(length(S1),2);
% 
% for ii=1:length(S1)
%     [p_in,p_on]=inpolygon(longitude_v(:),latitude_v(:),S1(ii).Lon,S1(ii).Lat);
%     Avg_Con_Oblast(ii)=mean(Ps(p_in|p_on));
%     
%     
%    [p_in,p_on]=inpolygon(HLon,HLat,S1(ii).Lon,S1(ii).Lat);
%    Oblast_Hosp(ii,1)=sum(p_in)+sum(p_on);
%    Oblast_Hosp(ii,2)=sum(p_in)+sum(p_on)-sum(PC_Hosp(p_in|p_on));
%    
%    
%    [p_in,p_on]=inpolygon(PhLon,PhLat,S1(ii).Lon,S1(ii).Lat);
%    Oblast_Pharm(ii,1)=sum(p_in)+sum(p_on);
%    Oblast_Pharm(ii,2)=sum(p_in)+sum(p_on)-sum(PC_Pharm(p_in|p_on));
% end
% 
% Num_Org=readtable('Data_ Ukraine 3W Round 4 2022-03-31.xlsx','Sheet','Num_of_Orgs_by_Oblast');
% Reached=readtable('Data_ Ukraine 3W Round 4 2022-03-31.xlsx','Sheet','People_Reached_by_Oblast');
% 
% 
% T=zeros(length(S1),2);
% 
% for ii=1:length(S1)
%     tf=strcmp(Num_Org.HASC_1,S1(ii).HASC_1);
%     if(sum(tf)>0)
%         T(ii,1)=Num_Org.Health(tf);
%     end
%     
%     
%     tf=strcmp(Reached.HASC_1,S1(ii).HASC_1);
%     if(sum(tf)>0)
%         T(ii,2)=Reached.Health(tf);
%     end
% end

for jj=1:4
    figure(jj);
    switch jj
        case 1
            temp_m=Avg_Con_Oblast./max(Avg_Con_Oblast);
        case 2
            temp_m=Oblast_Hosp(:,1)-Oblast_Hosp(:,2);
    temp_m=(temp_m-min(temp_m))./(max(temp_m)-min(temp_m));
        case 3
            temp_m=Oblast_Pharm(:,1)-Oblast_Pharm(:,2);
    temp_m=(temp_m-min(temp_m))./(max(temp_m)-min(temp_m));
        case 4
            temp_m=T(:,2);
    temp_m=(temp_m-min(temp_m))./(max(temp_m)-min(temp_m));
    end
    for ii=1:length(S1)
        geoshow(S1(ii),'FaceAlpha',temp_m(ii),'FaceColor','k');
    end
end