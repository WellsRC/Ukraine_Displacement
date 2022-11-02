clear;
clc;


load('Ukraine_Population_Reduced.mat','Ukraine_Pop')
Mapped_Raion_Name=Ukraine_Pop.map_raion;
clear Ukraine_Pop

[Number_Displacement,Date_Displacement,vLat_C,vLon_C,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,Pop_SES,Pop_MACRO,Pop_raion,Pop_oblast,Time_Sim,RC,Time_Switch]=LoadData(200);

age_class_v={'0-4','5-9','10-14','15-19','20-24','25-29','30-34','35-39','40-44','45-49','50-54','55-59','60-64','65-69','70-74','75-79','80+'};
gender_v={'f','m'};

Pop=zeros(length(gender_v),length(Pop_raion),length(age_class_v));
Pop(1,:,:)=Pop_F_Age;
Pop(2,:,:)=Pop_M_Age;

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

    PopT=sum(Pop,[1 3]);
for dd=1:length(Disease_Short)
    prev_avg=Prev_Disease(Disease_Short{dd},false);
    beta_T_avg=10.^fminbnd(@(x)Objective_Burden(x,prev_avg,Disease_Short{dd},Mapped_Raion_Name,age_class_v,gender_v,Pop,PopR),0,5);
    prev_bnd=Prev_Disease_Range(Disease_Short{dd});
    
    prev_v=linspace(prev_bnd(1),prev_bnd(2),251);
    beta_T=zeros(251,1);
    parfor jj=1:251
        [beta_T(jj)]=10.^fminbnd(@(x)Objective_Burden(x,prev_v(jj),Disease_Short{dd},Mapped_Raion_Name,age_class_v,gender_v,Pop,PopR),0,5);
    end
    save([Disease{dd} '_beta_weighting.mat'],'prev_avg','beta_T_avg','prev_v','beta_T');
end

