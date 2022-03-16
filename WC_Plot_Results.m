clear;
close all;
load('UKR_output.mat');

CC=[hex2rgb('#1b9e77');
hex2rgb('#d95f02');
hex2rgb('#7570b3');
hex2rgb('#e7298a');
hex2rgb('#66a61e');
hex2rgb('#e6ab02');
hex2rgb('#a6761d');
hex2rgb('#666666');];
CCv=repmat(CC,7,1);

figure('units','normalized','outerposition',[0.0 0.025 0.6 0.6]);

Temp=Total_Burden_Refugee;
Temp=Temp(9:end,:);
Temp.Cases=log10(Temp.Cases);
Temp.Cases=Temp.Cases-min(Temp.Cases);
wordcloud(Temp,'Refugee_State','Cases','Color',CCv);

print(gcf,['UKR_Refugee_WC.png'],'-dpng','-r300');


figure('units','normalized','outerposition',[0.0 0.025 0.6 0.6]);

dx=[0.495 0.715];
dy=[0.57 0.98];
plot(dx,[dy(1) dy(1)],'k','LineWidth',2); hold on
plot(dx,[dy(2) dy(2)],'k','LineWidth',2); hold on
plot([dx(1) dx(1)],dy,'k','LineWidth',2); hold on
plot([dx(2) dx(2)],dy,'k','LineWidth',2); hold on
for ii=1:length(CC(:,1))
    text(0.5,1-0.05.*(ii),Temp.Country{ii},'Fontsize',18,'Color',CC(ii,:)); hold on
    
end

box off;
xlim([0 1]);
ylim([0 1]);

print(gcf,['UKR_Refugee_WC_Legend.png'],'-dpng','-r300');

