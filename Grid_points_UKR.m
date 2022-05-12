clear;

c=10;
d_lon=fminbnd(@(z)(integral(@(x)deg2km(distance('gc',x,32,x,32+z)),44,53)./(53-44)-c).^2,0,1);
d_lat=fminbnd(@(z)(integral(@(x)deg2km(distance('gc',48,x,48+z,x)),22,42)./(42-22)-c).^2,0,1);

latitude=44:d_lat:53;
longitude=22:d_lon:42;
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

longitude_v=longitude_v(tp_UKR);
latitude_v=latitude_v(tp_UKR);
S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);
f=zeros(length(S2),1);
for ii=1:length(S2)    
   [tp_in,tp_on]=inpolygon(longitude_v(:),latitude_v(:),S2(ii).Lon,S2(ii).Lat);
   f(ii)=sum(tp_in|tp_on);
end

g=find(f==0);
for jj=1:length(g)
    ps=polyshape(S2(g(jj)).Lat,S2(g(jj)).Lon);
    [lat_temp,lon_temp] = centroid(ps,[1:ps.NumRegions]);
    
    longitude_v=[longitude_v;lon_temp];
    latitude_v=[latitude_v;lat_temp];
end

f=zeros(length(S2),1);
for ii=1:length(S2)    
   [tp_in,tp_on]=inpolygon(longitude_v(:),latitude_v(:),S2(ii).Lon,S2(ii).Lat);
   f(ii)=sum(tp_in|tp_on);
end

save('Grid_points_UKR_Fewer.mat','longitude_v','latitude_v');


