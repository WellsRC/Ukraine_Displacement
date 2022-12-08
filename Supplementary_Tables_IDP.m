load('Uncertainty_text.mat','test_Idp','Disease_Short','MLE_Macro_Pop','MLE_Macro_Disease_PostWar','UN_Macro_Pop','UN_Macro_Disease_PostWar','MLE_Rel_Diff_Nat_Displaced_Macro','MLE_Rel_Diff_Age_Displaced_Macro','MLE_Rel_Diff_Gender_Displaced_Macro','MLE_Rel_Diff_Age_Gender_Displaced_Macro','UN_Rel_Diff_Nat_Displaced_Macro','UN_Rel_Diff_Age_Displaced_Macro','UN_Rel_Diff_Gender_Displaced_Macro','UN_Rel_Diff_Age_Gender_Displaced_Macro');



Macro_Region=test_Idp.macro_name;
Macro_Region{strcmp(Macro_Region,'N/A')}='Other';
for ii=1:length(Macro_Region)
    temp=Macro_Region{ii};
    Macro_Region{ii}=[temp(1) lower(temp(2:end))];
end

Table_Model=cell(length(Macro_Region).*length(Disease_Short),3);
Table_Err=cell(length(Macro_Region).*length(Disease_Short),4);


for ii=1:length(Macro_Region)
    Table_Model{ii,1}='Population';
    Table_Model{ii,2}=Macro_Region{ii};
    Table_Model{ii,3}=[ num2str(round(MLE_Macro_Pop(ii,2))) ' (' num2str(round(prctile(UN_Macro_Pop(:,ii,2),2.5))) char(8211) num2str(round(prctile(UN_Macro_Pop(:,ii,2),97.5))) ')'];
    
    Table_Err{ii,1}='N/A';
    Table_Err{ii,2}='N/A';
    Table_Err{ii,3}='N/A';
    Table_Err{ii,4}='N/A';
end
for dd=1:5
    for ii=1:length(Macro_Region)

        Table_Model{ii+length(Macro_Region).*(dd),1}=Disease_Short{dd};
        Table_Model{ii+length(Macro_Region).*(dd),2}=Macro_Region{ii};
        Table_Model{ii+length(Macro_Region).*(dd),3}=[ num2str(round(MLE_Macro_Disease_PostWar(dd,ii))) ' (' num2str(round(prctile(UN_Macro_Disease_PostWar(:,dd,ii),2.5))) char(8211) num2str(round(prctile(UN_Macro_Disease_PostWar(:,dd,ii),97.5))) ')'];
        
        
    Table_Err{ii+length(Macro_Region).*(dd),1}=[ num2str(round(100.*MLE_Rel_Diff_Nat_Displaced_Macro(dd,ii),2)) '% (' num2str(round(prctile(100.*UN_Rel_Diff_Nat_Displaced_Macro(:,dd,ii),2.5),2)) '%' char(8211) num2str(round(prctile(100.*UN_Rel_Diff_Nat_Displaced_Macro(:,dd,ii),97.5),2)) '%)'];
    Table_Err{ii+length(Macro_Region).*(dd),2}=[ num2str(round(100.*MLE_Rel_Diff_Age_Displaced_Macro(dd,ii),2)) '% (' num2str(round(prctile(100.*UN_Rel_Diff_Age_Displaced_Macro(:,dd,ii),2.5),2)) '%' char(8211) num2str(round(prctile(100.*UN_Rel_Diff_Age_Displaced_Macro(:,dd,ii),97.5),2)) '%)'];
    Table_Err{ii+length(Macro_Region).*(dd),3}=[ num2str(round(100.*MLE_Rel_Diff_Gender_Displaced_Macro(dd,ii),2)) '% (' num2str(round(prctile(100.*UN_Rel_Diff_Gender_Displaced_Macro(:,dd,ii),2.5),2)) '%' char(8211) num2str(round(prctile(100.*UN_Rel_Diff_Gender_Displaced_Macro(:,dd,ii),97.5),2)) '%)'];
    Table_Err{ii+length(Macro_Region).*(dd),4}=[ num2str(round(100.*MLE_Rel_Diff_Age_Gender_Displaced_Macro(dd,ii),2)) '% (' num2str(round(prctile(100.*UN_Rel_Diff_Age_Gender_Displaced_Macro(:,dd,ii),2.5),2)) '%' char(8211) num2str(round(prctile(100.*UN_Rel_Diff_Age_Gender_Displaced_Macro(:,dd,ii),97.5),2)) '%)'];
    end
end

T=table(Table_Model,Table_Err);


writetable(T,'Supplementary_Data.xlsx','Sheet','Disease_Burden_IDPs','Range','A3','WriteVariableNames',false);

