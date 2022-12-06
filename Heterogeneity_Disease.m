% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % % Produces the panels for Figure 1
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
clear;
close all;
clc;

load('Ukraine_Population_Reduced.mat','Ukraine_Pop')
Mapped_Raion_Name=Ukraine_Pop.map_raion;

t1=Ukraine_Pop.oblast;
t2=Ukraine_Pop.raion;
t_name=cell(6125,1);

for ii=1:6125
    t_name{ii}=[t1{ii} ' ' t2{ii}];
end

Oblast_NAME=unique(t1);
Raion_NAME=unique(t2);

clear Ukraine_Pop

load('Calibration_Conflict_Kernel.mat');
[day_W_fix,RC,MLE_FD,MLE_Map_Ref,MLE_Map_IDP,FD_Model,Model_IDP,Model_Refugee] = Selected_Model_Parameters_MLE;

[Parameter,STDEV_Displace]=Parameter_Return(MLE_FD,RC,Time_Switch,day_W_fix,FD_Model);
[~,Pop_IDP,Pop_Refugee]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Time_Sim,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,Pop_SES);
Pop_D=Pop_IDP(:,:,end)+sum(Pop_Refugee,4);    


[Disease_Short,age_class_v,gender_v]=Disease_Stratificaion_Text;
Pop=Population_Join_Gender(Pop_F_Age,Pop_M_Age);
PopR=Raion_Population_Point(Pop,Pop_oblast,Pop_raion);


Disease_F=zeros(length(Oblast_NAME),17);    
Disease_M=zeros(length(Oblast_NAME),17);

PopO_F=zeros(length(Oblast_NAME),17);    
PopO_M=zeros(length(Oblast_NAME),17);

Nat_Prev=sum(Pop_D(:))./sum(Pop(:));

for ii=1:length(Oblast_NAME)
    for jj=1:length(Raion_NAME)
       tf=strcmp(Raion_NAME{jj},t2) & strcmp(Oblast_NAME{ii},t1) ;            
       Disease_F(ii,:)=Disease_F(ii,:)+squeeze(sum(Pop_D(1,tf,:),[1 2]))';
       Disease_M(ii,:)=Disease_M(ii,:)+squeeze(sum(Pop_D(2,tf,:),[1 2]))';


       PopO_F(ii,:)=PopO_F(ii,:)+squeeze(sum(Pop(1,tf,:),[1 2]))';
       PopO_M(ii,:)=PopO_M(ii,:)+squeeze(sum(Pop(2,tf,:),[1 2]))';
    end
end

female_prev=Disease_F./PopO_F;
male_prev=Disease_M./PopO_M;

nat_female_prev=sum(Disease_F,1)./sum(PopO_F,1);
nat_male_prev=sum(Disease_M,1)./sum(PopO_M,1);

web_spider_disease=Spider_Web_Plot(female_prev,male_prev,Nat_Prev,nat_female_prev,nat_male_prev,'Displacement');
print(gcf,['Test_Displacement.png'],'-dpng','-r300');

Disease={'Cardiovascular disease';'Diabetes';'Cancer';'HIV';'Tuberculosis'};


for dd=1:length(Disease_Short)
    
Disease_F=zeros(length(Oblast_NAME),17);    
Disease_M=zeros(length(Oblast_NAME),17);


PopO_F=zeros(length(Oblast_NAME),17);    
PopO_M=zeros(length(Oblast_NAME),17);

    [dpc,~,~]=Disease_Distribution_beta(Disease_Short{dd},Mapped_Raion_Name,age_class_v,gender_v,Pop,repmat(Pop,1,1,1,2),Pop,Pop,PopR,false);
    Nat_Prev=sum(dpc(:))./sum(Pop(:));
    
    for ii=1:length(Oblast_NAME)
        for jj=1:length(Raion_NAME)
           tf=strcmp(Raion_NAME{jj},t2) & strcmp(Oblast_NAME{ii},t1) ;            
           Disease_F(ii,:)=Disease_F(ii,:)+squeeze(sum(dpc(1,tf,:),[1 2]))';
           Disease_M(ii,:)=Disease_M(ii,:)+squeeze(sum(dpc(2,tf,:),[1 2]))';
           
                       
           PopO_F(ii,:)=PopO_F(ii,:)+squeeze(sum(Pop(1,tf,:),[1 2]))';
           PopO_M(ii,:)=PopO_M(ii,:)+squeeze(sum(Pop(2,tf,:),[1 2]))';
        end
    end
    
    female_prev=Disease_F./PopO_F;
    male_prev=Disease_M./PopO_M;
    
    nat_female_prev=sum(Disease_F,1)./sum(PopO_F,1);
    nat_male_prev=sum(Disease_M,1)./sum(PopO_M,1);
    
    web_spider_disease=Spider_Web_Plot(female_prev,male_prev,Nat_Prev,nat_female_prev,nat_male_prev,Disease{dd});
    print(gcf,['Test_' Disease_Short{dd} '.png'],'-dpng','-r300');
end