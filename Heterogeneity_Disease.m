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
Model_Num=6;
load(['Calibration_Kernel_Conflict_Window-Conflcit_Radius_Model=' num2str(Model_Num) '.mat']);
day_W_fix=day_W_fix(fval==min(fval));
RC=RC(fval==min(fval));
x=x0(fval==min(fval),:);
[Parameter,STDEV_Displace]=Parameter_Return(x,RC,Time_Switch,day_W_fix,Model_Num);
[~,Pop_IDP,Pop_Refugee]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Time_Sim,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,Pop_SES);
Pop_D=Pop_IDP(:,:,end)+sum(Pop_Refugee,4);    


age_class_v={'0-4','5-9','10-14','15-19','20-24','25-29','30-34','35-39','40-44','45-49','50-54','55-59','60-64','65-69','70-74','75-79','80+'};
gender_v={'f','m'};

Pop=zeros(length(gender_v),length(Pop_raion),length(age_class_v));
Pop(1,:,:)=Pop_F_Age;
Pop(2,:,:)=Pop_M_Age;

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


Disease_Short={'CVD';'Diabetes';'Cancer';'HIV';'TB'};

Disease={'Cardiovascular disease';'Diabetes';'Cancer';'HIV';'Tuberculosis'};

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