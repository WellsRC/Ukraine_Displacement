clear;
close all;
clc;
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % Load data and determine the dispacement per day
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% 
LoadData;
% 
load('Kernel_Paremeter.mat','Parameter');

load('Conflict_Colourmap.mat','conflict_map');
load('Health_Colourmap.mat','health_map');

% National disease burden, raion mortality
load('UKR_Disease_Burden.mat');

PopTotal=Ukraine_Pop.population_size;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % Determine the disease burden
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

Disease_Short={'TB';'TB_DR';'HIV';'HIV_T';'Diabetes';'Cancer';'CVD'};
Prob_DB=ones(length(PopTotal),length(Disease_Short));
for dd=1:length(Disease_Short)

    tf=strcmp(Disease_Short{dd},DB_UKR.Disease);

    prev=DB_UKR.Cases(tf);


    DB_temp=Disease_Distribution(Disease_Short{dd},Ukraine_Pop.map_raion,true,PopTotal); % Want to consider the males 20-59
    DB_temp=DB_temp+Disease_Distribution(Disease_Short{dd},Ukraine_Pop.map_raion,false,PopTotal); % Do not want to consider the males 20-59
    
    DB_temp=1-DB_temp./PopTotal;
    
    Prob_DB(:,dd)=DB_temp;
end

Prob_DB=1-prod(Prob_DB,2);

Prob_DB=(Prob_DB-min(Prob_DB))./(max(Prob_DB)-min(Prob_DB));

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % Plot remaining disease burden
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5



S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);
figure('units','normalized','outerposition',[0. 0. 1 1]);

scatter(Lon_P,Lat_P,5,Prob_DB,'filled');
colormap(health_map);
caxis([0 1]);
hold on
geoshow(S2,'FaceColor','none','LineWidth',1.5);

box off;
set(gca, 'visible', 'off');



print(gcf,['UKR_Prob_Disease_Burden.png'],'-dpng','-r300');
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % Conflict
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

load('Grid_points_UKR.mat');


[longitude_v,latitude_v]=meshgrid(longitude,latitude);
LonC=cell2mat(vLon_C);
LatC=cell2mat(vLat_C);
P=zeros(length(latitude_v(:)),length(vLon_C));
PCt=ones(length(latitude_v(:)),1);
PC=zeros(length(latitude_v(:)),length(vLon_C));
for jj=1:length(vLon_C)
    P= Kernel_Displacement(vLat_C{jj},vLon_C{jj},latitude_v(:),longitude_v(:),Parameter);
    PCt=PCt.*(1-P);    
    Pt=Parameter.w.*P+(1-Parameter.w).*Parameter.ScaleC.*(1-PCt);
    PC(:,jj)=Pt;
end


BC=readtable('ukr_border_crossings_170322.xlsx','Sheet','Border Crossings');

bc_lat=BC.Lat;
bc_lon=BC.Long;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Plot map of conflict
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5


figure('units','normalized','outerposition',[0. 0. 1 1]);

S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);

Ps=reshape(1-prod(1-PC,2),length(latitude),length(longitude));
Ps(~tp_UKR)=0;
contourf(longitude,latitude,log10(Ps),'LineStyle','none');
hold on
geoshow(S2,'FaceColor','none','LineWidth',1.5);
colormap(conflict_map);

scatter(bc_lon,bc_lat,100,hex2rgb('#FFBB00'),'filled');
box off;
set(gca, 'visible', 'off');


print(gcf,['UKR_Conflict_Displacement.png'],'-dpng','-r300');


clear;
clc;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Load data and determine the dispacement per day
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
LoadData;

load('Kernel_Paremeter.mat','Parameter');
load('Refugee_Country_Distribution_Parameters.mat');

[Pop_Displace_Day,Pop_Displace]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Lat_P,Lon_P,Pop,false);

Displace_Pop=sum(Pop_Displace,2);
Pop_Remain=Pop-Displace_Pop;

[Total_Burden_Refugee,Total_Burden_UKR] = Disease_Burden_Displacement(Displace_Pop,Pop_Male,Pop_Remain,Ukraine_Pop,lambda_sci,sc_GDP,lambda_bc,sc_bc,s_nato,lambda_GDP,Border_Crossing_Country);

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

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % Plot Disease Country
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

figure('units','normalized','outerposition',[0.15 0.15 0.6 0.8]);
subplot('Position',[0.215669014084507,0.121919584954604,0.748239436619718,0.862516212710766]);

Country_Namev={'Russian Federation','Poland','Belarus','Slovakia','Hungary','Romania','Moldova','Europe (Other)'};
Disesev={'All refugees';'TB';'Drug-resistant TB';'HIV';'HIV Treatment';'Diabetes';'Cancer';'CVD'};

T=Total_Burden_Refugee.Cases;
Tv=reshape(T,length(Country_Namev),length(Disesev));

[Ts,srt_indx]=sortrows(Tv,1);
[Tsc,srt_dindx]=sortrows(Ts',1);
Country_Name=Country_Namev(srt_indx);
Disese=Disesev(srt_dindx);
T=Tsc';
Ref_Num=[105897 1575703 938 185673 235576 84671 104929 304156];


bb=barh(T);
bb(8).FaceColor='k';
ylim([0.5 length(Country_Name)+0.5]);
set(gca,'Tickdir','out','linewidth',2,'YTick',[1:length(Country_Name)],'YTicklabel',Country_Name,'Fontsize',18,'XSCale','log','XTick',10.^[0:7]);

hold on;
scatter(Ref_Num(srt_indx),[1:length(Country_Name)]+0.365,40,'r','filled');
% xtickformat('percentage');

legend(flip(bb),flip(Disese),'Location','SouthEast');
legend boxoff;
box off;
ylabel('Country','Fontsize',22,'Position',[0.007661920010631,4.909022709122278]);
xlabel('Number of Refugees','Fontsize',22);
xlim([0.5 10^7.5]);

print(gcf,['Refugee_Disease_Distribution.png'],'-dpng','-r300');