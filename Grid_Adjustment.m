clear;
T=readtable('ukr_pd_2020_1km_ASCII_XYZ.csv'); % obtains the population density based on long and lat
longitude=table2array(T(:,1));
latitude=table2array(T(:,2));
population_size=table2array(T(:,3));
% 
load('Grid_points_UKR_Fewer.mat','longitude_v','latitude_v');

pop_adj=zeros(size(latitude_v));
 
for ii=1:length(longitude)
    d=distance('gc',latitude(ii),longitude(ii),latitude_v,longitude_v);
    pop_adj(d==min(d))=pop_adj(d==min(d))+population_size(ii)./sum(d==min(d));
end

save('Reduced_Pop_UKR.mat','longitude_v','latitude_v','pop_adj');

