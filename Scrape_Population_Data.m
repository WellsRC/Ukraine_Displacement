% Constructs a table for what area each point lies in
clear;

Mapped_Names=readtable('mapped_data.csv');


BC=readtable('ukr_border_crossings_170322.xlsx','Sheet','Border Crossings');

Border_Crossing_Country=BC.Country;
load('FB_SCI_Lookup.mat');

load('FB_UKR_UKR.mat','M_FB_UKR');


Age_Structure=readtable('ukr_admpop_2020_v02.xlsx','Sheet','ukr_admpop_adm1_2020');
load('Reduced_Pop_UKR.mat');

S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);

oblast=cell(length(longitude_v),1);
raion=cell(length(longitude_v),1);
map_raion=cell(length(longitude_v),1);
macro_region=cell(length(longitude_v),1);

% For determining the location where individuals go
per_Country_Desplace=zeros(length(longitude_v),7);
age_Dist_female=zeros(length(longitude_v),17);
age_Dist_male=zeros(length(longitude_v),17);

w_IDP=zeros(length(longitude_v),27);
distance_bc=zeros(length(longitude_v),height(BC));

load('Macro_Oblast_Map.mat');

for ii=1:length(S2)
    [tp_in,tp_on]=inpolygon(longitude_v,latitude_v,S2(ii).Lon,S2(ii).Lat);
    oblast(tp_in | tp_on)={S2(ii).NAME_1};
    raion(tp_in | tp_on)={S2(ii).NAME_2};
    
    tfm=strcmp(Macro_Map(:,2),S2(ii).NAME_1);
    macro_region(tp_in | tp_on)=Macro_Map(tfm,3);
    tfmn=strcmp(S2(ii).HASC_2,Mapped_Names.HASC_2) & strcmp(S2(ii).NAME_2,Mapped_Names.NAME_2);
    if(sum(tfmn)>0)
        NN=Mapped_Names.DistrictName{tfmn};
        map_raion(tp_in | tp_on)={NN};
    end
    
    w=zeros(1,7);
    for cc=1:7
        test=Country_ID{cc};
        tob=strcmp(FB_SCI.user_loc,{['UKR' num2str(S2(ii).ID_1)]});
        for ff=1:length(test)
            tfb=strcmp(FB_SCI.fr_loc,test{ff});
            tempw=FB_SCI.scaled_sci(tob & tfb);
            if(~isempty(tempw))
                w(cc)=w(cc)+tempw;
            end
        end
        w(cc)=w(cc)./length(test);
    end
    per_Country_Desplace(tp_in | tp_on,:)=repmat(w,sum(tp_in | tp_on),1);
    
    for cc=1:height(BC)
       distance_bc(tp_in | tp_on,cc)=deg2km(distance('gc',BC.Lat(cc),BC.Long(cc),latitude_v(tp_in | tp_on),longitude_v(tp_in | tp_on)));
    end
    
    w_IDP(tp_in | tp_on,:)=repmat(M_FB_UKR(S2(ii).ID_1,:),sum(tp_in | tp_on),1);
    
    tpmf=S2(ii).ID_1==Age_Structure.Shapefile_ID1;
    age_Dist_female(tp_in | tp_on,:)=repmat([table2array(Age_Structure(tpmf,16:32))./sum(table2array(Age_Structure(tpmf,50:66)))],sum(tp_in | tp_on),1);
    age_Dist_male(tp_in | tp_on,:)=repmat([table2array(Age_Structure(tpmf,33:49))./sum(table2array(Age_Structure(tpmf,50:66)))],sum(tp_in | tp_on),1);
end

% Do note need to check if oblast is empty as all points were selected to
% lie in shapefile

for ii=1:7
    per_Country_Desplace(per_Country_Desplace(:,ii)==0,ii)=mean(per_Country_Desplace(per_Country_Desplace(:,ii)>0,ii));
end
per_Poland=per_Country_Desplace(:,1);
per_Belarus=per_Country_Desplace(:,2);
per_Slovakia=per_Country_Desplace(:,3);
per_Hungary=per_Country_Desplace(:,4);
per_Romania=per_Country_Desplace(:,5);
per_Moldova=per_Country_Desplace(:,6);
per_Other=per_Country_Desplace(:,7);



for mm=1:length(map_raion)
    if(isempty(map_raion{mm}))
        map_raion{mm}='N/A';
    end
end

Ukraine_Pop=table(longitude_v,latitude_v,pop_adj,oblast,raion,macro_region,map_raion,age_Dist_female,age_Dist_male,per_Poland,per_Slovakia,per_Hungary,per_Romania,per_Belarus,per_Moldova,per_Other,distance_bc,w_IDP);

save('Ukraine_Population_Reduced.mat','Ukraine_Pop','Border_Crossing_Country');
