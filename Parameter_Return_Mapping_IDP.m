function [Parameter_Map_IDP,IDP_Mv]=Parameter_Return_Mapping_IDP(x,Model_IDP)


IDP_Mv=zeros(1,4);
temp=de2bi(Model_IDP);
IDP_Mv(1:length(temp))=temp;
% IDP parameters


Parameter_Map_IDP.STDEV_MACRO=10.^x(1);

if(IDP_Mv(1)>0)
    Parameter_Map_IDP.Breadth_SCI=10^x(2);
else
    Parameter_Map_IDP.Breadth_SCI=0;
end
if(IDP_Mv(2)>0)
    Parameter_Map_IDP.Breadth_Conflict=x(1+sum(IDP_Mv(1:2)));
else
    Parameter_Map_IDP.Breadth_Conflict=0;
end

if(IDP_Mv(3)>0)
    Parameter_Map_IDP.Breadth_Travel_Conflict=x(1+sum(IDP_Mv(1:3)));
else
    Parameter_Map_IDP.Breadth_Travel_Conflict=0;
end

if(IDP_Mv(4)>0)
    Parameter_Map_IDP.Capital=10.^x(1+sum(IDP_Mv(1:4)));
else
    Parameter_Map_IDP.Capital=0;
end

end