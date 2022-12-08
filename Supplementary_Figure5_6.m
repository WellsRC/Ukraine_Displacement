clear;
close all;

load('FigS5_S6.mat');
Model_Ref=[Model_Est_Poland Model_Est_Slovakia Model_Est_Hungary Model_Est_Romania Model_Est_Belarus Model_Est_Moldova Model_Est_Russia Model_Est_Europe];
Model_IDPs=[Model_Est_Kyiv Model_Est_East Model_Est_West Model_Est_South Model_Est_North Model_Est_Center];


NBC=Refugee_Displacement.Cumulative_Poland(end-1)+Refugee_Displacement.Cumulative_Slovakia(end-1)+Refugee_Displacement.Cumulative_Hungary(end-1)+Refugee_Displacement.Cumulative_Romania(end-1)+Refugee_Displacement.Cumulative_Belarus(end)+Refugee_Displacement.Cumulative_Moldova(end-1)+Refugee_Displacement.Cumulative_Russia(end);
Data_point_Europe=sum(Number_Displacement.Refugee(1:end-1))-NBC;
Data_point=[Refugee_Displacement.Cumulative_Poland(end-1) Refugee_Displacement.Cumulative_Slovakia(end-1)  Refugee_Displacement.Cumulative_Hungary(end-1) Refugee_Displacement.Cumulative_Romania(end-1) Refugee_Displacement.Cumulative_Belarus(end) Refugee_Displacement.Cumulative_Moldova(end-1) Refugee_Displacement.Cumulative_Russia(end) Data_point_Europe];
Data_point_IDP=[IDP_Displacement.Macro.Kyiv(end) IDP_Displacement.Macro.East(end) IDP_Displacement.Macro.West(end) IDP_Displacement.Macro.South(end) IDP_Displacement.Macro.North(end) IDP_Displacement.Macro.Center(end)];
dx=0.45;
Colors=[hex2rgb('#336B87')];
Scatter_Color=[hex2rgb('#8D230F')];

close all;
figure('units','normalized','outerposition',[0.061458333333333,0.185185185185185,0.896354166666667./2,0.708333333333333]);
% Refugee
subplot('Position',[0.177097853359353,0.1875,0.80147058823529,0.796263931104362]);
for ii=1:8
   patch( ii+[-dx -dx dx dx],prctile(Model_Ref(:,ii)./100000,[50 75 75 50]),Colors,'FaceAlpha',0.5,'LineStyle','none'); hold on;
   patch( ii+[-dx -dx dx dx],prctile(Model_Ref(:,ii)./100000,[2.5 97.5 97.5 2.5]),Colors,'FaceAlpha',0.5,'LineStyle','none');
end
MT=median(sum(Model_Ref,2));
hold on
scatter([1:8],(MT./sum(Data_point)).*Data_point./100000,40,Scatter_Color,'filled');
xlim([1-0.7 8+0.7]);
set(gca,'tickdir','out','lineWidth',2,'XTick',[1:8],'XTickLabel',{'Poland','Slovakia','Hungary','Romania','Belarus','Moldova','Russia','Europe'},'Fontsize',22);
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