clear;

% load('Calibration_Conflict_Kernel.mat','Time_Sim','vLat_C','vLon_C');
% [Mapping_Data,Refugee_Displacement,IDP_Displacement]=LoadData_Destination(Time_Sim,vLat_C,vLon_C);
% S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);
% Shapefile_Raion_Name={S2.NAME_2};
% Shapefile_Raion_Oblast_Name={S2.NAME_1};
% S1=shaperead('UKR_ADM_1\UKR_adm1.shp','UseGeoCoords',true);
% Shapefile_Oblast_Name={S1.NAME_1};
% save('Load_Data_Mapping.mat');

L=zeros(8,1);
k=zeros(8,1);
for ii=1:8
    load(['Calibration_Kernel_Conflict_Window-Conflcit_Radius_Model=' num2str(ii) '.mat']);
    L(ii)=-min(fval);
    k(ii)=length(x0(1,:));
end
aics=aicbic(L,k);

daics=aics-min(aics);

AIC_model_num=find(daics==0);

load('Load_Data_Mapping.mat');
% S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);
% Shapefile_Raion_Name={S2.NAME_2};
% Shapefile_Raion_Oblast_Name={S2.NAME_1};
% S1=shaperead('UKR_ADM_1\UKR_adm1.shp','UseGeoCoords',true);
% Shapefile_Oblast_Name={S1.NAME_1};
% save('Load_Data_MCMC_Mapping.mat');

load('Calibration_Conflict_Kernel.mat');
load(['Calibration_Kernel_Conflict_Window-Conflcit_Radius_Model=' num2str(AIC_model_num) '.mat']);
day_W_fix=day_W_fix(fval==min(fval));
RC=RC(fval==min(fval));
Parameter_V=x0(fval==min(fval),:);
load('Macro_Oblast_Map.mat','Macro_Map');

for model_num=1:16
    [LB,UB]=ParameterBounds_Mapping_IDP(model_num-1);
    options = optimoptions('surrogateopt','PlotFcn',[],'MaxFunctionEvaluations',1500,'UseParallel',false);

    [Parameter,STDEV_Displace]=Parameter_Return(Parameter_V,RC,Time_Switch,day_W_fix,AIC_model_num);

    [Pop_Displace,~,Pop_Refugee]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Time_Sim,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,Pop_SES);
    Daily_Refugee=squeeze(sum(Pop_Refugee,[1 3]));
    Daily_IDP_Origin=Parameter.w_IDP.*squeeze(sum(Pop_Displace,[1 3])); % Need to examine the new idp only
    [par_V,fval]=surrogateopt(@(x)ObjectiveFunction_IDP(x,Daily_IDP_Origin,Mapping_Data,IDP_Displacement,Time_Sim,Parameter,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Macro_Map,model_num-1),LB,UB,options);
    L_V_Mapping=-fval;
    save(['Mapping_IDP_MLE_Model=' num2str(model_num-1) '.mat'],'par_V','L_V_Mapping');
end