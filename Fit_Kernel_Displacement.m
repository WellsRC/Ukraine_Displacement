clear;

LoadData;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Run Fitting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x0 = [-3,-1 0.95];
lb=[-6 -4 0];
ub=[0 0 1];
options = optimoptions(@lsqnonlin,'FunctionTolerance',10^(-16),'MaxFunctionEvaluations',500,'MaxIterations',1000);
[par,fval] = lsqnonlin(@(x)ObjectiveFunction(x,vLat_C,vLon_C,Lat_P,Lon_P,Pop,Number_Displacement),x0,lb,ub,options);

Parameter.Scale=10.^par(1);
Parameter.Breadth=10.^par(2);
Parameter.w=par(3);

save('Kernel_Paremeter.mat','Parameter');