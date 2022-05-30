clear;

UKR_Mortality=readtable('Mortality_UKR_Eng_Ref_Col.csv');
DB_UKR=readtable('Disease_UKR_National.xlsx');

tf=~strcmp(UKR_Mortality.search_name,'');
UKR_Mortality=UKR_Mortality(tf,:);
load('Ukraine_Population_Regions.mat');

SFN=unique(Ukraine_Pop.map_raion);

tf=zeros(height(UKR_Mortality),1);

tf=logical(tf);

for ii=1:length(SFN)
    tf= tf | strcmp(SFN{ii},UKR_Mortality.raj_name);
end


UKR_Mortality=UKR_Mortality(tf,:);

save('UKR_Disease_Burden.mat','UKR_Mortality','DB_UKR');