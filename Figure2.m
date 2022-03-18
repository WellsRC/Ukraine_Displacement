% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% % Plot hospital
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load('Grid_points_UKR.mat');
load('Kernel_Paremeter.mat','Parameter');

load('Conflict_Colourmap.mat','conflict_map');

[longitude_v,latitude_v]=meshgrid(longitude,latitude);

H_near_Conflict=[47.1298	37.571
50.2649	28.6767
49.2088	37.2485
50.5218	30.2506
50.4496	30.5224
48.9054	38.4353
48.6333	38.378
50.4267	30.4538
48.9054	38.4353
47.1298	37.571
49.9808	36.2527
49.9808	36.2527
50.2649	28.6767
49.4606	36.8527
50.4646	30.4655
51.5055	31.2849
46.8489	35.3653
47.7789	37.2481];

date_HC=datenum([{'March 9, 2022';'March 9, 2022';'March 8, 2022';'March 8, 2022';'March 6, 2022';'March 5, 2022';'March 5, 2022';'March 5, 2022';'March 3, 2022';'March 2, 2022';'March 2, 2022';'March 1, 2022';'March 1, 2022';'February 28, 2022';'February 26, 2022';'February 25, 2022';'February 25, 2022';'February 24, 2022'}]);


HC_Lat=H_near_Conflict(:,1);
HC_Lon=H_near_Conflict(:,2);

date_HCu=unique(date_HC);
HC_Latv=cell(size(date_HCu));
HC_Lonv=cell(size(date_HCu));

for ii=1:length(date_HCu)
    HC_Latv{ii}=HC_Lat(date_HCu(ii)==date_HC);
    HC_Lonv{ii}=HC_Lon(date_HCu(ii)==date_HC);
end

PCt=ones(length(latitude_v(:)),1);
PC=zeros(length(latitude_v(:)),length(HC_Lonv));
for jj=1:length(HC_Latv)
    P= Kernel_Displacement(HC_Latv{jj},HC_Lonv{jj},latitude_v(:),longitude_v(:),Parameter);
    PCt=PCt.*(1-P);    
    Pt=Parameter.w.*P+(1-Parameter.w).*Parameter.ScaleC.*(1-PCt);
    PC(:,jj)=Pt;
end
figure('units','normalized','outerposition',[0. 0. 1 1]);

S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);

Ps=reshape(1-prod(1-PC,2),length(latitude),length(longitude));
Ps(~tp_UKR)=0;
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

text([H.Lon],[H.Lat],' ','color','w','Fontsize',18,'FontWeight','bold','Horizontalalignment','center');
hold on;
geoshow(S2,'FaceColor','none','LineWidth',1.5);


for k = 1:length([H.Lon])
    imagesc([x_low(k) x_high(k)], [y_low(k) y_high(k)], marker)
    hold on
end

box off;
set(gca, 'visible', 'off');

print(gcf,['UKR_Hospital.png'],'-dpng','-r300');