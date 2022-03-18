% Constructs a table for what area each point lies in
clear;

Mapped_Names=readtable('mapped_data.csv');


BC=readtable('ukr_border_crossings_170322.xlsx','Sheet','Border Crossings');

Border_Crossing_Country=BC.Country;
load('FB_SCI_Lookup.mat');

load('FB_UKR_UKR.mat','M_FB_UKR');


Male_Fight=readtable('ukr_admpop_2020_v02.xlsx','Sheet','ukr_admpop_adm1_2020');

T=readtable('ukr_pd_2020_1km_ASCII_XYZ.csv'); % obtains the population density based on long and lat
longitude=table2array(T(:,1));
latitude=table2array(T(:,2));
population_size=table2array(T(:,3));
clear T;
S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);

oblast=cell(length(longitude),1);
raion=cell(length(longitude),1);
map_raion=cell(length(longitude),1);

% For determining the location where individuals go
per_Country_Desplace=zeros(length(longitude),7);
per_male_fight=zeros(length(longitude),1);

w_IDP=zeros(length(longitude),27);
distance_bc=zeros(length(longitude),height(BC));



for ii=1:length(S2)
    [tp_in,tp_on]=inpolygon(longitude,latitude,S2(ii).Lon,S2(ii).Lat);
    oblast(tp_in | tp_on)={S2(ii).NAME_1};
    raion(tp_in | tp_on)={S2(ii).NAME_2};
    
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
    w=w./sum(w);
    per_Country_Desplace(tp_in | tp_on,:)=repmat(w,sum(tp_in | tp_on),1);
    
    for cc=1:height(BC)
       distance_bc(tp_in | tp_on,cc)=deg2km(distance('gc',BC.Lat(cc),BC.Lat(cc),latitude(tp_in | tp_on),longitude(tp_in | tp_on)));
    end
    
    w_IDP(tp_in | tp_on,:)=repmat(M_FB_UKR(S2(ii).ID_1,:),sum(tp_in | tp_on),1);
    
    tpmf=S2(ii).ID_1==Male_Fight.Shapefile_ID1;
    per_male_fight(tp_in | tp_on)=Male_Fight.Per_Fight(tpmf);
end
NBC=height(BC);
parfor jj=1:length(oblast)
   if(isempty(oblast{jj}))
      d=zeros(length(S2),1);
      for ii=1:length(S2)
        d(ii)=min(deg2km(distance('gc',latitude(jj),longitude(jj),S2(ii).Lat,S2(ii).Lon)));
      end
      f=find(d==min(d),1);
      oblast(jj)={S2(f).NAME_1};
      raion(jj)={S2(f).NAME_2};   
      
      tfmn=strcmp(S2(f).HASC_2,Mapped_Names.HASC_2) & strcmp(S2(f).NAME_2,Mapped_Names.NAME_2);
      if(sum(tfmn)>0)
        NN=Mapped_Names.DistrictName{tfmn};
        map_raion(jj)={NN};
     end
   
        w=zeros(1,7);
        for cc=1:7
            test=Country_ID{cc};
            tob=strcmp(FB_SCI.user_loc,{['UKR' num2str(S2(f).ID_1)]});
            for ff=1:length(test)
                tfb=strcmp(FB_SCI.fr_loc,test{ff});
                tempw=FB_SCI.scaled_sci(tob & tfb);
                if(~isempty(tempw))
                    w(cc)=w(cc)+tempw;
                end
            end            
            w(cc)=w(cc)./length(test);
        end

        w=w./sum(w);
        per_Country_Desplace(jj,:)=w;    
        
        for cc=1:NBC
            distance_bc(jj,cc)=deg2km(distance('gc',BC.Lat(cc),BC.Lat(cc),latitude(jj),longitude(jj)));
        end
        
         w_IDP(jj,:)=M_FB_UKR(S2(f).ID_1,:);
    
        tpmf=S2(f).ID_1==Male_Fight.Shapefile_ID1;
        per_male_fight(jj)=Male_Fight.Per_Fight(tpmf);
   end
end

for ii=1:7
    per_Country_Desplace(isnan(per_Country_Desplace(:,ii)),ii)=mean(per_Country_Desplace(~isnan(per_Country_Desplace(:,ii)),ii));
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

Ukraine_Pop=table(longitude,latitude,population_size,oblast,raion,map_raion,per_male_fight,per_Poland,per_Slovakia,per_Hungary,per_Romania,per_Belarus,per_Moldova,per_Other,distance_bc,w_IDP);

save('Ukraine_Population_Regions.mat','Ukraine_Pop','Border_Crossing_Country');
