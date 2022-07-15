function [Number_Displacement,Date_Displacement,vLat_C,vLon_C,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,Pop_MACRO,Pop_raion,Pop_oblast,Time_Sim,ML_Indx,RC,Time_Switch]=LoadData()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%% Impact of the Kernel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

RC=fmincon(@(x)(norminv(0.975,0,x)-12.5).^2,6.4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
%% Displacement data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
Time_Sim=[datenum('February 24, 2022'):datenum('May 13, 2022')];
% Refugee
T=readtable('UNHCR_UKR_Date.csv');
temp_Date_Displacement=datenum(T.data_date);
temp_Number_Displacement=T.daily_individuals;

Number_Displacement.Refugee=temp_Number_Displacement(temp_Date_Displacement<=datenum('May 13, 2022'));
Date_Displacement.Refugee=temp_Date_Displacement(temp_Date_Displacement<=datenum('May 13, 2022'));

% IDP Origin

T=readtable('Data_UKR_Displacement.xlsx','Sheet','IDP_Origin_MACRO');
temp_Date_Displacement=datenum(T.DATE);
temp_Number_Displacement=T(:,2:end);

Date_Displacement.IDP_Origin=temp_Date_Displacement;
Number_Displacement.IDP_Origin.Kyiv=temp_Number_Displacement.KYIV;
Number_Displacement.IDP_Origin.East=temp_Number_Displacement.EAST;
Number_Displacement.IDP_Origin.South=temp_Number_Displacement.SOUTH;
Number_Displacement.IDP_Origin.Center=temp_Number_Displacement.CENTER;
Number_Displacement.IDP_Origin.North=temp_Number_Displacement.NORTH;
Number_Displacement.IDP_Origin.West=temp_Number_Displacement.WEST;

% IDP Gender
T=readtable('Data_UKR_Displacement.xlsx','Sheet','IDP_Gender');
temp_Date_Displacement=datenum(T.Date);
Date_Displacement.Proportion_IDP_Female=temp_Date_Displacement;
Number_Displacement.Proportion_IDP_Female=T.Female;


% IDP Age
T=readtable('Data_UKR_Displacement.xlsx','Sheet','IDP_Age');
temp_Date_Displacement=datenum(T.Date);
Date_Displacement.Proportion_IDP_Age=temp_Date_Displacement;
Number_Displacement.Proportion_IDP_Age=table2array(T(:,2:end));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
%% Conflict data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
T=readtable('2022-02-15-2022-05-18-Ukraine.csv');

DT=datenum(T.event_date);

T=T(DT>=datenum('February 24, 2022'),:);

vLat_C=cell(length(Time_Sim),1);
vLon_C=cell(length(Time_Sim),1);

Date_Conflict=zeros(height(T),1);
for ii=1:length(Date_Conflict)
    Date_Conflict(ii)=datenum(T.event_date(ii));
end


CountC=zeros(size(Time_Sim));

for ii=1:length(Time_Sim)
   f=find(Date_Conflict==Time_Sim(ii));
   vLat_C{ii}=T.latitude(f);
   vLon_C{ii}=T.longitude(f);
   CountC(ii)=length(f);
end

% Fixed switch to the the initial nadir of the weekly conflict
Time_Switch=Time_Sim(28);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Population Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load('Ukraine_Population_Reduced.mat','Ukraine_Pop','Border_Crossing_Country');
Lat_P=Ukraine_Pop.latitude_v;
Lon_P=Ukraine_Pop.longitude_v;
Pop_MACRO=Ukraine_Pop.macro_region;
Pop_raion=Ukraine_Pop.raion;
Pop_oblast=Ukraine_Pop.oblast;
Pop_F_Age=repmat(Ukraine_Pop.pop_adj,1,17).*Ukraine_Pop.age_Dist_female;
Pop_M_Age=repmat(Ukraine_Pop.pop_adj,1,17).*Ukraine_Pop.age_Dist_male;

% Index of age for martial law
ML_Indx=[5:12];

end