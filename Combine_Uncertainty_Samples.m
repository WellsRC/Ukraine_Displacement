
clear;

Par_KD=[];
Par_Map=[];
L_T=[];

for ii=0:19
    load(['Mapping_Refugee_IDP_' num2str(ii) '.mat']);
    L_T=[L_T; L_V_Samp(L_V_Mapping<0) L_V_Mapping(L_V_Mapping<0)];
    Par_Map=[Par_Map; par_V(L_V_Mapping<0,:)];
    Par_KD=[Par_KD; Parameter_Samp(L_V_Mapping<0,:)];
end


Par_KD=Par_KD(Par_Map(:,4)>0,:);
L_T=L_T(Par_Map(:,4)>0,:);
Par_Map=Par_Map(Par_Map(:,4)>0,:);

MLE_KD=Par_KD(sum(L_T,2)==max(sum(L_T,2)),:);
MLE_Map=Par_Map(sum(L_T,2)==max(sum(L_T,2)),:);
save('Merge_Parameter_MLE.mat','MLE_KD','MLE_Map');

Par_KD=Par_KD(1:1000,:);
L_T=L_T(1:1000,:);
Par_Map=Par_Map(1:1000,:);
save('Merge_Parameter_Uncertainty.mat','Par_KD','Par_Map','L_T');
