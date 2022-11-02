function [LB,UB]=ParameterBounds_Mapping_IDP(Model_IDP)


IDP_Mv=zeros(1,4);
temp=de2bi(Model_IDP);
IDP_Mv(1:length(temp))=temp;

IDP_Mv=[1 IDP_Mv];

% % IDP parameters
% Parameter_Map_IDP.STDEV_MACRO=10.^x(1);
% Parameter_Map_IDP.Breadth_SCI=10^x(2);
% Parameter_Map_IDP.Breadth_Conflict=x(3);
% Parameter_Map_IDP.Breadth_Travel_Conflict=x(4);
% Parameter_Map_IDP.Capital=10.^x(5);


 LB=[  4 log10(0.1)  0.5       0.1 -1];
 UB=[ 6 log10(50)   1          1  1.5];

 LB=LB(IDP_Mv==1);
 UB=UB(IDP_Mv==1);
end