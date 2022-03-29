% ENSURE TO RUN Scrape_Total_Remaining_Pop
clear;
clc;

LoadData;

load('Kernel_Paremeter.mat','Parameter');

[Pop_Displace_Day,Pop_Displace]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Lat_P,Lon_P,Pop,false);

Displace_Pop=sum(Pop_Displace,2);
Pop_Remain=Pop-Displace_Pop;

load('Grid_points_UKR_Fewer.mat')
[longitude_v,latitude_v]=meshgrid(longitude,latitude);
longitude_v=longitude_v(tp_UKR);
latitude_v=latitude_v(tp_UKR);

S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);


nDays=length(vLat_C);
PC=ones(length(Lon_P),1);
PC_IDP=ones(length(Lon_P),nDays);

for jj=1:nDays    
    P = Kernel_Displacement(vLat_C{jj},vLon_C{jj},Lat_P,Lon_P,Parameter);
    PC=PC.*(1-P);
    Ptemp=(Parameter.w.*P+(1-Parameter.w).*Parameter.Scale.*(1-PC));
    PC_IDP(:,jj)=Ptemp;
end


load('Scale_Conflict_Fucntion_IDP.mat','ScaleConflict');

PC_IDPt=1-prod(1-ScaleConflict.*PC_IDP,2);

Pop_Moving=PC_IDPt.*Pop_Remain;

f_nz=find(Pop_Moving>0);

Pop_Moving_R=zeros(size(latitude_v));
for ii=1:length(f_nz)
   d=deg2km(distance('gc',Lon_P(f_nz(ii)),Lat_P(f_nz(ii)),longitude_v,latitude_v));
   Pop_Moving_R(d==min(d))=Pop_Moving_R(d==min(d))+Pop_Moving(f_nz(ii))./sum((d==min(d)));
end

PC_IDP=1-prod(1-PC_IDP,2);
Raion_Conflict=zeros(length(S2),1);
for ii=1:length(Raion_Conflict)    
    Raion_Conflict(ii)=mean(PC_IDP(strcmp(Ukraine_Pop.raion,S2(ii).NAME_2)));
end
DistC=zeros(length(S2),length(vLat_C));

for jj=1:length(S2)
    for kk=1:length(vLat_C)
        cLon=vLon_C{kk};
        cLat=vLat_C{kk};
        temp=zeros(1,(length(cLat)));
        parfor zz=1:length(cLon)
            temp(zz)=min(deg2km(distance('gc',cLon(zz),cLat(zz),S2(jj).Lon,S2(jj).Lat)));                   
        end
        [p_in]=inpolygon(cLon,cLat,S2(jj).Lon,S2(jj).Lat);
        if(sum(p_in)==0)
            DistC(jj,kk)=min(temp);
        end
    end
end

load('IDP_Fit_Inputs.mat','Pop_Raion','SCI_IDP','Raion_IDPSites','Dist','Raion_IDP','Raion_Index','Raion_Dist_BC','Num_BC');

Mapped_Names=readtable('mapped_data.csv');

Mapped_Raion_Name=cell(length(Pop_Moving_R),1);
parfor ii=1:length(Mapped_Raion_Name)
    tfmn=strcmp(S2(Raion_Index(ii)).HASC_2,Mapped_Names.HASC_2) & strcmp(S2(Raion_Index(ii)).NAME_2,Mapped_Names.NAME_2);
    if(sum(tfmn)>0)
        NN=Mapped_Names.DistrictName{tfmn};
        Mapped_Raion_Name(ii)={NN};
    else
        Mapped_Raion_Name(ii)={'N/A'};
    end
end


T=readtable('idp_estimation_08_03_2022-unhcr-protection-cluster.xlsx','Sheet','Dataset');



Lat_IDP=T.YLatitude;
Lon_IDP=T.XLongitude;
Zone=T.IDPLocationCluster;

clear Mapped_Names;


Raion_Zone_R=zeros(length(S2),1);
for ii=1:length(S2)
    if(Raion_IDP(ii)>0)
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
end

Raion_Zone_Full=Raion_Zone_R(Raion_Index);


load('Reduced_Grid_Popultaion_Total_UKR.mat','Pop_Remain_R','Pop_Total_R','Pop_Male_R');
Pop_Non_IDP=Pop_Remain_R-Pop_Moving_R;



load('Kernel_Paremeter_IDP_Non_Zero_Raion.mat','Parameter_IDP');

SCI_IDPt=max(log10(SCI_IDP(:)))-log10(SCI_IDP);


[Total_Burden_IDP] = Disease_Burden_Displacement_IDP(Pop_Non_IDP,Pop_Moving_R,Pop_Male_R,Pop_Total_R,Mapped_Raion_Name,Parameter_IDP,Pop_Raion(Raion_IDP>0),SCI_IDPt(Raion_IDP>0,:),Raion_IDPSites(Raion_IDP>0),Raion_Dist_BC(Raion_IDP>0,:),Num_BC(Raion_IDP>0),Raion_Conflict(Raion_IDP>0),DistC(Raion_IDP>0,:),Dist(Raion_IDP>0,:),Raion_Zone_R(Raion_IDP>0),Raion_Zone_Full);
save('Input_Figure3B.mat','Raion_Index','Total_Burden_IDP','Pop_Non_IDP','Pop_Male_R','Pop_Moving_R','Pop_Total_R','Mapped_Raion_Name','Parameter_IDP','Pop_Raion','SCI_IDPt','Raion_IDPSites','Raion_Dist_BC','Num_BC','Raion_Conflict','DistC','Dist','Raion_Zone_R','Raion_IDP','Raion_Zone_Full');

Zone_Non_IDP=reshape(Total_Burden_IDP.Cases(10:3:end),3,7);
Zone_IDP=reshape(Total_Burden_IDP.Cases(11:3:end),3,7);
figure('units','normalized','outerposition',[0.15 0.15 0.6 0.8]);
subplot('Position',[0.119718309859155,0.121919584954604,0.84419014084507,0.862516212710766]);
Country_Namev={'Zone 1','Zone 2','Zone 3'};
Disesev={'TB';'Drug-resistant TB';'HIV';'HIV Treatment';'Diabetes';'Cancer';'CVD'};
Zone=Zone_IDP+Zone_Non_IDP;


[Ts,srt_indx]=sortrows(Zone,1);
[Tsc,srt_dindx]=sortrows(Ts',1);
Zone_Non_IDP_T=Zone_Non_IDP(srt_indx,:)';
Zone_Non_IDP_T2=Zone_Non_IDP_T(srt_dindx,:)';


Country_Name=Country_Namev(srt_indx);
Disese=Disesev(srt_dindx);

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
xlim([1 10^7.5]);
set(gca,'Tickdir','out','linewidth',2,'YTick',[1:length(Country_Name)],'YTicklabel',Country_Name,'Fontsize',18,'XSCale','log','XTick',10.^[-1:7]);
xlabel('Number of civilians','Fontsize',22);
ylabel('IDP Cluster','Fontsize',22);


legend(flip(hh),flip(Disese),'Position',[0.799589206337793,0.137051448335493,0.194542249061272,0.254215297493335]);
legend boxoff;

print(gcf,['UKR_IDP_Disease_Burden.png'],'-dpng','-r300');