clear;
clc;
H=shaperead('Health/hotosm_ukr_health_facilities_points.shp','UseGeoCoords',true);

N={H.amenity};
tfh=strcmp(N,'hospital')|strcmp(N,'cancer');
H=H(tfh);

HLon=[H.Lon];
HLat=[H.Lat];

S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);

load('Input_Figure3B.mat');



Disease_Short={'TB';'TB_DR';'HIV';'HIV_T';'Diabetes';'Cancer';'CVD'};
Pre_WAR_Disease=zeros(3,length(Disease_Short)+1);

WAR_Disease=zeros(3,length(Disease_Short)+1);
TempC=Total_Burden_IDP.Cases;

for dd=0:length(Disease_Short)
    if(dd>0)
        temp=Disease_Distribution(Disease_Short{dd},Mapped_Raion_Name,false,Pop_Total_R)+Disease_Distribution(Disease_Short{dd},Mapped_Raion_Name,true,Pop_Total_R);
    else
        temp=Pop_Total_R;
    end
    for ii=1:3
        Pre_WAR_Disease(ii,dd+1)=sum(temp(Raion_Zone_Full==ii));
        WAR_Disease(ii,dd+1)=sum(TempC([1:3]+3.*(ii-1)+9.*dd));
    end
   
end
% 
 S2=S2(Raion_IDP>0);
 Raion_Zone_R=Raion_Zone_R(Raion_IDP>0);
Raion_Hosp=zeros(length(S2),1);
parfor ii=1:length(Raion_Hosp)
   [p_in,p_on]=inpolygon(HLon,HLat,S2(ii).Lon,S2(ii).Lat);
   Raion_Hosp(ii)=sum(p_in)+sum(p_on);
end

Hosp_Zone=zeros(3,1);
for ii=1:3
    Hosp_Zone(ii,1)=sum(Raion_Hosp(Raion_Zone_R==ii));
end


