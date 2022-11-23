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

load('Merge_Parameter_Uncertainty.mat','Par_FD','Par_Map_IDP','Par_Map_Ref','L_T','Model_IDP','Model_Refugee')

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

load('Macro_Oblast_Map.mat','Macro_Map');
load('Load_Data_MCMC_Mapping.mat');

for jj=1:NS
    [Parameter,STDEV_Displace]=Parameter_Return(Parameter_V(jj,:),RC,Time_Switch,day_W_fix,AIC_model_num);
    
    [~,Pop_IDP,Pop_Refugee]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Time_Sim,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,Pop_SES);
    Daily_Refugee=squeeze(sum(Pop_Refugee,[1 3]));
    Daily_IDP=squeeze(sum(Pop_IDP,[1 3]));
    
    
    [Parameter_Map_Refugee,Refugee_Mv]=Parameter_Return_Mapping_Refugee(MLE_Map_Ref,Model_Refugee);
    w_tot_ref=Determine_Weights_Refugee(Parameter_Map_Refugee,Mapping_Data,Refugee_Mv);


    [Parameter_Map_IDP,IDP_Mv]=Parameter_Return_Mapping_IDP(MLE_Map_IDP,Model_IDP);
    w_tot_idp=Determine_Weights_IDP(Parameter_Map_IDP,Mapping_Data,IDP_Mv);

    
    [Est_Daily_Refugee]=Country_Refuge_Displaced(w_tot_ref,Daily_Refugee);
    
    Model_Est_Poland(jj)=sum(Est_Daily_Refugee.Poland);
    Model_Est_Slovakia(jj)=sum(Est_Daily_Refugee.Slovakia);
    Model_Est_Hungary(jj)=sum(Est_Daily_Refugee.Hungary);
    Model_Est_Romania(jj)=sum(Est_Daily_Refugee.Romania);
    Model_Est_Belarus(jj)=sum(Est_Daily_Refugee.Belarus);
    Model_Est_Moldova(jj)=sum(Est_Daily_Refugee.Moldova);
    Model_Est_Russia(jj)=sum(Est_Daily_Refugee.Russia);
    Model_Est_Europe(jj)=sum(Est_Daily_Refugee.Europe_Other);
    
    
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
% 


load('FigS5_S6.mat');
Model_Ref=[Model_Est_Poland Model_Est_Slovakia Model_Est_Hungary Model_Est_Romania Model_Est_Belarus Model_Est_Moldova Model_Est_Russia];
Model_IDPs=[Model_Est_Kyiv Model_Est_East Model_Est_West Model_Est_South Model_Est_North Model_Est_Center];

Data_point=[Refugee_Displacement.Cumulative_Poland(end) Refugee_Displacement.Cumulative_Slovakia(end)  Refugee_Displacement.Cumulative_Hungary(end) Refugee_Displacement.Cumulative_Romania(end) Refugee_Displacement.Cumulative_Belarus(end) Refugee_Displacement.Cumulative_Moldova(end) Refugee_Displacement.Cumulative_Russia(end)];
Data_point_IDP=[IDP_Displacement.Macro.Kyiv(end) IDP_Displacement.Macro.East(end) IDP_Displacement.Macro.West(end) IDP_Displacement.Macro.South(end) IDP_Displacement.Macro.North(end) IDP_Displacement.Macro.Center(end)];
dx=0.45;
Colors=[hex2rgb('#336B87')];
Scatter_Color=[hex2rgb('#8D230F')];

close all;
figure('units','normalized','outerposition',[0.061458333333333,0.185185185185185,0.896354166666667./2,0.708333333333333]);
% Refugee
subplot('Position',[0.177097853359353,0.1875,0.80147058823529,0.796263931104362]);
for ii=1:7
   patch( ii+[-dx -dx dx dx],prctile(Model_Ref(:,ii)./100000,[50 75 75 50]),Colors,'FaceAlpha',0.5,'LineStyle','none'); hold on;
   patch( ii+[-dx -dx dx dx],prctile(Model_Ref(:,ii)./100000,[2.5 97.5 97.5 2.5]),Colors,'FaceAlpha',0.5,'LineStyle','none');
end
MT=median(sum(Model_Ref,2));
hold on
scatter([1:7],(MT./sum(Data_point)).*Data_point./100000,40,Scatter_Color,'filled');
xlim([1-0.7 7+0.7]);
set(gca,'tickdir','out','lineWidth',2,'XTick',[1:7],'XTickLabel',{'Poland','Slovakia','Hungary','Romania','Belarus','Moldova','Russia'},'Fontsize',22);
xtickangle(45)
% xlabel('Date','Fontsize',28);
ylabel({'Number of','refugees (100,000)'},'Fontsize',28);

print(gcf,'Supplementary_Figure_Distribution_Refugee.png','-dpng','-r300');

figure('units','normalized','outerposition',[0.061458333333333,0.185185185185185,0.896354166666667./2,0.708333333333333]);
% IDP
subplot('Position',[0.210900473933649,0.1875,0.767667967660994,0.796263931104362]);

MT=median(sum(Model_IDPs,2));
for ii=1:6
   patch( ii+[-dx -dx dx dx],prctile(Model_IDPs(:,ii)./100000,[50 75 75 50]),Colors,'FaceAlpha',0.5,'LineStyle','none'); hold on;
   patch( ii+[-dx -dx dx dx],prctile(Model_IDPs(:,ii)./100000,[2.5 97.5 97.5 2.5]),Colors,'FaceAlpha',0.5,'LineStyle','none');
end
hold on
scatter([1:6],(MT./sum(Data_point_IDP)).*Data_point_IDP./100000,40,Scatter_Color,'filled');
xlim([1-0.7 6+0.7]);
set(gca,'tickdir','out','lineWidth',2,'XTick',[1:6],'XTickLabel',{'Kyiv','East','West','South','North','Center'},'Fontsize',22);
xtickangle(45)
% xlabel('Date','Fontsize',28);
ylabel({'Number of IDPs','(100,000)'},'Fontsize',28);

print(gcf,'Supplementary_Figure_Distribution_IDP.png','-dpng','-r300');