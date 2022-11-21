clear;



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
% S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);
% Shapefile_Raion_Name={S2.NAME_2};
% Shapefile_Raion_Oblast_Name={S2.NAME_1};
% S1=shaperead('UKR_ADM_1\UKR_adm1.shp','UseGeoCoords',true);
% Shapefile_Oblast_Name={S1.NAME_1};
% save('Load_Data_MCMC_Mapping.mat');

load('Calibration_Conflict_Kernel.mat');
load(['Calibration_Kernel_Conflict_Window-Conflcit_Radius_Model=' num2str(AIC_model_num) '.mat']);
day_W_fix=day_W_fix(fval==min(fval));
RC=RC(fval==min(fval));
Parameter_V=x0(fval==min(fval),:);
load('Macro_Oblast_Map.mat','Macro_Map');



age_class_v={'0-4','5-9','10-14','15-19','20-24','25-29','30-34','35-39','40-44','45-49','50-54','55-59','60-64','65-69','70-74','75-79','80+'};
gender_v={'f','m'};


Pop=zeros(length(gender_v),length(Pop_raion),length(age_class_v));
Pop(1,:,:)=Pop_F_Age;
Pop(2,:,:)=Pop_M_Age;

Disease_Short={'CVD';'Diabetes';'Cancer';'HIV';'TB'};


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




[Parameter,STDEV_Displace]=Parameter_Return(Parameter_V,RC,Time_Switch,day_W_fix,AIC_model_num);

[Pop_Displace,Pop_IDP,Pop_Refugee]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Time_Sim,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,Pop_SES);

Pop_Non_IDP=Pop-sum(Pop_Displace,4);
Pop_Refugee=sum(Pop_Refugee,4);

Poland=zeros(32,5);
Slovakia=zeros(32,5);
Hungary=zeros(32,5);
Romania=zeros(32,5);
Belarus=zeros(32,5);
Moldova=zeros(32,5);
Russia=zeros(32,5);
Europe=zeros(32,5);

Ref_Pop_Model=zeros(32,8);

CVD=zeros(32,8);
Diabetes=zeros(32,8);
Cancer=zeros(32,8);
HIV=zeros(32,8);
TB=zeros(32,8);


Model_BN=zeros(32,5);

for ii=0:31
    
    load(['Mapping_Refugee_MLE_Model=' num2str(ii) '.mat'],'par_V');
        
        [Parameter_Map_Refugee,Refugee_Mv]=Parameter_Return_Mapping_Refugee(par_V,ii);

        w_tot_ref=Determine_Weights_Refugee(Parameter_Map_Refugee,Mapping_Data,Refugee_Mv);

        temp_Ref=squeeze(sum(Pop_Refugee,[1 3]))';
        [Est_Daily_Refugee]=Country_Refuge_Displaced(w_tot_ref,temp_Ref);
        
        Ref_Pop_Model(ii+1,:)=cell2mat(struct2cell(Est_Daily_Refugee));

    for dd=1:5
        [Burden_Non_IDP,Burden_IDP,Burden_Refugee,Burden_Baseline]=Disease_Distribution_beta(Disease_Short{dd},Mapped_Raion_Name,age_class_v,gender_v,Pop_Non_IDP,Pop_IDP,Pop_Refugee,Pop,PopR,false);
        Burden_Refugee=squeeze(sum(Burden_Refugee,[1 3]))';
        [Est_Daily_Refugee]=Country_Refuge_Displaced(w_tot_ref,Burden_Refugee);
        
        Poland(ii+1,dd)=Est_Daily_Refugee.Poland;
        Slovakia(ii+1,dd)=Est_Daily_Refugee.Slovakia;
        Hungary(ii+1,dd)=Est_Daily_Refugee.Hungary;
        Romania(ii+1,dd)=Est_Daily_Refugee.Romania;
        Belarus(ii+1,dd)=Est_Daily_Refugee.Belarus;
        Moldova(ii+1,dd)=Est_Daily_Refugee.Moldova;
        Russia(ii+1,dd)=Est_Daily_Refugee.Russia;
        Europe(ii+1,dd)=Est_Daily_Refugee.Europe_Other;
        if(strcmp(Disease_Short{dd},'CVD'))   
            CVD(ii+1,:)=cell2mat(struct2cell(Est_Daily_Refugee));
        elseif(strcmp(Disease_Short{dd},'Diabetes'))
            Diabetes(ii+1,:)=cell2mat(struct2cell(Est_Daily_Refugee));
        elseif(strcmp(Disease_Short{dd},'Cancer'))            
            Cancer(ii+1,:)=cell2mat(struct2cell(Est_Daily_Refugee));
        elseif(strcmp(Disease_Short{dd},'HIV'))
            HIV(ii+1,:)=cell2mat(struct2cell(Est_Daily_Refugee));            
        elseif(strcmp(Disease_Short{dd},'TB'))
            TB(ii+1,:)=cell2mat(struct2cell(Est_Daily_Refugee));            
        end
    end
    temp=de2bi(ii);
    Model_BN(ii+1,1:length(temp))=temp;
end

CVD_Prev=10000.*CVD./Ref_Pop_Model;
Diabetes_Prev=10000.*Diabetes./Ref_Pop_Model;
Cancer_Prev=10000.*Cancer./Ref_Pop_Model;
HIV_Prev=10000.*HIV./Ref_Pop_Model;
TB_Prev=10000.*TB./Ref_Pop_Model;


T_CVD=table(Model_BN,CVD);
T_Diabetes=table(Model_BN,Diabetes);
T_Cancer=table(Model_BN,Cancer);
T_HIV=table(Model_BN,HIV);
T_TB=table(Model_BN,TB);

writetable(T_CVD,'Model_Comparison_Disease_Burden.xlsx','Sheet','Refugee-CVD');
writetable(T_Diabetes,'Model_Comparison_Disease_Burden.xlsx','Sheet','Refugee-Diabetes');
writetable(T_Cancer,'Model_Comparison_Disease_Burden.xlsx','Sheet','Refugee-Cancer');
writetable(T_HIV,'Model_Comparison_Disease_Burden.xlsx','Sheet','Refugee-HIV');
writetable(T_TB,'Model_Comparison_Disease_Burden.xlsx','Sheet','Refugee-TB');

T_CVD_Prev=table(Model_BN,CVD_Prev);
T_Diabetes_Prev=table(Model_BN,Diabetes_Prev);
T_Cancer_Prev=table(Model_BN,Cancer_Prev);
T_HIV_Prev=table(Model_BN,HIV_Prev);
T_TB_Prev=table(Model_BN,TB_Prev);

writetable(T_CVD_Prev,'Model_Comparison_Disease_Burden.xlsx','Sheet','Refugee-CVD_Prev');
writetable(T_Diabetes_Prev,'Model_Comparison_Disease_Burden.xlsx','Sheet','Refugee-Diabetes_Prev');
writetable(T_Cancer_Prev,'Model_Comparison_Disease_Burden.xlsx','Sheet','Refugee-Cancer_Prev');
writetable(T_HIV_Prev,'Model_Comparison_Disease_Burden.xlsx','Sheet','Refugee-HIV_Prev');
writetable(T_TB_Prev,'Model_Comparison_Disease_Burden.xlsx','Sheet','Refugee-TB_Prev');