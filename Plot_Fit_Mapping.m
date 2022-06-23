clear;
% close all;
load('Load_Data_MCMC_Mapping.mat');


load('MCMC_out-k=2331.mat','L_V','Parameter_V')
f=find(L_V==max(L_V(L_V<0)),1);


Tot_Refugee_Data=sum(Number_Displacement.Refugee);

[Parameter,STDEV_Displace]=Parameter_Return(Parameter_V(f,:),RC,Time_Switch,day_W_fix);

[Pop_Displace,temp_IDP,Pop_Refugee]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Time_Sim,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,ML_Indx);
Daily_Refugee=squeeze(sum(Pop_Refugee,[1 3]));
temp_IDP=squeeze(sum(temp_IDP,[1 2 3]));
Daily_IDP_Origin=Parameter.w_IDP.*squeeze(sum(Pop_Displace,[1 3])); % Need to examine the new idp only

par=[1.28002277839657,2.80219780031663,4.20104005286396,0.0753034566282208,2.61146699502349,0.0403068705232432,2.70689046521075,0.9373,0.9897,0.6227,0.2502,5.7];
load('Macro_Oblast_Map.mat','Macro_Map');
[Parameter_Map_Refugee,Parameter_Map_IDP]=Parameter_Return_Mapping(par);

w_tot_ref=Determine_Weights_Refugee(Parameter_Map_Refugee,Mapping_Data);
w_tot_idp=Determine_Weights_IDP(Parameter_Map_IDP,Mapping_Data,w_tot_ref(:,1:end-1)./(1-Parameter_Map_Refugee.weight_Europe));

[Est_Daily_Refugee]=Country_Refuge_Displaced(w_tot_ref,Daily_Refugee);
[Est_Daily_IDP]=IDP_Refuge_Displaced(w_tot_idp,Daily_IDP_Origin,Time_Sim,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Parameter,Macro_Map);

Country={'Poland';'Slovakia';'Hungary';'Romania';'Belarus';'Moldova';'Russian Federation'};
figure('units','normalized','outerposition',[0. 0. 1 1]);
Data=zeros(7,1);
Model=zeros(7,1);
for ii=1:7
    switch ii
        case 1
            Data_point=Refugee_Displacement.Cumulative_Poland;
            Data_time=Refugee_Displacement.Date_Poland;
            Model_Est=Est_Daily_Refugee.Poland;
        case 2
            Data_point=Refugee_Displacement.Cumulative_Slovakia;
            Data_time=Refugee_Displacement.Date_Slovakia;
            Model_Est=Est_Daily_Refugee.Slovakia;
        case 3
            Data_point=Refugee_Displacement.Cumulative_Hungary;
            Data_time=Refugee_Displacement.Date_Hungary;
            Model_Est=Est_Daily_Refugee.Hungary;
        case 4
            Data_point=Refugee_Displacement.Cumulative_Romania;
            Data_time=Refugee_Displacement.Date_Romania;
            Model_Est=Est_Daily_Refugee.Romania;
        case 5
            Data_point=Refugee_Displacement.Cumulative_Belarus;
            Data_time=Refugee_Displacement.Date_Belarus;
            Model_Est=Est_Daily_Refugee.Belarus;
        case 6
            Data_point=Refugee_Displacement.Cumulative_Moldova;
            Data_time=Refugee_Displacement.Date_Moldova;
            Model_Est=Est_Daily_Refugee.Moldova;
        case 7
            Data_point=Refugee_Displacement.Cumulative_Russia;
            Data_time=Refugee_Displacement.Date_Russia;
            Model_Est=Est_Daily_Refugee.Russia;
    end
    Data(ii)=Data_point(end);
    Model(ii)=Model_Est(end);
end
Tot_Model=sum(Model)+Est_Daily_Refugee.Europe_Other(end);

bar([1:7],Model./Tot_Model,'k');
hold on
scatter([1:7],Data./Tot_Refugee_Data,40,'r','filled');
ylabel('proportion of refugees');
set(gca,'XTick',[1:7],'XTickLabel',Country);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% MACRO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
figure('units','normalized','outerposition',[0. 0. 1 1]);
N=Est_Daily_IDP.macro_name;
cc=1;


Tot_Data=IDP_Displacement.Macro.Kyiv+IDP_Displacement.Macro.East+IDP_Displacement.Macro.West+IDP_Displacement.Macro.South+IDP_Displacement.Macro.North+IDP_Displacement.Macro.Center;
Tot_Model=zeros(size(Tot_Data'));
for ii=1:length(N)
   if(strcmp('KYIV',N{ii}))
        Data_Points=IDP_Displacement.Macro.Kyiv;
        Model_Est=Est_Daily_IDP.macro(ii,ismember(Time_Sim,datenum(IDP_Displacement.Macro.Kyiv_Date)));
        
   elseif(strcmp('EAST',N{ii}))       
        Data_Points=IDP_Displacement.Macro.East;
        Model_Est=Est_Daily_IDP.macro(ii,ismember(Time_Sim,datenum(IDP_Displacement.Macro.East_Date)));
   elseif(strcmp('WEST',N{ii}))
        Data_Points=IDP_Displacement.Macro.West;
        Model_Est=Est_Daily_IDP.macro(ii,ismember(Time_Sim,datenum(IDP_Displacement.Macro.West_Date)));
   
   elseif(strcmp('SOUTH',N{ii}))
        Data_Points=IDP_Displacement.Macro.South;
        Model_Est=Est_Daily_IDP.macro(ii,ismember(Time_Sim,datenum(IDP_Displacement.Macro.South_Date)));

   elseif(strcmp('NORTH',N{ii}))
        Data_Points=IDP_Displacement.Macro.North;
        Model_Est=Est_Daily_IDP.macro(ii,ismember(Time_Sim,datenum(IDP_Displacement.Macro.North_Date)));

   elseif(strcmp('CENTER',N{ii}))
        Data_Points=IDP_Displacement.Macro.Center;
        Model_Est=Est_Daily_IDP.macro(ii,ismember(Time_Sim,datenum(IDP_Displacement.Macro.Center_Date)));
       
   else
       Model_Est=zeros(size(Tot_Model));
   end
   Tot_Model=Tot_Model+Model_Est;
end

for ii=1:length(N)
    
   if(strcmp('KYIV',N{ii}))
        Data_Points=IDP_Displacement.Macro.Kyiv;
        Model_Est=Est_Daily_IDP.macro(ii,ismember(Time_Sim,datenum(IDP_Displacement.Macro.Kyiv_Date)));
        
   elseif(strcmp('EAST',N{ii}))       
        Data_Points=IDP_Displacement.Macro.East;
        Model_Est=Est_Daily_IDP.macro(ii,ismember(Time_Sim,datenum(IDP_Displacement.Macro.East_Date)));
   elseif(strcmp('WEST',N{ii}))
        Data_Points=IDP_Displacement.Macro.West;
        Model_Est=Est_Daily_IDP.macro(ii,ismember(Time_Sim,datenum(IDP_Displacement.Macro.West_Date)));
   
   elseif(strcmp('SOUTH',N{ii}))
        Data_Points=IDP_Displacement.Macro.South;
        Model_Est=Est_Daily_IDP.macro(ii,ismember(Time_Sim,datenum(IDP_Displacement.Macro.South_Date)));

   elseif(strcmp('NORTH',N{ii}))
        Data_Points=IDP_Displacement.Macro.North;
        Model_Est=Est_Daily_IDP.macro(ii,ismember(Time_Sim,datenum(IDP_Displacement.Macro.North_Date)));
   elseif(strcmp('CENTER',N{ii}))
        Data_Points=IDP_Displacement.Macro.Center;
        Model_Est=Est_Daily_IDP.macro(ii,ismember(Time_Sim,datenum(IDP_Displacement.Macro.Center_Date)));
       
   end
   
   if(~strcmp('N/A',N{ii}))
       subplot(3,2,cc)
        bar([1:length(Data_Points)],Model_Est,'k'); hold on
        scatter([1:length(Data_Points)],Tot_Model(:).*Data_Points(:)./Tot_Data(:),40,'r','filled');
        ylabel('Number of IDPs');
        ylim([0 3*10^6]);
            title(N{ii})
        cc=cc+1;
   end
end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % Oblast
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Model_Est=zeros(length(IDP_Displacement.Oblast.Index),2);
% figure('units','normalized','outerposition',[0. 0. 1 1]);
% for ii=1:length(Model_Est(:,1))
%     Model_Est(ii,1)=IDP_Displacement.Oblast.IDP(ii,:);
%     Model_Est(ii,2)=Est_Daily_IDP.oblast(IDP_Displacement.Oblast.Index(ii),ismember(Time_Sim,datenum(IDP_Displacement.Oblast.Date)));
% end
% [rr,pp]=corr(Model_Est);
% bar(Model_Est(:,2),'k'); hold on
% scatter(1:length(Model_Est(:,1)),sum(Model_Est(:,2)).*Model_Est(:,1)./sum(Model_Est(:,1)),40,'r','filled');
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Raion
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Data_Points=zeros(length(IDP_Displacement.raion.IDP),1);
% Model_Est=Data_Points;
% 
% 
% figure('units','normalized','outerposition',[0. 0. 1 1]);
% 
% for ii=1:length(Data_Points)
%     Data_Points(ii)=IDP_Displacement.raion.IDP(ii,:);
%     if(Data_Points(ii)>0)
%         Model_Est(ii)=Est_Daily_IDP.raion(ii,ismember(Time_Sim,datenum(IDP_Displacement.raion.Date)));
%     end
% end
% 
% 
% bar(Model_Est(Data_Points>0),'k'); hold on
% scatter(1:length(Model_Est(Data_Points>0)),sum(Model_Est).*Data_Points(Data_Points>0)./sum(Data_Points),40,'r','filled');