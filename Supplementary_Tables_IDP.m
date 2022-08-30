load('Uncertainty_text.mat','test_Idp','Disease_Short','MLE_Macro_Pop','MLE_Macro_Disease','UN_Macro_Pop','UN_Macro_Disease_PostWar');

Macro_Region=test_Idp.macro_name;
Macro_Region{strcmp(Macro_Region,'N/A')}='Other';
for ii=1:length(Macro_Region)
    temp=Macro_Region{ii};
    Macro_Region{ii}=[temp(1) lower(temp(2:end))];
end

Population=cell(length(Macro_Region),1);
CVD=cell(length(Macro_Region),1);
Diabetes=cell(length(Macro_Region),1);
Cancer=cell(length(Macro_Region),1);
HIV=cell(length(Macro_Region),1);
TB=cell(length(Macro_Region),1);

for ii=1:length(Population)
    Population{ii}=[ num2str(round(MLE_Macro_Pop(ii,2))) '(' num2str(round(prctile(UN_Macro_Pop(:,ii,2),2.5))) char(8211) num2str(round(prctile(UN_Macro_Pop(:,ii,2),97.5))) ')'];
    CVD{ii}=[ num2str(round(MLE_Macro_Disease(strcmp(Disease_Short,'CVD'),ii,2))) '(' num2str(round(prctile(UN_Macro_Disease_PostWar(:,strcmp(Disease_Short,'CVD'),ii),2.5))) char(8211) num2str(round(prctile(UN_Macro_Disease_PostWar(:,strcmp(Disease_Short,'CVD'),ii),97.5))) ')'];
    Diabetes{ii}=[ num2str(round(MLE_Macro_Disease(strcmp(Disease_Short,'Diabetes'),ii,2))) '(' num2str(round(prctile(UN_Macro_Disease_PostWar(:,strcmp(Disease_Short,'Diabetes'),ii),2.5))) char(8211) num2str(round(prctile(UN_Macro_Disease_PostWar(:,strcmp(Disease_Short,'Diabetes'),ii),97.5))) ')'];
    Cancer{ii}=[ num2str(round(MLE_Macro_Disease(strcmp(Disease_Short,'Cancer'),ii,2))) '(' num2str(round(prctile(UN_Macro_Disease_PostWar(:,strcmp(Disease_Short,'Cancer'),ii),2.5))) char(8211) num2str(round(prctile(UN_Macro_Disease_PostWar(:,strcmp(Disease_Short,'Cancer'),ii),97.5))) ')'];
    HIV{ii}=[ num2str(round(MLE_Macro_Disease(strcmp(Disease_Short,'HIV'),ii,2))) '(' num2str(round(prctile(UN_Macro_Disease_PostWar(:,strcmp(Disease_Short,'HIV'),ii),2.5))) char(8211) num2str(round(prctile(UN_Macro_Disease_PostWar(:,strcmp(Disease_Short,'HIV'),ii),97.5))) ')'];
    TB{ii}=[ num2str(round(MLE_Macro_Disease(strcmp(Disease_Short,'TB'),ii,2))) '(' num2str(round(prctile(UN_Macro_Disease_PostWar(:,strcmp(Disease_Short,'TB'),ii),2.5))) char(8211) num2str(round(prctile(UN_Macro_Disease_PostWar(:,strcmp(Disease_Short,'TB'),ii),97.5))) ')'];
end

T=table(Macro_Region,Population,CVD,Diabetes,Cancer,HIV,TB);
[~,I]=sort(MLE_Macro_Pop(:,2),'descend');
T=T(I,:);
writetable(T,'Table_Macro_Region_Disease.csv')

