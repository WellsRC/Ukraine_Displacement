clear;
close all;
clc;
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % Load data and determine the dispacement per day
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% 
LoadData;
% 
load('Kernel_Paremeter.mat','Parameter');

load('Conflict_Colourmap.mat','conflict_map');
load('Health_Colourmap.mat','health_map');

[Pop_Displace_Day,Pop_Displace]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Lat_P,Lon_P,Pop);

% National disease burden, raion mortality
load('UKR_Disease_Burden.mat');


Displace_Pop=sum(Pop_Displace,2);
Pop_Remain=Pop-Displace_Pop;

Prob_DB=ones(size(Displace_Pop));

PopTotal=Pop;

nDays=length(Number_Displacement);

Conflict=ones(length(Lon_P),nDays);
for jj=1:nDays
    P = Kernel_Displacement(vLat_C{jj},vLon_C{jj},Lat_P,Lon_P,Parameter);
    
    if(jj==1)
        Conflict(:,jj)=(1-P);
    else
        Conflict(:,jj)=Conflict(:,jj-1).*(1-P);
    end
    
end

Conflict=1-Conflict;

SCF=0.052312566421567;

S1=shaperead('UKR_ADM_1\UKR_adm1.shp','UseGeoCoords',true);
Oblast_ID=zeros(size(Pop));

for ii=1:27
    tf=strcmp(S1(ii).NAME_1,Ukraine_Pop.oblast);
    Oblast_ID(tf)=ii;
end
Pop_IDP = Distribute_IDP(Lat_P,Lon_P,Pop_Remain,Pop,Conflict(:,end),Ukraine_Pop.w_IDP,Oblast_ID,SCF);
% 
% 
% Disease_Short={'TB';'TB_DR';'HIV';'HIV_T';'Diabetes';'Cancer';'CVD'};
% 
% for dd=1:length(Disease_Short)
% 
%     tf=strcmp(Disease_Short{dd},DB_UKR.Disease);
% 
%     prev=DB_UKR.Cases(tf);
% 
% 
%     DB_temp=Disease_Distribution(Disease_Short{dd},Ukraine_Pop.map_raion,true,PopTotal); % Want to consider the males 20-59
%     DB_temp=DB_temp+(Pop_Remain./(Displace_Pop+Pop_Remain)).*Disease_Distribution(Disease_Short{dd},Ukraine_Pop.map_raion,false,PopTotal); % Do not want to consider the males 20-59
%     
%     DB_temp=1-DB_temp./(Pop_Remain+Pop_Male);
%     
%     Prob_DB=Prob_DB.*DB_temp;
% end
% 
% Prob_DB=1-Prob_DB;
% 
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % % Plot remaining disease burden
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% 
% 
% 
% S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);
% figure('units','normalized','outerposition',[0. 0. 1 1]);
% 
% scatter(Lon_P,Lat_P,10,Prob_DB,'filled');
% colormap(health_map);
% hold on
% geoshow(S2,'FaceColor','none','LineWidth',1.5);
% 
% box off;
% set(gca, 'visible', 'off');
% 
% 
% 
% print(gcf,['UKR_Prob_Disease_Burden.png'],'-dpng','-r300');
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % % Conflict
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% 
% load('Grid_points_UKR.mat');
% 
% 
% [longitude_v,latitude_v]=meshgrid(longitude,latitude);
% LonC=cell2mat(vLon_C);
% LatC=cell2mat(vLat_C);
% P=zeros(length(latitude_v(:)),length(vLon_C));
% PCt=ones(length(latitude_v(:)),1);
% PC=zeros(length(latitude_v(:)),length(vLon_C));
% tic;
% for jj=1:length(vLon_C)
%     P(:,jj) = Kernel_Displacement(vLat_C{jj},vLon_C{jj},latitude_v(:),longitude_v(:),Parameter);
%     PCt=PCt.*(1-P(:,jj));
%     PC(:,jj)=1-PCt;
% end
% toc;
% 
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % % Run the plot
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% 
% 
% figure('units','normalized','outerposition',[0. 0. 1 1]);
% 
% S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);
% 
% Ps=reshape(PC(:,end),length(latitude),length(longitude));
% Ps(~tp_UKR)=0;
% contourf(longitude,latitude,log10(Ps),'LineStyle','none');
% hold on
% geoshow(S2,'FaceColor','none','LineWidth',1.5);
% 
% colormap(conflict_map);
% 
% box off;
% set(gca, 'visible', 'off');
% 
% 
% print(gcf,['UKR_Conflict_Displacement.png'],'-dpng','-r300');
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% % Plot hospital
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% figure('units','normalized','outerposition',[0. 0. 1 1]);
% 
% H=shaperead('Health/hotosm_ukr_health_facilities_points.shp','UseGeoCoords',true);
% N={H.amenity};
% tfh=strcmp(N,'hospital')|strcmp(N,'cancer');
% H=H(tfh);
% scatter([H.Lon],[H.Lat],100,'p','MarkerEdgeColor', 'y','MarkerFaceColor', 'y');
% hold on;
% geoshow(S2,'FaceColor','none','LineWidth',1.5);
% scatter([H.Lon],[H.Lat],100,'p','MarkerEdgeColor', 'y','MarkerFaceColor', 'y');
% 
% box off;
% set(gca, 'visible', 'off');
% 
% print(gcf,['UKR_Hospital.png'],'-dpng','-r300');