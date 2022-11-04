clear;

L=zeros(32,1);
k=zeros(32,1);

for ii=0:31
    
    load(['Mapping_Refugee_MLE_Model=' num2str(ii) '.mat'],'par_V','L_V_Mapping');
    if(~isempty(L_V_Mapping))
        L(ii+1)=L_V_Mapping;
        k(ii+1)=length(par_V);
    else
        L(ii+1)=-Inf;
        k(ii+1)=1;
    end
    
end

aics=aicbic(L,k);

daics=aics-min(aics);