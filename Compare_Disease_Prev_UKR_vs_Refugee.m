clear;
close all;
clc;
D={'CVD';'Diabetes';'Cancer';'HIV';'TB'};
prev=zeros(size(D));

load('Load_Data_MCMC.mat','Pop_M_Age','Pop_F_Age');

N=sum(Pop_F_Age(:))+sum(Pop_M_Age(:));


for ii=1:length(D)
    load('UKR_Disease_Burden.mat');
    tf=strcmp(D{ii},DB_UKR.Disease);

    prev(ii)=DB_UKR.Cases(tf)./N;
end

load('Figure1G_Output.mat','Refugee_Disease_t','Country_Name','Disease');

Prev_R=Refugee_Disease_t(2:end,2:end)./repmat(Refugee_Disease_t(1,2:end),length(D),1);

Disease=Disease(2:end);
Country_Name=Country_Name(2:end);

for ii=1:length(Disease)
    temp=prev(ii)./Prev_R(ii,:)-1;
    
    fprintf(['Maximum error in prevalence for ' Disease{ii} ' in ' Country_Name{temp==max(temp)} ' is ' num2str(100.*max(temp),'%4.2f') '\n']);
    fprintf(['Minimum error in prevalence for ' Disease{ii} ' in ' Country_Name{temp==min(temp)} ' is ' num2str(100.*min(temp),'%4.2f') '\n \n']);
end


clear;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% Table of comparison
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55


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

load('Merge_Parameter_Uncertainty.mat')
day_W_fix=7;

L=sum(L_T,2);
Par_KD=Par_KD(L==max(L),:);
Par_Map=Par_Map(L==max(L),:);

[Parameter_Map_Refugee,Parameter_Map_IDP]=Parameter_Return_Mapping(Par_Map);
load('Load_Data_MCMC_Mapping.mat','Mapping_Data');
w_tot_ref=Determine_Weights_Refugee(Parameter_Map_Refugee,Mapping_Data);



[Parameter,STDEV_Displace]=Parameter_Return(Par_KD,RC,Time_Switch,day_W_fix);

[Pop_Displace,Pop_IDP,Pop_Refugee]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Time_Sim,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,ML_Indx);

Num_Refugee=squeeze(sum(Pop_Refugee,[4]));


Disease_Short={'CVD';'Diabetes';'Cancer';'HIV';'TB'};

Prev_Dis_Gender_Age=zeros(length(Disease_Short),length(gender_v),length(age_class_v));
Prev_Dis_Age=zeros(length(Disease_Short),length(age_class_v));
Prev_Dis_Gender=zeros(length(Disease_Short),length(gender_v));
Prev_Dis_Nat=zeros(length(Disease_Short),1);

Refugee_Dis_Gender_Age=zeros(8,length(gender_v),length(age_class_v));
Refugee_Dis_Age=zeros(8,length(age_class_v));
Refugee_Dis_Gender=zeros(8,length(gender_v));
Refugee_Dis_Nat=squeeze(sum(Num_Refugee,[1 3]))*w_tot_ref;

for gg=1:2
    Refugee_Dis_Gender(:,gg)=squeeze(sum(Num_Refugee(gg,:,:),3))*w_tot_ref;
    for aa=1:17
        Refugee_Dis_Gender_Age(:,gg,aa)=squeeze(Num_Refugee(gg,:,aa))*w_tot_ref;
        Refugee_Dis_Age(:,aa)=squeeze(sum(Num_Refugee(:,:,aa),1))*w_tot_ref;
    end
end


for dd=1:length(Disease_Short)
    [~,~,pop_dis]=Disease_Distribution(Disease_Short{dd},Mapped_Raion_Name,age_class_v,gender_v,Pop,repmat(Pop,1,1,1,2),Pop,Pop,PopR,false);
    Prev_Dis_Gender_Age(dd,:,:)=squeeze(sum(pop_dis,2))./squeeze(sum(Pop,2));
    Prev_Dis_Age(dd,:)=squeeze(sum(pop_dis,[1 2]))./squeeze(sum(Pop,[1 2]));
    Prev_Dis_Gender(dd,:)=squeeze(sum(pop_dis,[2 3]))./squeeze(sum(Pop,[2 3]));
    Prev_Dis_Nat(dd)=squeeze(sum(pop_dis,[1 2 3]))./squeeze(sum(Pop,[1 2 3]));
end

Country_Name_temp={'Poland';'Slovakia';'Hungary';'Romania';'Belarus';'Moldova';'Russia';'Europe'};

Shift_index=zeros(size(Country_Name_temp));

load('Figure1G_Output.mat','Refugee_Disease_t','Country_Name','Disease');
temp_C=Country_Name(2:end);
for ii=1:length(Shift_index)
    Shift_index(ii)=find(strcmp(Country_Name_temp,temp_C{ii}));
end
Country_Name_temp2=Country_Name_temp(Shift_index);
Refugee_Dis_Gender_Age=Refugee_Dis_Gender_Age(Shift_index,:,:);
Refugee_Dis_Age=Refugee_Dis_Age(Shift_index,:);
Refugee_Dis_Gender=Refugee_Dis_Gender(Shift_index,:);
Refugee_Dis_Nat=Refugee_Dis_Nat(Shift_index);


Model_Est_Disease=Refugee_Disease_t(2:end,2:end);

Proxy_Disease_Age_Gender=zeros(size(Model_Est_Disease));
Proxy_Disease_Gender=zeros(size(Model_Est_Disease));
Proxy_Disease_Age=zeros(size(Model_Est_Disease));
Proxy_Disease_Nat=zeros(size(Model_Est_Disease));

for cc=1:8
    for dd=1:length(Disease_Short)
        Proxy_Disease_Age_Gender(dd,cc)=sum(squeeze(Prev_Dis_Gender_Age(dd,:,:)).*squeeze(Refugee_Dis_Gender_Age(cc,:,:)),[1 2]);
        Proxy_Disease_Age(dd,cc)=sum(squeeze(Prev_Dis_Age(dd,:)).*squeeze(Refugee_Dis_Age(cc,:)));
        Proxy_Disease_Gender(dd,cc)=sum(squeeze(Prev_Dis_Gender(dd,:)).*squeeze(Refugee_Dis_Gender(cc,:)));
        Proxy_Disease_Nat(dd,cc)=sum(squeeze(Prev_Dis_Nat(dd)).*squeeze(Refugee_Dis_Nat(cc)));
    end
end

[x,y]=meshgrid(Country_Name(2:end),Disease(2:end));

Model_Est_Disease=Model_Est_Disease(:);
Proxy_Disease_Age_Gender=Proxy_Disease_Age_Gender(:);
Proxy_Disease_Age=Proxy_Disease_Age(:);
Proxy_Disease_Gender=Proxy_Disease_Gender(:);
Proxy_Disease_Nat=Proxy_Disease_Nat(:);

Disease=y(:);
Country_Name=x(:);

Rel_Diff_Nat=Proxy_Disease_Nat./Model_Est_Disease-1;
Rel_Diff_Gender=Proxy_Disease_Gender./Model_Est_Disease-1;
Rel_Diff_Age=Proxy_Disease_Age./Model_Est_Disease-1;
Rel_Diff_Age_Gender=Proxy_Disease_Age_Gender./Model_Est_Disease-1;
T=table(Country_Name,Disease,Model_Est_Disease,Proxy_Disease_Nat,Proxy_Disease_Gender,Proxy_Disease_Age,Proxy_Disease_Age_Gender,Rel_Diff_Nat,Rel_Diff_Gender,Rel_Diff_Age,Rel_Diff_Age_Gender);

save('Comparison_Proxy_Prev_Table.mat','T');

writetable(T,'Comparison_Estimated_Disease.csv')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Uncertaity
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

clear;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% Table of comparison
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55


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


load('Merge_Parameter_Uncertainty.mat','Par_KD','Par_Map')
day_W_fix=7;

load('Load_Data_MCMC_Mapping.mat','Mapping_Data');
NS=length(Par_KD(:,1));


Disease_Short={'CVD';'Diabetes';'Cancer';'HIV';'TB'};


Country_Name_temp={'Poland';'Slovakia';'Hungary';'Romania';'Belarus';'Moldova';'Russia';'Europe'};

Shift_index=zeros(size(Country_Name_temp));

load('Figure1G_Output.mat','Refugee_Disease_t','Country_Name','Disease');
temp_C=Country_Name(2:end);
for ii=1:length(Shift_index)
    Shift_index(ii)=find(strcmp(Country_Name_temp,temp_C{ii}));
end


[x,y]=meshgrid(Country_Name(2:end),Disease(2:end));

Disease=y(:);
Country_Name=x(:);

Model_Est_Disease_UN=zeros(NS,length(Disease));
Proxy_Disease_Age_Gender_UN=zeros(NS,length(Disease));
Proxy_Disease_Age_UN=zeros(NS,length(Disease));
Proxy_Disease_Gender_UN=zeros(NS,length(Disease));
Proxy_Disease_Nat_UN=zeros(NS,length(Disease));

for ss=1:NS

    [Parameter_Map_Refugee,Parameter_Map_IDP]=Parameter_Return_Mapping(Par_Map);
    w_tot_ref=Determine_Weights_Refugee(Parameter_Map_Refugee,Mapping_Data);



    [Parameter,STDEV_Displace]=Parameter_Return(Par_KD,RC,Time_Switch,day_W_fix);

    [Pop_Displace,Pop_IDP,Pop_Refugee]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Time_Sim,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,ML_Indx);

    Num_Refugee=squeeze(sum(Pop_Refugee,[4]));


    Prev_Dis_Gender_Age=zeros(length(Disease_Short),length(gender_v),length(age_class_v));
    Prev_Dis_Age=zeros(length(Disease_Short),length(age_class_v));
    Prev_Dis_Gender=zeros(length(Disease_Short),length(gender_v));
    Prev_Dis_Nat=zeros(length(Disease_Short),1);

    Refugee_Dis_Gender_Age=zeros(8,length(gender_v),length(age_class_v));
    Refugee_Dis_Age=zeros(8,length(age_class_v));
    Refugee_Dis_Gender=zeros(8,length(gender_v));
    Refugee_Dis_Nat=squeeze(sum(Num_Refugee,[1 3]))*w_tot_ref;

    for gg=1:2
        Refugee_Dis_Gender(:,gg)=squeeze(sum(Num_Refugee(gg,:,:),3))*w_tot_ref;
        for aa=1:17
            Refugee_Dis_Gender_Age(:,gg,aa)=squeeze(Num_Refugee(gg,:,aa))*w_tot_ref;
            Refugee_Dis_Age(:,aa)=squeeze(sum(Num_Refugee(:,:,aa),1))*w_tot_ref;
        end
    end


    for dd=1:length(Disease_Short)
        [~,~,pop_dis]=Disease_Distribution(Disease_Short{dd},Mapped_Raion_Name,age_class_v,gender_v,Pop,repmat(Pop,1,1,1,2),Pop,Pop,PopR,false);
        Prev_Dis_Gender_Age(dd,:,:)=squeeze(sum(pop_dis,2))./squeeze(sum(Pop,2));
        Prev_Dis_Age(dd,:)=squeeze(sum(pop_dis,[1 2]))./squeeze(sum(Pop,[1 2]));
        Prev_Dis_Gender(dd,:)=squeeze(sum(pop_dis,[2 3]))./squeeze(sum(Pop,[2 3]));
        Prev_Dis_Nat(dd)=squeeze(sum(pop_dis,[1 2 3]))./squeeze(sum(Pop,[1 2 3]));
    end

    Country_Name_temp2=Country_Name_temp(Shift_index);
    Refugee_Dis_Gender_Age=Refugee_Dis_Gender_Age(Shift_index,:,:);
    Refugee_Dis_Age=Refugee_Dis_Age(Shift_index,:);
    Refugee_Dis_Gender=Refugee_Dis_Gender(Shift_index,:);
    Refugee_Dis_Nat=Refugee_Dis_Nat(Shift_index);


    Model_Est_Disease=Refugee_Disease_t(2:end,2:end);

    Proxy_Disease_Age_Gender=zeros(size(Model_Est_Disease));
    Proxy_Disease_Gender=zeros(size(Model_Est_Disease));
    Proxy_Disease_Age=zeros(size(Model_Est_Disease));
    Proxy_Disease_Nat=zeros(size(Model_Est_Disease));

    for cc=1:8
        for dd=1:length(Disease_Short)
            Proxy_Disease_Age_Gender(dd,cc)=sum(squeeze(Prev_Dis_Gender_Age(dd,:,:)).*squeeze(Refugee_Dis_Gender_Age(cc,:,:)),[1 2]);
            Proxy_Disease_Age(dd,cc)=sum(squeeze(Prev_Dis_Age(dd,:)).*squeeze(Refugee_Dis_Age(cc,:)));
            Proxy_Disease_Gender(dd,cc)=sum(squeeze(Prev_Dis_Gender(dd,:)).*squeeze(Refugee_Dis_Gender(cc,:)));
            Proxy_Disease_Nat(dd,cc)=sum(squeeze(Prev_Dis_Nat(dd)).*squeeze(Refugee_Dis_Nat(cc)));
        end
    end

    

    Model_Est_Disease=Model_Est_Disease(:);
    Proxy_Disease_Age_Gender=Proxy_Disease_Age_Gender(:);
    Proxy_Disease_Age=Proxy_Disease_Age(:);
    Proxy_Disease_Gender=Proxy_Disease_Gender(:);
    Proxy_Disease_Nat=Proxy_Disease_Nat(:);


    Rel_Diff_Nat(ss,:)=Proxy_Disease_Nat./Model_Est_Disease-1;
    Rel_Diff_Gender(ss,:)=Proxy_Disease_Gender./Model_Est_Disease-1;
    Rel_Diff_Age(ss,:)=Proxy_Disease_Age./Model_Est_Disease-1;
    Rel_Diff_Age_Gender(ss,:)=Proxy_Disease_Age_Gender./Model_Est_Disease-1;

    Model_Est_Disease_UN(ss,:)=Model_Est_Disease(:);
    Proxy_Disease_Age_Gender_UN(ss,:)=Proxy_Disease_Age_Gender(:);
    Proxy_Disease_Age_UN(ss,:)=Proxy_Disease_Age(:);
    Proxy_Disease_Gender_UN(ss,:)=Proxy_Disease_Gender(:);
    Proxy_Disease_Nat_UN(ss,:)=Proxy_Disease_Nat(:);
end


T=table(Country_Name,Disease,Model_Est_Disease,Proxy_Disease_Nat,Proxy_Disease_Gender,Proxy_Disease_Age,Proxy_Disease_Age_Gender,Rel_Diff_Nat,Rel_Diff_Gender,Rel_Diff_Age,Rel_Diff_Age_Gender);

save('Comparison_Proxy_Prev_Table_Uncertainty.mat','T');

writetable(T,'Comparison_Estimated_Disease_Uncertainty.csv')