clear;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% Displacement data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
T=readtable('UNHCR_UKR_Date.csv');
T=T(1:2,:);
Date_Displacement=datenum(T.data_date);
Number_Displacement=T.individuals;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% Conflict data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
T=readtable('2019-02-26-2022-03-03-Ukraine.csv');

vLat_C=cell(length(Date_Displacement),1);
vLon_C=cell(length(Date_Displacement),1);

Date_Conflict=zeros(height(T),1);
for ii=1:length(Date_Conflict)
    Date_Conflict(ii)=datenum(T.event_date(ii));
end

for ii=1:length(Date_Displacement)
   f=find(Date_Conflict==Date_Displacement(ii));
   vLat_C{ii}=T.latitude(f);
   vLon_C{ii}=T.longitude(f);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Population Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load('Ukraine_Population_Regions.mat','Ukraine_Pop');
Lat_P=Ukraine_Pop.latitude;
Lon_P=Ukraine_Pop.longitude;
Pop=Ukraine_Pop.population_size;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Run Fitting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x0 = [0.02,0.02];
lb=[0 0];
ub=[0.1 0.1];
options = optimoptions(@lsqnonlin,'FunctionTolerance',10^(-16),'MaxFunctionEvaluations',500,'MaxIterations',1000);
[par,fval] = lsqnonlin(@(x)ObjectiveFunction(x,vLat_C,vLon_C,Lat_P,Lon_P,Pop,Number_Displacement),x0,lb,ub,options);

Parameter.Scale=par(1);
Parameter.Breadth=par(2);

save('Kernel_Paremeter.mat','Parameter');