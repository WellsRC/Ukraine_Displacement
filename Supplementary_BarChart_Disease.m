clear;
clc;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % Plot Disease Country
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% 
load('Ukraine_Population_Reduced.mat','Ukraine_Pop')
Mapped_Raion_Name=Ukraine_Pop.map_raion;
clear Ukraine_Pop


L=zeros(8,1);
k=zeros(8,1);
for ii=1:8
    load(['Calibration_Kernel_Conflict_Window-Conflcit_Radius_Model=' num2str(ii) '.mat']);
    L(ii)=-min(fval);
    k(ii)=length(x0(1,:));
end
aics=aicbic(L,k);

daics=aics-min(aics);

AIC_model_num=find(daics==0);


load('Load_Data_Mapping.mat');

load('Calibration_Conflict_Kernel.mat');
load(['Calibration_Kernel_Conflict_Window-Conflcit_Radius_Model=' num2str(AIC_model_num) '.mat']);
day_W_fix=day_W_fix(fval==min(fval));
RC=RC(fval==min(fval));

age_class_v={'0-4','5-9','10-14','15-19','20-24','25-29','30-34','35-39','40-44','45-49','50-54','55-59','60-64','65-69','70-74','75-79','80+'};
gender_v={'f','m'};

Pop=zeros(length(gender_v),length(Pop_raion),length(age_class_v));
Pop(1,:,:)=Pop_F_Age;
Pop(2,:,:)=Pop_M_Age;

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

Disease_Short={'CVD';'Diabetes';'Cancer';'HIV';'TB'};

load('Merge_Parameter_MLE.mat')


[Parameter_Map_Refugee,Parameter_Map_IDP]=Parameter_Return_Mapping(MLE_Map);
load('Load_Data_MCMC_Mapping.mat','Mapping_Data');
w_tot_ref=Determine_Weights_Refugee(Parameter_Map_Refugee,Mapping_Data);


Refugee_Disease=zeros(length(Disease_Short)+1,9);

[Parameter,STDEV_Displace]=Parameter_Return(MLE_FD,RC,Time_Switch,day_W_fix,AIC_model_num);

[Pop_Displace,Pop_IDP,Pop_Refugee]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Time_Sim,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,Pop_SES);

Num_Refugee=squeeze(sum(Pop_Refugee,[4]));
Num_Non_Displaced=Pop-Pop_IDP(:,:,:,end)-Num_Refugee;

Refugee_Disease(1,1)=sum(Pop_IDP(:,:,:,end),[1 2 3]);
Refugee_Disease(1,2:9)=squeeze(sum(Num_Refugee,[1 3]))*w_tot_ref;

for dd=1:length(Disease_Short)  
    [test_non_idp,test_idp,dpc]=Disease_Distribution_beta(Disease_Short{dd},Mapped_Raion_Name,age_class_v,gender_v,Num_Non_Displaced,Pop_IDP,Num_Refugee,Pop,PopR,false); 
    dpc=sum(dpc,[1 3]);
    Refugee_Disease(dd+1,1)=sum(test_idp(:,:,:,end),[1 2 3]);
    Refugee_Disease(dd+1,2:9)=dpc*w_tot_ref;
end

close all;

Country_Name={'IDPs';'Poland';'Slovakia';'Hungary';'Romania';'Belarus';'Moldova';'Russia';'Europe'};

figure('units','normalized','outerposition',[0. 0.2 1 0.6]);
subplot('Position',[0.091911764705882,0.131531531531532,0.90283613445378,0.832432432432433]);


CC=[0 0 0; % All
    hex2rgb('#FB6542'); % CVD
    hex2rgb('#807dba'); %Diabetes
    hex2rgb('#FFBB00'); % Cancer
    hex2rgb('#034e76'); % HIV
%     hex2rgb('#9ebcda'); % HIV Treatment
    hex2rgb('#8c2d04')]; %TB
%     hex2rgb('#DE7a22');]; %TB drug-resitant

[B,I] = sort(Refugee_Disease(1,:));
I=flip(I);
Refugee_Disease_t=Refugee_Disease(:,I);
Country_Name=Country_Name(I);
    
bb=bar(Refugee_Disease_t','LineStyle','none');
for ii=1:length(bb)
   bb(ii).FaceColor=CC(ii,:); 
end
set(gca,'YScale','log','XTick',[1:(length(Country_Name)+1)],'XTickLabel',Country_Name);
xlim([0.5 length(Country_Name)+0.5]);
set(gca,'Tickdir','out','linewidth',2,'XTick',[1:length(Country_Name)],'XTicklabel',Country_Name,'Fontsize',24,'YSCale','log','YTick',10.^[0:7]);

hold on;
% xtickformat('percentage');
Disease={'Population';'CVD';'Diabetes';'Cancer';'HIV';'TB';};
legend((bb),(Disease),'Location','NorthEast','NumColumns',8);
legend boxoff;
box off;
% xlabel('Country','Fontsize',30,'Position',[5.000004291534425,0.062691391491044,-1]);
ylabel({'Number of people','displaced'},'Fontsize',30);
ylim([0.5 10^7]);

print(gcf,['Refugee_Disease_Distribution.png'],'-dpng','-r300');