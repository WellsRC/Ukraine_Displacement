close all;
clear;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % Conflict
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
LoadData;
load('Kernel_Paremeter.mat','Parameter');
load('Grid_points_UKR.mat');

load('Conflict_Colourmap.mat','conflict_map');

[longitude_v,latitude_v]=meshgrid(longitude,latitude);
LonC=cell2mat(vLon_C);
LatC=cell2mat(vLat_C);
P=zeros(length(latitude_v(:)),length(vLon_C));
PCt=ones(length(latitude_v(:)),1);
PC=zeros(length(latitude_v(:)),length(vLon_C));
for jj=1:length(vLon_C)
    P= Kernel_Displacement(vLat_C{jj},vLon_C{jj},latitude_v(:),longitude_v(:),Parameter);
    PCt=PCt.*(1-P);    
    Pt=Parameter.w.*P+(1-Parameter.w).*Parameter.ScaleC.*(1-PCt);
    PC(:,jj)=Pt;
end

S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);

Ps=reshape(1-prod(1-PC,2),length(latitude),length(longitude));
Ps(~tp_UKR)=0;


figure('units','normalized','outerposition',[0. 0. 1 1]);
contourf(longitude,latitude,log10(Ps),'LineStyle','none');
hold on
geoshow(S2,'FaceColor','none','LineWidth',1.5);
colormap(conflict_map);

H=shaperead('Health/hotosm_ukr_health_facilities_points.shp','UseGeoCoords',true);

N={H.amenity};
tfh=strcmp(N,'hospital')|strcmp(N,'cancer');
H=H(tfh);


marker = imread('H_icon.png');

markersize = 0.95.*[0.2,0.16]; %//The size of marker is expressed in axis units, NOT in pixels
x_low = [H.Lon] - markersize(1)/2; %//Left edge of marker
x_high = [H.Lon] + markersize(1)/2;%//Right edge of marker
y_low = [H.Lat] - markersize(2)/2; %//Bottom edge of marker
y_high = [H.Lat] + markersize(2)/2;%//Top edge of marker

for k = 1:length([H.Lon])
    imagesc([x_low(k) x_high(k)], [y_low(k) y_high(k)], marker)
    hold on
end

box off;
set(gca, 'visible', 'off');
text(22,52.12,'C','Fontsize',30,'FontWeight','bold');
print(gcf,['UKR_Hospital.png'],'-dpng','-r300');