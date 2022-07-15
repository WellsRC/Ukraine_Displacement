
clear;

Par_KD=[];
Par_Map=[];
L_T=[];

for ii=0:14
    load(['Mapping_Refugee_IDP_' num2str(ii) '.mat']);
    L_T=[L_T; L_V_Samp(L_V_Mapping<0) L_V_Mapping(L_V_Mapping<0)];
    Par_Map=[Par_Map; par_V(L_V_Mapping<0,:)];
    Par_KD=[Par_KD; Parameter_Samp(L_V_Mapping<0,:)];
end

save('Merge_Parameter_Uncertainty.mat','Par_KD','Par_Map','L_T');
