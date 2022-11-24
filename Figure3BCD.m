clear;
clc;
close all; 

H=shaperead('Health/hotosm_ukr_health_facilities_points.shp','UseGeoCoords',true);

N={H.amenity};
tfh=strcmp(N,'hospital')|strcmp(N,'cancer');
H=H(tfh);

HLon=[H.Lon];
HLat=[H.Lat];

[day_W_fix,RC,MLE_FD,MLE_Map_Ref,MLE_Map_IDP,FD_Model,Model_IDP,Model_Refugee] = Selected_Model_Parameters_MLE;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % Load data and determine the dispacement per day
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

[Parameter,~]=Parameter_Return(MLE_FD,RC,Time_Switch,day_W_fix,FD_Model);



nDays=length(Time_Sim);
PC=zeros(length(cell2mat(vLat_C)),nDays);
PC_H=zeros(length(HLat),nDays);

PC_W=zeros(length(cell2mat(vLat_C)),Parameter.day_W);
PCH_W=zeros(length(HLat),Parameter.day_W);
for jj=1:nDays
    if(Time_Sim(jj)<Parameter.Switch)
        P = Kernel_Displacement(vLat_C{jj},vLon_C{jj},cell2mat(vLat_C),cell2mat(vLon_C),Parameter);
        PH= Kernel_Displacement(vLat_C{jj},vLon_C{jj},HLat,HLon,Parameter);
        
    else
        P = Parameter.Switch_Scaled.*Kernel_Displacement(vLat_C{jj},vLon_C{jj},cell2mat(vLat_C),cell2mat(vLon_C),Parameter);
        PH = Parameter.Switch_Scaled.*Kernel_Displacement(vLat_C{jj},vLon_C{jj},HLat,HLon,Parameter);
    end
    % Cumulative probability
    PC_W(:,2:Parameter.day_W)=PC_W(:,1:(Parameter.day_W-1));    
    PC_W(:,1)=P;
    
    PCH_W(:,2:Parameter.day_W)=PCH_W(:,1:(Parameter.day_W-1));    
    PCH_W(:,1)=PH;
    
    PC(:,jj)=1-prod(1-PC_W(:,[1:min(jj,Parameter.day_W)]),2);
    PC_H(:,jj)=1-prod(1-PCH_W(:,[1:min(jj,Parameter.day_W)]),2);
end

P_H=1-geomean(1-PC_H,2);
P_C=1-geomean(1-PC,2);

NN=(PC_H./repmat(sum(PC_H,2),1,length(Time_Sim)));
NN(isnan(NN))=1;
Test_H2=repmat(P_H./max(P_C),1,length(Time_Sim)).*NN;


HLonNCZ=HLon(P_H==0);
HLatNCZ=HLat(P_H==0);

P_H=P_H./max(P_C);


S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);

Hosp_Raion=zeros(length(S2),3);

for ii=1:length(S2)
   [p_in,~]=inpolygon( HLat,HLon,S2(ii).Lat,S2(ii).Lon);
   Hosp_Raion(ii,1)=sum(p_in);
   Hosp_Raion(ii,2)=sum(P_H(p_in));
   if(Hosp_Raion(ii,1)>0)
        Hosp_Raion(ii,3)=sum(P_H(p_in))./sum(p_in);
   end
end
SC=Hosp_Raion(:,3)./max(Hosp_Raion(:,3));


S1=shaperead('UKR_ADM_1\UKR_adm1.shp','UseGeoCoords',true);
open('UKR_0_Map.fig')

for ii=1:length(S2)
	geoshow(S2(ii),'LineStyle','none','FaceAlpha',SC(ii),'Facecolor',hex2rgb('#A11F0C'));
end


load('Macro_Oblast_Map.mat','Macro_Map');
MNR=unique(Macro_Map(:,3));
for ii=1:length(MNR)
   t_mr=find(strcmp(MNR{ii}, Macro_Map(:,3)));
   t_o=false(length(S1),1)';
   for jj=1:length(t_mr)
      t_o=t_o | strcmp(Macro_Map(t_mr(jj),2),{S1.NAME_1}); 
   end
   fS=find(t_o);
   polyout=polyshape(S1(fS(1)).Lon,S1(fS(1)).Lat);
   for jj=2:length(fS)
       polytemp=polyshape(S1(fS(jj)).Lon,S1(fS(jj)).Lat);
       test=intersect(polyout,polytemp);
       if(isempty(test.Vertices))
           polyout = union(polyout,polytemp);  
       else
           polyout = subtract(polyout,polytemp);
       end
   end
   hold on;
   plot(polyout,'FaceColor','none','LineWidth',2,'EdgeColor',[0.4 0.4 0.4])
   if(strcmp(MNR{ii},'KYIV'))
        test=MNR{ii};
        test=[test(1) lower(test(2:end))];
        text(29.05904703547412,52.48141713894448,test,'HorizontalAlignment','center','Fontsize',28);     
        annotation(gcf,'arrow',[0.379755434782609 0.447010869565217],[0.916919959473151 0.753799392097264],'LineWidth',2,'color',[0.4 0.4 0.4]);
   elseif(strcmp(MNR{ii},'SOUTH'))
        test=MNR{ii};
        test=[test(1) lower(test(2:end))];
       text(31.564633464708603,47.2770598612715,test,'HorizontalAlignment','center','Fontsize',28);
   elseif(strcmp(MNR{ii},'NORTH'))
        [x,y] = centroid(polyout);
        test=MNR{ii};
        test=[test(1) lower(test(2:end))];
        text(x.*1.025,y.*1.005,test,'HorizontalAlignment','center','Fontsize',28)
   elseif(~strcmp(MNR{ii},'N/A'))
        [x,y] = centroid(polyout);
        test=MNR{ii};
        test=[test(1) lower(test(2:end))];
        text(x,y,test,'HorizontalAlignment','center','Fontsize',28)
   end
end


xp=linspace(22.15,40.22,1001+1);
     yp=[44 44.3];    
     
for jj=1:1001
    patch([xp(jj) xp(jj) xp(jj+1) xp(jj+1)],[yp(1) yp(2) yp(2) yp(1)],hex2rgb('#A11F0C'),'LineStyle','none','FaceAlpha',(jj-1)./1000);
    if(jj==1)
        text(xp(jj+1),yp(1)-0.01,['Low'],'Fontsize',28,'rotation',90,'Horizontalalignment','right')
    elseif(jj==1001)
        text(xp(jj+1),yp(1)-0.01,{'High'},'Fontsize',28,'rotation',90,'Horizontalalignment','right')
    end
end
patch([xp(1) xp(1) xp(end) xp(end)],[yp(1) yp(2) yp(2) yp(1)],'k','Facealpha',0);

text(31.252835977086363,43.412321118918925,['Proportion of hospitals affected'],'Fontsize',30,'Horizontalalignment','center');

axis off;

text(22.000000000000004,52.47793894762959,'B','Fontsize',40,'FontWeight','bold');

print(gcf,['Figure_3B.png'],'-dpng','-r300');


load('Load_Data_Mapping.mat');
load('Macro_Oblast_Map.mat','Macro_Map');



Hosp_Macro=zeros(7,2);

MNR=unique(Macro_Map(:,3));
for ii=1:length(MNR)
   t_mr=find(strcmp(MNR{ii}, Macro_Map(:,3)));
   
   t_o=false(length(S2),1)';
   for jj=1:length(t_mr)
      t_o=t_o | strcmp(Macro_Map(t_mr(jj),2),{S2.NAME_1}); 
   end
   Hosp_Macro(ii,:)=sum(Hosp_Raion(t_o,1:2),1); 
end


[day_W_fix,RC,MLE_FD,MLE_Map_Ref,MLE_Map_IDP,FD_Model,Model_IDP,Model_Refugee] = Selected_Model_Parameters_MLE;

load('Load_Data_Mapping.mat');

load('Calibration_Conflict_Kernel.mat');

[Parameter,STDEV_Displace]=Parameter_Return(MLE_FD,RC,Time_Switch,day_W_fix,FD_Model);
    
[Pop_Displace,Pop_IDP,Pop_Refugee]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Time_Sim,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,Pop_SES);
Daily_Refugee=squeeze(sum(Pop_Refugee,[1 3]));
Daily_IDP_Origin=Parameter.w_IDP.*squeeze(sum(Pop_Displace,[1 3])); % Need to examine the new idp only



load('Ukraine_Population_Reduced.mat','Ukraine_Pop')
Mapped_Raion_Name=Ukraine_Pop.map_raion;
Oblast_Pixel=Ukraine_Pop.oblast;
Raion_Pixel=Ukraine_Pop.raion;

clear Ukraine_Pop

[Disease_Short,age_class_v,gender_v]=Disease_Stratificaion_Text;
Pop=Population_Join_Gender(Pop_F_Age,Pop_M_Age);
PopR=Raion_Population_Point(Pop,Pop_oblast,Pop_raion);

Num_Refugee=squeeze(sum(Pop_Refugee,[4]));
Num_Non_Displaced=Pop-Pop_IDP(:,:,:,end)-Num_Refugee;

IDP_Disease=zeros(length(Disease_Short)+1,7);


[Parameter_Map_IDP,IDP_Mv]=Parameter_Return_Mapping_IDP(MLE_Map_IDP,Model_IDP);
w_tot_idp=Determine_Weights_IDP(Parameter_Map_IDP,Mapping_Data,IDP_Mv);

[Est_Daily_IDP]=IDP_Refuge_Displaced(w_tot_idp,Daily_IDP_Origin,Time_Sim,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Parameter,Macro_Map);

YY=[Est_Daily_IDP.macro];
YY=YY(:,end);
IDP_Disease(1,:)=YY;


Non_IDP=sum(Num_Non_Displaced, [1 3])';
Non_IDP_Disease=zeros(length(Disease_Short)+1,7);
Est_Pop_NIDP=Macro_Return(Non_IDP,Raion_Pixel,Oblast_Pixel,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Macro_Map);
YY=Est_Pop_NIDP.macro;
Non_IDP_Disease(1,:)=YY;


Pop_Remain_Inv=Est_Daily_IDP.raion(:,end)+Est_Pop_NIDP.raion;

Pre_War=zeros(length(Disease_Short)+1,7);

Pop_C=sum(Pop,[1 3])';
Est_Pop_PW=Macro_Return(Pop_C,Raion_Pixel,Oblast_Pixel,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Macro_Map);
YY=Est_Pop_PW.macro;
Pre_War(1,:)=YY;

Pop_Pre_Inv=Est_Pop_PW.raion;


T_HS=table(Shapefile_Raion_Oblast_Name,Shapefile_Raion_Name,Pop_Pre_Inv,Hosp_Raion(:,1),Est_Pop_NIDP.raion,Est_Daily_IDP.raion(:,end),Hosp_Raion(:,2));
writetable(T_HS,'Supplementary_Data.xlsx','Sheet','Hospital_Raions');


Daily_IDP_Origin=Parameter.w_IDP.*Pop_Displace;

for dd=1:length(Disease_Short)
    [test_non_idp,test_idp,~]=Disease_Distribution(Disease_Short{dd},Mapped_Raion_Name,age_class_v,gender_v,Num_Non_Displaced,Daily_IDP_Origin,Num_Refugee,Pop,PopR,false);
    test_idp=squeeze(sum(test_idp,[1 3]));
    test_non_idp=squeeze(sum(test_non_idp,[1 3]))';
    [Est_Daily_IDP]=IDP_Refuge_Displaced(w_tot_idp,test_idp,Time_Sim,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Parameter,Macro_Map);
    
    YY=[Est_Daily_IDP.macro];
    YY=YY(:,end);
    IDP_Disease(dd+1,:)=YY;
    
    Est_Pop_NIDP=Macro_Return(test_non_idp,Raion_Pixel,Oblast_Pixel,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Macro_Map);
    YY=Est_Pop_NIDP.macro;
    Non_IDP_Disease(dd+1,:)=YY;

    [test_pw,~,~]=Disease_Distribution(Disease_Short{dd},Mapped_Raion_Name,age_class_v,gender_v,Pop,Daily_IDP_Origin,Pop,Pop,PopR,false);
    
    test_pw=squeeze(sum(test_pw,[1 3]))';
    Est_Pop_PW=Macro_Return(test_pw,Raion_Pixel,Oblast_Pixel,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Macro_Map);
    YY=Est_Pop_PW.macro;
    Pre_War(dd+1,:)=YY;
end


P_H_FD=(Non_IDP_Disease'+IDP_Disease')./repmat(Hosp_Macro(:,1)-Hosp_Macro(:,2),1,length(Disease_Short)+1);
P_H_PW=(Pre_War')./repmat(Hosp_Macro(:,1),1,length(Disease_Short)+1);

Num_Add_Hospitals=(Non_IDP_Disease'+IDP_Disease').*repmat(Hosp_Macro(:,1),1,length(Disease_Short)+1)./(Pre_War')-repmat(Hosp_Macro(:,1)-Hosp_Macro(:,2),1,length(Disease_Short)+1);
% P_H_FD=P_H_FD([1 2 3 5 6 7],:);
% P_H_PW=P_H_PW([1 2 3 5 6 7],:);

RR=P_H_FD./P_H_PW-1;
% RR=RR(:,2:end);


NMR=cell(7,1);
for ii=1:7
   if(~strcmp(Est_Daily_IDP.macro_name{ii},'N/A'))
       tt=Est_Daily_IDP.macro_name{ii};
       NMR{ii}=[tt(1) lower(tt(2:end))];
   else
       NMR{ii}='Other';
   end
end

mR=max(RR,[],2);
[~,I]=sort(mR);
RR=RR(I,:);

Num_Add_Hospitals=Num_Add_Hospitals(I,:);

NMR=NMR(I);

figure('units','normalized','outerposition',[0 0 0.775 0.98]);
subplot('Position',[0.111413043478261,0.172020725388601,0.86616847826087,0.8]);
CC=[0 0 0; % all;
    hex2rgb('#FB6542'); % CVD
    hex2rgb('#807dba'); %Diabetes
    hex2rgb('#FFBB00'); % Cancer
    hex2rgb('#034e76'); % HIV
%     hex2rgb('#9ebcda'); % HIV Treatment
    hex2rgb('#8c2d04')]; %TB
%     hex2rgb('#DE7a22');]; %TB drug-resitant
CC=flip(CC);
RR=flip(RR,2);
bb=barh([1:7],100.*RR,'LineStyle','none');
for ii=1:length(bb)
   bb(ii).FaceColor=CC(ii,:); 
end
set(gca,'LineWidth',2,'tickdir','out','YTick',1:7,'YTickLabel',NMR,'Fontsize',24,'XTick',[-5 0:10:50]);
xlim([-5 50]);
box off;
xlabel('Percent increase in people per hospital','Fontsize',30);
ylabel('Macro region','Fontsize',30);
xtickformat('percentage');
Disease={'Population';'CVD';'Diabetes';'Cancer';'HIV';'TB'};
legend(flip(bb),Disease,'Fontsize',22,'Location','SouthEast')
text(-11.819607843137254,7.575635984963931,'D','Fontsize',40,'FontWeight','bold');
print(gcf,['Percent_increase_people_per_hospital.png'],'-dpng','-r300');



figure('units','normalized','outerposition',[0 0 0.775 0.98]);
subplot('Position',[0.111413043478261,0.172020725388601,0.86616847826087,0.8]);
CC=[0 0 0; % all
    hex2rgb('#FB6542'); % CVD
    hex2rgb('#807dba'); %Diabetes
    hex2rgb('#FFBB00'); % Cancer
    hex2rgb('#034e76'); % HIV
%     hex2rgb('#9ebcda'); % HIV Treatment
    hex2rgb('#8c2d04')]; %TB
%     hex2rgb('#DE7a22');]; %TB drug-resitant
CC=flip(CC);
Num_Add_Hospitals=flip(Num_Add_Hospitals,2);
bb=barh([1:7],Num_Add_Hospitals,'LineStyle','none');
for ii=1:length(bb)
   bb(ii).FaceColor=CC(ii,:); 
end
set(gca,'LineWidth',2,'tickdir','out','YTick',1:7,'YTickLabel',NMR,'Fontsize',24,'XTick',[-5 0:10:60]);
xlim([-1 65]);
box off;
xlabel('Number of additional hospitals needed','Fontsize',30);
ylabel('Macro region','Fontsize',30);
Disease={'Population';'CVD';'Diabetes';'Cancer';'HIV';'TB'};
legend(flip(bb),Disease,'Fontsize',22,'Location','SouthEast')

print(gcf,['Number_Additinal_Hospitals.png'],'-dpng','-r300');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Raion chnage
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5


PPH_Inv=Pop_Remain_Inv./(Hosp_Raion(:,1)-Hosp_Raion(:,2));
PPH_Pre_Inv=Pop_Pre_Inv./(Hosp_Raion(:,1));


RC_PPH=PPH_Inv./PPH_Pre_Inv-1;

RC_PPH_t=RC_PPH;
RC_PPH_t(RC_PPH>1)=1.01;
load('colormap_PPH.mat','PPH_map');

XC=[-0.4:0.05:1.05];
XCt=XC(2:end);
open('UKR_0_Map.fig')

for ii=1:length(S2)
    if(~isnan(RC_PPH_t(ii)))
        geoshow(S2(ii),'LineStyle','none','Facecolor',PPH_map(find(RC_PPH_t(ii)<XCt,1),:));
    else
        geoshow(S2(ii),'LineStyle','none','Facecolor',[0.7 0.7 0.7]);
    end
end


load('Macro_Oblast_Map.mat','Macro_Map');
MNR=unique(Macro_Map(:,3));
for ii=1:length(MNR)
   t_mr=find(strcmp(MNR{ii}, Macro_Map(:,3)));
   t_o=false(length(S1),1)';
   for jj=1:length(t_mr)
      t_o=t_o | strcmp(Macro_Map(t_mr(jj),2),{S1.NAME_1}); 
   end
   fS=find(t_o);
   polyout=polyshape(S1(fS(1)).Lon,S1(fS(1)).Lat);
   for jj=2:length(fS)
       polytemp=polyshape(S1(fS(jj)).Lon,S1(fS(jj)).Lat);
       test=intersect(polyout,polytemp);
       if(isempty(test.Vertices))
           polyout = union(polyout,polytemp);  
       else
           polyout = subtract(polyout,polytemp);
       end
   end
   hold on;
   plot(polyout,'FaceColor','none','LineWidth',2,'EdgeColor',[0.4 0.4 0.4])
   if(strcmp(MNR{ii},'KYIV'))
        test=MNR{ii};
        test=[test(1) lower(test(2:end))];
        text(29.05904703547412,52.48141713894448,test,'HorizontalAlignment','center','Fontsize',28);     
        annotation(gcf,'arrow',[0.379755434782609 0.447010869565217],[0.916919959473151 0.753799392097264],'LineWidth',2,'color',[0.4 0.4 0.4]);
   elseif(strcmp(MNR{ii},'SOUTH'))
        test=MNR{ii};
        test=[test(1) lower(test(2:end))];
       text(31.564633464708603,47.2770598612715,test,'HorizontalAlignment','center','Fontsize',28);
   elseif(strcmp(MNR{ii},'NORTH'))
        [x,y] = centroid(polyout);
        test=MNR{ii};
        test=[test(1) lower(test(2:end))];
        text(x.*1.025,y.*1.005,test,'HorizontalAlignment','center','Fontsize',28)
   elseif(~strcmp(MNR{ii},'N/A'))
        [x,y] = centroid(polyout);
        test=MNR{ii};
        test=[test(1) lower(test(2:end))];
        text(x,y,test,'HorizontalAlignment','center','Fontsize',28)
   end
end
axis off;

text(22.000000000000004,52.47793894762959,'C','Fontsize',40,'FontWeight','bold');
axes('Position',[0.02241847826087,0.138804457953394,0.302989130434782,0.364032421479237])
[NC,Cedges] = histcounts(RC_PPH_t,XC);

b=bar((XC(2:end)+XC(1:end-1))./2,NC);
b.FaceColor = 'flat';
for ii=1:length(PPH_map(:,1))
    b.CData(ii,:)=PPH_map(ii,:);
end
hold on
plot(ones(101,1),linspace(0,max(NC)+5,101),'k-.','LineWidth',2);
text(1.05,max(NC)./2,'Over 100%','Fontsize',18,'Rotation',90,'HorizontalAlignment','center')
set(gca,'LineWidth',2,'tickdir','out','fontsize',18,'XTick',[-0.4 -0.2 0 0.2 0.4 0.6 0.8 1],'XTicklabel',{'-40%','-20%','0%','20%','40%','60%','80%','100%'},'Yticklabel','','YTick',[]);
xlabel('Percent change in people per hospital','fontsize',22)
ylim([0 max(NC)+5]);
box off
print(gcf,['PPH_Increase_Raion.png'],'-dpng','-r300');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Uncertainty Hospitals
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clear;
clc;
close all; 
load('Ukraine_Population_Reduced.mat','Ukraine_Pop')
Mapped_Raion_Name=Ukraine_Pop.map_raion;
Oblast_Pixel=Ukraine_Pop.oblast;
Raion_Pixel=Ukraine_Pop.raion;
clear Ukraine_Pop

load('Calibration_Conflict_Kernel.mat');

load('Macro_Oblast_Map.mat','Macro_Map');

load('Load_Data_Mapping.mat');

[Disease_Short,age_class_v,gender_v]=Disease_Stratificaion_Text;
Pop=Population_Join_Gender(Pop_F_Age,Pop_M_Age);
PopR=Raion_Population_Point(Pop,Pop_oblast,Pop_raion);

[day_W_fix,RC,Par_FD,Par_Map_Ref,Par_Map_IDP,Model_FD,Model_IDP,Model_Refugee] = Selected_Model_Parameters_Uncertainty;

NS=length(Par_FD(:,1));

Pop_C=sum(Pop,[1 3])';
Est_Pop_PW=Macro_Return(Pop_C,Raion_Pixel,Oblast_Pixel,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Macro_Map);
YY=Est_Pop_PW.macro;

Pop_Pre_Inv_Raion=Est_Pop_PW.raion;
Pop_Pre_Inv_Macro=Est_Pop_PW.macro;

Pop_Remain_Inv_Raion=zeros(NS,length(S2));

Pop_Remain_Inv_Macro=zeros(NS,7);

H=shaperead('Health/hotosm_ukr_health_facilities_points.shp','UseGeoCoords',true);

N={H.amenity};
tfh=strcmp(N,'hospital')|strcmp(N,'cancer');
H=H(tfh);

HLon=[H.Lon];
HLat=[H.Lat];


S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);

Hosp_Macro=zeros(NS,7,2);
Hosp_Raion=zeros(NS,length(S2),3);
for ss=1:NS
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    % % Load data and determine the dispacement per day
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    [Parameter,~]=Parameter_Return(Par_FD(ss,:),RC,Time_Switch,day_W_fix,Model_FD);


    nDays=length(Time_Sim);
    PC=zeros(length(cell2mat(vLat_C)),nDays);
    PC_H=zeros(length(HLat),nDays);

    PC_W=zeros(length(cell2mat(vLat_C)),Parameter.day_W);
    PCH_W=zeros(length(HLat),Parameter.day_W);
    for jj=1:nDays
        if(Time_Sim(jj)<Parameter.Switch)
            P = Kernel_Displacement(vLat_C{jj},vLon_C{jj},cell2mat(vLat_C),cell2mat(vLon_C),Parameter);
            PH= Kernel_Displacement(vLat_C{jj},vLon_C{jj},HLat,HLon,Parameter);

        else
            P = Parameter.Switch_Scaled.*Kernel_Displacement(vLat_C{jj},vLon_C{jj},cell2mat(vLat_C),cell2mat(vLon_C),Parameter);
            PH = Parameter.Switch_Scaled.*Kernel_Displacement(vLat_C{jj},vLon_C{jj},HLat,HLon,Parameter);
        end
        % Cumulative probability
        PC_W(:,2:Parameter.day_W)=PC_W(:,1:(Parameter.day_W-1));    
        PC_W(:,1)=P;

        PCH_W(:,2:Parameter.day_W)=PCH_W(:,1:(Parameter.day_W-1));    
        PCH_W(:,1)=PH;

        PC(:,jj)=1-prod(1-PC_W(:,[1:min(jj,Parameter.day_W)]),2);
        PC_H(:,jj)=1-prod(1-PCH_W(:,[1:min(jj,Parameter.day_W)]),2);
    end

    P_H=1-geomean(1-PC_H,2);
    P_C=1-geomean(1-PC,2);

    NN=(PC_H./repmat(sum(PC_H,2),1,length(Time_Sim)));
    NN(isnan(NN))=1;
    Test_H2=repmat(P_H./max(P_C),1,length(Time_Sim)).*NN;


    HLonNCZ=HLon(P_H==0);
    HLatNCZ=HLat(P_H==0);

    P_H=P_H./max(P_C);


    for ii=1:length(S2)
       [p_in,~]=inpolygon( HLat,HLon,S2(ii).Lat,S2(ii).Lon);
       Hosp_Raion(ss,ii,1)=sum(p_in);
       Hosp_Raion(ss,ii,2)=sum(P_H(p_in));
       if(Hosp_Raion(ss,ii,1)>0)
            Hosp_Raion(ss,ii,3)=sum(P_H(p_in))./sum(p_in);
       end
    end
    

    MNR=unique(Macro_Map(:,3));
    for ii=1:length(MNR)
       t_mr=find(strcmp(MNR{ii}, Macro_Map(:,3)));

       t_o=false(length(S2),1)';
       for jj=1:length(t_mr)
          t_o=t_o | strcmp(Macro_Map(t_mr(jj),2),{S2.NAME_1}); 
       end
       Hosp_Macro(ss,ii,:)=squeeze(sum(Hosp_Raion(ss,t_o,1:2),2)); 
    end
    
    
    [Parameter,~]=Parameter_Return(Par_FD(ss,:),RC,Time_Switch,day_W_fix,Model_FD);
        
    [Pop_Displace,Pop_IDP,Pop_Refugee]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Time_Sim,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,ML_Indx);
    Daily_Refugee=squeeze(sum(Pop_Refugee,[1 3]));
    Daily_IDP_Origin=Parameter.w_IDP.*squeeze(sum(Pop_Displace,[1 3])); % Need to examine the new idp only
    
  
    Num_Refugee=squeeze(sum(Pop_Refugee,[4]));
    Num_Non_Displaced=Pop-Pop_IDP(:,:,:,end)-Num_Refugee;
       
    [Parameter_Map_IDP,IDP_Mv]=Parameter_Return_Mapping_IDP(Par_Map_IDP(ss,:),Model_IDP);
    w_tot_idp=Determine_Weights_IDP(Parameter_Map_IDP,Mapping_Data,IDP_Mv);
    
    [Est_Daily_IDP]=IDP_Refuge_Displaced(w_tot_idp,Daily_IDP_Origin,Time_Sim,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Parameter,Macro_Map);
    
    Non_IDP=sum(Num_Non_Displaced, [1 3])';
    Est_Pop_NIDP=Macro_Return(Non_IDP,Raion_Pixel,Oblast_Pixel,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Macro_Map);
       
    
    Pop_Remain_Inv_Raion(ss,:)=Est_Daily_IDP.raion(:,end)+Est_Pop_NIDP.raion;
    Pop_Remain_Inv_Macro(ss,:)=Est_Daily_IDP.macro(:,end)+Est_Pop_NIDP.macro;
    
end

save('Uncertainty_Hospital_UKR.mat','Hosp_Macro','Hosp_Raion','Pop_Pre_Inv_Raion','Pop_Remain_Inv_Raion','Pop_Remain_Inv_Macro','Pop_Pre_Inv_Macro');