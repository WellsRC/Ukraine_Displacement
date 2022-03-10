clear;
close all;
% clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Load data and determine the dispacement per day
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
LoadData;

load('Kernel_Paremeter.mat','Parameter');

load('Grid_points_UKR.mat');


[longitude_v,latitude_v]=meshgrid(longitude,latitude);
LonC=cell2mat(vLon_C);
LatC=cell2mat(vLat_C);
P=zeros(length(latitude_v(:)),length(vLon_C));
PCt=ones(length(latitude_v(:)),1);
PC=zeros(length(latitude_v(:)),length(vLon_C));
tic;
for jj=1:length(vLon_C)
    P(:,jj) = Kernel_Displacement(vLat_C{jj},vLon_C{jj},latitude_v(:),longitude_v(:),Parameter);
    PCt=PCt.*(1-P(:,jj));
    PC(:,jj)=1-PCt;
end
toc;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % Run the plot
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);
 figure('units','normalized','outerposition',[0. 0. 1 1]);
 P=mean(P,2);
Ps=reshape(P,length(latitude),length(longitude));
Ps(~tp_UKR)=0;
contourf(longitude,latitude,log10(Ps),'LineStyle','none');
hold on
geoshow(S2,'FaceColor','none','LineWidth',1.5)

title('Mean daily');

figure('units','normalized','outerposition',[0. 0. 1 1]);

Ps=reshape(PC(:,end),length(latitude),length(longitude));
Ps(~tp_UKR)=0;
contourf(longitude,latitude,log10(Ps),'LineStyle','none');
hold on
geoshow(S2,'FaceColor','none','LineWidth',1.5)

title('Final Cumulative');

figure('units','normalized','outerposition',[0. 0. 1 1]);
 PC=mean(PC,2);
Ps=reshape(PC,length(latitude),length(longitude));
Ps(~tp_UKR)=0;
contourf(longitude,latitude,log10(Ps),'LineStyle','none');
hold on
geoshow(S2,'FaceColor','none','LineWidth',1.5)
title('Mean Cumulative');



