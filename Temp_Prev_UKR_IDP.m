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

load('Mapping_Refugee_IDP_MLE.mat','par_V');
[Parameter_Map_Refugee,Parameter_Map_IDP]=Parameter_Return_Mapping(par_V);

% w_tot_ref=Determine_Weights_Refugee(Parameter_Map_Refugee,Mapping_Data);
w_tot_idp=Determine_Weights_IDP(Parameter_Map_IDP,Mapping_Data);


S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);
load('Macro_Oblast_Map.mat')
N={'CENTER';'EAST';'KYIV';'NORTH';'SOUTH';'WEST'};


Disease={'CVD';'Diabetes';'Cancer';'HIV';'HIV (Treated)';'TB';'TB (Drug ressitant)'};
Disease_Short={'CVD';'Diabetes';'Cancer';'HIV';'HIV_T';'TB';'TB_DR'};
CC=[    hex2rgb('#FB6542'); % CVD
    hex2rgb('#807dba'); %Diabetes
    hex2rgb('#FFBB00'); % Cancer
    hex2rgb('#034e76'); % HIV
    hex2rgb('#9ebcda'); % HIV Treatment
    hex2rgb('#8c2d04'); %TB
    hex2rgb('#DE7a22');]; %TB drug-resitant
   figure('units','normalized','outerposition',[0 0.05 1 1]);
   subplot('Position',[0.067226890756303,0.228976697061804,0.922773109243697,0.746392761066278])
   
   
for zz=1:length(Disease_Short)
    [test_non_idp,test_idp,dpc]=Disease_Distribution(Disease_Short{zz},Mapped_Raion_Name,age_class_v,gender_v,Num_Non_Displaced,DIDP,Num_Refugee,Pop,PopR,false);
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
        pl(zz)=semilogy(Time_Sim,R,'LineWidth',2,'color',CC(zz,:)); hold on        
end
set(gca,'LineWidth',2,'tickdir','out','Fontsize',22,'XTick',Time_Sim(1:7:end),'XTickLabel',{datestr(Time_Sim(1:7:end))},'Xminortick','on');

legend(pl,Disease,'Location','NorthWest','NumColumns',8,'Fontsize',22);

xtickangle(45);
xlim([Time_Sim(1) Time_Sim(end)]);
box off;
xlabel('Day','Fontsize',28);
ylabel('Disease per 1,000 IDPs','Fontsize',28);
text(738570.4837519405,1015.492393897241,'A','Fontsize',40,'Fontweight','bold');

print(gcf,['Temporal_Prev_IDP.png'],'-dpng','-r300');