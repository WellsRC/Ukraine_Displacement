clear;
clc;
load('Uncertainty_text.mat','UN_IDP_Num','UN_Refugee_Disease');

Population_MLE=round([Refugee_Disease_t(strcmp(Disease,'All'),2:end)'; sum(Refugee_Disease_t(strcmp(Disease,'All'),2:end))]);
CVD_MLE=round([Refugee_Disease_t(strcmp(Disease,'CVD'),2:end)'; sum(Refugee_Disease_t(strcmp(Disease,'CVD'),2:end))]);
Diabetes_MLE=round([Refugee_Disease_t(strcmp(Disease,'Diabetes'),2:end)'; sum(Refugee_Disease_t(strcmp(Disease,'Diabetes'),2:end))]);
Cancer_MLE=round([Refugee_Disease_t(strcmp(Disease,'Cancer'),2:end)'; sum(Refugee_Disease_t(strcmp(Disease,'Cancer'),2:end))]);
HIV_MLE=round([Refugee_Disease_t(strcmp(Disease,'HIV'),2:end)'; sum(Refugee_Disease_t(strcmp(Disease,'HIV'),2:end))]);
TB_MLE=round([Refugee_Disease_t(strcmp(Disease,'TB'),2:end)'; sum(Refugee_Disease_t(strcmp(Disease,'TB'),2:end))]);

CVD_Per_MLE=round(100.*[Refugee_Disease_t(strcmp(Disease,'CVD'),2:end)'./Refugee_Disease_t(strcmp(Disease,'All'),2:end)'; sum(Refugee_Disease_t(strcmp(Disease,'CVD'),2:end))./sum(Refugee_Disease_t(strcmp(Disease,'All'),2:end))],2);
Diabetes_Per_MLE=round(100.*[Refugee_Disease_t(strcmp(Disease,'Diabetes'),2:end)'./Refugee_Disease_t(strcmp(Disease,'All'),2:end)'; sum(Refugee_Disease_t(strcmp(Disease,'Diabetes'),2:end))./sum(Refugee_Disease_t(strcmp(Disease,'All'),2:end))],2);
Cancer_Per_MLE=round(100.*[Refugee_Disease_t(strcmp(Disease,'Cancer'),2:end)'./Refugee_Disease_t(strcmp(Disease,'All'),2:end)'; sum(Refugee_Disease_t(strcmp(Disease,'Cancer'),2:end))./sum(Refugee_Disease_t(strcmp(Disease,'All'),2:end))],2);
HIV_Per_MLE=round(100.*[Refugee_Disease_t(strcmp(Disease,'HIV'),2:end)'./Refugee_Disease_t(strcmp(Disease,'All'),2:end)'; sum(Refugee_Disease_t(strcmp(Disease,'HIV'),2:end))./sum(Refugee_Disease_t(strcmp(Disease,'All'),2:end))],2);
TB_Per_MLE=round(100.*[Refugee_Disease_t(strcmp(Disease,'TB'),2:end)'./Refugee_Disease_t(strcmp(Disease,'All'),2:end)'; sum(Refugee_Disease_t(strcmp(Disease,'TB'),2:end))./sum(Refugee_Disease_t(strcmp(Disease,'All'),2:end))],2);

Country=Country_Name([2:end 1]);
Country{end}='Total';



load('Uncertainty_text.mat','UN_Refugee_Num_Country','UN_Refugee_Disease');

Population_UN=round([prctile(UN_Refugee_Num_Country,[2.5 97.5])'; prctile(sum(UN_Refugee_Num_Country,2),[2.5 97.5])]);
CVD_UN=round([prctile(squeeze(UN_Refugee_Disease(:,1,:)),[2.5 97.5])'; prctile(sum(squeeze(UN_Refugee_Disease(:,1,:)),2),[2.5 97.5])]);
Diabetes_UN=round([prctile(squeeze(UN_Refugee_Disease(:,2,:)),[2.5 97.5])'; prctile(sum(squeeze(UN_Refugee_Disease(:,2,:)),2),[2.5 97.5])]);
Cancer_UN=round([prctile(squeeze(UN_Refugee_Disease(:,3,:)),[2.5 97.5])'; prctile(sum(squeeze(UN_Refugee_Disease(:,3,:)),2),[2.5 97.5])]);
HIV_UN=round([prctile(squeeze(UN_Refugee_Disease(:,4,:)),[2.5 97.5])'; prctile(sum(squeeze(UN_Refugee_Disease(:,4,:)),2),[2.5 97.5])]);
TB_UN=round([prctile(squeeze(UN_Refugee_Disease(:,6,:)),[2.5 97.5])'; prctile(sum(squeeze(UN_Refugee_Disease(:,6,:)),2),[2.5 97.5])]);

X=repmat(UN_Refugee_Num_Country,1,1,7);
X=permute(X, [1 3 2]);
Tot=squeeze(sum(UN_Refugee_Disease,3));
XTot=sum(X,3);
RTot=Tot./XTot;

UN_Refugee_Per=UN_Refugee_Disease./X;

CVD_Per_UN=round(100.*[prctile(squeeze(UN_Refugee_Per(:,1,:)),[2.5 97.5])'; prctile(RTot(:,1),[2.5 97.5])],2);
Diabetes_Per_UN=round(100.*[prctile(squeeze(UN_Refugee_Per(:,2,:)),[2.5 97.5])'; prctile(RTot(:,2),[2.5 97.5])],2);
Cancer_Per_UN=round(100.*[prctile(squeeze(UN_Refugee_Per(:,3,:)),[2.5 97.5])'; prctile(RTot(:,3),[2.5 97.5])],2);
HIV_Per_UN=round(100.*[prctile(squeeze(UN_Refugee_Per(:,4,:)),[2.5 97.5])'; prctile(RTot(:,4),[2.5 97.5])],2);
TB_Per_UN=round(100.*[prctile(squeeze(UN_Refugee_Per(:,6,:)),[2.5 97.5])'; prctile(RTot(:,6),[2.5 97.5])],2);

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



T=table(Country,Population,CVD,Diabetes,Cancer,HIV,TB);

writetable(T,'Refugee_Numbers_Table.csv')


CVD=cell(length(CVD_Per_MLE),1);
Diabetes=cell(length(CVD_Per_MLE),1);
Cancer=cell(length(CVD_Per_MLE),1);
HIV=cell(length(CVD_Per_MLE),1);
TB=cell(length(CVD_Per_MLE),1);

for ii=1:length(CVD)
    CVD{ii}=[num2str(CVD_Per_MLE(ii)) '% (' num2str(CVD_Per_UN(ii,1)) '%' char(8211) num2str(CVD_Per_UN(ii,2))  '%)'];
    Diabetes{ii}=[num2str(Diabetes_Per_MLE(ii)) '% (' num2str(Diabetes_Per_UN(ii,1)) '%' char(8211) num2str(Diabetes_Per_UN(ii,2))  '%)'];
    Cancer{ii}=[num2str(Cancer_Per_MLE(ii)) '% (' num2str(Cancer_Per_UN(ii,1)) '%' char(8211) num2str(Cancer_Per_UN(ii,2))  '%)'];
    HIV{ii}=[num2str(HIV_Per_MLE(ii)) '% (' num2str(HIV_Per_UN(ii,1)) '%' char(8211) num2str(HIV_Per_UN(ii,2))  '%)'];
    TB{ii}=[num2str(TB_Per_MLE(ii)) '% (' num2str(TB_Per_UN(ii,1)) '%' char(8211) num2str(TB_Per_UN(ii,2))  '%)'];
end


T=table(Country,CVD,Diabetes,Cancer,HIV,TB);

writetable(T,'Refugee_Percentage_Table.csv')