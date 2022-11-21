clear;
% close all;



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

CCC=[hex2rgb('#7fc97f');
hex2rgb('#beaed4');
hex2rgb('#fdc086');
hex2rgb('#ffff99');
hex2rgb('#386cb0');
hex2rgb('#666666');
hex2rgb('#bf5b17');
hex2rgb('#f0027f');];


L=zeros(8,1);
k=zeros(8,1);
for ii=1:8
load(['Calibration_Kernel_Conflict_Window-Conflcit_Radius_Model=' num2str(ii) '.mat']);
L(ii)=-min(fval);
k(ii)=length(x0(1,:));
end

aics=aicbic(L,k);

daics=aics-min(aics);

load('Calibration_Conflict_Kernel.mat');
NS=8;


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




Proxy_Disease_Age_Gender=zeros(8,5);
Proxy_Disease_Gender=zeros(8,5);
Proxy_Disease_Age=zeros(8,5);
Proxy_Disease_Nat=zeros(8,5);


Prev_Dis_Gender_Age=zeros(length(Disease_Short),length(gender_v),length(age_class_v));
Prev_Dis_Age=zeros(length(Disease_Short),length(age_class_v));
Prev_Dis_Gender=zeros(length(Disease_Short),length(gender_v));
Prev_Dis_Nat=zeros(length(Disease_Short));

Model_Type={'Location','Location and Age','Location and Gender','Location and Socio-economic status','Location, Age, and Gender','Location, Age, and Socio-economic status','Location, Gender, and Socio-economic status','Location, Age, Gender, and Socio-economic status'}';

Prev_Model=zeros(8,5);
Disease_Model=zeros(8,5);



[Disease_List,Model_List]=meshgrid(Disease_Short,Model_Type);

for jj=1:8
    load(['Calibration_Kernel_Conflict_Window-Conflcit_Radius_Model=' num2str(jj) '.mat']);
    day_W_fix=day_W_fix(fval==min(fval));
    RC=RC(fval==min(fval));
    Parameter_V=x0(fval==min(fval),:);



    [Parameter,STDEV_Displace]=Parameter_Return(Parameter_V,RC,Time_Switch,day_W_fix,jj);
    [Pop_Displace,Pop_IDP,Pop_Refugee]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Time_Sim,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,Pop_SES);
    Pop_Non_IDP=Pop-sum(Pop_Displace,4);
    Pop_Refugee=sum(Pop_Refugee,4);
    
    
    Num_Displaced=squeeze(sum(Pop_Displace,[4]));
    
    Displaced_UKR_Nat=sum(Num_Displaced(:));

    
    Displaced_UKR_Gender_Age=zeros(length(gender_v),length(age_class_v));
    Displaced_UKR_Age=zeros(1,length(age_class_v));
    Displaced_UKR_Gender=zeros(1,length(gender_v));

    for gg=1:2
        Displaced_UKR_Gender(gg)=squeeze(sum(Num_Displaced(gg,:,:),[2 3]));
        for aa=1:17
            Displaced_UKR_Gender_Age(gg,aa)=squeeze(sum(Num_Displaced(gg,:,aa)));
            Displaced_UKR_Age(aa)=squeeze(sum(Num_Displaced(:,:,aa),[1 2]));
        end
    end


    for dd=1:5
        [Burden_Non_IDP,Burden_IDP,Burden_Refugee,Burden_Baseline]=Disease_Distribution_beta(Disease_Short{dd},Mapped_Raion_Name,age_class_v,gender_v,Pop_Non_IDP,Pop_IDP,Pop_Refugee,Pop,PopR,false);
        temp=Burden_IDP(:,:,:,end);
        PD=Pop_IDP(:,:,:,end);
        PD=sum(PD(:))+sum(Pop_Refugee(:));
        Prev_Model(jj,dd)=10000.*(sum(Burden_Refugee(:))+sum(temp(:)))./PD;
        Disease_Model(jj,dd)=(sum(Burden_Refugee(:))+sum(temp(:)));
        
        
        Prev_Dis_Gender_Age(dd,:,:)=squeeze(sum(Burden_Baseline,2))./squeeze(sum(Pop,2));
        Prev_Dis_Age(dd,:)=squeeze(sum(Burden_Baseline,[1 2]))./squeeze(sum(Pop,[1 2]));
        Prev_Dis_Gender(dd,:)=squeeze(sum(Burden_Baseline,[2 3]))./squeeze(sum(Pop,[2 3]));
        Prev_Dis_Nat(dd)=squeeze(sum(Burden_Baseline,[1 2 3]))./squeeze(sum(Pop,[1 2 3])); 
        
        
        Proxy_Disease_Age_Gender(jj,dd)=sum(squeeze(Prev_Dis_Gender_Age(dd,:,:)).*Displaced_UKR_Gender_Age,[1 2]);
        Proxy_Disease_Age(jj,dd)=sum(squeeze(Prev_Dis_Age(dd,:).*Displaced_UKR_Age));
        Proxy_Disease_Gender(jj,dd)=sum(squeeze(Prev_Dis_Gender(dd,:).*Displaced_UKR_Gender));
        Proxy_Disease_Nat(jj,dd)=sum(squeeze(Prev_Dis_Nat(dd).*Displaced_UKR_Nat));
    end
    
end


Rel_Diff_Nat=Proxy_Disease_Nat./Disease_Model-1;
Rel_Diff_Age=Proxy_Disease_Age./Disease_Model-1;
Rel_Diff_Gender=Proxy_Disease_Gender./Disease_Model-1;
Rel_Diff_Age_Gender=Proxy_Disease_Age_Gender./Disease_Model-1;

Model_List=Model_List(:);
Disease_List=Disease_List(:);
Rel_Diff_Nat=Rel_Diff_Nat(:);
Rel_Diff_Age=Rel_Diff_Age(:);
Rel_Diff_Gender=Rel_Diff_Gender(:);
Rel_Diff_Age_Gender=Rel_Diff_Age_Gender(:);
Prev_Model=Prev_Model(:);
T=table(Disease_List,Model_List,Prev_Model,Rel_Diff_Nat,Rel_Diff_Age,Rel_Diff_Gender,Rel_Diff_Age_Gender);


writetable(T,'Disease_Burden_Displacement_Models.csv');
    
    