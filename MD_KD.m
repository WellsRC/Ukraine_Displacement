parpool(32);

load('Load_Data_MCMC.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % Run Fitting
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('Kernel_Paremeter-Window_Conflict=7_days_Melding.mat','x_0','L_0')
x_0=x_0(L_0==max(L_0),:);
[LB,UB]=ParameterBounds;
NS=5000;
L_0=zeros(NS,1);
prt=-0.05+lhsdesign(NS,length(LB)).*0.1;
x_0=repmat(x_0,NS,1).*(1+prt);
for ii=1:length(LB)
    x_0(x_0(:,ii)>UB(ii),ii)=UB(ii);
    x_0(x_0(:,ii)<LB(ii),ii)=LB(ii);
end
count=0;
parfor ii=1:NS
    L_0(ii)=-ObjectiveFunction(x_0(ii,:),vLat_C,vLon_C,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,Pop_MACRO,Number_Displacement,Date_Displacement,RC,Time_Switch,Time_Sim,ML_Indx,day_W_fix);
end

save(['Kernel_Paremeter-Window_Conflict=' num2str(day_W_fix) '_days_Melding_Focused.mat']);