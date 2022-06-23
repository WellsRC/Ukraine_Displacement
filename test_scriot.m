clear;

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

Pop=zeros(length(gender_v),length(Pop_raion),length(age_class_v));
Pop(1,:,:)=Pop_F_Age;
Pop(2,:,:)=Pop_M_Age;

Num_Refugee=cumsum(Pop_Refugee,4);
Num_Non_Displaced=Pop-Pop_IDP-Num_Refugee;

DIDP=Parameter.w_IDP.*Pop_Displace;
DIDPt=squeeze(sum(DIDP,[1 3]));

Pop_Civilian=squeeze(sum(Num_Non_Displaced(1,:,:,:),3)+sum(Pop(2,:,~ismember([1:17],ML_Indx),:),3));

x=[1.28002277839657,2.80219780031663,4.20104005286396,0.0753034566282208,2.61146699502349,0.0403068705232432,2.70689046521075,0.9373,0.9897,0.6227,0.2502,5.7];
[Parameter_Map_Refugee,Parameter_Map_IDP]=Parameter_Return_Mapping(x);

% w_tot_ref=Determine_Weights_Refugee(Parameter_Map_Refugee,Mapping_Data);
w_tot_idp=Determine_Weights_IDP(Parameter_Map_IDP,Mapping_Data);


S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);
load('Macro_Oblast_Map.mat')
N={'CENTER';'EAST';'KYIV';'NORTH';'SOUTH';'WEST'};
CC=[1 0 0;
    0 1 0;
    0 0 1;
    1 1 0;
    1 0 1;
    0 1 1
    0.5 0.5 0.5];

Disease={'CVD';'Diabetes';'Cancer';'HIV';'HIV (Treated)';'TB';'TB (Drug ressitant)'};
Disease_Short={'CVD';'Diabetes';'Cancer';'HIV';'HIV_T';'TB';'TB_DR'};
CC=[    hex2rgb('#FB6542'); % CVD
    hex2rgb('#807dba'); %Diabetes
    hex2rgb('#FFBB00'); % Cancer
    hex2rgb('#034e76'); % HIV
    hex2rgb('#9ebcda'); % HIV Treatment
    hex2rgb('#8c2d04'); %TB
    hex2rgb('#DE7a22');]; %TB drug-resitant
   figure('units','normalized','outerposition',[0. 0. 1 0.5]);
   subplot('Position',[0.05 0.1 0.94 0.89])
for zz=1:length(Disease_Short)
    [test_non_idp,test_idp,dpc]=Disease_Distribution(Disease_Short{zz},Mapped_Raion_Name,age_class_v,gender_v,Num_Non_Displaced,DIDP,Num_Refugee,Pop,PopR,true);
    test_idp=squeeze(sum(test_idp,[1 3]));
    ZZ=zeros(length(N),length(N),length(Time_Sim));
    ZZ_w=zeros(length(N),length(N),length(Time_Sim));
    for kk=1:length(N)
        f_indx_origin=find(strcmp(Macro_Map(:,3),N{kk}));    
        tf=false(size(Pop_oblast));
        for jj=1:length(f_indx_origin)
           tf=tf | strcmp( Macro_Map(f_indx_origin(jj),2),Pop_oblast);
        end
        w_temp_idp=w_tot_idp(:,tf,:);
        pop_dw=test_idp(tf,:);
        pop_w=DIDPt(tf,:);
        for ii=1:length(N)
            f_indx_destination=find(strcmp(Macro_Map(:,3),N{ii}));  
            tf=false(size(Shapefile_Raion_Oblast_Name));
            for jj=1:length(f_indx_destination)
                tf=tf | strcmp( Macro_Map(f_indx_destination(jj),2),Shapefile_Raion_Oblast_Name);
            end
            ZZ(ii,kk,:)=sum(squeeze(sum(w_temp_idp(tf,:,:),1)).*pop_w,1);
            ZZ_w(ii,kk,:)=sum(squeeze(sum(w_temp_idp(tf,:,:),1)).*pop_dw,1);
        end
    end
        R=1000.*squeeze(sum(ZZ_w,[1 2]))./squeeze(sum(ZZ,[1 2]));
        pl(zz)=semilogy([1:79],R,'LineWidth',2,'color',CC(zz,:)); hold on
        R=1000.*squeeze(sum(ZZ_w,[2]))./squeeze(sum(ZZ,[2]));
        semilogy(Time_Sim,R,'LineWidth',1.5,'LineStyle','-.','color',CC(zz,:)); hold on
        
end
set(gca,'LineWidth',2,'tickdir','out','Fontsize',20,'XTick',Time_Sim(1:7:end),'XTickLabel',{datestr(Time_Sim(1:7:end))});
xtickangle(45);
box off;
xlabel('Day','Fontsize',24);
ylabel('Disease per 1000 IDPs','Fontsize',24);
legend(pl,Disease,'Location','NorthWest','NumColumns',8);
% clear;
% 
% clear;
% clc;
% close all;
% 
% load('Load_Data_MCMC_Mapping.mat');
% load('Macro_Oblast_Map.mat','Macro_Map');
% 
% load('MCMC_out-k=2821.mat')
% Parameter_V=Parameter_V(L_V<0,:);
% L_V=L_V(L_V<0);
% Parameter_V=Parameter_V(end-9999:end,:);
% L_V=L_V(end-9999:end);
% 
% [Parameter,STDEV_Displace]=Parameter_Return(Parameter_V(L_V==max(L_V),:),RC,Time_Switch,day_W_fix);
%     
% [Pop_Displace,Pop_IDP,Pop_Refugee]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Time_Sim,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,ML_Indx);
% 
% Pop=zeros(length(gender_v),length(Pop_raion),length(age_class_v));
% Pop(1,:,:)=Pop_F_Age;
% Pop(2,:,:)=Pop_M_Age;
% 
% Num_Refugee=cumsum(Pop_Refugee,4);
% Num_Non_Displaced=Pop-Pop_IDP-Num_Refugee;
% 
% DIDP=squeeze(Parameter.w_IDP.*sum(Pop_Displace,[1 3]));
% 
% Pop_Civilian=squeeze(sum(Num_Non_Displaced(1,:,:,:),3)+sum(Pop(2,:,~ismember([1:17],ML_Indx),:),3));
% 
% x=[1.28002277839657,2.80219780031663,4.20104005286396,0.0753034566282208,2.61146699502349,0.0403068705232432,2.70689046521075,0.9373,0.9897,0.6227,0.2502,5.7];
% [Parameter_Map_Refugee,Parameter_Map_IDP]=Parameter_Return_Mapping(x);
% 
% % w_tot_ref=Determine_Weights_Refugee(Parameter_Map_Refugee,Mapping_Data);
% w_tot_idp=Determine_Weights_IDP(Parameter_Map_IDP,Mapping_Data);
% 
% 
% S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);
% load('Macro_Oblast_Map.mat')
% N={'CENTER';'EAST';'KYIV';'NORTH';'SOUTH';'WEST'};
% CC=[1 0 0;
%     0 1 0;
%     0 0 1;
%     1 1 0;
%     1 0 1;
%     0 1 1
%     0.5 0.5 0.5];
% 
% ZZ=zeros(length(N),length(N),length(Time_Sim));
% ZZ_w=zeros(length(N),length(N),length(Time_Sim));
% for kk=1:length(N)
%     f_indx_origin=find(strcmp(Macro_Map(:,3),N{kk}));    
%     tf=false(size(Pop_oblast));
%     for jj=1:length(f_indx_origin)
%        tf=tf | strcmp( Macro_Map(f_indx_origin(jj),2),Pop_oblast);
%     end
%     w_temp_idp=w_tot_idp(:,tf,:);
%     pop_w=DIDP(tf,:);
%     for ii=1:length(N)
%         f_indx_destination=find(strcmp(Macro_Map(:,3),N{ii}));  
%         tf=false(size(Shapefile_Raion_Oblast_Name));
%         for jj=1:length(f_indx_destination)
%             tf=tf | strcmp( Macro_Map(f_indx_destination(jj),2),Shapefile_Raion_Oblast_Name);
%         end
%         ZZ(kk,ii,:)=mean(squeeze(sum(w_temp_idp(tf,:,:),1)),1);
%         ZZ_w(ii,kk,:)=sum(squeeze(sum(w_temp_idp(tf,:,:),1)).*pop_w,1);
%     end
% end
% 
% ZZ_wc=cumsum(ZZ_w,3);
% ZZ_c=cumsum(ZZ,3);
% ZZ_w=ZZ_w./repmat(sum(ZZ_w,2),1,6,1);
% ZZ_wc=ZZ_wc./repmat(sum(ZZ_wc,2),1,6,1);
% 
% ZZ_c=ZZ_c./repmat(sum(ZZ_c,2),1,6,1);
% 
% figure('units','normalized','outerposition',[0. 0. 1 1]);
% 
% for ii=1:6
%    subplot(3,2,ii);area(Time_Sim,squeeze(ZZ(ii,:,:))'); 
%    ylim([0 1]);
%    xlim([Time_Sim(1) Time_Sim(end)]);
%    set(gca,'LineWidth',2,'tickdir','out','XTick',Time_Sim(1:7:end),'XTickLabel',datestr(Time_Sim(1:7:end)));
%    xlabel('Date');
%    ylabel('Daily Probability');
%    title(['Origin: ' N{ii}]);
%    if(ii==1)
%     legend(N);
%    end
%    box off;
%    xtickangle(45);
% end
% 
% 
% figure('units','normalized','outerposition',[0. 0. 1 1]);
% 
% for ii=1:6
%    subplot(3,2,ii);area(Time_Sim,squeeze(ZZ_c(ii,:,:))'); 
%    ylim([0 1]);
%    xlim([Time_Sim(1) Time_Sim(end)]);
%    set(gca,'LineWidth',2,'tickdir','out','XTick',Time_Sim(1:7:end),'XTickLabel',datestr(Time_Sim(1:7:end)));
%    xlabel('Date');
%    ylabel('Cumulative Probability');
%    title(['Origin: ' N{ii}]);
%    if(ii==1)
%     legend(N);
%    end
%    box off;
%    xtickangle(45);
% end
% 
% 
% figure('units','normalized','outerposition',[0. 0. 1 1]);
% 
% for ii=1:6
%    subplot(3,2,ii);area(Time_Sim,squeeze(ZZ_w(ii,:,:))'); 
%    ylim([0 1]);
%    xlim([Time_Sim(1) Time_Sim(end)]);
%    set(gca,'LineWidth',2,'tickdir','out','XTick',Time_Sim(1:7:end),'XTickLabel',datestr(Time_Sim(1:7:end)));
%    xlabel('Date');
%    ylabel('Daily Probability');
%    title(['Destination: ' N{ii} ]);
%    if(ii==1)
%     legend(N);
%    end
%    box off;
%    xtickangle(45);
% end
% 
% 
% 
% figure('units','normalized','outerposition',[0. 0. 1 1]);
% 
% for ii=1:6
%    subplot(3,2,ii);area(Time_Sim,squeeze(ZZ_wc(ii,:,:))'); 
%    ylim([0 1]);
%    xlim([Time_Sim(1) Time_Sim(end)]);
%    set(gca,'LineWidth',2,'tickdir','out','XTick',Time_Sim(1:7:end),'XTickLabel',datestr(Time_Sim(1:7:end)));
%    xlabel('Date');
%    ylabel('Cumulative Probability');
%    title(['Destination: ' N{ii} ]);
%    if(ii==1)
%     legend(N);
%    end
%    box off;
%    xtickangle(45);
% end