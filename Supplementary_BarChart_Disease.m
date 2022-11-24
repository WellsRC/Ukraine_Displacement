clear;
clc;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % Plot Disease Country
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% 
load('Ukraine_Population_Reduced.mat','Ukraine_Pop')
Mapped_Raion_Name=Ukraine_Pop.map_raion;
clear Ukraine_Pop

load('Calibration_Conflict_Kernel.mat');
load('Load_Data_Mapping.mat');
load('Macro_Oblast_Map.mat','Macro_Map');

[day_W_fix,RC,MLE_FD,MLE_Map_Ref,MLE_Map_IDP,FD_Model,Model_IDP,Model_Refugee] = Selected_Model_Parameters_MLE;


[Parameter,STDEV_Displace]=Parameter_Return(MLE_FD,RC,Time_Switch,day_W_fix,FD_Model);
[Parameter_Map_Refugee,Refugee_Mv]=Parameter_Return_Mapping_Refugee(MLE_Map_Ref,Model_Refugee);
w_tot_ref=Determine_Weights_Refugee(Parameter_Map_Refugee,Mapping_Data,Refugee_Mv);


[Disease_Short,age_class_v,gender_v]=Disease_Stratificaion_Text;
Pop=Population_Join_Gender(Pop_F_Age,Pop_M_Age);
PopR=Raion_Population_Point(Pop,Pop_oblast,Pop_raion);


Refugee_Disease=zeros(length(Disease_Short)+1,9);


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