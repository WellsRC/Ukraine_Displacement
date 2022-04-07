clear;
clc;
H=shaperead('Health/hotosm_ukr_health_facilities_points.shp','UseGeoCoords',true);

N={H.amenity};
tfh=strcmp(N,'hospital')|strcmp(N,'cancer');
H=H(tfh);

HLon=[H.Lon];
HLat=[H.Lat];


LoadData;

load('Kernel_Paremeter.mat','Parameter');

nDays=length(vLat_C);
PC=ones(length(HLon),1);
PC_IDP=ones(length(HLon),1);
PC_Con=ones(length(cell2mat(vLat_C)),1);
PC2=ones(length(cell2mat(vLat_C)),1);


for jj=1:nDays    
    P = Kernel_Displacement(vLat_C{jj},vLon_C{jj},HLat,HLon,Parameter);
    PC=PC.*(1-P);
    Ptemp=(Parameter.w.*P+(1-Parameter.w).*Parameter.Scale.*(1-PC));
    PC_IDP=PC_IDP.*(1-Ptemp);
    
    
    P = Kernel_Displacement(vLat_C{jj},vLon_C{jj},cell2mat(vLat_C),cell2mat(vLon_C),Parameter);
    PC2=PC2.*(1-P);
    Ptemp=(Parameter.w.*P+(1-Parameter.w).*Parameter.Scale.*(1-PC2));
    PC_Con=PC_Con.*(1-Ptemp);
end

PC_IDP=1-PC_IDP;
PC_Con=1-PC_Con;
% 
HLonNCZ=HLon(PC_IDP==0);
HLatNCZ=HLat(PC_IDP==0);
PC_IDP=PC_IDP./max(PC_Con);


S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);

load('Input_Figure3D.mat');



Disease_Short={'TB';'TB_DR';'HIV';'HIV_T';'Diabetes';'Cancer';'CVD'};
Pre_WAR_Disease=zeros(3,length(Disease_Short)+1);

WAR_Disease=zeros(3,length(Disease_Short)+1);
TempC=Total_Burden_IDP.Cases;

for dd=0:length(Disease_Short)
    if(dd>0)
        temp=Disease_Distribution(Disease_Short{dd},Mapped_Raion_Name,false,Pop_Total_R)+Disease_Distribution(Disease_Short{dd},Mapped_Raion_Name,true,Pop_Total_R);
    else
        temp=Pop_Total_R;
    end
    for ii=1:3
        Pre_WAR_Disease(ii,dd+1)=sum(temp(Raion_Zone_Full==ii));
        WAR_Disease(ii,dd+1)=sum(TempC([1:3]+3.*(ii-1)+9.*dd));
    end
   
end
% 
 S2=S2(Raion_IDP>0);
 Raion_Zone_R=Raion_Zone_R(Raion_IDP>0);
Raion_Hosp=zeros(length(S2),1);
Raion_Hosp_Weigthed=zeros(length(S2),1);
parfor ii=1:length(Raion_Hosp)
   [p_in,p_on]=inpolygon(HLon,HLat,S2(ii).Lon,S2(ii).Lat);
   Raion_Hosp(ii)=sum(p_in)+sum(p_on);
   Raion_Hosp_Weigthed(ii)=sum(p_in)+sum(p_on)-sum(PC_IDP(p_in|p_on));
end

Hosp_Zone=zeros(3,1);
Hosp_Zone_Weighted=zeros(3,1);
for ii=1:3
    Hosp_Zone(ii)=sum(Raion_Hosp(Raion_Zone_R==ii));
    Hosp_Zone_Weighted(ii)=sum(Raion_Hosp_Weigthed(Raion_Zone_R==ii));
end

close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Comparison of disease change
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

Pre_HC=(Pre_WAR_Disease)';

Current_HC=(WAR_Disease)';
[test,indxS]=sortrows(Current_HC);
Disesev={'All';'TB';'Drug-resistant TB';'HIV';'HIV Treatment';'Diabetes';'Cancer';'CVD'};

R=100.*(Current_HC./Pre_HC-1);
R=flip(R);
R=(R');
Rt=R(:,indxS);
Disese=Disesev(indxS);
figure('units','normalized','outerposition',[0.15 0.15 0.6 0.8]);
subplot('Position',[0.119718309859155,0.121919584954604,0.848591549295775,0.875992217898833]);

bb=barh(Rt,'LineStyle','none');
bb(8).FaceColor='k';
legend(flip(bb),flip(Disese),'Location','Northoutside','NumColumns',4);
legend boxoff;
ylim([0.5 3.5]);
xlim([-10 65])
box off;
xtickformat('percentage');
set(gca,'Tickdir','out','linewidth',2,'YTick',[1:3],'YTickLabel',{'Zone 1','Zone 2','Zone 3'},'Fontsize',18,'XTick',[-10:5:65]);
xlabel('Percent change in population','Fontsize',22);
ylabel('IDP cluster','Fontsize',22)
text(-19.958,3.78,'A','FontSize',30,'FontWeight','bold');
print(gcf,['Change_in_Disease.png'],'-dpng','-r300');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Assume only hospitals in non-conflict areas functional
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

Pre_HC=[Hosp_Zone; length(PC_IDP)];

Current_HC=[Hosp_Zone_Weighted; length(PC_IDP)-sum(PC_IDP)];

figure('units','normalized','outerposition',[0.15 0.15 0.6 0.8]);
subplot('Position',[0.108274647887324,0.121919584954604,0.867957746478873,0.862516212710766]);
bar(100.*(1-Current_HC./Pre_HC),'k','LineStyle','none');
ylim([0 60]);
xlim([0.5 4.5]);
set(gca,'Tickdir','out','linewidth',2,'YTick',[0:10:60],'Fontsize',18,'XTick',[1:4],'XTickLabel',{'Zone 1','Zone 2','Zone 3','Ukraine'});
xlabel('Location','Fontsize',22);
ylabel('Percent reduction','Fontsize',22)
ytickformat('percentage');
box off;

text(0,59.90,'A','FontSize',30,'FontWeight','bold');
print(gcf,['IDP_Zone_Reduction_Hospital.png'],'-dpng','-r300');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Assume only hospitals in non-conflict areas functional
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

Pre_HC=Pre_WAR_Disease./repmat(Hosp_Zone,1,8);

Current_HC=WAR_Disease./repmat(Hosp_Zone_Weighted,1,8);


Disesev={'All';'TB';'Drug-resistant TB';'HIV';'HIV Treatment';'Diabetes';'Cancer';'CVD'};

R=100.*(Current_HC./Pre_HC-1);
Rt=R(:,indxS);
Disese=Disesev(indxS);
figure('units','normalized','outerposition',[0.15 0.15 0.6 0.8]);
subplot('Position',[0.119718309859155,0.121919584954604,0.848591549295775,0.875992217898833]);

bb=barh(R,'LineStyle','none');
bb(8).FaceColor='k';
legend(flip(bb),flip(Disese),'Location','Northoutside','NumColumns',4);
legend boxoff;
ylim([0.5 3.5]);
xlim([0 130]);
xtickformat('percentage');
set(gca,'Tickdir','out','linewidth',2,'YTick',[1:3],'YTickLabel',{'Zone 1','Zone 2','Zone 3'},'Fontsize',18,'XTick',[0:10:130]);
xlabel('Percent increase in people per hospital','Fontsize',22);
ylabel('IDP cluster','Fontsize',22)
box off;
text(-17.53,3.78,'D','Fontsize',30,'FontWeight','bold');
print(gcf,['Hospital_Burden_Weighted_Conflict_Functional_Alternative.png'],'-dpng','-r300');