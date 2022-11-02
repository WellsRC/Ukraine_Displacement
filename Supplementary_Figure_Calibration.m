clear;
% close all;


L=zeros(8,1);
k=zeros(8,1);
for ii=1:8
load(['Calibration_Kernel_Conflict_Window-Conflcit_Radius_Model=' num2str(ii) '.mat']);
L(ii)=-min(fval);
k(ii)=length(x0(1,:));
end
aics=aicbic(L,k);

daics=aics-min(aics);

load('Calibration_Conflict_Kernel.mat');
NS=8;
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

Model_Type={'Location','Location and Age','Location and Gender','Location and Socio-economic status','Location, Age, and Gender','Location, Age, and Socio-economic status','Location, Gender, and Socio-economic status','Location, Age, Gender, and Socio-economic status'};

for jj=1:8
    load(['Calibration_Kernel_Conflict_Window-Conflcit_Radius_Model=' num2str(jj) '.mat']);
    day_W_fix=day_W_fix(fval==min(fval));
    RC=RC(fval==min(fval));
    Parameter_V=x0(fval==min(fval),:);



    [Parameter,STDEV_Displace]=Parameter_Return(Parameter_V,RC,Time_Switch,day_W_fix,jj);
    [~,Pop_IDP,Pop_Refugee]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Time_Sim,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,Pop_SES);
    Daily_Refugee(jj,:)=squeeze(sum(Pop_Refugee,[1:3]));
    Daily_IDP_Origin_Macro_Full=Calc_Macro_Displacement(squeeze(sum(Pop_IDP,[1 3])),Pop_MACRO);

    Daily_IDP_Origin_Kyiv(jj,:)=Daily_IDP_Origin_Macro_Full.Kyiv;
    Daily_IDP_Origin_South(jj,:)=Daily_IDP_Origin_Macro_Full.South;
    Daily_IDP_Origin_East(jj,:)=Daily_IDP_Origin_Macro_Full.East;
    Daily_IDP_Origin_West(jj,:)=Daily_IDP_Origin_Macro_Full.West;
    Daily_IDP_Origin_North(jj,:)=Daily_IDP_Origin_Macro_Full.North;
    Daily_IDP_Origin_Central(jj,:)=Daily_IDP_Origin_Macro_Full.Center;
    
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

close all;
dx=0.45;
Colors=[hex2rgb('#336B87')];
Scatter_Color=[hex2rgb('#8D230F')];
close all;
figure('units','normalized','outerposition',[0.061458333333333,0.185185185185185,0.896354166666667,0.708333333333333]);
% Refugee
subplot('Position',[0.088235294117646,0.309248554913295,0.400735294117645,0.674515376191068]);
for ii=1:8
    if(daics(ii)==0)
        plot( Time_Sim,Daily_Refugee(ii,:)./100000,'LineWidth',2.5); hold on;
    else
        plot( Time_Sim,Daily_Refugee(ii,:)./100000,'-.','LineWidth',1.5); hold on;
    end
end
hold on
scatter(Time_Refugee,Data_Refugee./100000,40,Scatter_Color,'filled');
xlim([Time_Sim(1) Time_Sim(end)]);
set(gca,'tickdir','out','lineWidth',2,'XTick',Time_Sim(1:7:end),'XTickLabel',{datestr(Time_Sim(1:7:end))},'Fontsize',22);
xtickangle(45)
xlabel('Date','Fontsize',28);
ylabel({'Daily number of','refugees (100,000)'},'Fontsize',28);
text(-0.214912280703055,0.981236203090508,'A','Units','normalized','Fontsize',40,'FontWeight','bold');
box off;
legend(Model_Type,'FontSize',12);
%IDP
subplot('Position',[0.59,0.313583815028902,0.400735294117645,0.670180116075461]);

for ii=1:8
    if(daics(ii)==0)
        plot( Time_Sim,Daily_IDP(ii,:)./100000,'LineWidth',2.5); hold on;
    else
        plot( Time_Sim,Daily_IDP(ii,:)./100000,'-.','LineWidth',1.5); hold on;
    end
end
hold on
scatter(Time_IDP,Data_IDP./100000,40,Scatter_Color,'filled');
xlim([Time_Sim(1)-0.7 Time_Sim(end)+0.7]);
set(gca,'tickdir','out','lineWidth',2,'XTick',Time_Sim(1:7:end),'XTickLabel',{datestr(Time_Sim(1:7:end))},'Fontsize',22);
xtickangle(45)
xlabel('Date','Fontsize',28);
ylabel({'Number of IDPs','(100,000)'},'Fontsize',28);
text(-0.214912280703055,0.981236203090508,'B','Units','normalized','Fontsize',40,'FontWeight','bold');
box off;
print(gcf,'Supplementary_Figure_Refugee_IDP_Calibration.png','-dpng','-r300');

figure('units','normalized','outerposition',[0 0.05 1 1]);
for dd=1:4
    switch dd
        case 1
            subplot('Position',[0.06,0.60 0.43 0.35]);
            text(-0.134326200116974,1.085282445865074,'A','Units','normalized','Fontsize',40,'FontWeight','bold');
        case 2
            subplot('Position',[0.55,0.60 0.43 0.35]);
            text(-0.134326200116974,1.085282445865074,'B','Units','normalized','Fontsize',40,'FontWeight','bold');
        case 3
            subplot('Position',[0.06,0.1 0.43 0.35]);
            text(-0.134326200116974,1.085282445865074,'C','Units','normalized','Fontsize',40,'FontWeight','bold');
        case 4
            subplot('Position',[0.55,0.1 0.43 0.35]);
            text(-0.134326200116974,1.085282445865074,'D','Units','normalized','Fontsize',40,'FontWeight','bold');
    end
datas=[Number_Displacement.IDP_Origin.Kyiv(dd) Number_Displacement.IDP_Origin.South(dd) Number_Displacement.IDP_Origin.East(dd) Number_Displacement.IDP_Origin.West(dd) Number_Displacement.IDP_Origin.North(dd) Number_Displacement.IDP_Origin.Center(dd)];
datas=100.*datas./sum(datas);

model_est=[Daily_IDP_Origin_Kyiv(:,Time_Sim==Date_Displacement.IDP_Origin(dd)) Daily_IDP_Origin_South(:,Time_Sim==Date_Displacement.IDP_Origin(dd)) Daily_IDP_Origin_East(:,Time_Sim==Date_Displacement.IDP_Origin(dd)) Daily_IDP_Origin_West(:,Time_Sim==Date_Displacement.IDP_Origin(dd)) Daily_IDP_Origin_North(:,Time_Sim==Date_Displacement.IDP_Origin(dd)) Daily_IDP_Origin_Central(:,Time_Sim==Date_Displacement.IDP_Origin(dd))];

model_est=100.*model_est./repmat(sum(model_est,2),1,6);
b=bar([1:6],model_est); hold on
for ii=1:8
    b(ii).EdgeColor=b(ii).FaceColor;
   if(daics(ii)~=0)
       b(ii).FaceColor=[1 1 1];
       b(ii).LineStyle='-.';
       b(ii).LineWidth=1.5;
   end
end
for ii=1:6
    plot(ii+[-0.4 0.4],[datas(ii) datas(ii)],'k','LineWidth',2);
end

set(gca,'linewidth',2,'tickdir','out','fontsize',22','XTick',[1:6],'XTickLabel',{'Kyiv','South','East','West','North','Center'})
xlim([0.5 6.5])
title(datestr(Date_Displacement.IDP_Origin(dd),'mmmm dd'))
ytickformat('percentage')
ylabel('Proportion','Fontsize',24)
xlabel('Origin macro-region','Fontsize',24);
box off;
end

print(gcf,'Supplementary_Figure_IDP_Origin_Calibration.png','-dpng','-r300');

figure('units','normalized','outerposition',[0.15 0.15 0.5 0.5]);
subplot('Position',[0.167372881355932,0.212527964205817,0.820974576271186,0.753914988814318]);
model_est=zeros(NS,length(Date_Displacement.Proportion_IDP_Female),1);
for dd=1:length(Date_Displacement.Proportion_IDP_Female)
    model_est(:,dd)=100.*Daily_IDP_Female(:,Time_Sim==Date_Displacement.Proportion_IDP_Female(dd));
end
b=bar([1:length(Date_Displacement.Proportion_IDP_Female)],model_est); hold on
for ii=1:8
    b(ii).EdgeColor=b(ii).FaceColor;
   if(daics(ii)~=0)
       b(ii).FaceColor=[1 1 1];
       b(ii).LineStyle='-.';
       b(ii).LineWidth=1.5;
   end
end
for ii=1:length(Date_Displacement.Proportion_IDP_Female)
    plot(ii+[-0.5 0.5],100.*Number_Displacement.Proportion_IDP_Female(ii).*ones(2,1),'k','LineWidth',2);
end
set(gca,'linewidth',2,'tickdir','out','fontsize',22','XTick',[1:length(Date_Displacement.Proportion_IDP_Female)],'XTickLabel',{datestr(Date_Displacement.Proportion_IDP_Female)})
xlim([0.5 length(Date_Displacement.Proportion_IDP_Female)+0.5])
ytickformat('percentage')
ylim([0 100]);
ylabel({'Percentage of IDPs','that are female'},'Fontsize',24)
xlabel('Date','Fontsize',24);
box off;
print(gcf,'Supplementary_Figure_IDP_Female_Calibration.png','-dpng','-r300');

figure('units','normalized','outerposition',[0 0.05 1 1]);
for dd=1:4
    switch dd
        case 1
            subplot('Position',[0.06,0.60 0.43 0.35]);
            text(-0.134326200116974,1.085282445865074,'A','Units','normalized','Fontsize',40,'FontWeight','bold');
        case 2
            subplot('Position',[0.55,0.60 0.43 0.35]);
            text(-0.134326200116974,1.085282445865074,'B','Units','normalized','Fontsize',40,'FontWeight','bold');
        case 3
            subplot('Position',[0.06,0.1 0.43 0.35]);
            text(-0.134326200116974,1.085282445865074,'C','Units','normalized','Fontsize',40,'FontWeight','bold');
        case 4
            subplot('Position',[0.55,0.1 0.43 0.35]);
            text(-0.134326200116974,1.085282445865074,'D','Units','normalized','Fontsize',40,'FontWeight','bold');
    end
datas=100.*[Number_Displacement.Proportion_IDP_Age(dd,:)];

model_est=100.*[Daily_IDP_Age_18_29(:,Time_Sim==Date_Displacement.IDP_Origin(dd)) Daily_IDP_Age_30_39(:,Time_Sim==Date_Displacement.IDP_Origin(dd)) Daily_IDP_Age_40_49(:,Time_Sim==Date_Displacement.IDP_Origin(dd)) Daily_IDP_Age_Over_50(:,Time_Sim==Date_Displacement.IDP_Origin(dd))];
b=bar([1:length(Date_Displacement.Proportion_IDP_Female)],model_est); hold on
for ii=1:8
    b(ii).EdgeColor=b(ii).FaceColor;
   if(daics(ii)~=0)
       b(ii).FaceColor=[1 1 1];
       b(ii).LineStyle='-.';
       b(ii).LineWidth=1.5;
   end
end
for ii=1:4
    plot(ii+[-0.5 0.5],[datas(ii) datas(ii)],'k','LineWidth',2);
end

set(gca,'linewidth',2,'tickdir','out','fontsize',22','XTick',[1:4],'XTickLabel',{'18-29','30-39','40-49','50+'})
xlim([0.5 4.5])
ylim([0 60]);
title(datestr(Date_Displacement.Proportion_IDP_Age(dd),'mmmm dd'))
ytickformat('percentage')
ylabel('Proportion','Fontsize',24)
xlabel('Age class','Fontsize',24);
box off;
end

print(gcf,'Supplementary_Figure_IDP_Age_Calibration.png','-dpng','-r300');