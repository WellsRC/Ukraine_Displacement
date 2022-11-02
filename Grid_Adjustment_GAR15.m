clear;

S_GAR15=shaperead('UKR_GAR15\gar_exp_UKR.shp','UseGeoCoords',true);

GAR_Lon=[S_GAR15.Lon];
GAR_Lat=[S_GAR15.Lat];
GAR_tc=[S_GAR15.tot_val];
GAR_Pop=[S_GAR15.tot_pob];

% 
load('Grid_points_UKR_Fewer.mat','longitude_v','latitude_v');
tot_capital_pop_GAR15=zeros(length(longitude_v),2);

pop_adj=zeros(size(latitude_v));
 
for ii=1:length(GAR_tc)
    d=distance('gc',GAR_Lat(ii),GAR_Lon(ii),latitude_v,longitude_v);
    tot_capital_pop_GAR15(d==min(d),1)=tot_capital_pop_GAR15(d==min(d),1)+GAR_tc(ii)./sum(d==min(d));
    tot_capital_pop_GAR15(d==min(d),2)=tot_capital_pop_GAR15(d==min(d),2)+GAR_Pop(ii)./sum(d==min(d));
end

f_zero=find(sum(tot_capital_pop_GAR15,2)==0);
for ii=1:length(f_zero)    
    d=distance('gc',latitude_v(f_zero(ii)),longitude_v(f_zero(ii)),GAR_Lat,GAR_Lon);
    
    tot_capital_pop_GAR15(f_zero(ii),1)=tot_capital_pop_GAR15(f_zero(ii),1)+mean(GAR_tc(d==min(d)));
    tot_capital_pop_GAR15(f_zero(ii),2)=tot_capital_pop_GAR15(f_zero(ii),2)+mean(GAR_Pop(d==min(d)));
end
tot_capital_per_capita=tot_capital_pop_GAR15(:,1)./tot_capital_pop_GAR15(:,2);
save('Reduced_GAR15_UKR.mat','tot_capital_per_capita');

