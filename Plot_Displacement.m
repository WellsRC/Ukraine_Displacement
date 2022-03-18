clear;
close all;
clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Load data and determine the dispacement per day
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
LoadData;

load('Kernel_Paremeter.mat','Parameter');

[Pop_Displace_Day,Pop_Displace]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Lat_P,Lon_P,Pop);
figure('units','normalized','outerposition',[0.15 0.15 0.6 0.8]);
subplot('Position',[0.087147887323944,0.224383916990921,0.900528169014085,0.765239948119325]);
bar(Pop_Displace_Day./10000,'k');
hold on
scatter([1:length(Number_Displacement)],Number_Displacement./10000,60,'r','filled');
box off;
XTL=datestr(Date_Displacement');
set(gca,'LineWidth',2,'tickdir','out','Xticklabel',XTL,'Fontsize',18,'XTick',[1:length(Number_Displacement)])
xtickangle(45);
xlim([0.5 length(Number_Displacement)+0.5]);
ylim([0 22]);

ylabel('Daily number Ukrainian refugees (10,000)','Fontsize',22);
xlabel('Date','Fontsize',22);

print(gcf,['Daily_Refugee_Fit.png'],'-dpng','-r300');