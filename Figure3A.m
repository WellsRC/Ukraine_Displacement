clear;
clc;
close all;

load('IDP_Fit_Inputs.mat','Raion_IDP');
load('Input_Figure3D.mat','Raion_Zone_R');



figure('units','normalized','outerposition',[0. 0. 1 1]);
ColRZ=[hex2rgb('33685b');hex2rgb('6fb98f');hex2rgb('b3c100')];

scatter(37.62,51.5,1,'w'); hold on;
text(37.62,52.5,'IDP Zone-1','Fontsize',28,'Color',ColRZ(1,:));
text(37.62,52,'IDP Zone-2','Fontsize',28,'Color',ColRZ(2,:));
text(37.62,51.5,'IDP Zone-3','Fontsize',28,'Color',ColRZ(3,:));

S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);
for ii=1:length(S2)
    if(Raion_IDP(ii)==0)
        geoshow(S2(ii),'LineWidth',1.5,'FaceAlpha',0,'Edgecolor',[0.4 0.4 0.4]);
    end
end


for ii=1:length(S2)
    if(Raion_IDP(ii)>0)
        geoshow(S2(ii),'LineWidth',1.5,'FaceAlpha',1,'EdgeColor',ColRZ(Raion_Zone_R(ii),:),'FaceColor',ColRZ(Raion_Zone_R(ii),:));
    end
end


axis off;

text(22,52.12,'A','Fontsize',30,'FontWeight','bold');

print(gcf,['IDP_Zone_Map.png'],'-dpng','-r300');