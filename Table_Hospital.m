clear;
clc
load('MLE_Hospital_Table.mat','T_HS');

Oblast_N=table2array(T_HS(:,1));
Raion_N=table2array(T_HS(:,2));
Pop_Pre=table2array(T_HS(:,3));
Hosp_Pre=table2array(T_HS(:,4));

NonIDP_Inv_InA=table2array(T_HS(:,5));
IDP_Inv_InA=table2array(T_HS(:,6));
Hosp_Inv_InA=table2array(T_HS(:,7));
load('Uncertainty_Hospital_UKR.mat','Hosp_Raion','Pop_IDP_Inv_Raion','Pop_NonIDP_Inv_Raion');

UN_Hospt_InA=squeeze(Hosp_Raion(:,:,2));

Non_IDP=cell(size(Oblast_N));
IDP=cell(size(Oblast_N));
Hosp_InA=cell(size(Oblast_N));

for ii=1:length(Non_IDP)
   Non_IDP{ii}=[ num2str(round(NonIDP_Inv_InA(ii))) ' (' num2str(round(prctile(Pop_NonIDP_Inv_Raion(:,ii),2.5))) char(8211) num2str(round(prctile(Pop_NonIDP_Inv_Raion(:,ii),97.5))) ')'];
   IDP{ii}=[ num2str(round(IDP_Inv_InA(ii))) ' (' num2str(round(prctile(Pop_IDP_Inv_Raion(:,ii),2.5))) char(8211) num2str(round(prctile(Pop_IDP_Inv_Raion(:,ii),97.5))) ')'];
   Hosp_InA{ii}=[ num2str(Hosp_Inv_InA(ii)) ' (' num2str(prctile(UN_Hospt_InA(:,ii),2.5)) char(8211) num2str(prctile(UN_Hospt_InA(:,ii),97.5)) ')'];
end

T_HS=table(Oblast_N,Raion_N,Pop_Pre,Hosp_Pre,Non_IDP,IDP,Hosp_InA);

writetable(T_HS,'Supplementary_Data.xlsx','Sheet','Hospital_Raions','Range','A3','WriteVariableNames',false);