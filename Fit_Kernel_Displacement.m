clear;

LoadData;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Run Fitting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x0 = [-2 0.51 0.25];
lb=[-2.5  0 0];
ub=[0 1 1];

RC=fmincon(@(x)(norminv(0.975,0,x)-12.5).^2,6.4);
tic;
options = optimoptions(@lsqnonlin,'FunctionTolerance',10^(-16),'MaxFunctionEvaluations',500,'MaxIterations',1000);
[par,fval] = lsqnonlin(@(x)ObjectiveFunction(x,vLat_C,vLon_C,Lat_P,Lon_P,Pop,Number_Displacement,RC),x0,lb,ub,options);
toc;
Parameter.Scale=10.^par(1);
Parameter.Breadth=RC;
Parameter.w=par(2);
Parameter.ScaleC=par(3);

save('Kernel_Paremeter.mat','Parameter');