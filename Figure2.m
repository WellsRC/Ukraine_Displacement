clear;
close all;

T=readtable('UNHCR_UKR_Date.csv');
Date_Displacement=datenum(T.data_date);
Date_Displacement=Date_Displacement(Date_Displacement<=datenum('March 11, 2022'));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% Conflict data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
T=readtable('2022-01-01-2022-03-17-Ukraine.csv');

ET=T.event_type;

tf=~strcmp(ET,'Protests');

T=T(tf,:);

DT=datenum(T.event_date);

T=T(DT>=datenum('February 24, 2022'),:);

vLat_C=cell(length(Date_Displacement),1);
vLon_C=cell(length(Date_Displacement),1);

Date_Conflict=zeros(height(T),1);
for ii=1:length(Date_Conflict)
    Date_Conflict(ii)=datenum(T.event_date(ii));
end

for ii=1:length(Date_Displacement)
   f=find(Date_Conflict==Date_Displacement(ii));
   vLat_C{ii}=T.latitude(f);
   vLon_C{ii}=T.longitude(f);
end

load('Kernel_Paremeter.mat','Parameter');
load('Grid_points_UKR_Fewer.mat')
[longitude_v,latitude_v]=meshgrid(longitude,latitude);


T=readtable('idp_estimation_08_03_2022-unhcr-protection-cluster.xlsx','Sheet','Dataset');
Num_IDP=T.IDPEstimation;
Lat_IDP=T.YLatitude;
Lon_IDP=T.XLongitude;

nDays=length(vLat_C);
PS_MinDay=zeros(length(latitude_v(:)),nDays);
PS_MeanDay=zeros(size(PS_MinDay));
PS_MedianDay=zeros(size(PS_MinDay));


for jj=1:nDays    
    [PS_MinDay(:,jj),PS_MeanDay(:,jj),PS_MedianDay(:,jj)]=Min_Distance_Conflict(vLat_C{jj},vLon_C{jj},latitude_v(:),longitude_v(:));
end

PS_GeoDay=zeros(size(PS_MinDay));
for ii=1:16
    PS_GeoDay(:,ii)=geomean(PS_MinDay(:,1:ii),2);
end

close all;

load('safety_colormap.mat','safety_map');
figure('units','normalized','outerposition',[0. 0. 1 1]);
dp=[5 9 13 16];
for dayplot=1:4
    switch dayplot
        case 1
            subplot('Position',[0.01 0.51 0.45 0.45])
        case 2
            subplot('Position',[0.46 0.51 0.45 0.45])
        case 3
            subplot('Position',[0.01 0.02 0.45 0.45])
        case 4
            subplot('Position',[0.46 0.02 0.45 0.45])
    end
    
    Safe_Day=PS_GeoDay(:,dp(dayplot));
    if(dayplot==3)
        scatter(Lon_IDP,Lat_IDP,5,'r','filled'); hold on;
    end
    Ps=reshape(Safe_Day,length(longitude),length(latitude));
    Ps(~tp_UKR)=NaN;
    contourf(unique(longitude_v),unique(latitude_v),(Ps),'LineStyle','none');
    
    if(dayplot==3)
        ss=scatter(Lon_IDP,Lat_IDP,10,'r','filled'); hold on;
        legend(ss,'UNHCR IDP site','Fontsize',18);
        legend boxoff;
    end
    if dayplot==1
        cxl=caxis;
    else
        caxis(cxl);
    end
    
    if(dayplot==4)
        h=colorbar;
        h.Position=[0.892419467669721,0.041540020263425,0.011204481792717,0.931104356636274];
        h.Ticks=[h.Limits];
        h.TickLabels={'Least safe','Most safe'};
        h.FontSize=20;
    end
    text(29.38,max(latitude),datestr([datenum('February 23, 2022')+dp(dayplot)],'mmmm dd, yyyy'),'Fontsize',28);
    text(min(longitude),max(latitude),char(64+dayplot),'Fontsize',30,'FontWeight','bold');
    box off;
set(gca, 'visible', 'off');
colormap(safety_map);
end
print(gcf,['Estimated_Safety_Region.png'],'-dpng','-r300');