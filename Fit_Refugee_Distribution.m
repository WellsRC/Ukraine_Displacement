clear;
clc;

% 
LoadData;


%MARCH 11

Ref_Num=[105897 1575703 938 185673 235576 84671 104929 304156];

% 
load('Kernel_Paremeter.mat','Parameter');

P=zeros(length(Lon_P),length(vLon_C));
PCt=ones(length(Lon_P),1);
PC=zeros(length(Lon_P),length(vLon_C));

for jj=1:length(vLon_C)
    P= Kernel_Displacement(vLat_C{jj},vLon_C{jj},Lat_P,Lon_P,Parameter);
    PCt=PCt.*(1-P);    
    Pt=Parameter.w.*P+(1-Parameter.w).*Parameter.ScaleC.*(1-PCt);
    PC(:,jj)=Pt;
end

P_Total=1-prod(1-PC,2);

Pop_Leave=Pop.*P_Total;


cLat=cell2mat(vLat_C);
cLon=cell2mat(vLon_C);

BC=readtable('ukr_border_crossings_170322.xlsx','Sheet','Border Crossings');
rLat=BC.Lat;
rLon=BC.Long;

x0=[0.5 log10(500) 0.2 0.2 0.8];
LB=[0 1 0 0 0];
UB=[1 4 1 1 1];
% opts= optimset('UseParallel',true,'MaxIter',2500,'MaxFunEvals',1000,'TolFun',10^(-3),'TolX',10^(-9));

% par=fmincon(@(x)ObjectiveFunction_Refugee_Dist(x,Ukraine_Pop,Border_Crossing_Country,Pop_Remain,Ref_Num),x0,[],[],[],[],LB,UB,[],opts);

opts=optimoptions('surrogateopt','PlotFcn','surrogateoptplot','MaxFunctionEvaluations',1250,'UseParallel',true);
par=surrogateopt(@(x)ObjectiveFunction_Refugee_Dist(x,Ukraine_Pop,Border_Crossing_Country,Pop_Leave,Ref_Num),LB,UB,opts);
sc_sci=par(1);
lambda_bc=10.^par(2);
sc_bc=par(3);
sc_nbc=par(4);
s_nato=par(5);

save('Refugee_Country_Distribution_Parameters.mat','sc_sci','lambda_bc','sc_bc','sc_nbc','ws','wo');