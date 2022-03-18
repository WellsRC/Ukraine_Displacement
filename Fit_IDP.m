clear;
clc;

LoadData;

T=readtable('idp_estimation_08_03_2022-unhcr-protection-cluster.xlsx','Sheet','Dataset');

date_IDP=datenum('March 8, 2022');

Lat_IDP=T.YLatitude;
Lon_IDP=T.XLongitude;
Num_IDP=T.IDPEstimation;

vLat_C=vLat_C{Date_Displacement<=date_IDP};
vLon_C=vLon_C{Date_Displacement<=date_IDP};

S1=shaperead('UKR_ADM_1\UKR_adm1.shp','UseGeoCoords',true);
Site_Oblast=zeros(length(Lon_IDP),1);
Pop_Oblast=zeros(length(Lon_P),1);

for ii=1:length(S1)
    tf=strcmp(Ukraine_Pop.oblast,S1(ii).NAME_1);
    Pop_Oblast(tf)=ii;
    [p_in]=inpolygon(Lon_IDP,Lat_IDP,S1(ii).Lon,S1(ii).Lat);
    Site_Oblast(p_in)=ii;
end

for ii=1:length(Site_Oblast)
    if(Site_Oblast(ii)==0)
        dob=zeros(length(S1),1);
        for jj=1:length(S1)
           dob=deg2km(distance('gc', 
        end
    end
end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Run Fitting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x0 = [-4 5 -4 5 -4 5];
lb=[-6  0 -6 0 -6];
ub=[0 10 0 10 0 10];

options = optimoptions(@lsqnonlin,'FunctionTolerance',10^(-16),'MaxFunctionEvaluations',500,'MaxIterations',1000);
[par,fval] = lsqnonlin(@(x)ObjectiveFunction_IDP(x,vLat_C,vLon_C,Lat_P,Lon_P,Pop_Remain,Lat_R,Lon_R,Num_IDP),x0,lb,ub,options);

Parameter_IDP.ScaleSite=10.^par(1);
Parameter_IDP.BreadthSite=10.^par(2);

Parameter_IDP.ScaleDistance=10.^par(3);
Parameter_IDP.ScaleDistance=10.^par(4);

Parameter_IDP.ScaleConflict=10.^par(5);
Parameter_IDP.ScaleConflict=10.^par(6);

save('Kernel_Paremeter_IDP.mat','Parameter_IDP');