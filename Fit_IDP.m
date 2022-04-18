clear;

load('IDP_Fit_Inputs.mat');
% Pop_Raion_T=log(Pop_Raion)-min(log(Pop_Raion));
SCI_IDPt=max(log10(SCI_IDP(:)))-log10(SCI_IDP);

Raion_Conflict_M=zeros(length(Raion_Conflict(:,1)),length(Raion_Index),length(Raion_Conflict(1,:)));
for dd=1:length(Raion_Conflict(1,:))
    Raion_Conflict_pix=Raion_Conflict(Raion_Index,dd)';
    Raion_Conflict_M(:,:,dd)=(repmat(Raion_Conflict_pix,length(Raion_Conflict_M(:,dd)),1)-repmat(Raion_Conflict(:,dd),1,length(Raion_Index)))+1;
end

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
ub=[0 3 0 10 0 6 3 2 1 0 6 2 2];
    
options = optimoptions('surrogateopt','MaxFunctionEvaluations',5000,'PlotFcn','surrogateoptplot');
[par,fval_so] = surrogateopt(@(x)ObjectiveFunction_IDP(x,Pop_IDP_R,Pop_Raion_M(Raion_IDP>0,:),SCI_IDPt(Raion_IDP>0,:),Raion_Dist_BC(Raion_IDP>0,:),Num_BC(Raion_IDP>0),Raion_Conflict_M(Raion_IDP>0,:,:),DistC(Raion_IDP>0,:),Dist(Raion_IDP>0,:),Raion_IDP(Raion_IDP>0),Raion_Zone_R(Raion_IDP>0)),lb,ub,options);
% options = optimoptions('fmincon','PlotFcn','optimplotfval','StepTolerance',10^(-8),'FunctionTolerance',10^(-8));
%  [par,fval]=fmincon(@(x)ObjectiveFunction_IDP(x,Pop_IDP_R,Pop_Raion_M(Raion_IDP>0,:),SCI_IDPt(Raion_IDP>0,:),Raion_Dist_BC(Raion_IDP>0,:),Num_BC(Raion_IDP>0),Raion_Conflict_M(Raion_IDP>0,:,:),DistC(Raion_IDP>0,:),Dist(Raion_IDP>0,:),Raion_IDP(Raion_IDP>0),Raion_Zone_R(Raion_IDP>0)),x0,[],[],[],[],lb,ub);
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

