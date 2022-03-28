function [P,Ps,Pm]=Min_Distance_Conflict(Lat_C,Lon_C,latitude_v,longitude_v)

d=zeros(size(latitude_v));
ds=zeros(size(latitude_v));
dm=zeros(size(latitude_v));

parfor ii=1:length(latitude_v)
    d(ii)=min(deg2km(distance('gc',Lat_C,Lon_C,latitude_v(ii),longitude_v(ii))));
    ds(ii)=mean(deg2km(distance('gc',Lat_C,Lon_C,latitude_v(ii),longitude_v(ii))))
    dm(ii)=median(deg2km(distance('gc',Lat_C,Lon_C,latitude_v(ii),longitude_v(ii))))
end

P=d./sum(d);
Ps=ds./sum(ds);
Pm=dm./sum(dm);
end