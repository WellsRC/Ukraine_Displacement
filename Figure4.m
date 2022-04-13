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




nDays=length(vLat_C);
PC=ones(length(Lon_P),1);
PC_IDP=ones(length(Lon_P),nDays);


PCc=ones(length(cell2mat(vLon_C)),1);
PC_c=ones(length(cell2mat(vLon_C)),nDays);

for jj=1:nDays    
    P = Kernel_Displacement(vLat_C{jj},vLon_C{jj},Lat_P,Lon_P,Parameter);
    PC=PC.*(1-P);
    Ptemp=(Parameter.w.*P+(1-Parameter.w).*Parameter.Scale.*(1-PC));
    PC_IDP(:,jj)=Ptemp;
    
    
    P = Kernel_Displacement(vLat_C{jj},vLon_C{jj},cell2mat(vLat_C),cell2mat(vLon_C),Parameter);
    PCc=PCc.*(1-P);
    Ptemp=(Parameter.w.*P+(1-Parameter.w).*Parameter.Scale.*(1-PCc));
    PC_c(:,jj)=Ptemp;
end


load('Scale_Conflict_Fucntion_IDP.mat','ScaleConflict');

%MARCH 8
PC_IDPt_March8=1-prod(1-ScaleConflict.*PC_IDP(:,1:13),2);
PC_ct=1-prod(1-PC_c,2);
PC_t_March8=(1-prod(1-PC_IDP(:,1:13),2))./max(PC_ct(:));

Pop_IDP_March_8=PC_IDPt_March8.*Pop_Remain;

Pop_Trapped_March_8=PC_t_March8.*(Pop_Remain-Pop_IDP_March_8);

%MARCH 11
PC_IDPt=1-prod(1-ScaleConflict.*PC_IDP,2);
PC_ct=1-prod(1-PC_c,2);
PC_t=(1-prod(1-PC_IDP,2))./max(PC_ct(:));

Pop_IDP=PC_IDPt.*Pop_Remain;

Pop_Trapped=PC_t.*(Pop_Remain-Pop_IDP);


load('IDP_Fit_Inputs.mat','Raion_IDP');
S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);
S2=S2(Raion_IDP>0);

for ii=1:length(S2)
    tf_t=strcmp(Ukraine_Pop.raion,S2(ii).NAME_2) & strcmp(Ukraine_Pop.oblast,S2(ii).NAME_1);
    if(ii==1)
        tf=tf_t;
    else
       tf=tf|tf_t; 
    end
end

Pop_Trapped(tf)=0;
Pop_Trapped_March_8(tf)=0;
save('Figure_4_output.mat');