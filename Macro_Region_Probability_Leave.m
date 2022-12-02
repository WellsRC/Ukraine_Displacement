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
[day_W_fix,RC,MLE_FD,MLE_Map_Ref,MLE_Map_IDP,FD_Model,Model_IDP,Model_Refugee] = Selected_Model_Parameters_MLE;
[Parameter,STDEV_Displace]=Parameter_Return(MLE_FD,RC,Time_Switch,day_W_fix,Model_FD);


[Disease_Short,age_class_v,gender_v]=Disease_Stratificaion_Text;
Pop=Population_Join_Gender(Pop_F_Age,Pop_M_Age);
PopR=Raion_Population_Point(Pop,Pop_oblast,Pop_raion);


[Pop_Displace,Pop_IDP,Pop_Refugee]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Time_Sim,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,Pop_SES);

MNR=unique(Pop_MACRO);

Prob_FD=zeros(1,length(MNR));

Pop=sum(Pop_F_Age,2)+sum(Pop_M_Age,2);
Pop_Dis=sum(Pop_Displace,[1 3 4]);

for ii=1:length(MNR)
    tf=strcmp(MNR{ii},Pop_MACRO);
    Prob_FD(ii)=sum(Pop_Dis(tf))./sum(Pop(tf));
end


[day_W_fix,RC,Par_FD,Par_Map_Ref,Par_Map_IDP,Model_FD,Model_IDP,Model_Refugee] = Selected_Model_Parameters_Uncertainty;

Prob_FD_U=zeros(length(Par_FD(:,1)),length(MNR));
for ss=1:length(Par_FD(:,1))
    [Parameter,STDEV_Displace]=Parameter_Return(Par_FD(ss,:),RC,Time_Switch,day_W_fix,Model_FD);

    [Pop_Displace,Pop_IDP,Pop_Refugee]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Time_Sim,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,Pop_SES);

    MNR=unique(Pop_MACRO);

    Pop=sum(Pop_F_Age,2)+sum(Pop_M_Age,2);
    Pop_Dis=sum(Pop_Displace,[1 3 4]);

    for ii=1:length(MNR)
        tf=strcmp(MNR{ii},Pop_MACRO);
        Prob_FD_U(ss,ii)=sum(Pop_Dis(tf))./sum(Pop(tf));
    end
end
save('Probability_Displaced_Macro_Region.mat');