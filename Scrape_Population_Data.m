% Constructs a table for what area each point lies in
clear;

BC=readtable('ukraine-border-crossings-080322.xlsx','Sheet','Border Crossings');
load('FB_SCI_Lookup.mat');

Male_Fight=readtable('ukr_admpop_2020_v02.xlsx','Sheet','ukr_admpop_adm1_2020');

T=readtable('ukr_pd_2020_1km_ASCII_XYZ.csv'); % obtains the population density based on long and lat
longitude=table2array(T(:,1));
latitude=table2array(T(:,2));
population_size=table2array(T(:,3));
clear T;
S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);

oblast=cell(length(longitude),1);
raion=cell(length(longitude),1);
hasc_raion=cell(length(longitude),1);

% For determining the location where individuals go
per_Country_Desplace=zeros(length(longitude),6);
per_male_fight=zeros(length(longitude),1);

distance_bc=zeros(length(longitude),5);



for ii=1:length(S2)
    [tp_in,tp_on]=inpolygon(longitude,latitude,S2(ii).Lon,S2(ii).Lat);
    oblast(tp_in | tp_on)={S2(ii).NAME_1};
    raion(tp_in | tp_on)={S2(ii).NAME_2};
    hasc_raion(tp_in | tp_on)={S2(ii).HASC_2};
    
    w=zeros(1,6);
    for cc=1:6
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
    
    for cc=1:5
       lat_BC=BC.Lat(strcmp(Country{cc},BC.Country)); 
       lon_BC=BC.Long(strcmp(Country{cc},BC.Country));
       d_temp=distance('gc',lat_BC(1),lon_BC(1),latitude(tp_in | tp_on),longitude(tp_in | tp_on));
       for kk=2:length(lon_BC)
           d_temp=min(d_temp,distance('gc',lat_BC(kk),lon_BC(kk),latitude(tp_in | tp_on),longitude(tp_in | tp_on)));
       end
       distance_bc(tp_in | tp_on,cc)=d_temp;
    end
    
    tpmf=S2(ii).ID_1==Male_Fight.Shapefile_ID1;
    per_male_fight(tp_in | tp_on)=Male_Fight.Per_Fight(tpmf);
end

parfor jj=1:length(oblast)
   if(isempty(oblast{jj}))
      d=zeros(length(S2),1);
      for ii=1:length(S2)
        d(ii)=min(distance('gc',latitude(jj),longitude(jj),S2(ii).Lat,S2(ii).Lon));
      end
      f=find(d==min(d),1);
      oblast(jj)={S2(f).NAME_1};
      raion(jj)={S2(f).NAME_2};   
      hasc_raion(jj)={S2(f).HASC_2};
   
        w=zeros(1,6);
        for cc=1:6
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
        
        for cc=1:5
           lat_BC=BC.Lat(strcmp(Country{cc},BC.Country)); 
           lon_BC=BC.Long(strcmp(Country{cc},BC.Country));
           distance_bc(jj,cc)=min(distance('gc',lat_BC,lon_BC,latitude(jj),longitude(jj)));         
        end
    
        tpmf=S2(f).ID_1==Male_Fight.Shapefile_ID1;
        per_male_fight(jj)=Male_Fight.Per_Fight(tpmf);
   end
end

for ii=1:6
    per_Country_Desplace(isnan(per_Country_Desplace(:,ii)),ii)=mean(per_Country_Desplace(~isnan(per_Country_Desplace(:,ii)),ii));
end
per_Poland=per_Country_Desplace(:,1);
per_Slovakia=per_Country_Desplace(:,2);
per_Hungary=per_Country_Desplace(:,3);
per_Romania=per_Country_Desplace(:,4);
per_Moldva=per_Country_Desplace(:,5);
per_Other=per_Country_Desplace(:,6);

db_Poland=distance_bc(:,1);
db_Slovakia=distance_bc(:,2);
db_Hungary=distance_bc(:,3);
db_Romania=distance_bc(:,4);
db_Moldva=distance_bc(:,5);


Ukraine_Pop=table(longitude,latitude,population_size,oblast,raion,hasc_raion,per_male_fight,per_Poland,per_Slovakia,per_Hungary,per_Romania,per_Moldva,per_Other,db_Poland,db_Slovakia,db_Hungary,db_Romania,db_Moldva);

save('Ukraine_Population_Regions.mat','Ukraine_Pop');
