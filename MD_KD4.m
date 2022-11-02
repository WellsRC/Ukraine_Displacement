clear;
parpool(16)
% [Number_Displacement,Date_Displacement,vLat_C,vLon_C,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,Pop_SES,Pop_MACRO,Pop_raion,Pop_oblast,Time_Sim,~,Time_Switch]=LoadData(25);
load('Calibration_Conflict_Kernel.mat');
Rad_Conflict=[25:25:200];
RC=zeros(size(Rad_Conflict));
for ii=1:length(Rad_Conflict)
    RC(ii)=fmincon(@(x)(norminv(0.975,0,x)-Rad_Conflict(ii)).^2,6.4);
end
day_W_fix=[1:21];

[RC,day_W_fix]=meshgrid(RC,day_W_fix);

RC=RC(:);
day_W_fix=day_W_fix(:);

N=length(RC);

Model_Num=4;

[LB,UB]=ParameterBounds(Model_Num);
options = optimoptions('surrogateopt','PlotFcn',[],'MaxFunctionEvaluations',10^4,'UseParallel',false);
fval=zeros(N,1);
x0=zeros(N,length(LB));


parfor ii=1:N
    [x0(ii,:),fval(ii)]=surrogateopt(@(x)ObjectiveFunction(x,vLat_C,vLon_C,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,Pop_SES,Pop_MACRO,Number_Displacement,Date_Displacement,RC(ii),Time_Switch,Time_Sim,day_W_fix(ii),Model_Num),LB,UB,options);
end

save(['Calibration_Kernel_Conflict_Window-Conflcit_Radius_Model=' num2str(Model_Num) '.mat'],'x0','fval','day_W_fix','RC');