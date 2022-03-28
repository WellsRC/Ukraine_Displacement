clear;
clc;

LoadData;


T=readtable('idp_estimation_08_03_2022-unhcr-protection-cluster.xlsx','Sheet','Dataset');

date_IDP=datenum('March 8, 2022');

Lat_IDP=T.YLatitude;
Lon_IDP=T.XLongitude;
Num_IDP=T.IDPEstimation;

% Need to trim the conflict based on the observed time of IDP
vLat_C=vLat_C(Date_Displacement<=date_IDP);
vLon_C=vLon_C(Date_Displacement<=date_IDP);

S1=shaperead('UKR_ADM_1\UKR_adm1.shp','UseGeoCoords',true);

S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);

Raion_IDP=zeros(length(S2),1);
for ii=1:length(S2)
    [p_in]=inpolygon(Lon_IDP,Lat_IDP,S2(ii).Lon,S2(ii).Lat);
    Raion_IDP(p_in)=sum(Num_IDP(p_in));
    Num_IDP(p_in)=0;
end

for ii=1:length(Num_IDP)
    if(Num_IDP(ii)>0)
        dob=zeros(length(S2),1);
        for jj=1:length(S2)
           dob(jj)=min(deg2km(distance('gc',Lon_IDP(ii),Lat_IDP(ii),S2(jj).Lon,S2(jj).Lat)));
        end
        Raion_IDP(dob==min(dob))=Num_IDP(ii)./sum(dob==min(dob));
        Raion_index(ii)=find(dob==min(dob),1);
    end
end
    

load('Grid_points_UKR_Fewer.mat');
load('FB_UKR_UKR.mat','M_FB_UKR');

[longitude_v,latitude_v]=meshgrid(longitude,latitude);
 longitude_v=longitude_v(:);
 latitude_v=latitude_v(:);
 
 SCI_IDP=zeros(length(latitude_v),1);
 
Raion_index=ones(length(latitude_v),1);
 for ii=1:27     
    [p_in,p_on]=inpolygon(longitude_v,latitude_v,S1(ii).Lon,S1(ii).Lat);
    SCI_IDP(p_in|p_on)=repmat(median(M_FB_UKR(:,ii)),sum(p_in|p_on),1);
 end
 
 for ii=1:length(S2)
    [p_in]=inpolygon(longitude_v,latitude_v,S2(ii).Lon,S2(ii).Lat);
    Raion_index(p_in)=ii;
 end

 for ii=1:length(Raion_index)
    if((Raion_index(ii)==0)&& tp_UKR)
        dob=zeros(length(S2),1);
        for jj=1:length(S2)
           dob(jj)=min(deg2km(distance('gc',longitude_v(ii),latitude_v(ii),S2(jj).Lon,S2(jj).Lat)));
        end
        Raion_index(ii)=find(dob==min(dob),1);
    end
end

Dmin_Conf=zeros(size(longitude_v));
parfor ii=1:length(latitude_v)
    Dmin_Conf(ii)=min(deg2km(distance('gc',cell2mat(vLat_C),cell2mat(vLon_C),latitude_v(ii),longitude_v(ii))));
end

clearvars -except vLat_C vLon_C latitude_v longitude_v Pop_Moving_R Lat_IDP Lon_IDP SCI_IDP Site_Oblast Num_IDP Raion_index Raion_IDP Dmin_Conf
 
D_IDP=zeros(size(SCI_IDP));

parfor ii=1:length(D_IDP)
    D_IDP(ii) = min(deg2km(distance('gc',Lat_IDP,Lon_IDP,latitude_v(ii),longitude_v(ii))));
end

load('Kernel_Paremeter_IDP.mat','Parameter_IDP');

    [w_Location]=Estimate_IDP_Displacement(Parameter_IDP,SCI_IDP,D_IDP,Dmin_Conf);
S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);
figure('units','normalized','outerposition',[0. 0. 1 1]);
contourf(unique(longitude_v),unique(latitude_v),reshape(w_Location,501,501),'LineStyle','none');
hold on
geoshow(S2,'FaceColor','none','LineWidth',1.5);

