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


Model_Type={'Location','Location and Age','Location and Gender','Location and Socio-economic status','Location, Age, and Gender','Location, Age, and Socio-economic status','Location, Gender, and Socio-economic status','Location, Age, Gender, and Socio-economic status','National'}';

Disease_Model=zeros(9,5);

for jj=1:8
    load(['Calibration_Kernel_Conflict_Window-Conflcit_Radius_Model=' num2str(jj) '.mat']);
    day_W_fix=day_W_fix(fval==min(fval));
    RC=RC(fval==min(fval));
    Parameter_V=x0(fval==min(fval),:);



    [Parameter,STDEV_Displace]=Parameter_Return(Parameter_V,RC,Time_Switch,day_W_fix,jj);
    [Pop_Displace,Pop_IDP,Pop_Refugee]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Time_Sim,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,Pop_SES);
    Pop_Non_IDP=Pop-sum(Pop_Displace,4);
    Pop_Refugee=sum(Pop_Refugee,4);
    for dd=1:5
        [Burden_Non_IDP,Burden_IDP,Burden_Refugee,Burden_Baseline]=Disease_Distribution_beta(Disease_Short{dd},Mapped_Raion_Name,age_class_v,gender_v,Pop_Non_IDP,Pop_IDP,Pop_Refugee,Pop,PopR,false);
        temp=Burden_IDP(:,:,:,end);
        PD=Pop_IDP(:,:,:,end);
        PD=sum(PD(:))+sum(Pop_Refugee(:));
        Disease_Model(jj,dd)=10000.*(sum(Burden_Refugee(:))+sum(temp(:)))./PD;
        Disease_Model(9,dd)=10000.*sum(Burden_Baseline(:))./sum(Pop(:));
    end
    
end

Rel_Diff=100.*(Disease_Model./repmat(Disease_Model(9,:),9,1)-1);

T=table(Model_Type,Disease_Model,Rel_Diff);
    
    