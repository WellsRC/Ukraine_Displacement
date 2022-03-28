% clear;
% clc;
% 
% load('IDP_Fit_Inputs.mat','Pop_Raion','Raion_IDP');
% 
% T=readtable('idp_estimation_08_03_2022-unhcr-protection-cluster.xlsx','Sheet','Dataset');
% 
% 
% 
% Lat_IDP=T.YLatitude;
% Lon_IDP=T.XLongitude;
% Zone=T.IDPLocationCluster;
% 
% clear T Ukraine_Pop;
% 
% S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);
% 
% Raion_Zone_R=zeros(length(S2),1);
% for ii=1:length(S2)
%     [p_in]=inpolygon(Lon_IDP,Lat_IDP,S2(ii).Lon,S2(ii).Lat);
%     if(sum(p_in)>0)
%         Raion_Zone_R(ii)=median(Zone(p_in));
%     end
%     if((Raion_IDP(ii)>0) && (Raion_Zone_R(ii)==0))
%        d=zeros(length( Lon_IDP));
%        parfor jj=1:length(d)
%            d(jj)=min(deg2km(distance('gc',Lon_IDP(jj),Lat_IDP(jj),S2(ii).Lon,S2(ii).Lat)));
%        end
%        Raion_Zone_R(ii)=median(Zone(d==min(d)));
%     end
% end
% 
% DiseaseBudren=[0.15 0.03 5.*10^(-3) 3.*10^(-3) 10^(-3) 6.*10^(-4) 10^(-4)];
% 
% 
% Pop_Raion=Pop_Raion(Raion_IDP>0);
% Raion_IDP=Raion_IDP(Raion_IDP>0);
% Raion_Zone_R=Raion_Zone_R(Raion_IDP>0);
% 
% Non_IDP=zeros(length(Pop_Raion),length(DiseaseBudren));
% IDP=zeros(length(Pop_Raion),length(DiseaseBudren));
% for ii=1:length(DiseaseBudren)
%     Non_IDP(:,ii)=binornd(round(Pop_Raion),DiseaseBudren(ii));
%     IDP(:,ii)=binornd(round(Raion_IDP),DiseaseBudren(ii));
% end
% 
% Zone_Non_IDP=zeros(3,length(DiseaseBudren));
% Zone_IDP=zeros(3,length(DiseaseBudren));
% for ii=1:length(DiseaseBudren)
%     for jj=1:3
%         Zone_IDP(jj,ii)=sum(IDP(Raion_Zone_R==jj,ii));
%         Zone_Non_IDP(jj,ii)=sum(Non_IDP(Raion_Zone_R==jj,ii));
%     end
% end
    

figure('units','normalized','outerposition',[0.15 0.15 0.6 0.8]);
subplot('Position',[0.119718309859155,0.121919584954604,0.84419014084507,0.862516212710766]);
Country_Namev={'Zone 1','Zone 2','Zone 3'};
Disesev={'CVD';'Diabetes';'Cancer';'HIV';'HIV Treatment';'TB';'Drug-resistant TB'};
Zone=Zone_IDP+Zone_Non_IDP;


Country_Name=Country_Namev(srt_indx);
Disese=Disesev(srt_dindx);

[Ts,srt_indx]=sortrows(Zone,1);
[Tsc,srt_dindx]=sortrows(Ts',1);
Zone_Non_IDP_T=Zone_Non_IDP(srt_indx,:)';
Zone_Non_IDP_T2=Zone_Non_IDP_T(srt_dindx,:)';

T=Tsc';
bb=barh(T,'LineWidth',2);
hold on;
hh=barh(Zone_Non_IDP_T2,'LineStyle','none');

for ii=1:length(bb)
    bb(ii).FaceAlpha=0;
    bb(ii).EdgeColor=bb(ii).FaceColor;
    hh(ii).FaceAlpha=1;
end

box off;

ylim([0.5 length(Country_Name)+0.5]);
xlim([1 10^6]);
set(gca,'Tickdir','out','linewidth',2,'YTick',[1:length(Country_Name)],'YTicklabel',Country_Name,'Fontsize',18,'XSCale','log','XTick',10.^[-1:6]);
xlabel('Number of people','Fontsize',22);
ylabel('IDP Cluster','Fontsize',22);
% close all;
% 
% S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);
% T=readtable('idp_estimation_08_03_2022-unhcr-protection-cluster.xlsx','Sheet','Dataset');
% 
% date_IDP=datenum('March 8, 2022');
% 
% Lat_IDP=T.YLatitude;
% Lon_IDP=T.XLongitude;
% IDP_Num=T.IDPEstimation;
% 
% Map_IDP=zeros(length(S2),1);
% 
% for ii=1:length(Map_IDP)
%     [p_in,p_on]=inpolygon(Lon_IDP,Lat_IDP,S2(ii).Lon,S2(ii).Lat);
%     Map_IDP(ii)=sum(IDP_Num(p_in|p_on));
%     IDP_Num(p_in|p_on)=0;
% end
% 
% for ii=1:length(IDP_Num)
%     if(IDP_Num(ii)>0)
%         d=zeros(length(S2),1);
%         for jj=1:length(S2)
%             d(jj)=min(deg2km(distance('gc',Lat_IDP(ii),Lon_IDP(ii),S2(jj).Lat,S2(jj).Lon))); 
%         end
%         Map_IDP(d==min(d))=IDP_Num(ii)./sum(d==min(d));
%         IDP_Num(ii)=0;
%     end 
% end
% 
% figure('units','normalized','outerposition',[0. 0. 1 1]);
% Map_IDPt=log10(Map_IDP);
% Map_IDPt(Map_IDP==0)=-1;
% Map_IDPt=(Map_IDPt-min(Map_IDPt))./(max(Map_IDPt)-min(Map_IDPt));
% for ii=1:length(S2)
%    geoshow(S2(ii),'FaceColor',hex2rgb('07575B'),'FaceAlpha',Map_IDPt(ii),'LineWidth',2); hold on
% end