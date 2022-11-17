parpool(16)

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

for model_num=1:32
    [LB,UB]=ParameterBounds_Mapping_Refugee(model_num-1);
    if(model_num==1)
        options = optimoptions('surrogateopt','PlotFcn',[],'MaxFunctionEvaluations',5000,'UseParallel',true);
    else
        Refugee_Mv=zeros(1,5);
        temp=de2bi(model_num-1);
        Refugee_Mv(1:length(temp))=temp;
        temp_c=2^sum(Refugee_Mv);
        f_temp=zeros(temp_c-1,2);
        par_X0=cell(temp_c-1,1);
        for jj=1:temp_c-1
            MdX0=Refugee_Mv;
            tempv=zeros(1,sum(Refugee_Mv));
            temp=de2bi(jj-1);
            tempv(1:length(temp))=temp;
            MdX0(MdX0>0)=tempv;
            load(['Mapping_Refugee_MLE_Model=' num2str(bi2de(MdX0)) '.mat'],'L_V_Mapping','par_V');
            f_temp(jj,1)=bi2de(MdX0);
            f_temp(jj,2)=L_V_Mapping;
            par_X0{jj}=par_V;
        end
        findx=find(f_temp(:,2)==max(f_temp(:,2)), 1, 'last' );
        X0=Initialize_Model_Refugee(par_X0{findx},f_temp(findx,1),model_num-1);
        options = optimoptions('surrogateopt','PlotFcn',[],'MaxFunctionEvaluations',5000,'UseParallel',true,'InitialPoints',X0);
    end

    [Parameter,STDEV_Displace]=Parameter_Return(Parameter_V,RC,Time_Switch,day_W_fix,AIC_model_num);

    [Pop_Displace,~,Pop_Refugee]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Time_Sim,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,Pop_SES);
    Daily_Refugee=squeeze(sum(Pop_Refugee,[1 3]));
    Daily_IDP_Origin=Parameter.w_IDP.*squeeze(sum(Pop_Displace,[1 3])); % Need to examine the new idp only
    [par_V,fval]=surrogateopt(@(x)ObjectiveFunction_Refugee(x,Daily_Refugee,Mapping_Data,Refugee_Displacement,Number_Displacement,model_num-1),LB,UB,options);
    L_V_Mapping=-fval;
    save(['Mapping_Refugee_MLE_Model=' num2str(model_num-1) '.mat'],'par_V','L_V_Mapping');
end