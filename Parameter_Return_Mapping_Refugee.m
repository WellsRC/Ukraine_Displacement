function [Parameter_Map_Refugee,Refugee_Mv]=Parameter_Return_Mapping_Refugee(x,Model_Refugee)

Refugee_Mv=zeros(1,5);
temp=de2bi(Model_Refugee);
Refugee_Mv(1:length(temp))=temp;


Parameter_Map_Refugee.weight_Europe=x(1);
Parameter_Map_Refugee.STDEV=10^x(2);

%Refugee parameters
if(Refugee_Mv(1)>0)
    Parameter_Map_Refugee.lambda_sci=10.^x(2+Refugee_Mv(1));
else
    Parameter_Map_Refugee.lambda_sci=0;    
end
if(Refugee_Mv(2)>0)
    Parameter_Map_Refugee.lambda_GDP=10.^x(2+sum(Refugee_Mv(1:2)));
else
    Parameter_Map_Refugee.lambda_GDP=0;
end
if(Refugee_Mv(3)>0)
    Parameter_Map_Refugee.lambda_GDPc=10.^x(2+sum(Refugee_Mv(1:3)));
else
    Parameter_Map_Refugee.lambda_GDPc=0;
end
if(Refugee_Mv(4)>0)
    Parameter_Map_Refugee.weight_NATO=x(2+sum(Refugee_Mv(1:4)));
else
    Parameter_Map_Refugee.weight_NATO=0;
end
if(Refugee_Mv(5)>0)
    Parameter_Map_Refugee.lambda_border=10^x(2+sum(Refugee_Mv(1:5)));
else
    Parameter_Map_Refugee.lambda_border=0;
end
end