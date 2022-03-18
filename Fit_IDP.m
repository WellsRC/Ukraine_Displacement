clear;
clc;

LoadData;

load('Kernel_Paremeter.mat','Parameter');

[Pop_Displace_Day,Pop_Displace]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Lat_P,Lon_P,Pop,false);

Displace_Pop=sum(Pop_Displace,2);
Pop_Remain=Pop-Displace_Pop;

T=readtable('idp_estimation_08_03_2022-unhcr-protection-cluster.xlsx','Sheet','Dataset');

date_IDP=datenum('March 8, 2022');

Lat_IDP=T.YLatitude;
Lon_IDP=T.XLongitude;
Num_IDP=T.IDPEstimation;

% Need to trim the conflict based on the observed time of IDP
vLat_C=vLat_C{Date_Displacement<=date_IDP};
vLon_C=vLon_C{Date_Displacement<=date_IDP};

S1=shaperead('UKR_ADM_1\UKR_adm1.shp','UseGeoCoords',true);
Site_Oblast=zeros(length(Lon_IDP),1);

for ii=1:length(S1)
    tf=strcmp(Ukraine_Pop.oblast,S1(ii).NAME_1);
    [p_in]=inpolygon(Lon_IDP,Lat_IDP,S1(ii).Lon,S1(ii).Lat);
    Site_Oblast(p_in)=ii;
end

for ii=1:length(Site_Oblast)
    if(Site_Oblast(ii)==0)
        dob=zeros(length(S1),1);
        for jj=1:length(S1)
           dob(jj)=min(deg2km(distance('gc',Lon_IDP(ii),Lat_IDP(ii),S1(jj).Lon,S1(jj).Lat)));
        end
        Site_Oblast(ii)=find(dob==min(dob),1);
    end
end

SCI_IDP=Ukraine_Pop.w_IDP;
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Run Fitting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x0 = [-4 5 -4 5 -4 5];
lb=[-6  0 -6 0 -6];
ub=[0 10 0 10 0 10];

options = optimoptions(@lsqnonlin,'FunctionTolerance',10^(-16),'MaxFunctionEvaluations',500,'MaxIterations',1000);
[par,fval] = lsqnonlin(@(x)ObjectiveFunction_IDP(x,Parameter,vLat_C,vLon_C,Lat_P,Lon_P,Pop_Remain,Lat_IDP,Lon_IDP,SCI_IDP,Site_Oblast,Num_IDP),x0,lb,ub,options);

Parameter_IDP.ScaleSite=10.^par(1);
Parameter_IDP.BreadthSite=10.^par(2);

Parameter_IDP.ScaleDistance=10.^par(3);
Parameter_IDP.ScaleDistance=10.^par(4);

Parameter_IDP.ScaleConflict=10.^par(5);
Parameter_IDP.ScaleConflict=10.^par(6);

save('Kernel_Paremeter_IDP.mat','Parameter_IDP');