clear;
clc;
close all; 

H=shaperead('Health/hotosm_ukr_health_facilities_points.shp','UseGeoCoords',true);

N={H.amenity};
tfh=strcmp(N,'hospital')|strcmp(N,'cancer');
H=H(tfh);

HLon=[H.Lon];
HLat=[H.Lat];

load('MCMC_out-k=2821.mat')
Parameter_V=Parameter_V(L_V<0,:);
L_V=L_V(L_V<0);
Parameter_V=Parameter_V(end-9999:end,:);
L_V=L_V(end-9999:end);

x=Parameter_V(L_V==max(L_V),:);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % Load data and determine the dispacement per day
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
[Parameter,STDEV_Displace]=Parameter_Return(x,RC,Time_Switch,day_W_fix);


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
        text(29.05904703547412,52.48141713894448,test,'HorizontalAlignment','center','Fontsize',20);     
        annotation(gcf,'arrow',[0.379755434782609 0.447010869565217],[0.916919959473151 0.753799392097264],'LineWidth',2,'color',[0.4 0.4 0.4]);
   elseif(strcmp(MNR{ii},'SOUTH'))
        test=MNR{ii};
        test=[test(1) lower(test(2:end))];
       text(31.564633464708603,47.2770598612715,test,'HorizontalAlignment','center','Fontsize',20);
   elseif(strcmp(MNR{ii},'NORTH'))
        [x,y] = centroid(polyout);
        test=MNR{ii};
        test=[test(1) lower(test(2:end))];
        text(x.*1.025,y.*1.005,test,'HorizontalAlignment','center','Fontsize',20)
   elseif(~strcmp(MNR{ii},'N/A'))
        [x,y] = centroid(polyout);
        test=MNR{ii};
        test=[test(1) lower(test(2:end))];
        text(x,y,test,'HorizontalAlignment','center','Fontsize',20)
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

text(median(xp),yp(1)-1.27,['Proportion of hospitals affected'],'Fontsize',30,'Horizontalalignment','center');

axis off;

text(22.000000000000004,52.47793894762959,'C','Fontsize',40,'FontWeight','bold');

print(gcf,['Hospital_Destroy.png'],'-dpng','-r300');

load('Load_Data_MCMC_Mapping.mat');
load('Macro_Oblast_Map.mat','Macro_Map');

load('MCMC_out-k=2821.mat')
Parameter_V=Parameter_V(L_V<0,:);
L_V=L_V(L_V<0);
Parameter_V=Parameter_V(end-9999:end,:);
L_V=L_V(end-9999:end);

[Parameter,STDEV_Displace]=Parameter_Return(Parameter_V(L_V==max(L_V),:),RC,Time_Switch,day_W_fix);
    
[Pop_Displace,Pop_IDP,Pop_Refugee]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Time_Sim,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,ML_Indx);
Daily_Refugee=squeeze(sum(Pop_Refugee,[1 3]));
Daily_IDP_Origin=Parameter.w_IDP.*squeeze(sum(Pop_Displace,[1 3])); % Need to examine the new idp only



load('Ukraine_Population_Reduced.mat','Ukraine_Pop')
Mapped_Raion_Name=Ukraine_Pop.map_raion;
Oblast_Pixel=Ukraine_Pop.oblast;

age_class_v={'0-4','5-9','10-14','15-19','20-24','25-29','30-34','35-39','40-44','45-49','50-54','55-59','60-64','65-69','70-74','75-79','80+'};
gender_v={'f','m'};

clear Ukraine_Pop


S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);
Raion_S={S2.NAME_2};
Oblast_S={S2.NAME_1};


Pop=zeros(length(gender_v),length(Pop_raion),length(age_class_v));
Pop(1,:,:)=Pop_F_Age;
Pop(2,:,:)=Pop_M_Age;

PopR=zeros(size(Pop));
for ii=1:length(Raion_S)
   tf=strcmp(Pop_raion,Raion_S{ii}) &  strcmp(Pop_oblast,Oblast_S{ii});
   for aa=1:length(Pop_F_Age(1,:))
       for gg=1:2
            PopR(gg,tf,aa)=sum(Pop(gg,tf,aa));
       end
   end
end

Num_Refugee=squeeze(sum(Pop_Refugee,[4]));
Num_Non_Displaced=Pop-Pop_IDP(:,:,:,end)-Num_Refugee;

Disease_Short={'CVD';'Diabetes';'Cancer';'HIV';'HIV_T';'TB';'TB_DR'};


IDP_Disease=zeros(length(Disease_Short)+1,6);



load(['Mapping_Refugee_IDP_MLE.mat'],'par_V');
[Parameter_Map_Refugee,Parameter_Map_IDP]=Parameter_Return_Mapping(par_V);

% w_tot_ref=Determine_Weights_Refugee(Parameter_Map_Refugee,Mapping_Data);
w_tot_idp=Determine_Weights_IDP(Parameter_Map_IDP,Mapping_Data);

[Est_Daily_IDP]=IDP_Refuge_Displaced(w_tot_idp,Daily_IDP_Origin,Time_Sim,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Parameter,Macro_Map);

YY=[Est_Daily_IDP.macro];
YY=YY([1 2 3 5 6 7],end);
IDP_Disease(1,:)=YY;


Non_IDP_Civilian=sum(Num_Non_Displaced(1,:,:),3)+sum(Num_Non_Displaced(2,:,~ismember([1:17],ML_Indx)),3);
Non_IDP_Disease=zeros(length(Disease_Short)+1,6);
Est_Pop_NIDP=Macro_Return(Non_IDP_Civilian,Oblast_Pixel,Macro_Map);
YY=Est_Pop_NIDP.macro;
Non_IDP_Disease(1,:)=YY([1 2 3 5 6 7]);


Pre_War=zeros(length(Disease_Short)+1,6);
Pop_Civilian=sum(Pop(1,:,:),3)+sum(Pop(2,:,~ismember([1:17],ML_Indx)),3);
Est_Pop_PW=Macro_Return(Pop_Civilian,Oblast_Pixel,Macro_Map);
YY=Est_Pop_PW.macro;
Pre_War(1,:)=YY([1 2 3 5 6 7]);

Daily_IDP_Origin=Parameter.w_IDP.*Pop_Displace;

for dd=1:length(Disease_Short)
    [test_non_idp,test_idp,~]=Disease_Distribution(Disease_Short{dd},Mapped_Raion_Name,age_class_v,gender_v,Num_Non_Displaced,Daily_IDP_Origin,Num_Refugee,Pop,PopR,false);
    test_idp=squeeze(sum(test_idp,[1 3]));
    test_non_idp=squeeze(sum(test_non_idp,[1 3]));
    [Est_Daily_IDP]=IDP_Refuge_Displaced(w_tot_idp,test_idp,Time_Sim,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Parameter,Macro_Map);
    
    YY=[Est_Daily_IDP.macro];
    YY=YY([1 2 3 5 6 7],end);
    IDP_Disease(dd+1,:)=YY;
    
    Est_Pop_NIDP=Macro_Return(test_non_idp,Oblast_Pixel,Macro_Map);
    YY=Est_Pop_NIDP.macro;
    Non_IDP_Disease(dd+1,:)=YY([1 2 3 5 6 7]);

    [test_pw,~,~]=Disease_Distribution(Disease_Short{dd},Mapped_Raion_Name,age_class_v,gender_v,Pop,Daily_IDP_Origin,Pop,Pop,PopR,false);
    
    test_pw=squeeze(sum(test_pw,[1 3]));
    Est_Pop_PW=Macro_Return(test_pw,Oblast_Pixel,Macro_Map);
    YY=Est_Pop_PW.macro;
    Pre_War(dd+1,:)=YY([1 2 3 5 6 7]);
end


Hosp_MR=zeros(2,6);
cc=1;
for ii=1:7
    if(~strcmp(MNR{ii},'N/A'))
     t_mr=find(strcmp(MNR{ii}, Macro_Map(:,3)));
       t_o=false(length(S2),1)';
       for jj=1:length(t_mr)
          t_o=t_o | strcmp(Macro_Map(t_mr(jj),2),{S2.NAME_1}); 
       end
            Hosp_MR(1,cc)=sum(Hosp_Raion(t_o,1));
            Hosp_MR(2,cc)=sum(Hosp_Raion(t_o,2));
            cc=cc+1;
    end
end
PWB=Pre_War./repmat(Hosp_MR(1,:),length(Disease_Short)+1,1);
Inv_B=(Non_IDP_Disease+IDP_Disease)./repmat(Hosp_MR(2,:),length(Disease_Short)+1,1);
RR=Inv_B./PWB;
NMR=cell(6,1);
cc=1;
for ii=1:7
   if(~strcmp(Est_Daily_IDP.macro_name{ii},'N/A'))
       tt=Est_Daily_IDP.macro_name{ii};
       NMR{cc}=[tt(1) lower(tt(2:end))];
       cc=cc+1;
   end
end

RR=RR(2:end,:);
[~,I]=sort(max(RR,[],1));
RR=RR(:,I);

figure('units','normalized','outerposition',[0. 0. 1 1]);
subplot('Position',[0.088020833333333,0.11127050354926,0.897916666666666,0.865692847236082]);
bb=barh([1:6],flip(RR),'LineStyle','none');

CC=[hex2rgb('#FB6542'); % CVD
    hex2rgb('#807dba'); %Diabetes
    hex2rgb('#FFBB00'); % Cancer
    hex2rgb('#034e76'); % HIV
    hex2rgb('#9ebcda'); % HIV Treatment
    hex2rgb('#8c2d04'); %TB
    hex2rgb('#DE7a22');]; %TB drug-resitant
CC=flip(CC);
for ii=1:length(bb)
    bb(ii).FaceColor=CC(ii,:);
end

set(gca,'YTick',[1:6],'YTickLabel',NMR(I),'XScale','log','LineWidth',2,'Fontsize',24,'tickdir','out')
xlabel('Fold increase','Fontsize',30);
ylabel('Macro-region','Fontsize',30);
xlim([0.01 10^2])
box off
Disease={'CVD';'Diabetes';'Cancer';'HIV';'HIV (Treated)';'TB';'TB (Drug resistant)'};
legend(flip(bb),Disease,'Location','SouthEast');
legend boxoff;
text(0.004131899933369,6.474566809103695,'D','Fontsize',40,'FontWeight','bold');
print(gcf,['Increased_Burden_Hospital.png'],'-dpng','-r300');