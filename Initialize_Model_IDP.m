function X0=Initialize_Model_IDP(par_X0,model_X0,model_num)
[LB,UB]=ParameterBounds_Mapping_IDP(model_num);

X0=UB;

IDP_Mv=zeros(1,4);
temp=de2bi(model_X0);
IDP_Mv(1:length(temp))=temp;


IDP_Mv2=zeros(1,4);
temp=de2bi(model_num);
IDP_Mv2(1:length(temp))=temp;

if(IDP_Mv2(2)==1)
   X0(1+sum(IDP_Mv2(1:2)))=LB(1+sum(IDP_Mv2(1:2))); 
end

X0(1)=par_X0(1);

%Refugee parameters
for jj=1:4
    if(IDP_Mv(jj)>0)    
        X0(1+sum(IDP_Mv2(1:jj)))=par_X0(1+sum(IDP_Mv(1:jj)));
    end
end
end