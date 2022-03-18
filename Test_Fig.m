close all;

figure('units','normalized','outerposition',[0.15 0.15 0.6 0.8]);
subplot('Position',[0.215669014084507,0.121919584954604,0.748239436619718,0.757457846952011]);

Country_Name={'Russian Federation','Poland','Belarus','Slovakia','Hungary','Romania','Moldova','Europe (Other)'};
Disese={'TB';'Drug-resistant TB';'HIV';'HIV Treatment';'Diabetes';'Cancer';'CVD'};
T=[31.2655384013155,20.6024502991574,19.3275828759546,22.2295507246408,0.571187226949940,1.07595394965552,4.92773652232627;16.6420245134146,23.6479851173360,20.1896631026445,17.4323525712421,2.88710010073673,14.6843080620405,4.51656653258559;14.5420060426371,13.1668595009593,18.4308135015296,22.2263614779723,21.5266626183766,9.04301883387218,1.06427802465288;20.2219521585835,11.8922395344880,14.5325512979894,24.3612419797008,12.0106136524006,1.22841411471709,15.7529872621206;20.3833203960749,18.5823283415145,5.72148958013417,17.8328990682867,19.5912303699243,11.3525643832419,6.53616786082354;29.0418217789816,6.69116817396377,19.5709512349963,17.0756061515745,6.14969531236571,5.65354124891377,15.8172160992044;0.0181320479452568,17.2892335925917,2.89775227472633,32.2224559989506,19.1704546384067,4.27233096300313,24.1296404843763;20.0945388252910,20.9168108455588,14.5341025195996,13.4690647007845,14.6252042236377,4.77135020156872,11.5889286835597];

for ii=1:length(Country_Name)
    T(ii,:)= 100.*T(ii,:)./sum(T(ii,:));
end

barh(T);
ylim([0.5 length(Country_Name)+0.5]);
set(gca,'Tickdir','out','linewidth',2,'YTick',[1:length(Country_Name)],'YTicklabel',Country_Name,'Fontsize',18,'XTick',[0:5:55]);
xlim([0 55]);
xtickformat('percentage');

legend(Disese,'Position',[0.801349769718071,0.6142974565058,0.194542249061272,0.254215297493335]);
legend boxoff;
box off;

xlabel('Percetage of disease burden','Fontsize',22);
hold on;
ax1 = gca; % current axes
ax1.XColor = 'k';
ax1.YColor = 'k';
ax1_pos = ax1.Position; % position of first axes

ax2 = axes('Position',ax1_pos,...
    'XAxisLocation','top',...
    'YAxisLocation','left',...
    'Color','none');

Ref_Num=[105897 1575703 938 185673 235576 84671 104929 304156];


line(Ref_Num,[1:length(Country_Name)],'Parent',ax2,'Color',[0.5 0.5 0.5],'LineWidth',2)
ylim([0.5 length(Country_Name)+0.5]);
xlim([1 10^7]);
set(ax2,'LineWidth',2,'tickdir','out','XScale','log','YTick',[1:length(Country_Name)],'YTickLabel',{},'Fontsize',18);
ax2.XColor=[0.5 0.5 0.5];
xlabel('Number of refugees','Fontsize',22,'Color',[0.5 0.5 0.5]);
ylabel('Country','Fontsize',22,'Position',[0.023425359784182,mean([1 length(Country_Name)]),-1]);