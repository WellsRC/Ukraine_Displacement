% Constructs a table for what area each point lies in
clear;

T=readtable('ukr_pd_2020_1km_ASCII_XYZ.csv'); % obtains the population density based on long and lat
longitude=table2array(T(:,1));
latitude=table2array(T(:,2));
population_size=table2array(T(:,3));
clear T;
S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);

oblast=cell(length(longitude),1);
raion=cell(length(longitude),1);

for ii=1:length(S2)
    [tp_in,tp_on]=inpolygon(longitude,latitude,S2(ii).Lon,S2(ii).Lat);
    oblast(tp_in | tp_on)={S2(ii).NAME_1};
    raion(tp_in | tp_on)={S2(ii).NAME_2};
end

for jj=1:length(oblast)
   if(isempty(oblast{jj}))
      d=zeros(length(S2),1);
      for ii=1:length(S2)
        d(ii)=min(distance('gc',latitude(jj),longitude(jj),S2(ii).Lat,S2(ii).Lon));
      end
      f=find(d==min(d),1);
      oblast(jj)={S2(f).NAME_1};
      raion(jj)={S2(f).NAME_2};
   end
end
Ukraine_Pop=table(longitude,latitude,population_size,oblast,raion,per_male,per_Poland,per_Belarus,per_Slovakia,per_Hungary,per_Romania,per_Moldva,per_Other);

save('Ukraine_Population_Regions.mat','Ukraine_Pop');
