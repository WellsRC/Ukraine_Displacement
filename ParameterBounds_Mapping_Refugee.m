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

 LB=[0    3  0.75 1.5 2.5 0    1.5];
 UB=[0.25 6 2.25 4.5 5.5 0.25 4.5]; 
     
LB=LB(Refugee_Mv==1);
UB=UB(Refugee_Mv==1);
end