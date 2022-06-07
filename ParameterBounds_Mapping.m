function [LB,UB]=ParameterBounds_Mapping()
% %Refugee parameters
% Parameter_Map_Refugee.lambda_sci=10.^x(1);
% Parameter_Map_Refugee.lambda_GDP=10.^x(2);
% Parameter_Map_Refugee.lambda_GDPc=10.^x(3);
% Parameter_Map_Refugee.weight_NATO=x(4);
% Parameter_Map_Refugee.lambda_border=10^x(5);
% Parameter_Map_Refugee.weight_Europe=x(6);
% Parameter_Map_Refugee.STDEV=10^x(7);
% 
% % IDP parameters
% Parameter_Map_IDP.Breadth_Border_Distance=10.^x(8);
% Parameter_Map_IDP.Breadth_SCI=10^x(9);
% Parameter_Map_IDP.Breadth_Population_Sites=10^x(10);
% Parameter_Map_IDP.Scale_Capital=x(11);
% Parameter_Map_IDP.Breadth_Capital=10.^x(12);
% Parameter_Map_IDP.Scale_Distance=x(13);
% Parameter_Map_IDP.Breadth_Distance=10.^x(14);
% Parameter_Map_IDP.Breadth_Distance_Conflict=10.^x(15);
% Parameter_Map_IDP.STDEV_MACRO=10.^x(16);
% Parameter_Map_IDP.STDEV_OBLAST=10.^x(17);
% Parameter_Map_IDP.STDEV_RAION=10.^x(18);

% LB=[ 0   2    3 0.01          1 0.01 1  -1 0 -2 0 -2 -10   -1  1 3 3 3];
% UB=[ 2   3.5  5 0.10          3 0.20 3 1.5 2  1 1  2  -4  1.5 -1 7 7 7];

LB=[log10(39)    log10(629.55) log10(15545) 0.060 log10(330) 0.024 log10(617.4) 2           0        -2  0       -2    0    0       -1  4 4 4];
UB=[log10(39.05) log10(629.60) log10(15547) 0.062 log10(331) 0.025 log10(617.5) log10(5000) 1  log10(50) 1 log10(50)   1    3 log10(50) 6 6 6];
end