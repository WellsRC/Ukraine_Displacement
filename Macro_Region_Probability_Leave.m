clear;
clc;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % Plot Disease Country
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% 
load('Ukraine_Population_Reduced.mat','Ukraine_Pop')
Mapped_Raion_Name=Ukraine_Pop.map_raion;
clear Ukraine_Pop
[Number_Displacement,Date_Displacement,vLat_C,vLon_C,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,Pop_MACRO,Pop_raion,Pop_oblast,Time_Sim,ML_Indx,RC,Time_Switch]=LoadData;


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
day_W_fix=7;


[Parameter,STDEV_Displace]=Parameter_Return(MLE_KD,RC,Time_Switch,day_W_fix);

[Pop_Displace,Pop_IDP,Pop_Refugee]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Time_Sim,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,ML_Indx);

MNR=unique(Pop_MACRO);

Prob_FD=zeros(1,length(MNR));

Pop=sum(Pop_F_Age,2)+sum(Pop_M_Age,2);
Pop_Dis=sum(Pop_Displace,[1 3 4]);

for ii=1:length(MNR)
    tf=strcmp(MNR{ii},Pop_MACRO);
    Prob_FD(ii)=sum(Pop_Dis(tf))./sum(Pop(tf));
end

load('Merge_Parameter_Uncertainty.mat')
Prob_FD_U=zeros(length(Par_KD(:,1)),length(MNR));
for ss=1:length(Par_KD(:,1))
    [Parameter,STDEV_Displace]=Parameter_Return(Par_KD(ss,:),RC,Time_Switch,day_W_fix);

    [Pop_Displace,Pop_IDP,Pop_Refugee]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Time_Sim,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,ML_Indx);

    MNR=unique(Pop_MACRO);

    Pop=sum(Pop_F_Age,2)+sum(Pop_M_Age,2);
    Pop_Dis=sum(Pop_Displace,[1 3 4]);

    for ii=1:length(MNR)
        tf=strcmp(MNR{ii},Pop_MACRO);
        Prob_FD_U(ss,ii)=sum(Pop_Dis(tf))./sum(Pop(tf));
    end
end
save('Probability_Dsiplaced_Macro_Region.mat');