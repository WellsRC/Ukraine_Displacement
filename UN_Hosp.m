

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Uncertainty Hospitals
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clear;
clc;
close all; 
load('Ukraine_Population_Reduced.mat','Ukraine_Pop')
Mapped_Raion_Name=Ukraine_Pop.map_raion;
Oblast_Pixel=Ukraine_Pop.oblast;
Raion_Pixel=Ukraine_Pop.raion;
clear Ukraine_Pop

load('Calibration_Conflict_Kernel.mat');

load('Macro_Oblast_Map.mat','Macro_Map');

load('Load_Data_Mapping.mat');

[Disease_Short,age_class_v,gender_v]=Disease_Stratificaion_Text;
Pop=Population_Join_Gender(Pop_F_Age,Pop_M_Age);
PopR=Raion_Population_Point(Pop,Pop_oblast,Pop_raion);

[day_W_fix,RC,Par_FD,Par_Map_Ref,Par_Map_IDP,Model_FD,Model_IDP,Model_Refugee] = Selected_Model_Parameters_Uncertainty;

NS=length(Par_FD(:,1));

Pop_C=sum(Pop,[1 3])';
Est_Pop_PW=Macro_Return(Pop_C,Raion_Pixel,Oblast_Pixel,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Macro_Map);
YY=Est_Pop_PW.macro;

Pop_Pre_Inv_Raion=Est_Pop_PW.raion;
Pop_Pre_Inv_Macro=Est_Pop_PW.macro;

Pop_NonIDP_Inv_Raion=zeros(NS,length(S2));
Pop_NonIDP_Inv_Macro=zeros(NS,7);


Pop_IDP_Inv_Raion=zeros(NS,length(S2));
Pop_IDP_Inv_Macro=zeros(NS,7);

H=shaperead('Health/hotosm_ukr_health_facilities_points.shp','UseGeoCoords',true);

N={H.amenity};
tfh=strcmp(N,'hospital')|strcmp(N,'cancer');
H=H(tfh);

HLon=[H.Lon];
HLat=[H.Lat];


S2=shaperead('UKR_ADM_2/UKR_adm2.shp','UseGeoCoords',true);

Hosp_Macro=zeros(NS,7,2);
Hosp_Raion=zeros(NS,length(S2),3);
for ss=1:NS
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    % % Load data and determine the dispacement per day
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    [Parameter,~]=Parameter_Return(Par_FD(ss,:),RC,Time_Switch,day_W_fix,Model_FD);


    nDays=length(Time_Sim);
    PC=zeros(length(cell2mat(vLat_C)),nDays);
    PC_H=zeros(length(HLat),nDays);

    PC_W=zeros(length(cell2mat(vLat_C)),Parameter.day_W);
    PCH_W=zeros(length(HLat),Parameter.day_W);
    for jj=1:nDays
        if(Time_Sim(jj)<Parameter.Switch)
            P = Kernel_Displacement(vLat_C{jj},vLon_C{jj},cell2mat(vLat_C),cell2mat(vLon_C),Parameter);
            PH= Kernel_Displacement(vLat_C{jj},vLon_C{jj},HLat,HLon,Parameter);

        else
            P = Parameter.Switch_Scaled.*Kernel_Displacement(vLat_C{jj},vLon_C{jj},cell2mat(vLat_C),cell2mat(vLon_C),Parameter);
            PH = Parameter.Switch_Scaled.*Kernel_Displacement(vLat_C{jj},vLon_C{jj},HLat,HLon,Parameter);
        end
        % Cumulative probability
        PC_W(:,2:Parameter.day_W)=PC_W(:,1:(Parameter.day_W-1));    
        PC_W(:,1)=P;

        PCH_W(:,2:Parameter.day_W)=PCH_W(:,1:(Parameter.day_W-1));    
        PCH_W(:,1)=PH;

        PC(:,jj)=1-prod(1-PC_W(:,[1:min(jj,Parameter.day_W)]),2);
        PC_H(:,jj)=1-prod(1-PCH_W(:,[1:min(jj,Parameter.day_W)]),2);
    end

    P_H=1-geomean(1-PC_H,2);
    P_C=1-geomean(1-PC,2);

    NN=(PC_H./repmat(sum(PC_H,2),1,length(Time_Sim)));
    NN(isnan(NN))=1;
    Test_H2=repmat(P_H./max(P_C),1,length(Time_Sim)).*NN;


    HLonNCZ=HLon(P_H==0);
    HLatNCZ=HLat(P_H==0);

    P_H=P_H./max(P_C);


    for ii=1:length(S2)
       [p_in,~]=inpolygon( HLat,HLon,S2(ii).Lat,S2(ii).Lon);
       Hosp_Raion(ss,ii,1)=sum(p_in);
       Hosp_Raion(ss,ii,2)=sum(P_H(p_in));
       if(Hosp_Raion(ss,ii,1)>0)
            Hosp_Raion(ss,ii,3)=sum(P_H(p_in))./sum(p_in);
       end
    end
    

    MNR=unique(Macro_Map(:,3));
    for ii=1:length(MNR)
       t_mr=find(strcmp(MNR{ii}, Macro_Map(:,3)));

       t_o=false(length(S2),1)';
       for jj=1:length(t_mr)
          t_o=t_o | strcmp(Macro_Map(t_mr(jj),2),{S2.NAME_1}); 
       end
       Hosp_Macro(ss,ii,:)=squeeze(sum(Hosp_Raion(ss,t_o,1:2),2)); 
    end
    
    
    [Parameter,~]=Parameter_Return(Par_FD(ss,:),RC,Time_Switch,day_W_fix,Model_FD);
        
    [Pop_Displace,Pop_IDP,Pop_Refugee]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Time_Sim,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,Pop_SES);
    Daily_Refugee=squeeze(sum(Pop_Refugee,[1 3]));
    Daily_IDP_Origin=Parameter.w_IDP.*squeeze(sum(Pop_Displace,[1 3])); % Need to examine the new idp only
    
  
    Num_Refugee=squeeze(sum(Pop_Refugee,[4]));
    Num_Non_Displaced=Pop-Pop_IDP(:,:,:,end)-Num_Refugee;
       
    [Parameter_Map_IDP,IDP_Mv]=Parameter_Return_Mapping_IDP(Par_Map_IDP(ss,:),Model_IDP);
    w_tot_idp=Determine_Weights_IDP(Parameter_Map_IDP,Mapping_Data,IDP_Mv);
    
    [Est_Daily_IDP]=IDP_Refuge_Displaced(w_tot_idp,Daily_IDP_Origin,Time_Sim,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Parameter,Macro_Map);
    
    Non_IDP=sum(Num_Non_Displaced, [1 3])';
    Est_Pop_NIDP=Macro_Return(Non_IDP,Raion_Pixel,Oblast_Pixel,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Macro_Map);
       
    
    Pop_NonIDP_Inv_Raion(ss,:)=Est_Pop_NIDP.raion;
    Pop_NonIDP_Inv_Macro(ss,:)=Est_Pop_NIDP.macro;
    
    
    Pop_IDP_Inv_Raion(ss,:)=Est_Daily_IDP.raion(:,end);
    Pop_IDP_Inv_Macro(ss,:)=Est_Daily_IDP.macro(:,end);
    
end

save('Uncertainty_Hospital_UKR.mat','Hosp_Macro','Hosp_Raion','Pop_Pre_Inv_Raion','Pop_NonIDP_Inv_Macro','Pop_NonIDP_Inv_Raion','Pop_Pre_Inv_Macro','Pop_IDP_Inv_Macro','Pop_IDP_Inv_Raion');