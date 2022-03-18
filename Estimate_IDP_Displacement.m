function [Num_IDP_Location]=Estimate_IDP_Displacement(Parameter_IDP,vLat_C,vLon_C,Lat_P,Lon_P,Pop_Remain,Lat_R,Lon_R)

nDays=length(vLat_C);
nSite=length(Lat_R);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Location of sites relative to conflict
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Ps=ones(size(LatR));

Parameter.Scale=Parameter_IDP.ScaleSite;
Parameter.Breadth=Parameter_IDP.BreadthSite;
for jj=1:nDays
    P = Kernel_Displacement(vLat_C{jj},vLon_C{jj},Lat_R,Lon_R,Parameter);
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
    Pd(jj,:)=Kernel_Displacement(Lat_R(jj),Lon_R(jj),Lat_P,Lon_P,Parameter);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Conflict in the specified location
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Pc=ones(1,length(Lon_P));
Parameter.Scale=Parameter_IDP.ScaleConflict;
Parameter.Breadth=Parameter_IDP.BreadthConflict;

for jj=1:nDays
    P = Kernel_Displacement(vLat_C{jj},vLon_C{jj},Lat_P,Lon_P,Parameter);
    Pc=Pc.*(1-P);
end

Pc=1-Pc;

P_Tot=repmat(Ps,1,length(Lon_P)).*Pd.*repmat(Pc,length(Lat_IDP),1);
Num_IDP_Location=P_Tot*(Pop_Remain');
end