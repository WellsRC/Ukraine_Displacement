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

PopTotal=Ukraine_Pop.population_size;



Disease_Short={'TB';'TB_DR';'HIV';'HIV_T';'Diabetes';'Cancer';'CVD'};

for dd=1:length(Disease_Short)

    tf=strcmp(Disease_Short{dd},DB_UKR.Disease);

    prev=DB_UKR.Cases(tf);


    DB_temp=Disease_Distribution(Disease_Short{dd},Ukraine_Pop.map_raion,true,PopTotal); % Want to consider the males 20-59
    DB_temp=DB_temp+(Pop_Remain./(Displace_Pop+Pop_Remain)).*Disease_Distribution(Disease_Short{dd},Ukraine_Pop.map_raion,false,PopTotal); % Do not want to consider the males 20-59
    
    DB_temp=1-DB_temp./(Pop_Remain+Pop_Male);
    
    Prob_DB=Prob_DB.*DB_temp;
end
% 
Prob_DB=1-Prob_DB;
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % Plot remaining disease burden
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5



S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);
figure('units','normalized','outerposition',[0. 0. 1 1]);

scatter(Lon_P,Lat_P,10,Prob_DB,'filled');
colormap(health_map);
hold on
geoshow(S2,'FaceColor','none','LineWidth',1.5);

box off;
set(gca, 'visible', 'off');



print(gcf,['UKR_Prob_Disease_Burden.png'],'-dpng','-r300');
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % Conflict
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

load('Grid_points_UKR.mat');


[longitude_v,latitude_v]=meshgrid(longitude,latitude);
LonC=cell2mat(vLon_C);
LatC=cell2mat(vLat_C);
P=zeros(length(latitude_v(:)),length(vLon_C));
PCt=ones(length(latitude_v(:)),1);
PC=zeros(length(latitude_v(:)),length(vLon_C));
tic;
for jj=1:length(vLon_C)
    P= Kernel_Displacement(vLat_C{jj},vLon_C{jj},latitude_v(:),longitude_v(:),Parameter);
    PCt=PCt.*(1-P(:,jj));    
    Pt=Parameter.w.*P+(1-Parameter.w).*Parameter.ScaleC.*(1-PCt);
    PC(:,jj)=Pt;
end
toc;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % Run the plot
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5


figure('units','normalized','outerposition',[0. 0. 1 1]);

S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);

Ps=reshape(1-prod(1-PC,2),length(latitude),length(longitude));
Ps(~tp_UKR)=0;
contourf(longitude,latitude,log10(Ps),'LineStyle','none');
hold on
geoshow(S2,'FaceColor','none','LineWidth',1.5);

colormap(conflict_map);

box off;
set(gca, 'visible', 'off');


print(gcf,['UKR_Conflict_Displacement.png'],'-dpng','-r300');


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% % Plot hospital
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure('units','normalized','outerposition',[0. 0. 1 1]);

H=shaperead('Health/hotosm_ukr_health_facilities_points.shp','UseGeoCoords',true);
N={H.amenity};
tfh=strcmp(N,'hospital')|strcmp(N,'cancer');
H=H(tfh);
text([H.Lon],[H.Lat],'H','color','b','Fontsize',18,'FontWeight','bold','Horizontalalignment','center');
hold on;
geoshow(S2,'FaceColor','none','LineWidth',1.5);
text([H.Lon],[H.Lat],'H','color','b','Fontsize',18,'FontWeight','bold','Horizontalalignment','center');

box off;
set(gca, 'visible', 'off');

print(gcf,['UKR_Hospital.png'],'-dpng','-r300');