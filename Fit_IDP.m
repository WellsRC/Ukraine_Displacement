clear;
load('IDP_Fit_Inputs.mat');
% Pop_Raion_T=log(Pop_Raion)-min(log(Pop_Raion));
SCI_IDPt=max(log10(SCI_IDP(:)))-log10(SCI_IDP);

Raion_Conflict_pix=Raion_Conflict(Raion_Index)';
Raion_Conflict=(repmat(Raion_Conflict_pix,length(Raion_Conflict),1)-repmat(Raion_Conflict,1,length(Raion_Conflict_pix)))+1;


Pop_Raion_pix=Pop_Raion(Raion_Index)';
Pop_Raion_M=(repmat(Pop_Raion,1,length(Pop_Raion_pix))./repmat(Pop_Raion_pix,length(Pop_Raion),1));
T=readtable('idp_estimation_08_03_2022-unhcr-protection-cluster.xlsx','Sheet','Dataset');



Lat_IDP=T.YLatitude;
Lon_IDP=T.XLongitude;
Zone=T.IDPLocationCluster;

S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);

Raion_Zone_R=zeros(length(S2),1);
for ii=1:length(S2)
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

lb=[-5 -3 -9 -4 -2 0 0 -3 -1 -1 0 -3 -2];
ub=[0 3 0 10 0 6 3 2 1 0 6 0 2];

options = optimoptions('surrogateopt','MaxFunctionEvaluations',5000);
[par,fval_so] = surrogateopt(@(x)ObjectiveFunction_IDP(x,Pop_Moving_R,Pop_Raion_M(Raion_IDP>0,:),SCI_IDPt(Raion_IDP>0,:),Raion_Dist_BC(Raion_IDP>0,:),Num_BC(Raion_IDP>0),Raion_Conflict(Raion_IDP>0,:),DistC(Raion_IDP>0,:),Dist(Raion_IDP>0,:),Raion_IDP(Raion_IDP>0),Raion_Zone_R(Raion_IDP>0)),lb,ub,options);
 
% options = optimoptions(@fmincon,'FunctionTolerance',10^(-16),'MaxFunctionEvaluations',5000,'MaxIterations',10000,'StepTolerance',10^(-9));
 
% [par,fval] = fmincon(@(x)ObjectiveFunction_IDP(x,Pop_Moving_R,Pop_Raion(Raion_IDP>0),SCI_IDP(Raion_IDP>0,:),Raion_IDPSites(Raion_IDP>0),Raion_Dist_BC(Raion_IDP>0),Num_BC(Raion_IDP>0),Raion_Conflict(Raion_IDP>0),DistC(Raion_IDP>0,:),Dist(Raion_IDP>0,:),Raion_IDP(Raion_IDP>0)),par,[],[],[],[],lb,ub,[],options);

%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%     % SCI 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%     Parameter_IDP.Scale_SCI=10.^par(1);
%     Parameter_IDP.Breadth_SCI=10.^par(2);
% 
% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%     % Location of sites relative to pixels
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Parameter_IDP.Breadth_Distance=10.^par(3);
%     
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    % Population_Sites
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Parameter_IDP.Scale_Population_Sites=10.^par(1);
    Parameter_IDP.Breadth_Population_Sites=10.^par(2);
    Parameter_IDP.Scale_Distance=10.^par(3);
    Parameter_IDP.Breadth_Distance=10.^par(4);
    
    Parameter_IDP.Scale_Border_Distance=10.^par(5);
    Parameter_IDP.Breadth_Border_Distance=10.^par(6);
    
    Parameter_IDP.Breadth_SCI=10^par(7);
    
    Parameter_IDP.Scale_Border_Number=10^par(8);
    Parameter_IDP.Breadth_Border_Number=10^par(9);
    
    Parameter_IDP.Scale_Distance_Conflict=10^par(10);
    Parameter_IDP.Breadth_Distance_Conflict=10^par(11);
    
    Parameter_IDP.Scale_Level_Conflict=10^par(12);
    Parameter_IDP.Breadth_Level_Conflict=10^par(13);

save('Kernel_Paremeter_IDP_Non_Zero_Raion.mat','Parameter_IDP');


[w_Location]=Estimate_IDP_Displacement(Parameter_IDP,Pop_Raion_M(Raion_IDP>0,:),SCI_IDPt(Raion_IDP>0,:),Raion_Dist_BC(Raion_IDP>0,:),Num_BC(Raion_IDP>0),Raion_Conflict(Raion_IDP>0,:),DistC(Raion_IDP>0,:),Dist(Raion_IDP>0,:));

Est_Raion_IDP=w_Location*Pop_Moving_R;
%     Est_Raion_IDP(Est_Raion_IDP==0)=10^(-16);
%     Raion_IDP(Raion_IDP==0)=10^(-16);
    L=sqrt(sum((Raion_IDP(Raion_IDP>0)-Est_Raion_IDP).^2))./length(Raion_IDP(Raion_IDP>0));
close all;
figure(1)
[SR,IR]=sort(Raion_IDP(Raion_IDP>0));
bar([1:length(Est_Raion_IDP)],Est_Raion_IDP(IR)); hold on;
scatter([1:length(Est_Raion_IDP)],SR,40,'r','filled');

Raion_Zone_Rnz=Raion_Zone_R(Raion_IDP>0);
Zone_IDP=zeros(length(unique(Raion_Zone_Rnz)),1);
Est_Zone_IDP=zeros(length(unique(Raion_Zone_Rnz)),1);

for ii=1:length(Zone_IDP)
   Zone_IDP(ii)=sum(Raion_IDP(Raion_Zone_R==ii)); 
   Est_Zone_IDP(ii)=sum(Est_Raion_IDP(Raion_Zone_Rnz==ii));
end

figure(2)
bar([1:length(Zone_IDP)],Est_Zone_IDP); hold on;
scatter([1:length(Zone_IDP)],Zone_IDP,40,'r','filled');
