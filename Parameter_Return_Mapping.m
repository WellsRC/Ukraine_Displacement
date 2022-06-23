function [Parameter_Map_Refugee,Parameter_Map_IDP]=Parameter_Return_Mapping(x)

%Refugee parameters
Parameter_Map_Refugee.lambda_sci=10.^x(1);
Parameter_Map_Refugee.lambda_GDP=10.^x(2);
Parameter_Map_Refugee.lambda_GDPc=10.^x(3);
Parameter_Map_Refugee.weight_NATO=x(4);
Parameter_Map_Refugee.lambda_border=10^x(5);
Parameter_Map_Refugee.weight_Europe=x(6);
Parameter_Map_Refugee.STDEV=10^x(7);

% IDP parameters
Parameter_Map_IDP.Breadth_SCI=10^x(8);
Parameter_Map_IDP.Breadth_Conflict=x(9);
Parameter_Map_IDP.Breadth_Travel_Conflict=x(10);
Parameter_Map_IDP.Capital=10.^x(11);
Parameter_Map_IDP.STDEV_MACRO=10.^x(12);

end