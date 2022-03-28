clear;
clc;

load('IDP_Fit_Inputs.mat','Pop_Raion','Pop_Moving_R','SCI_IDP','Raion_IDPSites','Raion_Conflict','DistC','Dist','Raion_IDP','Raion_Index','Raion_Dist_BC','Num_BC');

Mapped_Names=readtable('mapped_data.csv');


S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);

Mapped_Raion_Name=cell(length(Pop_Moving_R),1);
parfor ii=1:length(Mapped_Raion_Name)
    tfmn=strcmp(S2(Raion_Index(ii)).HASC_2,Mapped_Names.HASC_2) & strcmp(S2(Raion_Index(ii)).NAME_2,Mapped_Names.NAME_2);
    if(sum(tfmn)>0)
        NN=Mapped_Names.DistrictName{tfmn};
        Mapped_Raion_Name(ii)={NN};
    else
        Mapped_Raion_Name(ii)={'N/A'};
    end
end
load('Reduced_Grid_Popultaion_Total_UKR.mat','Pop_Total_R','Pop_Remain_R');
T=readtable('idp_estimation_08_03_2022-unhcr-protection-cluster.xlsx','Sheet','Dataset');



Lat_IDP=T.YLatitude;
Lon_IDP=T.XLongitude;
Zone=T.IDPLocationCluster;

clear Mapped_Names;


Raion_Zone_R=zeros(length(S2),1);
for ii=1:length(S2)
    if(Raion_IDP(ii)>0)
        [p_in]=inpolygon(Lon_IDP,Lat_IDP,S2(ii).Lon,S2(ii).Lat);
        if(sum(p_in)>0)
            Raion_Zone_R(ii)=median(Zone(p_in));
        end
        if((Raion_IDP(ii)>0) && (Raion_Zone_R(ii)==0))
           d=zeros(length( Lon_IDP));
           parfor jj=1:length(d)
               d(jj)=min(deg2km(distance('gc',Lon_IDP(jj),Lat_IDP(jj),S2(ii).Lon,S2(ii).Lat)));
           end
           Raion_Zone_R(ii)=median(Zone(d==min(d)));
        end
    end
end

Raion_Zone_Full=Raion_Zone_R(Raion_Index);

Pop_Non_IDP=Pop_Remain_R-Pop_Moving_R;

load('Kernel_Paremeter_IDP_Non_Zero_Raion.mat','Parameter_IDP');

[Total_Burden_IDP] = Disease_Burden_Displacement_IDP(Pop_Non_IDP,Pop_Moving_R,Pop_Total_R,Mapped_Raion_Name,Parameter_IDP,SCI_IDP(Raion_IDP>0,:),Raion_IDPSites(Raion_IDP>0),Raion_Dist_BC(Raion_IDP>0,:),Num_BC(Raion_IDP>0),Raion_Conflict(Raion_IDP>0),DistC(Raion_IDP>0,:),Dist(Raion_IDP>0,:),Pop_Raion(Raion_IDP>0),Raion_Zone_R(Raion_IDP>0),Raion_Zone_Full);