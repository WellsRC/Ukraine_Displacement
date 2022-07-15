clear;
clc;
close all; 

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
Raion_Pixel=Ukraine_Pop.raion;

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

Disease_Short={'CVD';'Diabetes';'Cancer';'HIV';'TB'};


IDP_Disease=zeros(length(Disease_Short),7);



load(['Mapping_Refugee_IDP_MLE.mat'],'par_V');
[Parameter_Map_Refugee,Parameter_Map_IDP]=Parameter_Return_Mapping(par_V);

w_tot_idp=Determine_Weights_IDP(Parameter_Map_IDP,Mapping_Data);

[Est_Daily_IDP]=IDP_Refuge_Displaced(w_tot_idp,Daily_IDP_Origin,Time_Sim,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Parameter,Macro_Map);

YY=[Est_Daily_IDP.macro];
YY=YY(:,end);
IDP_Pop_FD=YY;


Non_IDP_Pop=sum(Num_Non_Displaced,[1 3]);
Non_IDP_Disease=zeros(length(Disease_Short),7);
Est_Pop_NIDP=Macro_Return(Non_IDP_Pop,Raion_Pixel,Oblast_Pixel,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Macro_Map);
YY=Est_Pop_NIDP.macro;
non_IDP_Pop_FD=YY;


Pre_War=zeros(length(Disease_Short),7);
Pop_C=sum(Pop,[1 3]);
Est_Pop_PW=Macro_Return(Pop_C,Raion_Pixel,Oblast_Pixel,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Macro_Map);
YY=Est_Pop_PW.macro;
Pop_PW=YY;

Daily_IDP_Origin=Parameter.w_IDP.*Pop_Displace;

for dd=1:length(Disease_Short)
    [test_non_idp,test_idp,~]=Disease_Distribution(Disease_Short{dd},Mapped_Raion_Name,age_class_v,gender_v,Num_Non_Displaced,Daily_IDP_Origin,Num_Refugee,Pop,PopR,false);
    test_idp=squeeze(sum(test_idp,[1 3]));
    test_non_idp=squeeze(sum(test_non_idp,[1 3]));
    [Est_Daily_IDP]=IDP_Refuge_Displaced(w_tot_idp,test_idp,Time_Sim,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Parameter,Macro_Map);
    
    YY=[Est_Daily_IDP.macro];
    YY=YY(:,end);
    IDP_Disease(dd,:)=YY;
    
    Est_Pop_NIDP=Macro_Return(test_non_idp,Raion_Pixel,Oblast_Pixel,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Macro_Map);
    YY=Est_Pop_NIDP.macro;
    Non_IDP_Disease(dd,:)=YY;

    [test_pw,~,~]=Disease_Distribution(Disease_Short{dd},Mapped_Raion_Name,age_class_v,gender_v,Pop,Daily_IDP_Origin,Pop,Pop,PopR,false);
    
    test_pw=squeeze(sum(test_pw,[1 3]));
    Est_Pop_PW=Macro_Return(test_pw,Raion_Pixel,Oblast_Pixel,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Macro_Map);
    YY=Est_Pop_PW.macro;
    Pre_War(dd,:)=YY;
end

close all
CC=[    hex2rgb('#FB6542'); % CVD
    hex2rgb('#807dba'); %Diabetes
    hex2rgb('#FFBB00'); % Cancer
    hex2rgb('#034e76'); % HIV
%     hex2rgb('#9ebcda'); % HIV Treatment
    hex2rgb('#8c2d04');]; %TB
%     hex2rgb('#DE7a22');]; %TB drug-resitant
Disease={'CVD';'Diabetes';'Cancer';'HIV';'TB'};

NMR=cell(7,1);
for ii=1:7
       tt=Est_Daily_IDP.macro_name{ii};
       NMR{ii}=[tt(1) lower(tt(2:end))];
end

for ii=1:7
    if(ii~=4)
        figure('units','normalized','outerposition',[0.25 0.25 0.5 0.5]);
       subplot('Position',[0.203389830508475,0.252796420581655,0.786610169491526,0.6331096196868])

        Prev_PW=1000.*Pre_War(:,ii)./Pop_PW(ii)';

        Prev_IDP=1000.*IDP_Disease(:,ii)./IDP_Pop_FD(ii)';
        Prev_non_IDP=1000.*Non_IDP_Disease(:,ii)./non_IDP_Pop_FD(ii)';
        Prev_FD=1000.*(IDP_Disease(:,ii)+Non_IDP_Disease(:,ii))./(IDP_Pop_FD(ii)'+non_IDP_Pop_FD(ii)');


        mmin=min([Prev_PW(:);Prev_IDP(:);Prev_non_IDP(:);Prev_FD(:)]);
        mmax=max([Prev_PW(:);Prev_IDP(:);Prev_non_IDP(:);Prev_FD(:)]);

        p1=scatter(Prev_PW,log10(Prev_IDP)-log10(Prev_PW),90,CC,'s','LineWidth',2); hold on;
        p2=scatter(Prev_PW,log10(Prev_non_IDP)-log10(Prev_PW),90,CC,'d','LineWidth',2);
        p3=scatter(Prev_PW,log10(Prev_FD)-log10(Prev_PW),90,CC,'filled');
        plot(linspace(mmin*0.95,mmax.*1.05,101),zeros(1,101),'k-','LineWidth',2);
        box off;
        set(gca,'LineWidth',2,'tickdir','out','Fontsize',22,'Xminortick','on','Yminortick','off','Xscale','log','YTick',[-0.35:0.05:0.2]);
        xlabel('Cases per 1,000 (Pre-invasion)','Fontsize',28);
        ylabel({'log_{10} Ratio','(Post-invasion)'},'Fontsize',28);
        title(NMR{ii},'Fontsize',30);
%         legend([p1 p2 p3],{'IDP','non-IDP','IDP and non-IDP'},'Fontsize',18,'Location','NorthWest')
        xlim([mmin*0.95 mmax.*1.05]);
        ylim([-0.35 0.2]);
        text(mmin*0.95-0.1981.*(mmax.*1.05-mmin*0.95),mmin*0.95+1.078.*(mmax.*1.05-mmin*0.95),char(64+ii),'Fontsize',40,'FontWeight','bold');
        print(gcf,['Scatter_Prev_Force_Disp_Macro_' num2str(ii) '.png'],'-dpng','-r300');
    end
end
