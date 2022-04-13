% % % % ENSURE TO RUN Scrape_IDP_Inputs

clear;
clc;
% 
% LoadData;
% 
% load('Kernel_Paremeter.mat','Parameter');
% 
% 
% [Pop_Displace_Day,Pop_Displace]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Lat_P,Lon_P,Pop,false);
% 
% Displace_Pop=sum(Pop_Displace,2);
% Pop_Remain=Pop-Displace_Pop;
% 
% load('Grid_points_UKR_Fewer.mat')
% [longitude_v,latitude_v]=meshgrid(longitude,latitude);
% longitude_v=longitude_v(tp_UKR);
% latitude_v=latitude_v(tp_UKR);
% 
% S1=shaperead('UKR_ADM_1\UKR_adm1.shp','UseGeoCoords',true);
% 
% S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);
% 
% % Determine the scalining factor for the overall number of IDP
% nDays=length(vLat_C);
% PC=ones(length(Lon_P),1);
% PC_IDP=ones(length(Lon_P),nDays);
% 
% for jj=1:nDays    
%     P = Kernel_Displacement(vLat_C{jj},vLon_C{jj},Lat_P,Lon_P,Parameter);
%     PC=PC.*(1-P);
%     Ptemp=(Parameter.w.*P+(1-Parameter.w).*Parameter.Scale.*(1-PC));
%     PC_IDP(:,jj)=Ptemp;
% end
% 
% 
% load('Scale_Conflict_Fucntion_IDP.mat','ScaleConflict');
% 
% f_nz=find((1-prod(1-ScaleConflict.*PC_IDP,2)).*Pop_Remain>0);
% 
% 
% load('IDP_Fit_Inputs.mat','Pop_Raion','SCI_IDP','Raion_IDPSites','Dist','Raion_IDP','Raion_Index','Raion_Dist_BC','Num_BC','Pop_IDP_R');
% n_start=length(Pop_IDP_R(1,:))+1;
% Pop_IDP_R=[Pop_IDP_R zeros(length(Pop_IDP_R(:,1)),nDays-length(Pop_IDP_R(1,:)))];
% PC_IDPt=ScaleConflict.*PC_IDP;
% Pop_Remaint=Pop_Remain;
% for dd=1:(n_start-1)
%     Pop_IDP=PC_IDPt(:,dd).*Pop_Remaint;
%     Pop_Remaint=Pop_Remaint-Pop_IDP;
% end
% 
% min_d_index=cell(length(latitude_v),2);
% for ii=1:length(f_nz)
%    d=deg2km(distance('gc',Lat_P(f_nz(ii)),Lon_P(f_nz(ii)),latitude_v,longitude_v));
%    fd=find(d==min(d));
%    for jj=1:length(fd)
%        min_d_index{fd(jj),1}=[min_d_index{fd(jj),1} f_nz(ii)];
%        min_d_index{fd(jj),2}=[min_d_index{fd(jj),2} 1./length(fd)];
%    end
% end
% 
% for dd=n_start:nDays
%     Pop_IDP=PC_IDPt(:,dd).*Pop_Remaint;
%     Pop_Remaint=Pop_Remaint-PC_IDPt(:,dd).*Pop_Remaint;
%     parfor ii=1:length(latitude_v)        
%        Pop_IDP_R(ii,dd)=sum(min_d_index{ii,2}'.*Pop_IDP(min_d_index{ii,1}));
%     end
% end
% 
% 
% Raion_Conflict=zeros(length(S2),nDays);
% for dd=1:nDays
%     for ii=1:length(S2)   
%         temp=1-prod(1-PC_IDP(:,1:dd),2);
%         Raion_Conflict(ii,dd)=mean(temp(strcmp(Ukraine_Pop.raion,S2(ii).NAME_2)));
%     end
% end
% DistC=zeros(length(S2),nDays);
% for jj=1:length(S2)
%     for kk=1:length(vLat_C)
%         cLon=vLon_C{kk};
%         cLat=vLat_C{kk};
%         temp=zeros(1,(length(cLat)));
%         parfor zz=1:length(cLon)
%             temp(zz)=min(deg2km(distance('gc',cLat(zz),cLon(zz),S2(jj).Lat,S2(jj).Lon)));                   
%         end
%         [p_in]=inpolygon(cLon,cLat,S2(jj).Lon,S2(jj).Lat);
%         if(sum(p_in)==0)
%             DistC(jj,kk,dd)=min(temp);
%         end
%     end
% end
% 
% 
% 
% 
% Mapped_Names=readtable('mapped_data.csv');
% 
% Mapped_Raion_Name=cell(length(Pop_IDP_R(:,1)),1);
% parfor ii=1:length(Mapped_Raion_Name)
%     tfmn=strcmp(S2(Raion_Index(ii)).HASC_2,Mapped_Names.HASC_2) & strcmp(S2(Raion_Index(ii)).NAME_2,Mapped_Names.NAME_2);
%     if(sum(tfmn)>0)
%         NN=Mapped_Names.DistrictName{tfmn};
%         Mapped_Raion_Name(ii)={NN};
%     else
%         Mapped_Raion_Name(ii)={'N/A'};
%     end
% end
% 
% 
% T=readtable('idp_estimation_08_03_2022-unhcr-protection-cluster.xlsx','Sheet','Dataset');
% 
% 
% 
% Lat_IDP=T.YLatitude;
% Lon_IDP=T.XLongitude;
% Zone=T.IDPLocationCluster;
% 
% clear Mapped_Names;
% % 
% 
% Raion_Zone_R=zeros(length(S2),1);
% for ii=1:length(S2)
%     if(Raion_IDP(ii)>0)
%         [p_in]=inpolygon(Lon_IDP,Lat_IDP,S2(ii).Lon,S2(ii).Lat);
%         if(sum(p_in)>0)
%             Raion_Zone_R(ii)=median(Zone(p_in));
%         end
%         if((Raion_IDP(ii)>0) && (Raion_Zone_R(ii)==0))
%            d=zeros(length( Lon_IDP));
%            parfor jj=1:length(d)
%                d(jj)=min(deg2km(distance('gc',Lat_IDP(jj),Lon_IDP(jj),S2(ii).Lat,S2(ii).Lon)));
%            end
%            Raion_Zone_R(ii)=median(Zone(d==min(d)));
%         end
%     end
% end
% 
% Raion_Zone_Full=Raion_Zone_R(Raion_Index);
% 
% 
% load('Reduced_Grid_Popultaion_Total_UKR.mat','Pop_Remain_R','Pop_Total_R','Pop_Male_R');
% Pop_Non_IDP=Pop_Remain_R-sum(Pop_IDP_R,2);
% 
% 
% 
% load('Kernel_Paremeter_IDP_Non_Zero_Raion.mat','Parameter_IDP');
% % 
% SCI_IDPt=max(log10(SCI_IDP(:)))-log10(SCI_IDP);
% 
% Raion_Conflict_M=zeros(length(Raion_Conflict(Raion_IDP>0,1)),length(Raion_Index),length(Raion_Conflict(1,:)));
% for dd=1:length(Raion_Conflict(1,:))
%     Raion_Conflict_pix=Raion_Conflict(Raion_Index,dd)';
%     
%     test=(repmat(Raion_Conflict_pix,length(Raion_Conflict_M(:,dd)),1));
%     test2=repmat(Raion_Conflict(Raion_IDP>0,dd),1,length(Raion_Index));
%     Raion_Conflict_M(:,:,dd)=test-test2+1;
% end
% 
% Pop_Raion_pix=Pop_Raion(Raion_Index)';
% Pop_Raion_M=(repmat(Pop_Raion,1,length(Pop_Raion_pix))./repmat(Pop_Raion_pix,length(Pop_Raion),1));
% 
% 
% [Total_Burden_IDP] = Disease_Burden_Displacement_IDP(Pop_Non_IDP,Pop_IDP_R,Pop_Male_R,Pop_Total_R,Mapped_Raion_Name,Parameter_IDP,Pop_Raion_M(Raion_IDP>0,:),SCI_IDPt(Raion_IDP>0,:),Raion_Dist_BC(Raion_IDP>0,:),Num_BC(Raion_IDP>0),Raion_Conflict_M,DistC(Raion_IDP>0,:),Dist(Raion_IDP>0,:),Raion_Zone_R(Raion_IDP>0),Raion_Zone_Full);
% save('Input_Figure3D.mat','Raion_Index','Total_Burden_IDP','Pop_Non_IDP','Pop_Male_R','Pop_IDP_R','Pop_Total_R','Mapped_Raion_Name','Parameter_IDP','Pop_Raion_M','SCI_IDPt','Raion_IDPSites','Raion_Dist_BC','Num_BC','Raion_Conflict','DistC','Dist','Raion_Zone_R','Raion_IDP','Raion_Zone_Full');

load('Input_Figure3D.mat')
Zone_Non_IDP=reshape(Total_Burden_IDP.Cases(10:3:end),3,7);
Zone_IDP=reshape(Total_Burden_IDP.Cases(11:3:end),3,7);

close all;
figure('units','normalized','outerposition',[0.15 0.15 0.6 0.8]);
subplot('Position',[0.119718309859155,0.121919584954604,0.851232394366197,0.862516212710766]);
Country_Namev={'Zone 1','Zone 2','Zone 3'};
Disesev={'TB';'Drug-resistant TB';'HIV';'HIV Treatment';'Diabetes';'Cancer';'CVD'};
Zone=Zone_IDP+Zone_Non_IDP;


[Tsc,srt_dindx]=sortrows(Zone',1);
Zone_Non_IDP_T=Zone_Non_IDP';
Zone_Non_IDP_T2=Zone_Non_IDP_T(srt_dindx,:)';



Country_Name=Country_Namev;
Disese=Disesev(srt_dindx);

T=Tsc';


PInc=(T-Zone_Non_IDP_T2)./Zone_Non_IDP_T2;

bb=barh(100.*PInc,'LineWidth',2);
% hold on;
% hh=barh(Zone_Non_IDP_T2,'LineStyle','none');
CC=[hex2rgb('#F52549'); % CVD
    hex2rgb('#807dba'); %Diabetes
    hex2rgb('#FFBB00'); % Cancer
    hex2rgb('#034e76'); % HIV
    hex2rgb('#9ebcda'); % HIV Treatment
    hex2rgb('#8c2d04'); %TB
    hex2rgb('#DE7a22');]; %TB drug-resitant

for ii=1:length(bb)
    bb(length(bb)+1-ii).FaceColor=CC(ii,:);
    bb(length(bb)+1-ii).EdgeColor=CC(ii,:);
%     hh(ii).FaceAlpha=1;
end


ylim([0.5 length(Country_Name)+0.5]);
xtickformat('percentage');
% xlim([1 10^7.5]);
set(gca,'Tickdir','out','linewidth',2,'YTick',[1:length(Country_Name)],'YTicklabel',Country_Namev,'Fontsize',18,'XTick',[0:10:100]);
xlabel('Percent increase in disease among civilians','Fontsize',22);
ylabel('IDP cluster','Fontsize',22);


legend(flip(bb),flip(Disese),'Location','Northoutside','NumColumns',4);
legend boxoff;
box off;
text(-12.15092967942089,3.8424,'B','FontSize',30,'FontWeight','bold');

ax2 = axes('Position',[0.240316901408451,0.667963683527886,0.732816901408454,0.216601815823605]);
gg=bar(ax2,Zone_Non_IDP_T2,'LineStyle','none');

for ii=1:length(gg)
    gg(length(gg)+1-ii).FaceColor=CC(ii,:);
    gg(length(gg)+1-ii).EdgeColor=CC(ii,:);
%     hh(ii).FaceAlpha=1;
end

set(gca,'Tickdir','out','linewidth',2,'XTick',[1:length(Country_Name)],'Fontsize',16,'YTick',10.^[-1:7],'Yscale','log','XTickLabel',Country_Namev);
ylim([100 10^6.2]);
xlim([0.5 3.5]);
ylabel({'Disease among','non-IDP'},'Fontsize',16);
xlabel('IDP cluster','Fontsize',16);
box off;
% ax2.Position=[0.285211267605634,0.72632944228275,0.692323943661973,0.246433203631647];
print(gcf,['UKR_IDP_Disease_Burden.png'],'-dpng','-r300');