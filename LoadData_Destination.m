function [Mapping_Data,Refugee_Displacement,IDP_Displacement]=LoadData_Destination(Time_Sim,vLat_C,vLon_C)

T=readtable('Refugee leaving Ukraine - Poland.csv');
D=datenum(T.data_date);
T=T(D>=Time_Sim(1) & D<=Time_Sim(end),:);
Refugee_Displacement.Cumulative_Poland=T.cumulative_refugees;
Refugee_Displacement.Date_Poland=T.data_date;

T=readtable('Refugee leaving Ukraine - Moldova.csv');
D=datenum(T.data_date);
T=T(D>=Time_Sim(1) & D<=Time_Sim(end),:);
Refugee_Displacement.Cumulative_Moldova=T.cumulative_refugees;
Refugee_Displacement.Date_Moldova=T.data_date;

T=readtable('Refugee leaving Ukraine - Belarus.csv');
D=datenum(T.data_date);
T=T(D>=Time_Sim(1) & D<=Time_Sim(end),:);
Refugee_Displacement.Cumulative_Belarus=T.cumulative_refugees;
Refugee_Displacement.Date_Belarus=T.data_date;

T=readtable('Refugee leaving Ukraine - Russia.csv');
D=datenum(T.data_date);
T=T(D>=Time_Sim(1) & D<=Time_Sim(end),:);
Refugee_Displacement.Cumulative_Russia=T.cumulative_refugees;
Refugee_Displacement.Date_Russia=T.data_date;

T=readtable('Refugee leaving Ukraine - Slovakia.xlsx');
D=datenum(T.data_date);
T=T(D>=Time_Sim(1) & D<=Time_Sim(end),:);
Refugee_Displacement.Cumulative_Slovakia=T.cumulative_refugees;
Refugee_Displacement.Date_Slovakia=T.data_date;

T=readtable('Refugee leaving Ukraine - Romania.xlsx');
D=datenum(T.data_date);
T=T(D>=Time_Sim(1) & D<=Time_Sim(end),:);
Refugee_Displacement.Cumulative_Romania=T.cumulative_refugees;
Refugee_Displacement.Date_Romania=T.data_date;

T=readtable('Refugee leaving Ukraine - Hungary.xlsx');
D=datenum(T.data_date);
T=T(D>=Time_Sim(1) & D<=Time_Sim(end),:);
Refugee_Displacement.Cumulative_Hungary=T.cumulative_refugees;
Refugee_Displacement.Date_Hungary=T.data_date;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% IDP (MACRO)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
T=readtable('Data_UKR_Displacement.xlsx','Sheet','IDP_Current_MACRO');

IDP_Displacement.Macro.Kyiv=T.KYIV;
IDP_Displacement.Macro.Kyiv_Date=T.DATE;

IDP_Displacement.Macro.East=T.EAST;
IDP_Displacement.Macro.East_Date=T.DATE;

IDP_Displacement.Macro.South=T.SOUTH;
IDP_Displacement.Macro.South_Date=T.DATE;

IDP_Displacement.Macro.Center=T.CENTER;
IDP_Displacement.Macro.Center_Date=T.DATE;

IDP_Displacement.Macro.North=T.NORTH;
IDP_Displacement.Macro.North_Date=T.DATE;

IDP_Displacement.Macro.West=T.WEST;
IDP_Displacement.Macro.West_Date=T.DATE;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% IDP (Oblast)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
T=readtable('Data_UKR_Displacement.xlsx','Sheet','IDP_Oblast');

S1=shaperead('UKR_ADM_1\UKR_adm1.shp','UseGeoCoords',true);
indx=[1:length(S1)];
tf=zeros(height(T),1);
for ii=1:height(T)
    tf(ii)=indx(strcmp(T.oblast_shape{ii},{S1.HASC_1}));
end
IDP_Displacement.Oblast.Index=tf;
IDP_Displacement.Oblast.IDP=T.IDP;
IDP_Displacement.Oblast.Date=T.DATE;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% IDP (Raion)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
T=readtable('idp_estimation_08_03_2022-unhcr-protection-cluster.xlsx','Sheet','Dataset');

S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);

raion=zeros(length(S2),1);
for ii=1:length(S2)
    [in_p]=inpolygon(T.YLatitude,T.XLongitude,S2(ii).Lat,S2(ii).Lon);
    if(ii==1)
       t_test=in_p; 
    else
       t_test=t_test | in_p; 
    end
    if(sum(in_p)>0)
        raion(ii)=sum(T.IDPEstimation(in_p));
    end
end


for jj=1:length(t_test)
   if(~t_test(jj))
        min_dist=zeros(length(S2),1);
        for ii=1:length(S2)
            min_dist(ii)=min(deg2km(distance('gc',T.YLatitude(jj),T.XLongitude(jj),S2(ii).Lat,S2(ii).Lon)));
        end
        raion(min_dist==min(min_dist))=raion(min_dist==min(min_dist))+T.IDPEstimation(jj)./sum((min_dist==min(min_dist)));
   end
end

IDP_Displacement.raion.IDP=raion;
IDP_Displacement.raion.Date=datenum('March 8, 2022');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Mapping information
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

load('Ukraine_Population_Reduced.mat','Ukraine_Pop');

Mapping_Data.Refugee.Poland.FB=Ukraine_Pop.per_Poland;
Mapping_Data.Refugee.Slovakia.FB=Ukraine_Pop.per_Slovakia;
Mapping_Data.Refugee.Hungary.FB=Ukraine_Pop.per_Hungary;
Mapping_Data.Refugee.Romania.FB=Ukraine_Pop.per_Romania;
Mapping_Data.Refugee.Belarus.FB=Ukraine_Pop.per_Belarus;
Mapping_Data.Refugee.Moldova.FB=Ukraine_Pop.per_Moldova;
Mapping_Data.Refugee.Russia.FB=min([Mapping_Data.Refugee.Poland.FB Mapping_Data.Refugee.Slovakia.FB Mapping_Data.Refugee.Hungary.FB Mapping_Data.Refugee.Romania.FB Mapping_Data.Refugee.Belarus.FB Mapping_Data.Refugee.Moldova.FB],[],2);

%https://tradingeconomics.com/country-list/gdp?continent=europe
Mapping_Data.Refugee.Poland.GDP=594;
Mapping_Data.Refugee.Slovakia.GDP=60.26;
Mapping_Data.Refugee.Hungary.GDP=105;
Mapping_Data.Refugee.Romania.GDP=155;
Mapping_Data.Refugee.Belarus.GDP=249;
Mapping_Data.Refugee.Moldova.GDP=11.91;
Mapping_Data.Refugee.Russia.GDP=1484;

%https://tradingeconomics.com/country-list/gdp-per%20capita?continent=europe
Mapping_Data.Refugee.Poland.GDP_per_Capita=14588;
Mapping_Data.Refugee.Slovakia.GDP_per_Capita=17252;
Mapping_Data.Refugee.Hungary.GDP_per_Capita=14328;
Mapping_Data.Refugee.Romania.GDP_per_Capita=10830;
Mapping_Data.Refugee.Belarus.GDP_per_Capita=6222;
Mapping_Data.Refugee.Moldova.GDP_per_Capita=3250;
Mapping_Data.Refugee.Russia.GDP_per_Capita=11787;

Mapping_Data.Refugee.Poland.NATO=1;
Mapping_Data.Refugee.Slovakia.NATO=1;
Mapping_Data.Refugee.Hungary.NATO=1;
Mapping_Data.Refugee.Romania.NATO=1;
Mapping_Data.Refugee.Belarus.NATO=0;
Mapping_Data.Refugee.Moldova.NATO=0;
Mapping_Data.Refugee.Russia.NATO=0;


TT=Ukraine_Pop.w_IDP;
Oblast_Indx=zeros(length(S2),1);
for ii=1:length(S1)
    tf=strcmp({S2.NAME_1},S1(ii).NAME_1);
    Oblast_Indx(tf)=ii;
end
TT=TT(:,Oblast_Indx);
Mapping_Data.IDP.FB=TT';

GAR15=shaperead('UKR_GAR15\gar_exp_UKR.shp','UseGeoCoords',true);

CAP=zeros(height(Ukraine_Pop),length(S2));
CAP_S2=zeros(1,length(S2));
CGAR15=[GAR15.tot_val];
tot_Pop=[GAR15.tot_pob];


load('Ukraine_Population_Reduced.mat','Ukraine_Pop','Border_Crossing_Country');
Pop_R=zeros(height(Ukraine_Pop),length(S2));
Pop_S2=zeros(1,length(S2));
for jj=1:length(S2)
    tgf=inpolygon([GAR15.Lat],[GAR15.Lon],S2(jj).Lat,S2(jj).Lon);
    CAP_S2(jj)=sum(CGAR15(tgf))./sum(tot_Pop(tgf));
    
    tf= strcmp(Ukraine_Pop.oblast,S2(jj).NAME_1) &  strcmp(Ukraine_Pop.raion,S2(jj).NAME_2); 
    CAP(tf,:)=CAP_S2(jj);
    Pop_S2(jj)=sum(Ukraine_Pop.pop_adj(tf));
    Pop_R(tf,:)=Pop_S2(jj);
end

CAP=CAP./repmat(CAP_S2,height(Ukraine_Pop),1);
CAP(isnan(CAP))=1;
Mapping_Data.IDP.Captial=CAP';
Mapping_Data.IDP.Population_Ratio=(Pop_R./repmat(Pop_S2,height(Ukraine_Pop),1))';

% Dist=zeros(height(Ukraine_Pop),length(S2));
% for jj=1:length(S2)
%    parfor ii=1:height(Ukraine_Pop)
%       tf= strcmp(Ukraine_Pop.oblast,S2(jj).NAME_1) &  strcmp(Ukraine_Pop.raion,S2(jj).NAME_2); 
%       Dist(ii,jj)=sum(Ukraine_Pop.pop_adj(tf).*deg2km(distance('gc',Ukraine_Pop.latitude_v(ii),Ukraine_Pop.longitude_v(ii),Ukraine_Pop.latitude_v(tf),Ukraine_Pop.longitude_v(tf))))./(sum(Ukraine_Pop.pop_adj(tf)));
%    end
% end
% Mapping_Data.IDP.Distance=Dist';



BC_Name={'Poland';'Slovakia';'Hungary';'Romania';'Belarus';'Moldova';'Russian Federation'};
Dist=inf.*ones(length(S2),7);
for jj=1:length(BC_Name)
   bc_f=strcmp(BC_Name{jj},Border_Crossing_Country); 
   all_d=Ukraine_Pop.distance_bc(:,bc_f);
   switch jj
       case 1
            Mapping_Data.Refugee.Poland.Distance_Border=median(all_d,2);
            Mapping_Data.Refugee.Poland.Number_Border_Crossings=sum(bc_f);
       case 2
            Mapping_Data.Refugee.Slovakia.Distance_Border=median(all_d,2);
            Mapping_Data.Refugee.Slovakia.Number_Border_Crossings=sum(bc_f);
       case 3
            Mapping_Data.Refugee.Hungary.Distance_Border=median(all_d,2);
            Mapping_Data.Refugee.Hungary.Number_Border_Crossings=sum(bc_f);
       case 4
            Mapping_Data.Refugee.Romania.Distance_Border=median(all_d,2);
            Mapping_Data.Refugee.Romania.Number_Border_Crossings=sum(bc_f);
       case 5
            Mapping_Data.Refugee.Belarus.Distance_Border=median(all_d,2);
            Mapping_Data.Refugee.Belarus.Number_Border_Crossings=sum(bc_f);
       case 6
            Mapping_Data.Refugee.Moldova.Distance_Border=median(all_d,2);
            Mapping_Data.Refugee.Moldova.Number_Border_Crossings=sum(bc_f);
       case 7
            Mapping_Data.Refugee.Russia.Distance_Border=median(all_d,2);
            Mapping_Data.Refugee.Russia.Number_Border_Crossings=sum(bc_f);
   end
   for kk=1:length(S2)
      tf= strcmp(Ukraine_Pop.oblast,S2(kk).NAME_1) &  strcmp(Ukraine_Pop.raion,S2(kk).NAME_2); 
      temp=median(min(all_d(tf,:),[],2));
      Dist(kk,jj)=min(temp,Dist(kk,jj));
   end
end
Mapping_Data.IDP.Distance_Border=Dist;
Mapping_Data.IDP.Distance_Border_Name=BC_Name;


nDays=length(vLat_C);

PS_MinDay=zeros(height(Ukraine_Pop),nDays);
for jj=1:nDays    
    [PS_MinDay(:,jj),~,~]=Min_Distance_Conflict(vLat_C{jj},vLon_C{jj},[Ukraine_Pop.latitude_v],[Ukraine_Pop.longitude_v]);
end

PS_GeoDay=zeros(size(PS_MinDay));
for ii=1:nDays
    PS_GeoDay(:,ii)=1-geomean(PS_MinDay(:,max(1,ii-6):ii),2);
end

Conflict=zeros(length(S2),nDays);
Raion_Index=zeros(length(PS_GeoDay(:,1)),1);

for jj=1:length(S2)
    tf= strcmp(Ukraine_Pop.oblast,S2(jj).NAME_1) &  strcmp(Ukraine_Pop.raion,S2(jj).NAME_2); 
    Conflict(jj,:)=median(PS_GeoDay(tf,:),1);
    Raion_Index(tf)=jj;
end


Mapping_Data.IDP.Raion_Conflict=Conflict;
Mapping_Data.IDP.Restricted_Travel_Indexing=Raion_Index;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
%% Area under control
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55

% https://www.arcgis.com/home/item.html?id=9f04944a2fe84edab9da31750c2b15eb
SP=shaperead('Test_Shape\DonbasBeforeFeb24_2022.shp','UseGeoCoords',true);
SA=shaperead('Test_Shape\Assessed Russian-controlled Ukrainian Territory.shp','UseGeoCoords',true);
SC=shaperead('Test_Shape\Claimed Russian Control over Ukrainian Territory.shp','UseGeoCoords',true);
SU=shaperead('Test_Shape\Claimed Ukrainian Counteroffensives.shp','UseGeoCoords',true);
SR=shaperead('Test_Shape\AssessedRussianAdvancesinUkraine.shp','UseGeoCoords',true);

AURC=zeros(length(S2),2);
for ii=1:length(S2)
    tf=inpolygon(S2(ii).Lat,S2(ii).Lon,SA(1).Lat,SA(1).Lon);
    for jj=2:length(SA)
        tf=inpolygon(S2(ii).Lat,S2(ii).Lon,SA(jj).Lat,SA(jj).Lon) | tf;
    end
    for jj=1:length(SC)
        tf=inpolygon(S2(ii).Lat,S2(ii).Lon,SC(jj).Lat,SC(jj).Lon) | tf;
    end
    
    for jj=1:length(SU)
        tf=inpolygon(S2(ii).Lat,S2(ii).Lon,SU(jj).Lat,SU(jj).Lon) | tf;
    end
    
    for jj=1:length(SR)
        tf=inpolygon(S2(ii).Lat,S2(ii).Lon,SR(jj).Lat,SR(jj).Lon) | tf;
    end
    
    tf2=inpolygon(S2(ii).Lat,S2(ii).Lon,SP(1).Lat,SP(1).Lon) | inpolygon(S2(ii).Lat,S2(ii).Lon,SP(2).Lat,SP(2).Lon);
    AURC(ii,:)=[min(1,sum(tf)) min(1,sum(tf2))];
end
Mapping_Data.IDP.Raion_Russian_Control=AURC;