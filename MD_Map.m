clear;

rng shuffle;
load('Load_Data_MCMC_Mapping.mat');
% S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);
% Shapefile_Raion_Name={S2.NAME_2};
% Shapefile_Raion_Oblast_Name={S2.NAME_1};
% S1=shaperead('UKR_ADM_1\UKR_adm1.shp','UseGeoCoords',true);
% Shapefile_Oblast_Name={S1.NAME_1};
% save('Load_Data_MCMC_Mapping.mat');
load('MCMC_out-k=2821.mat','L_V','Parameter_V')


Parameter_V=Parameter_V(L_V<0,:);
L_V=L_V(L_V<0);
Parameter_V=Parameter_V(end-9999:end,:);
L_V=L_V(end-9999:end);


NS=250;

[LB,UB]=ParameterBounds_Mapping;
par_V=zeros(NS,length(LB));
L_V_Mapping=zeros(NS,1);

load('Macro_Oblast_Map.mat','Macro_Map');
x=[1.28002277839657,2.80219780031663,4.20104005286396,0.0753034566282208,2.61146699502349,0.0403068705232432,4,0.9373,0.9897,0.6227,0.2502,5.7];

options = optimoptions('surrogateopt','PlotFcn',[],'MaxFunctionEvaluations',250,'InitialPoints',x,'UseParallel',false);

ccf=0;
while(isfile(['Mapping_Refugee_IDP_' num2str(ccf) '.mat']))
    ccf=ccf+1;
end


rr=randi(10^4,NS,1);
Parameter_Samp=Parameter_V(rr,:);
L_V_Samp=L_V(rr);

for ss=1:NS
    save(['Mapping_Refugee_IDP_' num2str(ccf) '.mat'],'par_V','L_V_Mapping','L_V_Samp','Parameter_Samp');
    [Parameter,STDEV_Displace]=Parameter_Return(Parameter_V(rr(ss),:),RC,Time_Switch,day_W_fix);

    [Pop_Displace,~,Pop_Refugee]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Time_Sim,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,ML_Indx);
    Daily_Refugee=squeeze(sum(Pop_Refugee,[1 3]));
    Daily_IDP_Origin=Parameter.w_IDP.*squeeze(sum(Pop_Displace,[1 3])); % Need to examine the new idp only
    
    [par_V(ss,:),fval]=surrogateopt(@(x)ObjectiveFunction_IDP_Refugee(x,Daily_Refugee,Daily_IDP_Origin,Mapping_Data,Refugee_Displacement,IDP_Displacement,Time_Sim,Parameter,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Macro_Map),LB,UB,options);
    L_V_Mapping(ss)=-fval;
end

save(['Mapping_Refugee_IDP_' num2str(ccf) '.mat'],'par_V','L_V_Mapping','L_V_Samp','Parameter_Samp');