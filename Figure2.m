% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% % Plot hospital
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


figure('units','normalized','outerposition',[0. 0. 1 1]);

S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);

H=shaperead('Health/hotosm_ukr_health_facilities_points.shp','UseGeoCoords',true);

N={H.amenity};
tfh=strcmp(N,'hospital')|strcmp(N,'cancer');
H=H(tfh);


marker = imread('H_icon_inverted.png');

markersize = 0.95.*[0.2,0.16]; %//The size of marker is expressed in axis units, NOT in pixels
x_low = [H.Lon] - markersize(1)/2; %//Left edge of marker
x_high = [H.Lon] + markersize(1)/2;%//Right edge of marker
y_low = [H.Lat] - markersize(2)/2; %//Bottom edge of marker
y_high = [H.Lat] + markersize(2)/2;%//Top edge of marker

text([H.Lon],[H.Lat],' ','color','w','Fontsize',18,'FontWeight','bold','Horizontalalignment','center');
hold on;
geoshow(S2,'FaceColor','none','LineStyle','none');


for k = 1:length([H.Lon])
    imagesc([x_low(k) x_high(k)], [y_low(k) y_high(k)], marker)
    hold on
end

box off;
set(gca, 'visible', 'off');

print(gcf,['UKR_Hospital.png'],'-dpng','-r300');