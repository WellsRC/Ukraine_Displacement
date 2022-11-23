clear;
close all;

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


load('Calibration_Conflict_Kernel.mat');
load(['Calibration_Kernel_Conflict_Window-Conflcit_Radius_Model=' num2str(AIC_model_num) '.mat']);
day_W_fix=day_W_fix(fval==min(fval));
RC=RC(fval==min(fval));


load('Load_Data_Mapping.mat');
load('Macro_Oblast_Map.mat','Macro_Map');

load('Merge_Parameter_Uncertainty.mat','Par_FD','Par_Map_IDP','Par_Map_Ref','L_T','Model_IDP','Model_Refugee');


NS=length(Par_KD(:,1));

Dist_Refugee=zeros(NS,8);
Dist_IDP=zeros(NS,7);



for ii=1:NS


    
[Parameter_Map_Refugee,Refugee_Mv]=Parameter_Return_Mapping_Refugee(Par_Map_Ref(ii,:),Model_Refugee);
w_tot_ref=Determine_Weights_Refugee(Parameter_Map_Refugee,Mapping_Data,Refugee_Mv);


[Parameter_Map_IDP,IDP_Mv]=Parameter_Return_Mapping_IDP(Par_Map_IDP(ii,:),Model_IDP);
w_tot_idp=Determine_Weights_IDP(Parameter_Map_IDP,Mapping_Data,IDP_Mv);



[Parameter,STDEV_Displace]=Parameter_Return(Par_FD(ii,:),RC,Time_Switch,day_W_fix,AIC_model_num);
    
[Pop_Displace,Pop_IDP,Pop_Refugee]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Time_Sim,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,Pop_SES);

Daily_Refugee=squeeze(sum(Pop_Refugee,[1 3]));
Daily_IDP_Origin=Parameter.w_IDP.*squeeze(sum(Pop_Displace,[1 3])); % Need to examine the new idp only


[Est_Daily_Refugee]=Country_Refuge_Displaced(w_tot_ref,Daily_Refugee);
[Est_Daily_IDP]=IDP_Refuge_Displaced(w_tot_idp,Daily_IDP_Origin,Time_Sim,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Parameter,Macro_Map);

Dist_Refugee(ii,:)=[Est_Daily_Refugee.Poland(end-1) Est_Daily_Refugee.Slovakia(end-1) Est_Daily_Refugee.Hungary(end-1) Est_Daily_Refugee.Moldova(end-1) Est_Daily_Refugee.Romania(end-1) Est_Daily_Refugee.Belarus(end-1) Est_Daily_Refugee.Russia(end-1) Est_Daily_Refugee.Europe_Other(end-1)];

end

save('Refugee_Uncertainty_Mapping.mat');