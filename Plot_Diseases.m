clear;
close all;
% clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Load data and determine the dispacement per day
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
LoadData;

load('Kernel_Paremeter.mat','Parameter');

% load('Grid_points_UKR.mat');

% 
% [longitude_v,latitude_v]=meshgrid(longitude,latitude);
% LonC=cell2mat(vLon_C);
% LatC=cell2mat(vLat_C);
% P = Kernel_Displacement(LatC(:),LonC(:),latitude_v(:),longitude_v(:),Parameter);

[Pop_Displace_Day,Pop_Displace]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Lat_P,Lon_P,Pop);
% Displace_Pop=sum(Pop_Displace,2);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % Run the plot
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% 
% Diseases={'HIV','TB','Cancer'};
% 
% S1=shaperead('UKR_ADM_1\UKR_adm1.shp','UseGeoCoords',true);
% Oblast_Name=cell(length(S1),1);
% 
% for ii=1:length(Oblast_Name)
%     Oblast_Name{ii}={S1(ii).NAME_1};
% end
% 
% S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);
% Raion_Name=cell(length(S2),1);
% 
% for ii=1:length(Raion_Name)
%     Raion_Name{ii}={S2(ii).NAME_2};
% end
% 
% Total_Burden=zeros(length(Diseases),1);
% Oblast_Burden=zeros(length(Diseases),length(Oblast_Name));
% Raion_Burden=rand(length(Diseases),length(Raion_Name));
% 
% figure('units','normalized','outerposition',[0. 0. 1 1]);
% % axesm miller
% Ps=reshape(P,length(latitude),length(longitude));
% Ps(~tp_UKR)=0;
% contourf(longitude,latitude,log10(Ps),'LineStyle','none');
% hold on
% geoshow(S2,'FaceColor','none','LineWidth',1.5)
% 
% 
% % for ii=1:length(Diseases)
% lambda_D=1.7;
% lambda_GDP=0.0007; 
% PR=[57.7 7.4 11 4.7 5.5 10]';
% PR=100.*PR./sum(PR);
%     lambda_P=lsqnonlin(@(x)(PR-Disease_Burden_Displacement(Diseases{1},Displace_Pop,Oblast_Name,Raion_Name,Ukraine_Pop,x(1),10.^x(2),x(3))),[lambda_D log10(lambda_GDP) 0.95],[0 -10 0],[3 0 1]);
% % end
% [Per_Cases,Total_Burden,Oblast_Burden,Raion_Burden] =Disease_Burden_Displacement(Diseases{1},Displace_Pop,Oblast_Name,Raion_Name,Ukraine_Pop,lambda_P(1),10.^lambda_P(2),lambda_P(3));
% Total_Burden



