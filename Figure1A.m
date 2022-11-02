% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % % Produces the panels for Figure 1
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
clear;
close all;
clc;
% 
% [Number_Displacement,Date_Displacement,vLat_C,vLon_C,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,Pop_MACRO,Pop_raion,Pop_oblast,Time_Sim,ML_Indx,RC,Time_Switch]=LoadData;
% day_W_fix=7;
% load('Merge_Parameter_MLE.mat')
% 
% x=MLE_KD;
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % % Load data and determine the dispacement per day
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% [Parameter,STDEV_Displace]=Parameter_Return(x,RC,Time_Switch,day_W_fix);
% load('Conflict_Colourmap.mat','conflict_map');
% 
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % % Determine the disease burden
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% 
% 
% c=5;
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
% nDays=length(Time_Sim);
% PC=zeros(length(latitude_v(:)),nDays);
% 
% PC_W=zeros(length(latitude_v(:)),Parameter.day_W);
% for jj=1:nDays
%     if(Time_Sim(jj)<Parameter.Switch)
%         P = Kernel_Displacement(vLat_C{jj},vLon_C{jj},latitude_v(:),longitude_v(:),Parameter);
%         
%     else
%         P = Parameter.Switch_Scaled.*Kernel_Displacement(vLat_C{jj},vLon_C{jj},latitude_v(:),longitude_v(:),Parameter);
%         
%     end
%     % Cumulative probability
%     PC_W(:,2:Parameter.day_W)=PC_W(:,1:(Parameter.day_W-1));    
%     PC_W(:,1)=P;
%     PC(:,jj)=1-prod(1-PC_W(:,[1:min(jj,Parameter.day_W)]),2);
% end
% 
% 
% BC=readtable('ukr_border_crossings_140422.xlsx','Sheet','Border Crossings');
% 
% bc_lat=BC.Lat;
% bc_lon=BC.Long;
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % % Plot map of conflict
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% 
% 
% S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);
% 
% xp=linspace(22.15,40.22,length(conflict_map(:,1))+1);
%      yp=[44 44.3];    
%      
%     
%         figure('units','normalized','outerposition',[0 0 1.*0.775 1]);
%          subplot('Position',[0.0082,0.1681,1,0.815]);
%         
%         Ps=reshape(1-geomean(1-PC,2),length(latitude),length(longitude));
%         Ps(~tp_UKR)=0;
%         contourf(longitude,latitude,log10(Ps),'LineStyle','none');
%         hold on
%         geoshow(S2,'FaceColor','none','LineWidth',1.5,'EdgeColor',[0.4 0.4 0.4]);
%         colormap(conflict_map);
%         
%         
%     
%     box off;
%     for jj=1:length(conflict_map(:,1))
%         patch([xp(jj) xp(jj) xp(jj+1) xp(jj+1)],[yp(1) yp(2) yp(2) yp(1)],conflict_map(jj,:),'LineStyle','none');
%         if(jj==1)
%             text(xp(jj+1),yp(1)-0.01,['None'],'Fontsize',28,'rotation',90,'Horizontalalignment','right')
%         elseif(jj==length(conflict_map(:,1)))
%             text(xp(jj+1),yp(1)-0.01,{'High'},'Fontsize',28,'rotation',90,'Horizontalalignment','right')
%         end
%     end
%     patch([xp(1) xp(1) xp(end) xp(end)],[yp(1) yp(2) yp(2) yp(1)],'k','Facealpha',0);
%     text(22,52.74,'A','Fontsize',40,'FontWeight','bold');
%     text(31.252835977086363,43.412321118918925,['Probability of forcible displacement'],'Fontsize',30,'Horizontalalignment','center');
%     text(32,52.83,'Forcible displacement','Fontsize',30,'Horizontalalignment','center');   
%     
%     ss=scatter(bc_lon,bc_lat,200,'x','MarkerEdgeColor','k','MarkerFaceColor','k','LineWidth',4.5);
% legend(ss,'Border crossing','Fontsize',28,'Position',[0.681612324145068,0.868625465789303,0.212635864260728,0.051671731103638]);
% 
%     set(gca, 'visible', 'off');
%     
%     print(gcf,['UKR_Prob_Disease_Burden_Figure_1_Conflict.png'],'-dpng','-r300');
% %     
% clear; 
load('Ukraine_Population_Reduced.mat','Ukraine_Pop')
Mapped_Raion_Name=Ukraine_Pop.map_raion;
clear Ukraine_Pop

[Number_Displacement,Date_Displacement,vLat_C,vLon_C,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,Pop_SES,Pop_MACRO,Pop_raion,Pop_oblast,Time_Sim,RC,Time_Switch]=LoadData(200);

age_class_v={'0-4','5-9','10-14','15-19','20-24','25-29','30-34','35-39','40-44','45-49','50-54','55-59','60-64','65-69','70-74','75-79','80+'};
gender_v={'f','m'};

Pop=zeros(length(gender_v),length(Pop_raion),length(age_class_v));
Pop(1,:,:)=Pop_F_Age;
Pop(2,:,:)=Pop_M_Age;

Disease_Short={'CVD';'Diabetes';'Cancer';'HIV';'TB'};

Disease={'Cardiovascular disease';'Diabetes';'Cancer';'HIV';'Tuberculosis'};

S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);
Raion_S={S2.NAME_2};
Oblast_S={S2.NAME_1};

PopR=zeros(size(Pop));
for ii=1:length(Raion_S)
   tf=strcmp(Pop_raion,Raion_S{ii}) &  strcmp(Pop_oblast,Oblast_S{ii});
   for aa=1:length(Pop_F_Age(1,:))
       for gg=1:2
            PopR(gg,tf,aa)=sum(Pop(gg,tf,aa));
       end
   end
end

Prob_DB=zeros(length(S2),length(Disease_Short));
beta_T=10.^[3.05241835779787;2.69599664807722;0.595801670461706;1.55183259987430;0.878500094803445];
    PopT=sum(Pop,[1 3]);
for dd=1:length(Disease_Short)
    [dpc,~,~]=Disease_Distribution_beta(beta_T(dd),Disease_Short{dd},Mapped_Raion_Name,age_class_v,gender_v,Pop,repmat(Pop,1,1,1,2),Pop,Pop,PopR,false);
    dpc=sum(dpc,[1 3]);
    testd=Prev_Disease(Disease_Short{dd},false);
    [sum(dpc(:)) testd]
    for rr=1:length(S2)      
        tf=strcmp(S2(rr).NAME_1,Pop_oblast) & strcmp(S2(rr).NAME_2,Pop_raion);
        Prob_DB(rr,dd)=sum(dpc(tf))./sum(PopT(tf));
    end
end

CC=[hex2rgb('#FB6542'); % CVD
    hex2rgb('#807dba'); %Diabetes
    hex2rgb('#FFBB00'); % Cancer
    hex2rgb('#034e76'); % HIV
%     hex2rgb('#9ebcda'); % HIV Treatment
    hex2rgb('#8c2d04');]; %TB
%     hex2rgb('#DE7a22');]; %TB drug-resitant
    
xp=linspace(22.15,40.22,101);
     yp=[44 44.3];
%      
for dd=1:(length(Disease_Short))
    test_M=Prob_DB(:,dd).*1000;
    X=prctile(test_M(test_M>0),[1:1:100]);
    FA=[1:1:100]./100;
    ddx=dd+1;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % Plot remaining disease burden
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    
    figure('units','normalized','outerposition',[0.2 0.2 1.*0.775/2 1/2]);
    subplot('Position',[0.0082,0.1681,1,0.815]);
    
    scatter(32,53,0.1,'w'); hold on;
    for jj=1:length(S2)    
        if(test_M(jj)>0)
            fx=find(test_M(jj)<=X,1);
            geoshow(S2(jj),'FaceColor',CC(dd,:),'FaceAlpha',FA(fx),'LineWidth',1.5,'EdgeColor',[0.4 0.4 0.4]);
        else
                geoshow(S2(jj),'FaceColor','k','FaceAlpha',0.4,'LineWidth',1.5,'EdgeColor',[0.4 0.4 0.4]);
        end
    end
    box off;
    for jj=1:length(FA)
        patch([xp(jj) xp(jj) xp(jj+1) xp(jj+1)],[yp(1) yp(2) yp(2) yp(1)],CC(dd,:),'FaceAlpha',FA(jj));
        if(dd<4 && dd>1)
            if(jj==1)
                text(xp(jj+1),yp(1)-0.01,[ '\leq' num2str(X(jj),'%3.1f')],'Rotation',90,'Fontsize',18,'Horizontalalignment','right')
            elseif(rem(jj,10)==0)
                text(xp(jj+1),yp(1)-0.01,[ num2str(X(jj),'%3.1f')],'Rotation',90,'Fontsize',18,'Horizontalalignment','right')
            end
        elseif (dd>=4)
            if(jj==1)
                text(xp(jj+1),yp(1)-0.01,[ '\leq' num2str(X(jj),'%3.2f')],'Rotation',90,'Fontsize',18,'Horizontalalignment','right')
            elseif(rem(jj,10)==0)
                text(xp(jj+1),yp(1)-0.01,[ num2str(X(jj),'%3.2f')],'Rotation',90,'Fontsize',18,'Horizontalalignment','right')
            end            
        else
            if(jj==1)
                text(xp(jj+1),yp(1)-0.01,[ '\leq' num2str(X(jj),'%3.0f')],'Rotation',90,'Fontsize',18,'Horizontalalignment','right')
            elseif(rem(jj,10)==0)
                text(xp(jj+1),yp(1)-0.01,[ num2str(X(jj),'%3.0f')],'Rotation',90,'Fontsize',18,'Horizontalalignment','right')
            end            
        end
    end
    text(22,52.74,char(65+dd),'Fontsize',40,'FontWeight','bold');
    text(median(xp),42.5836,['Prevalence per 1,000 people'],'Fontsize',22,'Horizontalalignment','center');
    text(32,52.83,Disease{dd},'Fontsize',30,'Horizontalalignment','center');        
    set(gca, 'visible', 'off');
   
    print(gcf,['UKR_Prob_Disease_Burden_Figure_1_Panel=' num2str(dd) '.png'],'-dpng','-r300');
    
    
end
