
clear;


L=zeros(16,1);
k=zeros(16,1);
for model_num=1:16
    load(['Mapping_IDP_MLE_Model=' num2str(model_num-1) '.mat'],'par_V','L_V_Mapping');
    L(model_num)=L_V_Mapping;
    k(model_num)=length(par_V);
end


aics=aicbic(L,k);

daics=aics-min(aics);

Model_IDP=find(daics==0)-1;

L=zeros(32,1);
k=zeros(32,1);
for model_num=1:32
    load(['Mapping_Refugee_MLE_Model=' num2str(model_num-1) '.mat'],'par_V','L_V_Mapping');
    L(model_num)=L_V_Mapping;
    k(model_num)=length(par_V);
end


aics=aicbic(L,k);

daics=aics-min(aics);

Model_Refugee=find(daics==0)-1;


load('MCMC_Sample_Forcible_Displacement_Parameters.mat','Parameter_Samp','L_V_Samp');

Par_FD=Parameter_Samp;
Par_Map_Ref=[];
Par_Map_IDP=[];
L_T=L_V_Samp;

for ii=1:2
    load(['MCMC_Sample_Refugee_Mapping_Parameters_' num2str(ii+1) '.mat'],'Parameter_Samp_Ref','L_V_Samp_Ref');
    if(ii==1)
        Par_Map_Ref=Parameter_Samp_Ref;
    else
        Par_Map_Ref(L_V_Samp_Ref~=0,:)=Parameter_Samp_Ref(L_V_Samp_Ref~=0,:);
    end
    
    load(['MCMC_Sample_IDP_Mapping_Parameters_' num2str(ii+1) '.mat'],'Parameter_Samp_IDP','L_V_Samp_IDP');
    if(ii==1)
        Par_Map_IDP=Parameter_Samp_IDP;
    else
        Par_Map_IDP(L_V_Samp_IDP~=0,:)=Parameter_Samp_IDP(L_V_Samp_IDP~=0,:);
    end
    
    L_T=L_T+L_V_Samp_Ref+L_V_Samp_IDP;
end

L_T=L_T(251:750);
Par_FD=Par_FD(251:750,:);
Par_Map_Ref=Par_Map_Ref(251:750,:);
Par_Map_IDP=Par_Map_IDP(251:750,:);
save('Merge_Parameter_Uncertainty.mat','Par_FD','Par_Map_Ref','Par_Map_IDP','L_T','Model_IDP','Model_Refugee');

MLE_FD=Par_FD(sum(L_T,2)==max(sum(L_T,2)),:);
MLE_Map_Ref=Par_Map_Ref(sum(L_T,2)==max(sum(L_T,2)),:);
MLE_Map_IDP=Par_Map_IDP(sum(L_T,2)==max(sum(L_T,2)),:);
save('Merge_Parameter_MLE.mat','MLE_FD','MLE_Map_Ref','MLE_Map_IDP','Model_IDP','Model_Refugee');


