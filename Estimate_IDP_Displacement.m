function [Num_IDP_Location]=Estimate_IDP_Displacement(Parameter_IDP,ParameterC,vLat_C,vLon_C,Lat_P,Lon_P,Pop_Remain,Lat_IDP,Lon_IDP,SCI_IDP,Site_Oblast)

nDays=length(vLat_C);
nSite=length(Lat_IDP);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% SCI 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
Psci=zeros(length(Lat_IDP),length(Lon_P));
Parameter.Scale=1;
Parameter.Breadth=Parameter_IDP.BreadthDistance;
parfor jj=1:nSite
    Psci(jj,:)=Kernel_Function( SCI_IDP(:,Site_Oblast(jj)),Parameter);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Location of sites relative to conflict
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Ps=ones(size(LatR));

Parameter.Scale=Parameter_IDP.ScaleSite;
Parameter.Breadth=Parameter_IDP.BreadthSite;
for jj=1:nDays
    P = Kernel_Displacement(vLat_C{jj},vLon_C{jj},Lat_IDP,Lon_IDP,Parameter);
    Ps=Ps.*(1-P);
end

Ps=1-Ps;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Location of sites relative to pixels
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Pd=zeros(length(Lat_IDP),length(Lon_P));


Parameter.Scale=Parameter_IDP.ScaleDistance;
Parameter.Breadth=Parameter_IDP.BreadthDistance;
parfor jj=1:nSite
    Pd(jj,:)=Kernel_Displacement(Lat_IDP(jj),Lon_IDP(jj),Lat_P,Lon_P,Parameter);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Conflict in the specified location
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PC=ones(1,length(Lon_P));

PC_IDP=ones(1,length(Lon_P));


for jj=1:nDays    
    P = Kernel_Displacement(vLat_C{jj},vLon_C{jj},Lat_P,Lon_P,ParameterC);
    PC=PC.*(1-P);
    Ptemp=Parameter_IDP.ScaleConflict.*(Parameter.w.*P+(1-Parameter.w).*Parameter.ScaleC.*(1-PC));
    PC_IDP=PC_IDP.*(1-Ptemp);
end

PC_IDP=1-PC_IDP;

P_Tot=repmat(Ps,1,length(Lon_P)).*Pd.*repmat(PC_IDP,length(Lat_IDP),1);
Num_IDP_Location=P_Tot*(Pop_Remain');
end