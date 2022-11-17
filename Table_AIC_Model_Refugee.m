clear;


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


Data_O=[Refugee_Displacement.Cumulative_Poland(end) Refugee_Displacement.Cumulative_Slovakia(end) Refugee_Displacement.Cumulative_Hungary(end) Refugee_Displacement.Cumulative_Romania(end) Refugee_Displacement.Cumulative_Belarus(end) Refugee_Displacement.Cumulative_Moldova(end)  Refugee_Displacement.Cumulative_Russia(end)];
Data_O=Data_O./sum(Number_Displacement.Refugee);
Data_O=round([Data_O 1-sum(Data_O)],4);
[Parameter,STDEV_Displace]=Parameter_Return(Parameter_V,RC,Time_Switch,day_W_fix,AIC_model_num);

[Pop_Displace,~,Pop_Refugee]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Time_Sim,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,Pop_SES);
Daily_Refugee=squeeze(sum(Pop_Refugee,[1 3]));
Daily_IDP_Origin=Parameter.w_IDP.*squeeze(sum(Pop_Displace,[1 3])); % Need to examine the new idp only

L=zeros(32,1);
k=zeros(32,1);
Poland=zeros(32,1);
Slovakia=zeros(32,1);
Hungary=zeros(32,1);
Romania=zeros(32,1);
Belarus=zeros(32,1);
Moldova=zeros(32,1);
Russia=zeros(32,1);
Europe=zeros(32,1);

Model_BN=zeros(32,5);

for ii=0:31
    
    load(['Mapping_Refugee_MLE_Model=' num2str(ii) '.mat'],'par_V','L_V_Mapping');
    if(~isempty(L_V_Mapping))
        L(ii+1)=L_V_Mapping;
        k(ii+1)=length(par_V);
        
        [Parameter_Map_Refugee,Refugee_Mv]=Parameter_Return_Mapping_Refugee(par_V,ii);

        w_tot_ref=Determine_Weights_Refugee(Parameter_Map_Refugee,Mapping_Data,Refugee_Mv);


        [Est_Daily_Refugee]=Country_Refuge_Displaced(w_tot_ref,Daily_Refugee);
        Tot_temp=sum(Est_Daily_Refugee.Poland)+sum(Est_Daily_Refugee.Slovakia)+sum(Est_Daily_Refugee.Hungary)+sum(Est_Daily_Refugee.Romania)+sum(Est_Daily_Refugee.Belarus)+sum(Est_Daily_Refugee.Moldova)+sum(Est_Daily_Refugee.Russia)+sum(Est_Daily_Refugee.Europe_Other);
        Poland(ii+1)=round(sum(Est_Daily_Refugee.Poland)./Tot_temp,4)-Data_O(1);
        Slovakia(ii+1)=round(sum(Est_Daily_Refugee.Slovakia)./Tot_temp,4)-Data_O(2);
        Hungary(ii+1)=round(sum(Est_Daily_Refugee.Hungary)./Tot_temp,4)-Data_O(3);
        Romania(ii+1)=round(sum(Est_Daily_Refugee.Romania)./Tot_temp,4)-Data_O(4);
        Belarus(ii+1)=round(sum(Est_Daily_Refugee.Belarus)./Tot_temp,4)-Data_O(5);
        Moldova(ii+1)=round(sum(Est_Daily_Refugee.Moldova)./Tot_temp,4)-Data_O(6);
        Russia(ii+1)=round(sum(Est_Daily_Refugee.Russia)./Tot_temp,4)-Data_O(7);
        Europe(ii+1)=round(sum(Est_Daily_Refugee.Europe_Other)./Tot_temp,4)-Data_O(8);
    else
        L(ii+1)=-Inf;
        k(ii+1)=1;
    end
    
    
    temp=de2bi(ii);
    Model_BN(ii+1,1:length(temp))=temp;
end

aics=aicbic(L,k);

daics=round(aics-min(aics),2);

w=exp(-daics./2)./sum(exp(-daics./2));

MC=(w')*Model_BN;

T=table(Model_BN,Poland,Slovakia,Hungary,Romania,Belarus,Moldova,Russia,Europe,daics);

writetable(T,'AIC_Refugee_Map.csv');

