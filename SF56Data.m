clear;
close all;

load('Calibration_Conflict_Kernel.mat');
load('Load_Data_Mapping.mat');
load('Macro_Oblast_Map.mat','Macro_Map');

[day_W_fix,RC,Par_FD,Par_Map_Ref,Par_Map_IDP,Model_FD,Model_IDP,Model_Refugee] = Selected_Model_Parameters_Uncertainty;

Parameter_V=Par_FD;
Parameter_Ref_V=Par_Map_Ref;
Parameter_IDP_V=Par_Map_IDP;

NS=length(Par_FD(:,1));


Model_Est_Poland=zeros(NS,1);
Model_Est_Slovakia=zeros(NS,1);
Model_Est_Hungary=zeros(NS,1);
Model_Est_Romania=zeros(NS,1);
Model_Est_Belarus=zeros(NS,1);
Model_Est_Moldova=zeros(NS,1);
Model_Est_Russia=zeros(NS,1);
Model_Est_Europe=zeros(NS,1);


Model_Est_North=zeros(NS,1);
Model_Est_East=zeros(NS,1);
Model_Est_West=zeros(NS,1);
Model_Est_South=zeros(NS,1);
Model_Est_Center=zeros(NS,1);
Model_Est_Kyiv=zeros(NS,1);


for jj=1:NS
    [Parameter,STDEV_Displace]=Parameter_Return(Parameter_V(jj,:),RC,Time_Switch,day_W_fix,Model_FD);
    
    [~,Pop_IDP,Pop_Refugee]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Time_Sim,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,Pop_SES);
    Daily_Refugee=squeeze(sum(Pop_Refugee,[1 3]));
    Daily_IDP=squeeze(sum(Pop_IDP,[1 3]));
    
    
    [Parameter_Map_Refugee,Refugee_Mv]=Parameter_Return_Mapping_Refugee(Parameter_Ref_V(jj,:),Model_Refugee);
    w_tot_ref=Determine_Weights_Refugee(Parameter_Map_Refugee,Mapping_Data,Refugee_Mv);


    [Parameter_Map_IDP,IDP_Mv]=Parameter_Return_Mapping_IDP(Parameter_IDP_V(jj,:),Model_IDP);
    w_tot_idp=Determine_Weights_IDP(Parameter_Map_IDP,Mapping_Data,IDP_Mv);

    
    [Est_Daily_Refugee]=Country_Refuge_Displaced(w_tot_ref,Daily_Refugee);
    
    % Need to show data for may 12
    Model_Est_Poland(jj)=sum(Est_Daily_Refugee.Poland(1:end-1)); % Model ends may 13
    Model_Est_Slovakia(jj)=sum(Est_Daily_Refugee.Slovakia(1:end-1)); % Model ends may 13
    Model_Est_Hungary(jj)=sum(Est_Daily_Refugee.Hungary(1:end-1)); % Model ends may 13
    Model_Est_Romania(jj)=sum(Est_Daily_Refugee.Romania(1:end-1)); % Model ends may 13
    Model_Est_Belarus(jj)=sum(Est_Daily_Refugee.Belarus(1:end-1)); % Model ends may 13
    Model_Est_Moldova(jj)=sum(Est_Daily_Refugee.Moldova(1:end-1)); % Model ends may 13
    Model_Est_Russia(jj)=sum(Est_Daily_Refugee.Russia(1:end-1)); % Model ends may 13
    Model_Est_Europe(jj)=sum(Est_Daily_Refugee.Europe_Other(1:end-1)); % Model ends may 13
    
    
    [Est_Daily_IDP]=IDP_Refuge_Displaced(w_tot_idp,Daily_IDP,Time_Sim,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Parameter,Macro_Map);
    N_Macro=Est_Daily_IDP.macro_name;
    Model_Est_Kyiv(jj)=Est_Daily_IDP.macro(strcmp(N_Macro,'KYIV'),ismember(Time_Sim,datenum(IDP_Displacement.Macro.Kyiv_Date(end))));
    Model_Est_East(jj)=Est_Daily_IDP.macro(strcmp(N_Macro,'EAST'),ismember(Time_Sim,datenum(IDP_Displacement.Macro.East_Date(end))));
    Model_Est_West(jj)=Est_Daily_IDP.macro(strcmp(N_Macro,'WEST'),ismember(Time_Sim,datenum(IDP_Displacement.Macro.West_Date(end))));   
    Model_Est_South(jj)=Est_Daily_IDP.macro(strcmp(N_Macro,'SOUTH'),ismember(Time_Sim,datenum(IDP_Displacement.Macro.South_Date(end))));
    Model_Est_North(jj)=Est_Daily_IDP.macro(strcmp(N_Macro,'NORTH'),ismember(Time_Sim,datenum(IDP_Displacement.Macro.North_Date(end))));
    Model_Est_Center(jj)=Est_Daily_IDP.macro(strcmp(N_Macro,'CENTER'),ismember(Time_Sim,datenum(IDP_Displacement.Macro.Center_Date(end))));
end

save('FigS5_S6.mat');
