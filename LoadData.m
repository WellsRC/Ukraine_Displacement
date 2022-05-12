% Script to laod the data used i nthe Fitting

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% Displacement data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
T=readtable('UNHCR_UKR_Date.csv');
Date_Displacement=datenum(T.data_date);
Number_Displacement=T.daily_individuals;

Number_Displacement=Number_Displacement(Date_Displacement<=datenum('March 11, 2022'));
Date_Displacement=Date_Displacement(Date_Displacement<=datenum('March 11, 2022'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% Conflict data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
T=readtable('2022-01-01-2022-03-17-Ukraine.csv');

ET=T.event_type;

tf=~strcmp(ET,'Protests');

T=T(tf,:);

DT=datenum(T.event_date);

T=T(DT>=datenum('February 24, 2022'),:);

vLat_C=cell(length(Date_Displacement),1);
vLon_C=cell(length(Date_Displacement),1);

Date_Conflict=zeros(height(T),1);
for ii=1:length(Date_Conflict)
    Date_Conflict(ii)=datenum(T.event_date(ii));
end

for ii=1:length(Date_Displacement)
   f=find(Date_Conflict==Date_Displacement(ii));
   vLat_C{ii}=T.latitude(f);
   vLon_C{ii}=T.longitude(f);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Population Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load('Ukraine_Population_Reduced.mat','Ukraine_Pop','Border_Crossing_Country');
Lat_P=Ukraine_Pop.latitude_v;
Lon_P=Ukraine_Pop.longitude_v;
Pop=Ukraine_Pop.pop_adj.*(1-sum(Ukraine_Pop.age_Dist_male(:,5:12),2)); % considering only those who can leave under martial law
Pop_Male=Ukraine_Pop.pop_adj-Pop;

