% clear;
% close all;
% 
% c=10;
% d_lon=fminbnd(@(z)(integral(@(x)deg2km(distance('gc',x,32,x,32+z)),44,53)./(53-44)-c).^2,0,1);
% d_lat=fminbnd(@(z)(integral(@(x)deg2km(distance('gc',48,x,48+z,x)),22,42)./(42-22)-c).^2,0,1);
% 
% latitude=44:d_lat:53;
% longitude=22:d_lon:42;
% [longitude_v,latitude_v]=meshgrid(longitude,latitude);
% 
% S1=shaperead('UKR_ADM_1\UKR_adm1.shp','UseGeoCoords',true);
% 
% for ii=1:length(S1)
%    [tp_in,tp_on]=inpolygon(longitude_v(:),latitude_v(:),S1(ii).Lon,S1(ii).Lat);
%    if(ii==1)
%       tp_UKR=tp_in|tp_on;
%    else
%       tp_UKR=tp_UKR|tp_in|tp_on; 
%    end
% end
% 
% [Number_Displacement,Date_Displacement,vLat_C,vLon_C,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,Pop_MACRO,Pop_raion,Pop_oblast,Time_Sim,ML_Indx,RC,Time_Switch]=LoadData;
% 
% T=readtable('idp_estimation_08_03_2022-unhcr-protection-cluster.xlsx','Sheet','Dataset');
% Num_IDP=T.IDPEstimation;
% Lat_IDP=T.YLatitude;
% Lon_IDP=T.XLongitude;
% 
% nDays=length(vLat_C);
% PS_MinDay=zeros(length(latitude_v(:)),nDays);
% PS_MeanDay=zeros(size(PS_MinDay));
% PS_MedianDay=zeros(size(PS_MinDay));
% 
% 
% for jj=1:nDays    
%     [PS_MinDay(:,jj),PS_MeanDay(:,jj),PS_MedianDay(:,jj)]=Min_Distance_Conflict(vLat_C{jj},vLon_C{jj},latitude_v(:),longitude_v(:));
% end

% PS_GeoDay=zeros(size(PS_MinDay));
% for ii=1:nDays
%     PS_GeoDay(:,ii)=1-geomean(PS_MinDay(:,max(1,ii-6):ii),2);
% end
% clear;
% S0=shaperead('UKR_ADM_0\UKR_adm0.shp','UseGeoCoords',true);
% fig1=figure('units','normalized','outerposition',[0. 0. 1 1]);
% for dayplot=1:4
%     switch dayplot
%         case 1
%             sp1=subplot('Position',[0.01 0.51 0.45 0.45]);
%         case 2
%             sp2=subplot('Position',[0.46 0.51 0.45 0.45]);
%         case 3
%             sp3=subplot('Position',[0.01 0.02 0.45 0.45]);
%         case 4
%             sp4=subplot('Position',[0.46 0.02 0.45 0.45]);
%     end
% 
%     geoshow(S0,'FaceColor','none','LineWidth',1.5,'EdgeColor',[0.4 0.4 0.4]);
% end
%save('Fig_2_Properties.mat','fig1','sp1','sp2','sp3','sp4');
close all;
load('Figure_2_Plotting_Data.mat');


load('Conflict_Colourmap.mat','conflict_map');
dp=[7 13 21 42;
    59 66 72 79];

for jj=1:2    
%     close all;
    load('Fig_2_Properties.mat')
    for dayplot=1:4
        switch dayplot
            case 1
                set(fig1, 'CurrentAxes', sp1)
            case 2
                set(fig1, 'CurrentAxes', sp2)
            case 3
                set(fig1, 'CurrentAxes', sp3)
            case 4
                set(fig1, 'CurrentAxes', sp4)
        end

        Safe_Day=PS_GeoDay(:,dp(jj,dayplot));
        Ps=reshape(Safe_Day,length(latitude),length(longitude));
        Ps(~tp_UKR)=NaN;
        
        hold on;
        contourf(longitude,latitude,(Ps),'LineStyle','none'); 
        if(datenum('February 23, 2022')+dp(jj,dayplot)==datenum('March 8, 2022'))
            ss=scatter(Lon_IDP,Lat_IDP,30,'MarkerFaceColor',hex2rgb('#258039'),'MarkerEdgeColor',hex2rgb('#258039')); hold on;
            legend(ss,'UNHCR IDP site','Fontsize',18);
            legend boxoff;
        end
        if dayplot==1
            cxl=caxis;
        else
            caxis(cxl);
        end

        if((dayplot==4) &&(jj==2))
            h=colorbar;
            h.Position=[0.892419467669721,0.041540020263425,0.011204481792717,0.931104356636274];
            h.Ticks=[h.Limits];
            h.TickLabels={'Low-risk','High-Risk'};
            h.FontSize=20;
        end
        text(29.38,max(latitude),datestr([datenum('February 23, 2022')+dp(jj,dayplot)],'mmmm dd, yyyy'),'Fontsize',28);
        text(min(longitude),max(latitude),char(64+dayplot+4.*(jj-1)),'Fontsize',30,'FontWeight','bold');
        box off;
    set(gca, 'visible', 'off');
    colormap(conflict_map);
    end
    print(gcf,['Estimated_Risk_Region-' num2str(jj) '.png'],'-dpng','-r300');
end

figure('units','normalized','outerposition',[0.2 0.2 0.6 0.6]);
Sum_Safe=sum(PS_GeoDay,1);
Sum_Safe=(Sum_Safe-min(Sum_Safe))./(max(Sum_Safe)-min(Sum_Safe));
subplot('Position',[0.139084507042254,0.335135135135135,0.84154929577465,0.618018018018018]);
plot([1:nDays],Sum_Safe,'-ko','LineWidth',2,'MarkerFaceColor','k');
xlabel('Date','Fontsize',24);
ylabel('Relative level of risk','Fontsize',24,'Position',[-8.231208906156617,0.500000476837158,-0.999999999999986]);
xlim([1 nDays]);
ylim([0 1]);
text(-10.231208906156617,1.010260770975057,{'Highest','risk'},'Fontsize',16)
text(-10.231208906156617,-0.005830903790087,{'Lowest','risk'},'Fontsize',16)
set(gca,'LineWidth',2,'tickdir','out','Fontsize',20,'XTick',[1:7:nDays],'Ytick',[0:0.1:1],'XTickLabel',{datestr(datenum('February 24,2022')+[0:7:(nDays-1)])});
xtickangle(45);
box off;
print(gcf,['Relative_Risk_UKR.png'],'-dpng','-r300');

