
load('Input_Figure3B.mat');

[w_Location]=Estimate_IDP_Displacement(Parameter_IDP,Pop_Raion(Raion_IDP>0),SCI_IDPt(Raion_IDP>0,:),Raion_IDPSites(Raion_IDP>0),Raion_Dist_BC(Raion_IDP>0,:),Num_BC(Raion_IDP>0),Raion_Conflict(Raion_IDP>0),DistC(Raion_IDP>0,:),Dist(Raion_IDP>0,:));

Raion_Zone_R=Raion_Zone_R(Raion_IDP>0);

load('Grid_points_UKR_Fewer.mat')
[longitude_v,latitude_v]=meshgrid(longitude,latitude);
longitude_v=longitude_v(tp_UKR);
latitude_v=latitude_v(tp_UKR);
LoadData;

load('Kernel_Paremeter.mat','Parameter');

nDays=length(vLat_C);
PC=ones(length(latitude_v(:)),1);
PC_IDP=ones(length(latitude_v(:)),1);


for jj=1:nDays    
    P = Kernel_Displacement(vLat_C{jj},vLon_C{jj},latitude_v(:),longitude_v(:),Parameter);
    PC=PC.*(1-P);
    Ptemp=(Parameter.w.*P+(1-Parameter.w).*Parameter.Scale.*(1-PC));
    PC_IDP=PC_IDP.*(1-Ptemp);
end

PC_IDP=1-PC_IDP;

for ii=1:3

    figure(ii)
    w1=sum(w_Location(Raion_Zone_R==ii,:),1).*(PC_IDP');

    scatter(longitude_v,latitude_v,3,log10(w1),'filled');
    caxis([-6 0]);
end