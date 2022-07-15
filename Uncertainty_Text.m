clear;
load('Ukraine_Population_Reduced.mat','Ukraine_Pop')
Mapped_Raion_Name=Ukraine_Pop.map_raion;
Oblast_Pixel=Ukraine_Pop.oblast;
Raion_Pixel=Ukraine_Pop.raion;
clear Ukraine_Pop

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MLE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load('Macro_Oblast_Map.mat','Macro_Map');
load('Merge_Parameter_Uncertainty.mat')
day_W_fix=7;

L=sum(L_T,2);
KD_MLE=Par_KD(L==max(L),:);
Map_MLE=Par_Map(L==max(L),:);


[Parameter_Map_Refugee,Parameter_Map_IDP]=Parameter_Return_Mapping(Map_MLE);

[Number_Displacement,Date_Displacement,vLat_C,vLon_C,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,Pop_MACRO,Pop_raion,Pop_oblast,Time_Sim,ML_Indx,RC,Time_Switch]=LoadData;


age_class_v={'0-4','5-9','10-14','15-19','20-24','25-29','30-34','35-39','40-44','45-49','50-54','55-59','60-64','65-69','70-74','75-79','80+'};
gender_v={'f','m'};


Pop=zeros(length(gender_v),length(Pop_raion),length(age_class_v));
Pop(1,:,:)=Pop_F_Age;
Pop(2,:,:)=Pop_M_Age;


load('Load_Data_MCMC_Mapping.mat','Mapping_Data','Shapefile_Raion_Name','Shapefile_Raion_Oblast_Name','Shapefile_Oblast_Name');

Pop_Macro=Macro_Return(squeeze(sum(Pop,[1 3]))',Raion_Pixel,Oblast_Pixel,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Macro_Map);


Disease_Short={'CVD';'Diabetes';'Cancer';'HIV';'TB'};


w_tot_ref=Determine_Weights_Refugee(Parameter_Map_Refugee,Mapping_Data);

[Parameter,~]=Parameter_Return(KD_MLE,RC,Time_Switch,day_W_fix);

[Pop_Displace,Pop_IDP,Pop_Refugee]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Time_Sim,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,ML_Indx);


Daily_IDP_Origin=Parameter.w_IDP.*squeeze(sum(Pop_Displace,[1 3])); % Need to examine the new idp only
    

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

Num_Refugee=squeeze(sum(Pop_Refugee,[4]));
Num_Non_Displaced=Pop-Pop_IDP(:,:,:,end)-Num_Refugee;

w_tot_idp=Determine_Weights_IDP(Parameter_Map_IDP,Mapping_Data);
[Est_Daily_IDP]=IDP_Refuge_Displaced(w_tot_idp,Daily_IDP_Origin,Time_Sim,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Parameter,Macro_Map);
Est_Pop_NIDP=Macro_Return(squeeze(sum(Num_Non_Displaced,[1 3]))',Raion_Pixel,Oblast_Pixel,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Macro_Map);
MLE_Rel_Change_Pop= (Est_Daily_IDP.macro(:,end)+Est_Pop_NIDP.macro)./Pop_Macro.macro-1;

MLE_Macro_Pop=[Pop_Macro.macro Est_Daily_IDP.macro(:,end)+Est_Pop_NIDP.macro];

MLE_Num_IDP=sum(Pop_IDP(:,:,:,end),[1 2 3]);
MLE_Refugee_Num_Country=squeeze(sum(Num_Refugee,[1 3]))*w_tot_ref;

MLE_Macro_Disease=zeros(length(Disease_Short),7,2);
MLE_IDP_Disease=zeros(1,length(Disease_Short));
MLE_Refugee_Disease=zeros(length(Disease_Short),8);
for dd=1:length(Disease_Short)
    [test_non_idp,test_idp,dpc]=Disease_Distribution(Disease_Short{dd},Mapped_Raion_Name,age_class_v,gender_v,Num_Non_Displaced,Pop_IDP,Num_Refugee,Pop,PopR,false);
    dpc=sum(dpc,[1 3]);
    MLE_IDP_Disease(dd)=sum(test_idp(:,:,:,end),[1 2 3]);
    
    test_Idp=Macro_Return(squeeze(sum(squeeze(test_idp(:,:,:,end))+test_non_idp,[1 3]))',Raion_Pixel,Oblast_Pixel,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Macro_Map);
    MLE_Macro_Disease(dd,:,2)=test_Idp.macro;
    MLE_Refugee_Disease(dd,:)=dpc*w_tot_ref;
    
    [test_pop_disease,~,~]=Disease_Distribution(Disease_Short{dd},Mapped_Raion_Name,age_class_v,gender_v,Pop,Pop,Pop,Pop,PopR,false);
    test_pop_macro=Macro_Return(squeeze(sum(test_pop_disease,[1 3]))',Raion_Pixel,Oblast_Pixel,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Macro_Map);
    MLE_Macro_Disease(dd,:,1)=test_pop_macro.macro;
end

load('Merge_Parameter_Uncertainty.mat')

NS=length(Par_KD(:,1));


UN_IDP_Disease=zeros(NS,length(Disease_Short));
temp_IDP_Disease=zeros(1,length(Disease_Short));
UN_Refugee_Disease=zeros(NS,length(Disease_Short),8);
UN_Num_IDP=zeros(NS,1);
UN_Refugee_Num_Country=zeros(NS,8);
prev_samp=zeros(NS,length(Disease_Short));
UN_Rel_Change_Pop=zeros(NS,7);
UN_Macro_Pop=zeros(NS,7,2);
UN_Macro_Disease_PreWar=zeros(NS,length(Disease_Short),7);
UN_Macro_Disease_PostWar=zeros(NS,length(Disease_Short),7);


for ii=1:NS
    [Parameter_Map_Refugee,Parameter_Map_IDP]=Parameter_Return_Mapping(Par_Map(ii,:));
    w_tot_ref=Determine_Weights_Refugee(Parameter_Map_Refugee,Mapping_Data);

    [Parameter,~]=Parameter_Return(Par_KD(ii,:),RC,Time_Switch,day_W_fix);

    [Pop_Displace,Pop_IDP,Pop_Refugee]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Time_Sim,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,ML_Indx);
    
    Daily_IDP_Origin=Parameter.w_IDP.*squeeze(sum(Pop_Displace,[1 3])); % Need to examine the new idp only
    
    Num_Refugee=squeeze(sum(Pop_Refugee,[4]));
    Num_Non_Displaced=Pop-Pop_IDP(:,:,:,end)-Num_Refugee;

    w_tot_idp=Determine_Weights_IDP(Parameter_Map_IDP,Mapping_Data);
    [Est_Daily_IDP]=IDP_Refuge_Displaced(w_tot_idp,Daily_IDP_Origin,Time_Sim,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Parameter,Macro_Map);
    Est_Pop_NIDP=Macro_Return(squeeze(sum(Num_Non_Displaced,[1 3]))',Raion_Pixel,Oblast_Pixel,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Macro_Map);
    UN_Rel_Change_Pop(ii,:)= (Est_Daily_IDP.macro(:,end)+Est_Pop_NIDP.macro)./Pop_Macro.macro-1;
    
    UN_Macro_Pop(ii,:,:)=[Pop_Macro.macro Est_Daily_IDP.macro(:,end)+Est_Pop_NIDP.macro];
    
    UN_Num_IDP(ii)=sum(Pop_IDP(:,:,:,end),[1 2 3]);
    UN_Refugee_Num_Country(ii,:)=squeeze(sum(Num_Refugee,[1 3]))*w_tot_ref;
    
    parfor dd=1:length(Disease_Short)
        [test_non_idp,test_idp,dpc,prev_samp(ii,dd)]=Disease_Distribution(Disease_Short{dd},Mapped_Raion_Name,age_class_v,gender_v,Num_Non_Displaced,Pop_IDP,Num_Refugee,Pop,PopR,true);
        dpc=sum(dpc,[1 3]);
        UN_IDP_Disease(ii,dd)=squeeze(sum(test_idp(:,:,:,end),[1 2 3]));
        
        
        test_Idp=Macro_Return(squeeze(sum(squeeze(test_idp(:,:,:,end))+test_non_idp,[1 3]))',Raion_Pixel,Oblast_Pixel,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Macro_Map);
        UN_Macro_Disease_PostWar(ii,dd,:)=test_Idp.macro;
    
        UN_Refugee_Disease(ii,dd,:)=dpc*w_tot_ref;
        
        [test_pop_disease,~,~]=Disease_Distribution(Disease_Short{dd},Mapped_Raion_Name,age_class_v,gender_v,Pop,Pop,Pop,Pop,PopR,true);
        test_pop_macro=Macro_Return(squeeze(sum(test_pop_disease,[1 3]))',Raion_Pixel,Oblast_Pixel,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Macro_Map);
        UN_Macro_Disease_PreWar(ii,dd,:)=test_pop_macro.macro;
    end
end

save('Uncertainty_text.mat');
