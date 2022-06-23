clear;
close all;

[Number_Displacement,Date_Displacement,vLat_C,vLon_C,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,Pop_MACRO,Pop_raion,Pop_oblast,Time_Sim,ML_Indx,RC,Time_Switch]=LoadData;
load('MCMC_out-k=2821.mat','L_V','Parameter_V')
day_W_fix=7;

Parameter_V=Parameter_V(L_V<0,:);
Parameter_V=unique(Parameter_V(end-9999:end,:),'rows');
NS=500;
Daily_Refugee=zeros(NS,length(Time_Sim));
Daily_IDP=zeros(NS,length(Time_Sim));
Daily_IDP_Origin_Kyiv=zeros(NS,length(Time_Sim));
Daily_IDP_Origin_East=zeros(NS,length(Time_Sim));
Daily_IDP_Origin_South=zeros(NS,length(Time_Sim));
Daily_IDP_Origin_North=zeros(NS,length(Time_Sim));
Daily_IDP_Origin_West=zeros(NS,length(Time_Sim));
Daily_IDP_Origin_Central=zeros(NS,length(Time_Sim));
Daily_IDP_Age_18_29=zeros(NS,length(Time_Sim));
Daily_IDP_Age_30_39=zeros(NS,length(Time_Sim));
Daily_IDP_Age_40_49=zeros(NS,length(Time_Sim));
Daily_IDP_Age_Over_50=zeros(NS,length(Time_Sim));
Daily_IDP_Female=zeros(NS,length(Time_Sim));
r_samp=randi(length(Parameter_V(:,1)),NS,1);
parfor jj=1:NS
    [Parameter,STDEV_Displace]=Parameter_Return(Parameter_V(r_samp(jj),:),RC,Time_Switch,day_W_fix);
    [~,Pop_IDP,Pop_Refugee]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Time_Sim,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,ML_Indx);
    Daily_Refugee(jj,:)=squeeze(sum(Pop_Refugee,[1:3]));
    Daily_IDP_Origin_Macro_Full=Calc_Macro_Displacement(squeeze(sum(Pop_IDP,[1 3])),Pop_MACRO);

    Daily_IDP_Origin_Kyiv(jj,:)=Daily_IDP_Origin_Macro_Full.Kyiv;
    Daily_IDP_Origin_South(jj,:)=Daily_IDP_Origin_Macro_Full.South;
    Daily_IDP_Origin_East(jj,:)=Daily_IDP_Origin_Macro_Full.East;
    Daily_IDP_Origin_West(jj,:)=Daily_IDP_Origin_Macro_Full.West;
    Daily_IDP_Origin_North(jj,:)=Daily_IDP_Origin_Macro_Full.North;
    Daily_IDP_Origin_Central(jj,:)=Daily_IDP_Origin_Macro_Full.Central;
    
    Daily_IDP_Age_Full=Calc_Age_Displacement(squeeze(sum(Pop_IDP,[1 2])));
    
    Daily_IDP_Age_18_29(jj,:)=Daily_IDP_Age_Full(1,:);
    Daily_IDP_Age_30_39(jj,:)=Daily_IDP_Age_Full(2,:);
    Daily_IDP_Age_40_49(jj,:)=Daily_IDP_Age_Full(3,:);
    Daily_IDP_Age_Over_50(jj,:)=Daily_IDP_Age_Full(4,:);
    
    Daily_IDP_Female(jj,:)=Calc_Gender_Displacement(squeeze(sum(Pop_IDP,[2 3])));
    
    Daily_IDP(jj,:)=Daily_IDP_Origin_Macro_Full.Kyiv+Daily_IDP_Origin_Macro_Full.East+Daily_IDP_Origin_Macro_Full.South+Daily_IDP_Origin_Macro_Full.Center+Daily_IDP_Origin_Macro_Full.North+Daily_IDP_Origin_Macro_Full.West;
end

Data_Refugee=Number_Displacement.Refugee;
Time_Refugee=Date_Displacement.Refugee;

Data_IDP=Number_Displacement.IDP_Origin.Kyiv+Number_Displacement.IDP_Origin.East+Number_Displacement.IDP_Origin.South+Number_Displacement.IDP_Origin.Center+Number_Displacement.IDP_Origin.North+Number_Displacement.IDP_Origin.West;
Time_IDP=Date_Displacement.IDP_Origin;

dx=0.45;
Colors=[hex2rgb('#336B87')];
Scatter_Color=[hex2rgb('#8D230F')];
close all;
figure('units','normalized','outerposition',[0.061458333333333,0.185185185185185,0.896354166666667,0.708333333333333]);
% Refugee
subplot('Position',[0.088235294117646,0.309248554913295,0.400735294117645,0.674515376191068]);
for ii=1:length(Time_Sim)
   patch( Time_Sim(ii)+[-dx -dx dx dx],prctile(Daily_Refugee(:,ii)./100000,[50 75 75 50]),Colors,'FaceAlpha',0.5,'LineStyle','none'); hold on;
   patch( Time_Sim(ii)+[-dx -dx dx dx],prctile(Daily_Refugee(:,ii)./100000,[2.5 97.5 97.5 2.5]),Colors,'FaceAlpha',0.5,'LineStyle','none');
end
hold on
scatter(Time_Refugee,Data_Refugee./100000,40,Scatter_Color,'filled');
xlim([Time_Sim(1)-0.7 Time_Sim(end)+0.7]);
set(gca,'tickdir','out','lineWidth',2,'XTick',Time_Sim(1:7:end),'XTickLabel',{datestr(Time_Sim(1:7:end))},'Fontsize',22);
xtickangle(45)
xlabel('Date','Fontsize',28);
ylabel({'Daily number of','refugees (100,000)'},'Fontsize',28);
%IDP
subplot('Position',[0.59,0.313583815028902,0.400735294117645,0.670180116075461]);

for ii=1:length(Time_Sim)
   patch( Time_Sim(ii)+[-dx -dx dx dx],prctile(Daily_IDP(:,ii)./100000,[50 75 75 50]),Colors,'FaceAlpha',0.5,'LineStyle','none'); hold on;
   patch( Time_Sim(ii)+[-dx -dx dx dx],prctile(Daily_IDP(:,ii)./100000,[2.5 97.5 97.5 2.5]),Colors,'FaceAlpha',0.5,'LineStyle','none');
end
hold on
scatter(Time_IDP,Data_IDP./100000,40,Scatter_Color,'filled');
xlim([Time_Sim(1)-0.7 Time_Sim(end)+0.7]);
set(gca,'tickdir','out','lineWidth',2,'XTick',Time_Sim(1:7:end),'XTickLabel',{datestr(Time_Sim(1:7:end))},'Fontsize',22);
xtickangle(45)
xlabel('Date','Fontsize',28);
ylabel({'Number of IDPs','(100,000)'},'Fontsize',28);