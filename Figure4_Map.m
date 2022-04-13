clear;
clc;
close all;

load('IDP_Fit_Inputs.mat','Raion_IDP');
T=readtable('idp_estimation_08_03_2022-unhcr-protection-cluster.xlsx','Sheet','Dataset');

Lat_IDP=T.YLatitude;
Lon_IDP=T.XLongitude;
Zone=T.IDPLocationCluster;
IDP_Num=T.IDPEstimation;

S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);
S1=shaperead('UKR_ADM_1\UKR_adm1.shp','UseGeoCoords',true);

Raion_Zone_R=zeros(length(S2),1);
for ii=1:length(S2)
    [p_in]=inpolygon(Lat_IDP,Lon_IDP,S2(ii).Lat,S2(ii).Lon);
    if(sum(p_in)>0)
        Raion_Zone_R(ii)=median(Zone(p_in));
    end
    if((Raion_IDP(ii)>0) && (Raion_Zone_R(ii)==0))
       d=zeros(length( Lon_IDP));
       parfor jj=1:length(d)
           d(jj)=min(deg2km(distance('gc',Lat_IDP(jj),Lon_IDP(jj),S2(ii).Lat,S2(ii).Lon)));
       end
       Raion_Zone_R(ii)=median(Zone(d==min(d)));
    end
end

IDP_Oblast=zeros(length(S1),1);

for ii=1:length(S1)
    p_in=inpolygon(Lat_IDP,Lon_IDP,S1(ii).Lat,S1(ii).Lon);
   IDP_Oblast(ii)=sum(IDP_Num(p_in)); 
end

load('Kernel_Paremeter_IDP_Non_Zero_Raion.mat','Parameter_IDP');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% Determine the IDP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55

load('Input_Figure3D.mat')


Raion_Conflict_M=zeros(length(Raion_Conflict(Raion_IDP>0,1)),length(Raion_Index),length(Raion_Conflict(1,:)));
for dd=1:length(Raion_Conflict(1,:))
    Raion_Conflict_pix=Raion_Conflict(Raion_Index,dd)';
    
    test=(repmat(Raion_Conflict_pix,length(Raion_Conflict_M(:,dd)),1));
    test2=repmat(Raion_Conflict(Raion_IDP>0,dd),1,length(Raion_Index));
    Raion_Conflict_M(:,:,dd)=test-test2+1;
end


Raion_IDP_March8=zeros(length(S2),1);
Raion_IDP_March11=zeros(length(S2),1);

 for dd=1:length(Pop_IDP_R(1,:))
    [w_Location]=Estimate_IDP_Displacement(Parameter_IDP,Pop_Raion_M(Raion_IDP>0,:),SCI_IDPt(Raion_IDP>0,:),Raion_Dist_BC(Raion_IDP>0,:),Num_BC(Raion_IDP>0,:),squeeze(Raion_Conflict_M(:,:,dd)),DistC(Raion_IDP>0,dd),Dist(Raion_IDP>0,:));
    if(dd==1)
        Raion_IDP_March11(Raion_IDP>0)=w_Location*Pop_IDP_R(:,dd);
        Raion_IDP_March8(Raion_IDP>0)=w_Location*Pop_IDP_R(:,dd);
    else
        Raion_IDP_March11(Raion_IDP>0)=Raion_IDP_March11(Raion_IDP>0)+w_Location*Pop_IDP_R(:,dd);
        if(dd<=13)
            Raion_IDP_March8(Raion_IDP>0)=Raion_IDP_March8(Raion_IDP>0)+w_Location*Pop_IDP_R(:,dd);
        end
    end
 end

FI=Raion_IDP_March11./Raion_IDP_March8;

FI(Raion_IDP_March8==0)=0;
clearvars -except Raion_IDP_March11 Raion_IDP_March8 FI IDP_Oblast

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Determine the trappd population
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

load('Figure_4_output.mat','Pop_Trapped','Ukraine_Pop','Pop_Trapped_March_8')
S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);
S1=shaperead('UKR_ADM_1\UKR_adm1.shp','UseGeoCoords',true);
UKR_March31=readtable('Data_ Ukraine 3W Round 4 2022-03-31.xlsx','Sheet','UDE_Inputs');
UKR_April7=readtable('Data_ Ukraine 3W Round 5 2022-04-07.xlsx','Sheet','UDE_Inputs');

Data_HA_People_Reached=zeros(length(S1),2);
Data_HA_NumOrg=zeros(length(S1),2);
PIN=zeros(length(S1),1);
Test_Pop=zeros(length(S1),1);

UKR_P=Ukraine_Pop.population_size;
RO={S2.NAME_1};
IDP_Est=zeros(length(S1),1);
for rr=1:length(S1)      
    tf=strcmp(S1(rr).NAME_1,Ukraine_Pop.oblast);
    Test_Pop(rr)=sum(UKR_P(tf));
    tfr=strcmp(S1(rr).NAME_1,RO);
    if(sum(Raion_IDP_March8(tfr))>0)
        IDP_Est(rr)=(sum(Raion_IDP_March11(tfr))./sum(Raion_IDP_March8(tfr))).*IDP_Oblast(rr);
    end
    PIN(rr,2)=sum(Pop_Trapped(tf))+IDP_Est(rr);
    PIN(rr,1)=sum(Pop_Trapped_March_8(tf))+IDP_Oblast(rr);
    tob=strcmp(UKR_March31.HASC_1,S1(rr).HASC_1);
    if(sum(tob)>0)
        Data_HA_NumOrg(rr,1)=UKR_March31.NumberOfOrganisations(tob);
        Data_HA_People_Reached(rr,1)=UKR_March31.PeopleReached(tob);
    end
    
    tob=strcmp(UKR_April7.HASC_1,S1(rr).HASC_1);
    if(sum(tob)>0)
        Data_HA_NumOrg(rr,2)=UKR_April7.NumberOfOrganisations(tob);
        Data_HA_People_Reached(rr,2)=UKR_April7.PeopleReached(tob);
    end
end

dt=datenum('April 7,2022')-datenum('March 31,2022');
dt0=datenum('February 24,2022')-datenum('March 31,2022');

gr_PR=fminbnd(@(x)(sum((Data_HA_People_Reached(:,1).*(2.*exp(10.^x.*dt0)./(exp(10.^x.*dt0)+1))).^2)+sum(((Data_HA_People_Reached(:,2))-(Data_HA_People_Reached(:,1).*(2.*exp(10.^x.*dt)./(exp(10.^x.*dt)+1)))).^2)),-21,0);

dt2=datenum('March 11,2022')-datenum('March 8,2022');

gr_IDP=fminbnd(@(x)sum(((PIN(IDP_Oblast>0,1).*(2.*exp(10.^x.*dt2)./(exp(10.^x.*dt2)+1)))-(PIN(IDP_Oblast>0,2))).^2),-21,0);

dt_est=datenum('March 11,2022')-datenum('March 31,2022');
EstPR=(Data_HA_People_Reached(:,1).*(2.*exp(10.^gr_PR.*dt_est)./(exp(10.^gr_PR.*dt_est)+1)));

Est_Cov_March_11=EstPR./PIN(:,2);

dt2_est=datenum('March 31,2022')-datenum('March 8,2022');
Est_PIN=PIN(:,1).*(2.*exp(10.^gr_IDP.*dt2_est)./(exp(10.^gr_IDP.*dt2_est)+1));
Est_Cov_March_31=Data_HA_People_Reached(:,1)./Est_PIN;



