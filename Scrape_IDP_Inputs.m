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



T=readtable('idp_estimation_08_03_2022-unhcr-protection-cluster.xlsx','Sheet','Dataset');

date_IDP=datenum('March 8, 2022');

Lat_IDP=T.YLatitude;
Lon_IDP=T.XLongitude;
Num_IDP=T.IDPEstimation;

Need to trim the conflict based on the observed time of IDP
vLat_C=vLat_C(Date_Displacement<=date_IDP);
vLon_C=vLon_C(Date_Displacement<=date_IDP);

S1=shaperead('UKR_ADM_1\UKR_adm1.shp','UseGeoCoords',true);

S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);

Raion_IDP=zeros(length(S2),1);
Raion_IDPSites=zeros(length(S2),1);
Pop_Raion=zeros(length(S2),1);

for ii=1:length(S2)
    [p_in]=inpolygon(Lon_IDP,Lat_IDP,S2(ii).Lon,S2(ii).Lat);
    Raion_IDP(ii)=sum(Num_IDP(p_in));
    Num_IDP(p_in)=0;
    Raion_IDPSites(ii)=sum(p_in);
    tf=strcmp(Ukraine_Pop.raion,S2(ii).NAME_2);
    Pop_Raion(ii)=sum(Ukraine_Pop.population_size(tf));
end

for ii=1:length(Num_IDP)
    if(Num_IDP(ii)>0)
        dob=zeros(length(S2),1);
        for jj=1:length(S2)
           dob(jj)=min(deg2km(distance('gc',Lon_IDP(ii),Lat_IDP(ii),S2(jj).Lon,S2(jj).Lat)));
        end
        Raion_IDP(dob==min(dob))=Raion_IDP(dob==min(dob))+Num_IDP(ii)./sum(dob==min(dob));
        Num_IDP(ii)=0;
        Raion_IDPSites(dob==min(dob))=Raion_IDPSites(dob==min(dob))+1./sum(dob==min(dob));
    end
end


Num_IDP=T.IDPEstimation;

load('FB_UKR_UKR.mat','M_FB_UKR');
 SCI_IDP=zeros(length(S2),27);
 Oblast_Index=zeros(length(latitude_v),1);
 
 for ii=1:27     
    SCI_IDP([S2.ID_1]==ii,:)=repmat(M_FB_UKR(ii,:),sum([S2.ID_1]==ii),1);    
    [p_in,p_on]=inpolygon(longitude_v,latitude_v,S1(ii).Lon,S1(ii).Lat);
    Oblast_Index(p_in|p_on)=ii;
 end
 SCI_IDP=SCI_IDP(:,Oblast_Index);
 clear Oblast_Index;
 
 
BC=readtable('ukr_border_crossings_170322.xlsx','Sheet','Border Crossings');
BC_Lat=BC.Lat;
BC_Lon=BC.Long;

Num_BC=zeros(length(S2),1);
Raion_Dist_BC=zeros(length(S2),length(BC_Lon));
for jj=1:length(BC_Lon)
    dobt=zeros(length(S2),1);
    for ii=1:length(S2)  
        dobt(ii)=min(deg2km(distance('gc',BC_Lon(jj),BC_Lat(jj),S2(ii).Lon,S2(ii).Lat)));
    end
    Raion_Dist_BC(:,jj)=dobt;
    Num_BC(dobt==min(dobt))=Num_BC(dobt==min(dobt))+1./sum(dobt==min(dobt));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Run Fitting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Determine the scalining factor for the overall number of IDP



nDays=length(vLat_C);
PC=ones(length(Lon_P),1);
PC_IDP=ones(length(Lon_P),nDays);

for jj=1:nDays    
    P = Kernel_Displacement(vLat_C{jj},vLon_C{jj},Lat_P,Lon_P,Parameter);
    PC=PC.*(1-P);
    Ptemp=(Parameter.w.*P+(1-Parameter.w).*Parameter.Scale.*(1-PC));
    PC_IDP(:,jj)=Ptemp;
end


options = optimoptions(@fmincon,'FunctionTolerance',10^(-16),'MaxFunctionEvaluations',500,'MaxIterations',1000);
[pars,fval]=fmincon(@(x)ObjectiveFunction_SCaleConflict_IDP(x,PC_IDP,Pop_Remain,sum(T.IDPEstimation)),-0.001,[],[],[],[],-6,0,[],options);


ScaleConflict=10^pars;

PC_IDPt=1-prod(1-ScaleConflict.*PC_IDP,2);

Pop_Moving=PC_IDPt.*Pop_Remain;

f_nz=find(Pop_Moving>0);

Pop_Moving_R=zeros(size(latitude_v));
for ii=1:length(f_nz)
   d=deg2km(distance('gc',Lon_P(f_nz(ii)),Lat_P(f_nz(ii)),longitude_v,latitude_v));
   Pop_Moving_R(d==min(d))=Pop_Moving_R(d==min(d))+Pop_Moving(f_nz(ii))./sum((d==min(d)));
end

save('Scale_Conflict_Fucntion_IDP.mat','ScaleConflict');

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

Raion_Index=zeros(length(latitude_v),1);

for ii=1:length(S2)       
[p_in,p_on]=inpolygon(longitude_v,latitude_v,S2(ii).Lon,S2(ii).Lat);
Raion_Index(p_in|p_on)=ii;
end

Dist=zeros(length(S2),length(latitude_v));
parfor ii=1:length(latitude_v)    
    Dist(:,ii)=DistanceBorder_Polygon(longitude_v(ii),latitude_v(ii),S2,Raion_Index(ii));
end

save('IDP_Fit_Inputs.mat','Pop_Raion','Pop_Moving_R','SCI_IDP','Raion_IDPSites','Raion_Conflict','DistC','Dist','Raion_IDP','Raion_Index','Raion_Dist_BC','Num_BC');
