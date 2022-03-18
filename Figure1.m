% clear;
% close all;
% clc;
% % 
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % % Load data and determine the dispacement per day
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % 
% LoadData;
% % 
% load('Kernel_Paremeter.mat','Parameter');
% 
% load('Conflict_Colourmap.mat','conflict_map');
% load('Health_Colourmap.mat','health_map');
% 
% % National disease burden, raion mortality
% load('UKR_Disease_Burden.mat');
% 
% PopTotal=Ukraine_Pop.population_size;
% 
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % % Determine the disease burden
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% 
% Disease_Short={'TB';'TB_DR';'HIV';'HIV_T';'Diabetes';'Cancer';'CVD'};
% Prob_DB=ones(size(PopTotal));
% for dd=1:length(Disease_Short)
% 
%     tf=strcmp(Disease_Short{dd},DB_UKR.Disease);
% 
%     prev=DB_UKR.Cases(tf);
% 
% 
%     DB_temp=Disease_Distribution(Disease_Short{dd},Ukraine_Pop.map_raion,true,PopTotal); % Want to consider the males 20-59
%     DB_temp=DB_temp+Disease_Distribution(Disease_Short{dd},Ukraine_Pop.map_raion,false,PopTotal); % Do not want to consider the males 20-59
%     
%     DB_temp=1-DB_temp./PopTotal;
%     
%     Prob_DB=Prob_DB.*DB_temp;
% end
% % 
% Prob_DB=1-Prob_DB;
% 
% Prob_DB=(Prob_DB-min(Prob_DB))./(max(Prob_DB)-min(Prob_DB));
% % 
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % % Plot remaining disease burden
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% 
% 
% 
% S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);
% figure('units','normalized','outerposition',[0. 0. 1 1]);
% 
% scatter(Lon_P,Lat_P,5,Prob_DB,'filled');
% colormap(health_map);
% caxis([0 1]);
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
% for jj=1:length(vLon_C)
%     P= Kernel_Displacement(vLat_C{jj},vLon_C{jj},latitude_v(:),longitude_v(:),Parameter);
%     PCt=PCt.*(1-P);    
%     Pt=Parameter.w.*P+(1-Parameter.w).*Parameter.ScaleC.*(1-PCt);
%     PC(:,jj)=Pt;
% end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % Plot map of conflict
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% 
% 
% figure('units','normalized','outerposition',[0. 0. 1 1]);
% 
% S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);
% 
% Ps=reshape(1-prod(1-PC,2),length(latitude),length(longitude));
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


% clear;
% clc;
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % Load data and determine the dispacement per day
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% LoadData;
% 
% load('Kernel_Paremeter.mat','Parameter');
% 
% [Pop_Displace_Day,~]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Lat_P,Lon_P,Pop,false);
% 
% Pop_Displace_Day_UN=zeros(1000,length(Pop_Displace_Day));
% 
% for ii=1:1000
%    NP=floor(Pop)+ceil((Pop-floor(Pop))-rand(size(Pop))); 
%    [Pop_Displace_Day_UN(ii,:),~]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Lat_P,Lon_P,NP,true); 
% end
% figure('units','normalized','outerposition',[0.15 0.15 0.6 0.8]);
% subplot('Position',[0.087147887323944,0.224383916990921,0.900528169014085,0.765239948119325]);
% bar(Pop_Displace_Day./10000,'k');
% hold on
% scatter([1:length(Number_Displacement)],Number_Displacement./10000,60,'r','filled');
% box off;
% XTL=datestr(Date_Displacement');
% set(gca,'LineWidth',2,'tickdir','out','Xticklabel',XTL,'Fontsize',18,'XTick',[1:length(Number_Displacement)])
% xtickangle(45);
% xlim([0.5 length(Number_Displacement)+0.5]);
% ylim([0 22]);
% 
% ylabel('Daily number Ukrainian refugees (10,000)','Fontsize',22);
% xlabel('Date','Fontsize',22);
% 
% print(gcf,['Daily_Refugee_Fit.png'],'-dpng','-r300');


clear;
clc;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Refugee distribution countries
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

LoadData;

load('Kernel_Paremeter.mat','Parameter');

[~,Pop_Displace]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Lat_P,Lon_P,Pop,false);

PCt=ones(length(Lat_P),1);
PC=ones(length(Lat_P),1);
for jj=1:length(vLon_C)
    P= Kernel_Displacement(vLat_C{jj},vLon_C{jj},Lat_P,Lon_P,Parameter);
    PCt=PCt.*(1-P);    
    Pt=Parameter.w.*P+(1-Parameter.w).*Parameter.ScaleC.*(1-PCt);
    PC=PC.*(1-Pt);
end

Tot_Displace=sum(Pop_Displace,2);

Disease_Burden_Displacement(Displace_Pop,Pop_Male,Pop_Remain,Ukraine_Pop,sc_sci,lambda_bc,sc_bc,sc_nbc,ws,wo,Border_Crossing_Country);
