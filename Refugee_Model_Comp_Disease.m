clear;

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
Parameter_V=x0(fval==min(fval),:);
load('Macro_Oblast_Map.mat','Macro_Map');


[Disease_Short,age_class_v,gender_v]=Disease_Stratificaion_Text;
Pop=Population_Join_Gender(Pop_F_Age,Pop_M_Age);
PopR=Raion_Population_Point(Pop,Pop_oblast,Pop_raion);

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

CVD_Prev=100000.*CVD./Ref_Pop_Model;
Diabetes_Prev=100000.*Diabetes./Ref_Pop_Model;
Cancer_Prev=100000.*Cancer./Ref_Pop_Model;
HIV_Prev=100000.*HIV./Ref_Pop_Model;
TB_Prev=100000.*TB./Ref_Pop_Model;


T_CVD=table(Model_BN,CVD);
T_Diabetes=table(Model_BN,Diabetes);
T_Cancer=table(Model_BN,Cancer);
T_HIV=table(Model_BN,HIV);
T_TB=table(Model_BN,TB);

writetable(T_CVD,'Supplementary_Data.xlsx','Sheet','Refugee-CVD');
writetable(T_Diabetes,'Supplementary_Data.xlsx','Sheet','Refugee-Diabetes');
writetable(T_Cancer,'Supplementary_Data.xlsx','Sheet','Refugee-Cancer');
writetable(T_HIV,'Supplementary_Data.xlsx','Sheet','Refugee-HIV');
writetable(T_TB,'Supplementary_Data.xlsx','Sheet','Refugee-TB');

T_CVD_Prev=table(Model_BN,CVD_Prev);
T_Diabetes_Prev=table(Model_BN,Diabetes_Prev);
T_Cancer_Prev=table(Model_BN,Cancer_Prev);
T_HIV_Prev=table(Model_BN,HIV_Prev);
T_TB_Prev=table(Model_BN,TB_Prev);

writetable(T_CVD_Prev,'Supplementary_Data.xlsx','Sheet','Refugee-CVD_Prev');
writetable(T_Diabetes_Prev,'Supplementary_Data.xlsx','Sheet','Refugee-Diabetes_Prev');
writetable(T_Cancer_Prev,'Supplementary_Data.xlsx','Sheet','Refugee-Cancer_Prev');
writetable(T_HIV_Prev,'Supplementary_Data.xlsx','Sheet','Refugee-HIV_Prev');
writetable(T_TB_Prev,'Supplementary_Data.xlsx','Sheet','Refugee-TB_Prev');