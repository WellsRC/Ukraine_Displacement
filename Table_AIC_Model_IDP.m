clear;


L=zeros(8,1);
k=zeros(8,1);
for jj=1:8
    load(['Calibration_Kernel_Conflict_Window-Conflcit_Radius_Model=' num2str(jj) '.mat']);
    L(jj)=-min(fval);
    k(jj)=length(x0(1,:));
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



[Parameter,STDEV_Displace]=Parameter_Return(Parameter_V,RC,Time_Switch,day_W_fix,AIC_model_num);

[Pop_Displace,~,Pop_Refugee]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Time_Sim,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,Pop_SES);
Daily_Refugee=squeeze(sum(Pop_Refugee,[1 3]));
Daily_IDP_Origin=Parameter.w_IDP.*squeeze(sum(Pop_Displace,[1 3])); % Need to examine the new idp only


L=zeros(16,1);
k=zeros(16,1);
IDPc=zeros(16,7);
Model_BN=zeros(16,4);

Data_O=zeros(1,7);

for ii=0:15
    
    load(['Mapping_IDP_MLE_Model=' num2str(ii) '.mat'],'par_V','L_V_Mapping');
    if(~isempty(L_V_Mapping))
        L(ii+1)=L_V_Mapping;
        k(ii+1)=length(par_V);
        
        
        [Parameter_Map_IDP,IDP_Mv]=Parameter_Return_Mapping_IDP(par_V,ii);
        w_tot_idp=Determine_Weights_IDP(Parameter_Map_IDP,Mapping_Data,IDP_Mv);


        [Est_Daily_IDP]=IDP_Refuge_Displaced(w_tot_idp,Daily_IDP_Origin,Time_Sim,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Parameter,Macro_Map);
        NN=length(Est_Daily_IDP.macro_name);
        
        N=Est_Daily_IDP.macro_name;

        Tot_Data=IDP_Displacement.Macro.Kyiv+IDP_Displacement.Macro.East+IDP_Displacement.Macro.West+IDP_Displacement.Macro.South+IDP_Displacement.Macro.North+IDP_Displacement.Macro.Center;
        Tot_Model=zeros(size(Tot_Data'));
        for jj=1:NN
           if(strcmp('KYIV',N{jj}))
                Data_Points=IDP_Displacement.Macro.Kyiv;
                Model_Est=Est_Daily_IDP.macro(jj,ismember(Time_Sim,datenum(IDP_Displacement.Macro.Kyiv_Date)));

           elseif(strcmp('EAST',N{jj}))       
                Data_Points=IDP_Displacement.Macro.East;
                Model_Est=Est_Daily_IDP.macro(jj,ismember(Time_Sim,datenum(IDP_Displacement.Macro.East_Date)));
           elseif(strcmp('WEST',N{jj}))
                Data_Points=IDP_Displacement.Macro.West;
                Model_Est=Est_Daily_IDP.macro(jj,ismember(Time_Sim,datenum(IDP_Displacement.Macro.West_Date)));

           elseif(strcmp('SOUTH',N{jj}))
                Data_Points=IDP_Displacement.Macro.South;
                Model_Est=Est_Daily_IDP.macro(jj,ismember(Time_Sim,datenum(IDP_Displacement.Macro.South_Date)));

           elseif(strcmp('NORTH',N{jj}))
                Data_Points=IDP_Displacement.Macro.North;
                Model_Est=Est_Daily_IDP.macro(jj,ismember(Time_Sim,datenum(IDP_Displacement.Macro.North_Date)));

           elseif(strcmp('CENTER',N{jj}))
                Data_Points=IDP_Displacement.Macro.Center;
                Model_Est=Est_Daily_IDP.macro(jj,ismember(Time_Sim,datenum(IDP_Displacement.Macro.Center_Date)));

           else
               Model_Est=zeros(size(Tot_Model));
           end
           Tot_Model=Tot_Model+Model_Est;
        end

        for jj=1:NN
           if(strcmp('KYIV',N{jj}))
                Data_Points=IDP_Displacement.Macro.Kyiv;
                Model_Est=Est_Daily_IDP.macro(jj,ismember(Time_Sim,datenum(IDP_Displacement.Macro.Kyiv_Date)));

           elseif(strcmp('EAST',N{jj}))       
                Data_Points=IDP_Displacement.Macro.East;
                Model_Est=Est_Daily_IDP.macro(jj,ismember(Time_Sim,datenum(IDP_Displacement.Macro.East_Date)));
           elseif(strcmp('WEST',N{jj}))
                Data_Points=IDP_Displacement.Macro.West;
                Model_Est=Est_Daily_IDP.macro(jj,ismember(Time_Sim,datenum(IDP_Displacement.Macro.West_Date)));

           elseif(strcmp('SOUTH',N{jj}))
                Data_Points=IDP_Displacement.Macro.South;
                Model_Est=Est_Daily_IDP.macro(jj,ismember(Time_Sim,datenum(IDP_Displacement.Macro.South_Date)));

           elseif(strcmp('NORTH',N{jj}))
                Data_Points=IDP_Displacement.Macro.North;
                Model_Est=Est_Daily_IDP.macro(jj,ismember(Time_Sim,datenum(IDP_Displacement.Macro.North_Date)));

           elseif(strcmp('CENTER',N{jj}))
                Data_Points=IDP_Displacement.Macro.Center;
                Model_Est=Est_Daily_IDP.macro(jj,ismember(Time_Sim,datenum(IDP_Displacement.Macro.Center_Date)));

           end
           if(~strcmp('N/A',N{jj}))
                IDPc(ii+1,jj)=Model_Est(end)./Tot_Model(end);
                Data_O(jj)=Data_Points(end);
           end 
        end


    else
        L(jj+1)=-Inf;
        k(jj+1)=1;
    end
    
    
    temp=de2bi(jj);
    Model_BN(jj+1,1:length(temp))=temp;
end

Data_O=Data_O./sum(Data_O);
aics=aicbic(L,k);

daics=aics-min(aics);
w=exp(-daics./2)./sum(exp(-daics./2));

T=table(Model_BN,daics,w);

