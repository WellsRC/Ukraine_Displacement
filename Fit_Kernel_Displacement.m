clear;

[Number_Displacement,Date_Displacement,vLat_C,vLon_C,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,Pop_MACRO,Time_Sim,ML_Indx,RC,Time_Switch]=LoadData;
day_W_fix=7;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Run Fitting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[lb,ub]=ParameterBounds;


options = optimoptions('surrogateopt','MaxFunctionEvaluations',2500);

[par,fval] =surrogateopt(@(x)ObjectiveFunction(x,vLat_C,vLon_C,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,Pop_MACRO,Number_Displacement,Date_Displacement,RC,Time_Switch,Time_Sim,ML_Indx,day_W_fix),lb,ub,options);

[Parameter,STDEV_Displace]=Parameter_Return(par,RC,Time_Switch,day_W_fix);

save(['Kernel_Paremeter-Window_Conflict=' num2str(day_W_fix) '_days.mat'],'Parameter','STDEV_Displace');