clear;
load('IDP_Fit_Inputs.mat');
% Pop_Raion_T=log(Pop_Raion)-min(log(Pop_Raion));
SCI_IDPt=max(log10(SCI_IDP(:)))-log10(SCI_IDP);

Raion_Conflict_M=zeros(length(Raion_Conflict(:,1)),length(Raion_Index),length(Raion_Conflict(1,:)));
for dd=1:length(Raion_Conflict(1,:))
    Raion_Conflict_pix=Raion_Conflict_M(Raion_Index,dd)';
    Raion_Conflict_M(:,:,dd)=(repmat(Raion_Conflict_pix,length(Raion_Conflict_M(:,dd)),1)-repmat(Raion_Conflict(:,dd),1,length(Raion_Index)))+1;
end

Pop_Raion_pix=Pop_Raion(Raion_Index)';
Pop_Raion_M=(repmat(Pop_Raion,1,length(Pop_Raion_pix))./repmat(Pop_Raion_pix,length(Pop_Raion),1));
T=readtable('idp_estimation_08_03_2022-unhcr-protection-cluster.xlsx','Sheet','Dataset');



Lat_IDP=T.YLatitude;
Lon_IDP=T.XLongitude;
Zone=T.IDPLocationCluster;

S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);

Raion_Zone_R=zeros(length(S2),1);
for ii=1:length(S2)
    [p_in]=inpolygon(Lon_IDP,Lat_IDP,S2(ii).Lon,S2(ii).Lat);
    if(sum(p_in)>0)
        Raion_Zone_R(ii)=median(Zone(p_in));
    end
    if((Raion_IDP(ii)>0) && (Raion_Zone_R(ii)==0))
       d=zeros(length( Lon_IDP));
       parfor jj=1:length(d)
           d(jj)=min(deg2km(distance('gc',Lon_IDP(jj),Lat_IDP(jj),S2(ii).Lon,S2(ii).Lat)));
       end
       Raion_Zone_R(ii)=median(Zone(d==min(d)));
    end
end

load('Kernel_Paremeter_IDP_Non_Zero_Raion.mat','Parameter_IDP');




for dd=1:length(Pop_IDP_R(1,:))
    [w_Location]=Estimate_IDP_Displacement(Parameter_IDP,Pop_Raion_M(Raion_IDP>0,:),SCI_IDPt(Raion_IDP>0,:),Raion_Dist_BC(Raion_IDP>0,:),Num_BC(Raion_IDP>0),squeeze(Raion_Conflict_M(Raion_IDP>0,:,dd)),DistC(Raion_IDP>0,dd),Dist(Raion_IDP>0,:));
    if(dd==1)
        Est_Raion_IDP=w_Location*Pop_IDP_R(:,dd);
    else
        Est_Raion_IDP=Est_Raion_IDP+w_Location*Pop_IDP_R(:,dd);
    end
end

%     Est_Raion_IDP(Est_Raion_IDP==0)=10^(-16);
%     Raion_IDP(Raion_IDP==0)=10^(-16);
    L=sqrt(sum((Raion_IDP(Raion_IDP>0)-Est_Raion_IDP).^2))./length(Raion_IDP(Raion_IDP>0));
close all;


ColRZ=[hex2rgb('33685b');hex2rgb('6fb98f');hex2rgb('b3c100')];

figure('units','normalized','outerposition',[0. 0.15 1 0.8]);
subplot('Position',[0.057255296484791,0.27756160830090,0.113437980826133,0.695201037613484]);

Raion_Zone_Rnz=Raion_Zone_R(Raion_IDP>0);
Zone_IDP=zeros(length(unique(Raion_Zone_Rnz)),1);
Est_Zone_IDP=zeros(length(unique(Raion_Zone_Rnz)),1);

for ii=1:length(Zone_IDP)
   Zone_IDP(ii)=sum(Raion_IDP(Raion_Zone_R==ii)); 
   Est_Zone_IDP(ii)=sum(Est_Raion_IDP(Raion_Zone_Rnz==ii));
end

bb=bar([1:length(Zone_IDP)],Est_Zone_IDP,'LineStyle','none'); hold on;
bb.FaceColor = 'flat';
bb.CData=ColRZ;
scatter([1:length(Zone_IDP)],Zone_IDP,40,'r','filled');

set(gca,'LineWidth',2,'tickdir','out','Xticklabel',{'Zone 1','Zone 2','Zone 3'},'Fontsize',18,'XTick',[1:3],'YScale','log');
xtickangle(45);
box off
xlim([0.5 3.5]);
ylim([10^2 10^7]);
ylabel('Number of IDP','Fontsize',22);
xlabel('IDP cluster','Fontsize',22);
text(-0.916666681567828,11086033.30572686,0,'A','Fontsize',40,'Fontweight','bold');
subplot('Position',[0.228991596638655,0.27756160830090,0.763130252100837,0.695201037613484]);
[SR,IR]=sort(Raion_IDP(Raion_IDP>0));
bb=bar([1:length(Est_Raion_IDP)],Est_Raion_IDP(IR),'LineStyle','none'); hold on;
scatter([1:length(Est_Raion_IDP)],SR,40,'r','filled');

Raion_Zone_Rt=Raion_Zone_R(Raion_IDP>0);
bb.FaceColor = 'flat';
for ii=1:length(IR)
    bb.CData(ii,:)=ColRZ(Raion_Zone_Rt(IR(ii)),:);
end
box off;

xlim([0.5 length(Est_Raion_IDP)+.5]);
ylim([10^(-7) 10^6]);



S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);
NameX=cell(length(Est_Raion_IDP),1);
S2=S2(Raion_IDP>0);
S2=S2(IR);
for ii=1:length(S2)
    NameX{ii}=S2(ii).NAME_2;
end

set(gca,'LineWidth',2,'tickdir','out','Xticklabel',NameX,'Fontsize',15,'XTick',[1:length(Est_Raion_IDP)],'YScale','log');

xtickangle(45)

ylabel('Number of IDP','Fontsize',22);
xlabel('IDP raion','Fontsize',22,'Position',[30,5.094e-12,0]);
text(-3.410874054613361,1167250.796905481,'B','Fontsize',40,'Fontweight','bold');

print(gcf,['UKR_IDP_Distribution.png'],'-dpng','-r300');