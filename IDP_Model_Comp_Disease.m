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

Daily_IDP_Origin=Parameter.w_IDP.*Pop_Displace; % Need to examine the new idp only

West=zeros(16,5);
Central=zeros(16,5);
East=zeros(16,5);
South=zeros(16,5);
North=zeros(16,5);
Kyiv=zeros(16,5);
Russia=zeros(16,5);



IDP_Pop_Model=zeros(16,7);

CVD=zeros(16,7);
Diabetes=zeros(16,7);
Cancer=zeros(16,7);
HIV=zeros(16,7);
TB=zeros(16,7);

Model_BN=zeros(16,4);

for ii=0:15
    
        load(['Mapping_IDP_MLE_Model=' num2str(ii) '.mat'],'par_V');
        
        [Parameter_Map_IDP,IDP_Mv]=Parameter_Return_Mapping_IDP(par_V,ii);
        w_tot_idp=Determine_Weights_IDP(Parameter_Map_IDP,Mapping_Data,IDP_Mv);
        temp_IDP=squeeze(sum(Daily_IDP_Origin,[1 3]));
        [Est_Daily_IDP]=IDP_Refuge_Displaced(w_tot_idp,temp_IDP,Time_Sim,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Parameter,Macro_Map);
        
        IDP_Pop_Model(ii+1,:)=Est_Daily_IDP.macro(:,end);
    for dd=1:5
        [Burden_Non_IDP,Burden_IDP,Burden_Refugee,Burden_Baseline]=Disease_Distribution_beta(Disease_Short{dd},Mapped_Raion_Name,age_class_v,gender_v,Pop_Non_IDP,Daily_IDP_Origin,Pop_Refugee,Pop,PopR,false);
        Burden_IDP=squeeze(sum(Burden_IDP,[1 3]));
        [Est_Daily_IDP]=IDP_Refuge_Displaced(w_tot_idp,Burden_IDP,Time_Sim,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Parameter,Macro_Map);
        N=Est_Daily_IDP.macro_name;
        for jj=1:7
            if(strcmp('KYIV',N{jj}))
                Kyiv(ii+1,dd)=Est_Daily_IDP.macro(jj,end);
            elseif(strcmp('EAST',N{jj}))       
                East(ii+1,dd)=Est_Daily_IDP.macro(jj,end);
            elseif(strcmp('WEST',N{jj}))
                West(ii+1,dd)=Est_Daily_IDP.macro(jj,end);
            elseif(strcmp('SOUTH',N{jj}))
                South(ii+1,dd)=Est_Daily_IDP.macro(jj,end);
            elseif(strcmp('NORTH',N{jj}))
                North(ii+1,dd)=Est_Daily_IDP.macro(jj,end);
            elseif(strcmp('CENTER',N{jj}))
                Central(ii+1,dd)=Est_Daily_IDP.macro(jj,end);
            end            
        end
        
        if(strcmp(Disease_Short{dd},'CVD'))   
            CVD(ii+1,:)=Est_Daily_IDP.macro(:,end);
        elseif(strcmp(Disease_Short{dd},'Diabetes'))
            Diabetes(ii+1,:)=Est_Daily_IDP.macro(:,end);
        elseif(strcmp(Disease_Short{dd},'Cancer'))            
            Cancer(ii+1,:)=Est_Daily_IDP.macro(:,end);
        elseif(strcmp(Disease_Short{dd},'HIV'))
            HIV(ii+1,:)=Est_Daily_IDP.macro(:,end);
        elseif(strcmp(Disease_Short{dd},'TB'))
            TB(ii+1,:)=Est_Daily_IDP.macro(:,end);
        end
    end
    temp=de2bi(ii);
    Model_BN(ii+1,1:length(temp))=temp;
end


CVD_Prev=10000.*CVD./IDP_Pop_Model;
Diabetes_Prev=10000.*Diabetes./IDP_Pop_Model;
Cancer_Prev=10000.*Cancer./IDP_Pop_Model;
HIV_Prev=10000.*HIV./IDP_Pop_Model;
TB_Prev=10000.*TB./IDP_Pop_Model;



T_CVD=table(Model_BN,CVD);
T_Diabetes=table(Model_BN,Diabetes);
T_Cancer=table(Model_BN,Cancer);
T_HIV=table(Model_BN,HIV);
T_TB=table(Model_BN,TB);

writetable(T_CVD,'Supplementary_Data.xlsx','Sheet','IDP-CVD');
writetable(T_Diabetes,'Supplementary_Data.xlsx','Sheet','IDP-Diabetes');
writetable(T_Cancer,'Supplementary_Data.xlsx','Sheet','IDP-Cancer');
writetable(T_HIV,'Supplementary_Data.xlsx','Sheet','IDP-HIV');
writetable(T_TB,'Supplementary_Data.xlsx','Sheet','IDP-TB');



T_CVD_Prev=table(Model_BN,CVD_Prev);
T_Diabetes_Prev=table(Model_BN,Diabetes_Prev);
T_Cancer_Prev=table(Model_BN,Cancer_Prev);
T_HIV_Prev=table(Model_BN,HIV_Prev);
T_TB_Prev=table(Model_BN,TB_Prev);

writetable(T_CVD_Prev,'Supplementary_Data.xlsx','Sheet','IDP-CVD_Prev');
writetable(T_Diabetes_Prev,'Supplementary_Data.xlsx','Sheet','IDP-Diabetes_Prev');
writetable(T_Cancer_Prev,'Supplementary_Data.xlsx','Sheet','IDP-Cancer_Prev');
writetable(T_HIV_Prev,'Supplementary_Data.xlsx','Sheet','IDP-HIV_Prev');
writetable(T_TB_Prev,'Supplementary_Data.xlsx','Sheet','IDP-TB_Prev');