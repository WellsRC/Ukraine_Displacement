function X0=Initialize_Model_Refugee(par_X0,model_X0,model_num)
[~,UB]=ParameterBounds_Mapping_Refugee(model_num);

X0=UB;

Refugee_Mv=zeros(1,5);
temp=de2bi(model_X0);
Refugee_Mv(1:length(temp))=temp;


Refugee_Mv2=zeros(1,5);
temp=de2bi(model_num);
Refugee_Mv2(1:length(temp))=temp;

X0(1:2)=par_X0(1:2);

%Refugee parameters
for jj=1:5
    if(Refugee_Mv(jj)>0)    
        X0(2+sum(Refugee_Mv2(1:jj)))=par_X0(2+sum(Refugee_Mv(1:jj)));
    end
end
end