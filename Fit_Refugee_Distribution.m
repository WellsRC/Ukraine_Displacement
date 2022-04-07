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

x0=[0.454361909312188,2.63076720745783,0.200891946735844,0.0196196960694897,2.84108555056334];
LB=[-1.5 1 0.1 0 1.5];
UB=[1.5 4 0.5 0.05 3.5];
opts= optimset('UseParallel',false,'MaxIter',2500,'MaxFunEvals',1000,'TolFun',10^(-14),'TolX',10^(-14));

[par,fval]=lsqnonlin(@(x)ObjectiveFunction_Refugee_Dist(x,Ukraine_Pop,Border_Crossing_Country,Pop_Leave,Ref_Num),x0,LB,UB,opts);

lambda_sci=10^par(1);
lambda_bc=10.^par(2);
sc_bc=par(3);
s_nato=par(4);
lambda_GDP=10^par(5);

save('Refugee_Country_Distribution_Parameters.mat','lambda_sci','lambda_bc','sc_bc','s_nato','lambda_GDP');