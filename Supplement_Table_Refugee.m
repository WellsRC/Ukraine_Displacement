clear;
load('Uncertainty_text.mat')

Model_Est_Disease_T=cell(8,5);
Rel_Diff_Nat_T=cell(8,5);
Rel_Diff_Gender_T=cell(8,5);
Rel_Diff_Age_T=cell(8,5);
Rel_Diff_Age_Gender_T=cell(8,5);
Disease=cell(8,5);
Country=cell(8,5);
Country_Name={'Poland';'Slovakia';'Hungary';'Romania';'Belarus';'Moldova';'Russia';'Europe'};
for ii=1:5
    for jj=1:8
        Country{jj,ii}=Country_Name{jj};
        Disease{jj,ii}=Disease_Short{ii};
        Model_Est_Disease_T{jj,ii}=[num2str(round(MLE_Refugee_Disease(ii,jj))) ' (' num2str(round(prctile(UN_Refugee_Disease(:,ii,jj),2.5))) char(8211) num2str(round(prctile(UN_Refugee_Disease(:,ii,jj),97.5))) ')'];
        Rel_Diff_Nat_T{jj,ii}=[num2str(round(100.*MLE_Rel_Diff_Nat(ii,jj),2)) '% (' num2str(round(prctile(100.*UN_Rel_Diff_Nat(:,ii,jj),2.5),2)) '%' char(8211) num2str(round(prctile(100.*UN_Rel_Diff_Nat(:,ii,jj),97.5),2)) '%)'];
        Rel_Diff_Gender_T{jj,ii}=[num2str(round(100.*MLE_Rel_Diff_Gender(ii,jj),2)) '% (' num2str(round(prctile(100.*UN_Rel_Diff_Gender(:,ii,jj),2.5),2)) '%' char(8211) num2str(round(prctile(100.*UN_Rel_Diff_Gender(:,ii,jj),97.5),2)) '%)'];
        Rel_Diff_Age_T{jj,ii}=[num2str(round(100.*MLE_Rel_Diff_Age(ii,jj),2)) '% (' num2str(round(prctile(100.*UN_Rel_Diff_Age(:,ii,jj),2.5),2)) '%' char(8211) num2str(round(prctile(100.*UN_Rel_Diff_Age(:,ii,jj),97.5),2)) '%)'];
        Rel_Diff_Age_Gender_T{jj,ii}=[num2str(round(100.*MLE_Rel_Diff_Age_Gender(ii,jj),2)) '% (' num2str(round(prctile(100.*UN_Rel_Diff_Age_Gender(:,ii,jj),2.5),2)) '%' char(8211) num2str(round(prctile(100.*UN_Rel_Diff_Age_Gender(:,ii,jj),97.5),2)) '%)'];
    end
end


Disease=Disease(:);
Country=Country(:);
Model_Est_Disease_T=Model_Est_Disease_T(:);
Rel_Diff_Nat_T=Rel_Diff_Nat_T(:);
Rel_Diff_Gender_T=Rel_Diff_Gender_T(:);
Rel_Diff_Age_T=Rel_Diff_Age_T(:);
Rel_Diff_Age_Gender_T=Rel_Diff_Age_Gender_T(:);

T_Final=table(Disease,Country,Model_Est_Disease_T,Rel_Diff_Nat_T,Rel_Diff_Gender_T,Rel_Diff_Age_T,Rel_Diff_Age_Gender_T);

writetable(T_Final,'Supplementary_Data.xlsx','Sheet','Disease_Burden_Refugees','Range','A3','WriteVariableNames',false);

