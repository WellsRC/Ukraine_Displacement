% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % Produces the panels for Figure 1
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
clear;
close all;
clc;


LoadData;


% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % Load data and determine the dispacement per day
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% 
% 
load('Kernel_Paremeter.mat','Parameter');

load('Conflict_Colourmap.mat','conflict_map');

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % Determine the disease burden
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
load('Grid_points_UKR.mat');


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


BC=readtable('ukr_border_crossings_170322.xlsx','Sheet','Border Crossings');

bc_lat=BC.Lat;
bc_lon=BC.Long;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Plot map of conflict
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5


S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);

xp=linspace(22.15,40.22,length(conflict_map(:,1))+1);
     yp=[44 44.3];    
     
    
        figure('units','normalized','outerposition',[0 0 1.*0.775 1]);
         subplot('Position',[0.0082,0.1681,1,0.815]);
        
        Ps=reshape(1-prod(1-PC,2),length(latitude),length(longitude));
        Ps(~tp_UKR)=0;
        contourf(longitude,latitude,log10(Ps),'LineStyle','none');
        hold on
        geoshow(S2,'FaceColor','none','LineWidth',1.5,'EdgeColor',[0.4 0.4 0.4]);
        colormap(conflict_map);
        
        
    
    box off;
    for jj=1:length(conflict_map(:,1))
        patch([xp(jj) xp(jj) xp(jj+1) xp(jj+1)],[yp(1) yp(2) yp(2) yp(1)],conflict_map(jj,:),'LineStyle','none');
        if(jj==1)
            text(xp(jj+1),yp(1)-0.01,['None'],'Fontsize',28,'rotation',90,'Horizontalalignment','right')
        elseif(jj==length(conflict_map(:,1)))
            text(xp(jj+1),yp(1)-0.01,{'High'},'Fontsize',28,'rotation',90,'Horizontalalignment','right')
        end
    end
    patch([xp(1) xp(1) xp(end) xp(end)],[yp(1) yp(2) yp(2) yp(1)],'k','Facealpha',0);
    text(22,52.74,'A','Fontsize',40,'FontWeight','bold');
    text(median(xp),yp(1)-1.27,['Intensity of conflict'],'Fontsize',30,'Horizontalalignment','center');
    text(32,52.83,'Conflict','Fontsize',30,'Horizontalalignment','center');   
    
    ss=scatter(bc_lon,bc_lat,200,'x','MarkerEdgeColor','k','MarkerFaceColor','k','LineWidth',4.5);
legend(ss,'Border crossing','Fontsize',28,'Position',[0.681612324145068,0.868625465789303,0.212635864260728,0.051671731103638]);

    set(gca, 'visible', 'off');
    
    print(gcf,['UKR_Prob_Disease_Burden_Figure_1_Conflict.png'],'-dpng','-r300');
    
    


Disease_Short={'CVD';'Diabetes';'Cancer';'HIV';'TB'};

Disease={'Cardiovascular disease';'Diabetes';'Cancer';'HIV';'Tuberculosis'};

S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);

Prob_DB=zeros(length(S2),length(Disease_Short));

PopTotal=Ukraine_Pop.population_size;
for dd=1:length(Disease_Short)
    dpc=Disease_Distribution(Disease_Short{dd},Ukraine_Pop.map_raion,false,Pop,Pop)+Disease_Distribution(Disease_Short{dd},Ukraine_Pop.map_raion,true,Pop_Male,Pop_Male);
    for rr=1:length(S2)      
        tf=strcmp(S2(rr).NAME_1,Ukraine_Pop.oblast) & strcmp(S2(rr).NAME_2,Ukraine_Pop.raion);
        Prob_DB(rr,dd)=sum(dpc(tf))./sum(Ukraine_Pop.population_size(tf));
    end
end

CC=[hex2rgb('#F52549'); % CVD
    hex2rgb('#807dba'); %Diabetes
    hex2rgb('#FFBB00'); % Cancer
    hex2rgb('#034e76'); % HIV
%     hex2rgb('#9ebcda'); % HIV Treatment
    hex2rgb('#8c2d04');]; %TB
%     hex2rgb('#DE7a22');]; %TB drug-resitant
    
xp=linspace(22.15,40.22,101);
     yp=[44 44.3];
     fact_inc=[1 1 10 10 100];
%      
for dd=1:(length(Disease_Short))
    test_M=Prob_DB(:,dd).*100.*fact_inc(dd);
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
        if(jj==1)
            text(xp(jj+1),yp(1)-0.01,[ '\leq' num2str(X(jj),'%3.1f')],'Rotation',90,'Fontsize',18,'Horizontalalignment','right')
        elseif(rem(jj,10)==0)
            text(xp(jj+1),yp(1)-0.01,[ num2str(X(jj),'%3.1f')],'Rotation',90,'Fontsize',18,'Horizontalalignment','right')
        end
    end
    text(22,52.74,char(65+dd),'Fontsize',40,'FontWeight','bold');
    text(median(xp),42.5836,['Prevalence per ' num2str(100.*fact_inc(dd)) ' people'],'Fontsize',22,'Horizontalalignment','center');
    text(32,52.83,Disease{dd},'Fontsize',30,'Horizontalalignment','center');        
    set(gca, 'visible', 'off');
   
    print(gcf,['UKR_Prob_Disease_Burden_Figure_1_Panel=' num2str(dd) '.png'],'-dpng','-r300');
    
    
end
