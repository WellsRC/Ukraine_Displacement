clear;
clc;

LoadData;

load('Kernel_Paremeter.mat','Parameter');

[Pop_Displace_Day,Pop_Displace]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Lat_P,Lon_P,Pop,false);

Displace_Pop=sum(Pop_Displace,2);
Pop_Remain=Pop-Displace_Pop;

clearvars -except Pop_Remain Pop_Male;

load('Grid_points_UKR_Fewer.mat')

[longitude_v,latitude_v]=meshgrid(longitude,latitude);
longitude_v=longitude_v(tp_UKR);
latitude_v=latitude_v(tp_UKR);

load('Ukraine_Population_Regions.mat','Ukraine_Pop');
Lat_P=Ukraine_Pop.latitude;
Lon_P=Ukraine_Pop.longitude;
Pop_Total=Ukraine_Pop.population_size;

clear Ukraine_Pop;

f_nz=find(Pop_Total>0);

Pop_Male_R=zeros(size(latitude_v));
Pop_Remain_R=zeros(size(latitude_v));
Pop_Total_R=zeros(size(latitude_v));
for ii=1:length(f_nz)
   d=deg2km(distance('gc',Lon_P(f_nz(ii)),Lat_P(f_nz(ii)),longitude_v,latitude_v));
   Pop_Remain_R(d==min(d))=Pop_Remain_R(d==min(d))+Pop_Remain(f_nz(ii))./sum((d==min(d)));
   Pop_Male_R(d==min(d))=Pop_Male_R(d==min(d))+Pop_Male(f_nz(ii))./sum((d==min(d)));
   Pop_Total_R(d==min(d))=Pop_Total_R(d==min(d))+Pop_Total(f_nz(ii))./sum((d==min(d)));
end

save('Reduced_Grid_Popultaion_Total_UKR.mat','Pop_Remain_R','Pop_Total_R','Pop_Male_R');