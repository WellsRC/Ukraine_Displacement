clear;
clc;

LoadData;

load('Kernel_Paremeter.mat','Parameter');


T=readtable('idp_estimation_08_03_2022-unhcr-protection-cluster.xlsx','Sheet','Dataset');

date_IDP=datenum('March 8, 2022');

Lat_IDP=T.YLatitude;
Lon_IDP=T.XLongitude;
Num_IDP=T.IDPEstimation;

% Need to trim the conflict based on the observed time of IDP
vLat_C=vLat_C(Date_Displacement<=date_IDP);
vLon_C=vLon_C(Date_Displacement<=date_IDP);

[Pop_Displace_Day,Pop_Displace]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Lat_P,Lon_P,Pop,false);

Displace_Pop=sum(Pop_Displace,2);
Pop_Remain=Pop-Displace_Pop;

load('Grid_points_UKR_Fewer.mat')
[longitude_v,latitude_v]=meshgrid(longitude,latitude);
longitude_v=longitude_v(tp_UKR);
latitude_v=latitude_v(tp_UKR);

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
    tf=strcmp(Ukraine_Pop.raion,S2(ii).NAME_2) & strcmp(Ukraine_Pop.oblast,S2(ii).NAME_1);
    Pop_Raion(ii)=sum(Ukraine_Pop.population_size(tf));
end

for ii=1:length(Num_IDP)
    if(Num_IDP(ii)>0)
        dob=zeros(length(S2),1);
        for jj=1:length(S2)
           dob(jj)=min(deg2km(distance('gc',Lat_IDP(ii),Lon_IDP(ii),S2(jj).Lat,S2(jj).Lon)));
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
        dobt(ii)=min(deg2km(distance('gc',BC_Lat(jj),BC_Lon(jj),S2(ii).Lat,S2(ii).Lon)));
    end
    Raion_Dist_BC(:,jj)=dobt;
    Num_BC(dobt==min(dobt))=Num_BC(dobt==min(dobt))+1./sum(dobt==min(dobt));
end
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
[pars,fval]=fmincon(@(x)ObjectiveFunction_SCaleConflict_IDP(x,PC_IDP,Pop_Remain,sum(T.IDPEstimation)),-0.001,[],[],[],[],-8,0,[],options);


ScaleConflict=10^pars;

f_nz=find((1-prod(1-ScaleConflict.*PC_IDP,2)).*Pop_Remain>0);

Pop_IDP_R=zeros(length(latitude_v),nDays);

PC_IDPt=ScaleConflict.*PC_IDP;
Pop_Remaint=Pop_Remain;

min_d_index=cell(length(latitude_v),2);
for ii=1:length(f_nz)
   d=deg2km(distance('gc',Lat_P(f_nz(ii)),Lon_P(f_nz(ii)),latitude_v,longitude_v));
   fd=find(d==min(d));
   for jj=1:length(fd)
       min_d_index{fd(jj),1}=[min_d_index{fd(jj),1} f_nz(ii)];
       min_d_index{fd(jj),2}=[min_d_index{fd(jj),2} 1./length(fd)];
   end
end

for dd=1:nDays
    Pop_IDP=PC_IDPt(:,dd).*Pop_Remaint;
    Pop_Remaint=Pop_Remaint-PC_IDPt(:,dd).*Pop_Remaint;
    parfor ii=1:length(latitude_v)        
       Pop_IDP_R(ii,dd)=sum(min_d_index{ii,2}'.*Pop_IDP(min_d_index{ii,1}));
    end
end

save('Scale_Conflict_Fucntion_IDP.mat','ScaleConflict');

Raion_Conflict=zeros(length(S2),nDays);
for dd=1:nDays
    for ii=1:length(S2)   
        temp=1-prod(1-PC_IDP(:,1:dd),2);
        Raion_Conflict(ii,dd)=mean(temp(strcmp(Ukraine_Pop.raion,S2(ii).NAME_2)));
    end
end
DistC=zeros(length(S2),nDays);
for jj=1:length(S2)
    for kk=1:length(vLat_C)
        cLon=vLon_C{kk};
        cLat=vLat_C{kk};
        temp=zeros(1,(length(cLat)));
        parfor zz=1:length(cLon)
            temp(zz)=min(deg2km(distance('gc',cLat(zz),cLon(zz),S2(jj).Lat,S2(jj).Lon)));                   
        end
        [p_in]=inpolygon(cLon,cLat,S2(jj).Lon,S2(jj).Lat);
        if(sum(p_in)==0)
            DistC(jj,kk,dd)=min(temp);
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

save('IDP_Fit_Inputs.mat','Pop_Raion','Pop_IDP_R','SCI_IDP','Raion_IDPSites','Raion_Conflict','DistC','Dist','Raion_IDP','Raion_Index','Raion_Dist_BC','Num_BC');
