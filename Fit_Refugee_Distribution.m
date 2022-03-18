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

x0=[2.49377949755863,0.8,2.56067086258808,0.143207402528654,0.0213288306672176,2.60485727006010];
LB=[1 0 1 0 0 1];
UB=[4 0.99 4 1 0.1 4];
opts= optimset('UseParallel',true,'MaxIter',2500,'MaxFunEvals',1000,'TolFun',10^(-9),'TolX',10^(-9));

[par,fval]=lsqnonlin(@(x)ObjectiveFunction_Refugee_Dist(x,Ukraine_Pop,Border_Crossing_Country,Pop_Leave,Ref_Num),x0,LB,UB,opts);

lambda_sci=10^par(1);
sc_GDP=par(2);
lambda_bc=10.^par(3);
sc_bc=par(4);
s_nato=par(5);
lambda_GDP=10^par(6);

save('Refugee_Country_Distribution_Parameters.mat','lambda_sci','sc_GDP','lambda_bc','sc_bc','s_nato','lambda_GDP');