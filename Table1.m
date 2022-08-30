clear;
clc;
load('Uncertainty_text.mat','UN_Refugee_Num_Country','UN_Refugee_Disease','UN_Num_IDP','UN_IDP_Disease','MLE_Refugee_Num_Country','MLE_Refugee_Disease','MLE_Num_IDP','MLE_IDP_Disease');

Population_MLE=[round(MLE_Num_IDP); round(MLE_Refugee_Num_Country)'];
CVD_MLE=[round(MLE_IDP_Disease(1)); round(squeeze(MLE_Refugee_Disease(1,:))')];
Diabetes_MLE=[round(MLE_IDP_Disease(2)); round(squeeze(MLE_Refugee_Disease(2,:))')];
Cancer_MLE=[round(MLE_IDP_Disease(3)); round(squeeze(MLE_Refugee_Disease(3,:))')];
HIV_MLE=[round(MLE_IDP_Disease(4)); round(squeeze(MLE_Refugee_Disease(4,:))')];
TB_MLE=[round(MLE_IDP_Disease(5)); round(squeeze(MLE_Refugee_Disease(5,:))')];

Country_Name={'IDPs';'Poland';'Slovakia';'Hungary';'Romania';'Belarus';'Moldova';'Russia';'Europe'};

Population_UN=[round(prctile(UN_Num_IDP,[2.5 97.5])); round(prctile(UN_Refugee_Num_Country,[2.5 97.5])')];
CVD_UN=[round(prctile(squeeze(UN_IDP_Disease(:,1)),[2.5 97.5])); round(prctile(squeeze(UN_Refugee_Disease(:,1,:)),[2.5 97.5])')];
Diabetes_UN=[round(prctile(squeeze(UN_IDP_Disease(:,2)),[2.5 97.5])); round(prctile(squeeze(UN_Refugee_Disease(:,2,:)),[2.5 97.5])')];
Cancer_UN=[round(prctile(squeeze(UN_IDP_Disease(:,3)),[2.5 97.5])); round(prctile(squeeze(UN_Refugee_Disease(:,3,:)),[2.5 97.5])')];
HIV_UN=[round(prctile(squeeze(UN_IDP_Disease(:,4)),[2.5 97.5])); round(prctile(squeeze(UN_Refugee_Disease(:,4,:)),[2.5 97.5])')];
TB_UN=[round(prctile(squeeze(UN_IDP_Disease(:,5)),[2.5 97.5])); round(prctile(squeeze(UN_Refugee_Disease(:,5,:)),[2.5 97.5])')];

Population=cell(length(Population_MLE),1);
CVD=cell(length(Population_MLE),1);
Diabetes=cell(length(Population_MLE),1);
Cancer=cell(length(Population_MLE),1);
HIV=cell(length(Population_MLE),1);
TB=cell(length(Population_MLE),1);

for ii=1:length(Population)
    Population{ii}=[num2str(Population_MLE(ii)) ' (' num2str(Population_UN(ii,1)) char(8211) num2str(Population_UN(ii,2))  ')'];
    CVD{ii}=[num2str(CVD_MLE(ii)) ' (' num2str(CVD_UN(ii,1)) char(8211) num2str(CVD_UN(ii,2))  ')'];
    Diabetes{ii}=[num2str(Diabetes_MLE(ii)) ' (' num2str(Diabetes_UN(ii,1)) char(8211) num2str(Diabetes_UN(ii,2))  ')'];
    Cancer{ii}=[num2str(Cancer_MLE(ii)) ' (' num2str(Cancer_UN(ii,1)) char(8211) num2str(Cancer_UN(ii,2))  ')'];
    HIV{ii}=[num2str(HIV_MLE(ii)) ' (' num2str(HIV_UN(ii,1)) char(8211) num2str(HIV_UN(ii,2))  ')'];
    TB{ii}=[num2str(TB_MLE(ii)) ' (' num2str(TB_UN(ii,1)) char(8211) num2str(TB_UN(ii,2))  ')'];
end

[~,I]=sort(Population_MLE,'descend');
Country=Country_Name(I);
Population=Population(I);
CVD=CVD(I);
Diabetes=Diabetes(I);
Cancer=Cancer(I);
HIV=HIV(I);
TB=TB(I);
T=table(Country,Population,CVD,Diabetes,Cancer,HIV,TB);

writetable(T,'Table1.csv')
