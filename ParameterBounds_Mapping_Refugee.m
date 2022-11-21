function [LB,UB]=ParameterBounds_Mapping_Refugee(Model_Refugee)

Refugee_Mv=zeros(1,5);
temp=de2bi(Model_Refugee);
Refugee_Mv(1:length(temp))=temp;


 
 Refugee_Mv=[1 1 Refugee_Mv];
 
% %Refugee parameters

% Parameter_Map_Refugee.weight_Europe=x(1);
% Parameter_Map_Refugee.STDEV=10^x(2);
% Parameter_Map_Refugee.lambda_sci=10.^x(3);
% Parameter_Map_Refugee.lambda_GDP=10.^x(4);
% Parameter_Map_Refugee.lambda_GDPc=10.^x(5);
% Parameter_Map_Refugee.weight_NATO=x(6);
% Parameter_Map_Refugee.lambda_border=10^x(7);

 LB=[0.001 3  0.75 1.5 2.5 0 1.5];
 UB=[0.01  6  4.00 6.0 7.0 1 6.0]; 
     
LB=LB(Refugee_Mv==1);
UB=UB(Refugee_Mv==1);
end