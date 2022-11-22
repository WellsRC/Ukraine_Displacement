% parpool(3)

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

load('Calibration_Conflict_Kernel.mat');
load(['Calibration_Kernel_Conflict_Window-Conflcit_Radius_Model=' num2str(AIC_model_num) '.mat']);
day_W_fix=day_W_fix(fval==min(fval));
RC=RC(fval==min(fval));
load('Macro_Oblast_Map.mat','Macro_Map');


L=zeros(16,1);
k=zeros(16,1);
for model_num=1:16
    load(['Mapping_IDP_MLE_Model=' num2str(model_num-1) '.mat'],'par_V','L_V_Mapping');
    L(model_num)=L_V_Mapping;
    k(model_num)=length(par_V);
end


aics=aicbic(L,k);

daics=aics-min(aics);

AIC_model_IDP=find(daics==0)-1;

load('MCMC_Sample_Forcible_Displacement_Parameters.mat','Parameter_Samp','L_V_Samp');

NS=length(L_V_Samp)/4;
Parameter_Samp_IDP=zeros(length(L_V_Samp),k(daics==0));
L_V_Samp_IDP=zeros(size(L_V_Samp));

[LB,UB]=ParameterBounds_Mapping_IDP(AIC_model_IDP);
options = optimoptions('surrogateopt','PlotFcn',[],'UseParallel',false);
for ii=(2.*NS+1):3.*NS
    [Parameter,STDEV_Displace]=Parameter_Return(Parameter_Samp(ii,:),RC,Time_Switch,day_W_fix,AIC_model_num);

    [Pop_Displace,~,Pop_Refugee]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Time_Sim,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,Pop_SES);
    Daily_IDP_Origin=Parameter.w_IDP.*squeeze(sum(Pop_Displace,[1 3])); % Need to examine the new idp only
    [Parameter_Samp_IDP(ii,:),fval]=surrogateopt(@(x)ObjectiveFunction_IDP(x,Daily_IDP_Origin,Mapping_Data,IDP_Displacement,Time_Sim,Parameter,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Macro_Map,AIC_model_IDP),LB,UB,options);
    L_V_Samp_IDP(ii)=-fval;    
end

save('MCMC_Sample_IDP_Mapping_Parameters_3.mat','Parameter_Samp_IDP','L_V_Samp_IDP');