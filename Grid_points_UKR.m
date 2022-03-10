clear;

latitude=linspace(44,53,1001);
longitude=linspace(22,42,1001);
[longitude_v,latitude_v]=meshgrid(longitude,latitude);

S1=shaperead('UKR_ADM_1\UKR_adm1.shp','UseGeoCoords',true);

for ii=1:length(S1)
   [tp_in,tp_on]=inpolygon(longitude_v(:),latitude_v(:),S1(ii).Lon,S1(ii).Lat);
   if(ii==1)
      tp_UKR=tp_in|tp_on;
   else
      tp_UKR=tp_UKR|tp_in|tp_on; 
   end
end

save('Grid_points_UKR.mat','latitude','longitude','tp_UKR');