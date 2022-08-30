 clear;
 load('Uncertainty_text.mat');
clc;
 
% Number of refugees
MLE=round(sum(MLE_Refugee_Num_Country)./10^6,2);
CI=round(prctile(sum(UN_Refugee_Num_Country,2)./10^6,[2.5 97.5]),2);

fprintf(['Number of refugees: ' num2str(MLE) ' (95%% CrI:' num2str(min(CI)) char(8211) num2str(max(CI))  ') \n'])


% Number of refugees with CVD
dis=1;
MLE=round(sum(MLE_Refugee_Disease(dis,:)));
CI=round(prctile(sum(squeeze(UN_Refugee_Disease(:,dis,:)),2),[2.5 97.5]));

fprintf(['Number of refugees with CVD: ' num2str(MLE) ' (95%% CrI:' num2str(min(CI)) char(8211) num2str(max(CI))  ') \n'])

% Number of refugees with Diabetes
dis=2;
MLE=round(sum(MLE_Refugee_Disease(dis,:)));
CI=round(prctile(sum(squeeze(UN_Refugee_Disease(:,dis,:)),2),[2.5 97.5]));

fprintf(['Number of refugees with diabetes: ' num2str(MLE) ' (95%% CrI:' num2str(min(CI)) char(8211) num2str(max(CI))  ') \n'])

% Number of refugees with cancer
dis=3;
MLE=round(sum(MLE_Refugee_Disease(dis,:)));
CI=round(prctile(sum(squeeze(UN_Refugee_Disease(:,dis,:)),2),[2.5 97.5]));

fprintf(['Number of refugees with cancer: ' num2str(MLE) ' (95%% CrI:' num2str(min(CI)) char(8211) num2str(max(CI))  ') \n'])

% Number of refugees with HIV
dis=4;
MLE=round(sum(MLE_Refugee_Disease(dis,:)));
CI=round(prctile(sum(squeeze(UN_Refugee_Disease(:,dis,:)),2),[2.5 97.5]));

fprintf(['Number of refugees with HIV: ' num2str(MLE) ' (95%% CrI:' num2str(min(CI)) char(8211) num2str(max(CI))  ') \n'])

% Number of refugees with TB
dis=5;
MLE=round(sum(MLE_Refugee_Disease(dis,:)));
CI=round(prctile(sum(squeeze(UN_Refugee_Disease(:,dis,:)),2),[2.5 97.5]));

fprintf(['Number of refugees with TB: ' num2str(MLE) ' (95%% CrI:' num2str(min(CI)) char(8211) num2str(max(CI))  ') \n'])


% Proportion of refugees with CVD
dis=1;


MLE=round(100.*(MLE_Refugee_Disease(dis,:)./MLE_Refugee_Num_Country),2);
CI=round(100.*prctile(squeeze(UN_Refugee_Disease(:,dis,:))./UN_Refugee_Num_Country,[2.5 97.5]),2);

test=100.*squeeze(UN_Refugee_Disease(:,dis,:))./UN_Refugee_Num_Country;
max_test=max(test,[],2);
min_test=min(test,[],2);
diff_test=max_test-min_test;

diffCI=diff(CI);

C_Name={'Poland','Slovakia','Hungary','Romania','Belarus','Moldova','Russia','Europe'};

fprintf(['Minimum CVD prevalence in ' C_Name{MLE==min(MLE)} ': ' num2str(round(min(MLE),2)) '%% (95%% CrI:' num2str(round(prctile(CI(:,MLE==min(MLE)),2.5),2)) '%%' char(8211) num2str(round(prctile(CI(:,MLE==min(MLE)),97.5),2)) '%%) \n'])
fprintf(['Maximim CVD prevalence in ' C_Name{MLE==max(MLE)} ': ' num2str(round(max(MLE),2)) '%% (95%% CrI:' num2str(round(prctile(CI(:,MLE==max(MLE)),2.5),2)) '%%' char(8211) num2str(round(prctile(CI(:,MLE==max(MLE)),97.5),2)) '%%) \n'])

Red_Macro_MLE=1-MLE_Macro_Pop(:,2)./MLE_Macro_Pop(:,1);
Red_Macro_UN=1-UN_Macro_Pop(:,:,2)./UN_Macro_Pop(:,:,1);

N_Macro=unique(Macro_Map(:,3));

for ii=1:length(N_Macro)
    fprintf(['Population displacement in ' N_Macro{ii} ': ' num2str(round(100.*Red_Macro_MLE(ii),2)) '%% (95%% CrI:' num2str(round(100.*prctile(Red_Macro_UN(:,ii),2.5),2)) '%%' char(8211) num2str(round(100.*prctile(Red_Macro_UN(:,ii),97.5),2)) '%%) \n'])
end



load('Uncertainty_Hospital_UKR.mat')
PPR=repmat(Pop_Pre_Inv_Raion',1000,1);
PPH_PreW=PPR./squeeze(Hosp_Raion(:,:,1));
PPH_W=Pop_Remain_Inv_Raion./squeeze(Hosp_Raion(:,:,1)-Hosp_Raion(:,:,2));
Inc=PPH_W./PPH_PreW-1;
Inc_t=Inc(:,Hosp_Raion(1,:,1)>0);
pp=zeros(1000,1);
for ii=1:1000
pp(ii)=sum(Inc_t(ii,:)>=0.05)./length(Inc_t(ii,:));
end
fprintf(['95%% CrI for the percentage of hospitals with at least a 5%% increase in people per hospital:'  num2str(round(prctile(100.*pp,[2.5]),2)) '%%' char(8211)  num2str(round(prctile(100.*pp,[97.5]),2)) '%% \n']);
rr=zeros(1000,1);
for ii=1:1000
rr(ii)=sum(Inc_t(ii,:)<0)./length(Inc_t(ii,:));
end
fprintf(['95%% CrI for the percentage of hospitals with a reduction in people per hospital:'  num2str(round(prctile(100.*rr,[2.5]),2)) '%%' char(8211)  num2str(round(prctile(100.*rr,[97.5]),2)) '%% \n']);

Num_H=(Pop_Remain_Inv_Macro./repmat(Pop_Pre_Inv_Macro',1000,1)).*Hosp_Macro(:,:,1)-(Hosp_Macro(:,:,1)-Hosp_Macro(:,:,2));

for ii=1:length(N_Macro)
    fprintf(['Uncertainty in number of additional hospitals for ' N_Macro{ii} ': ' num2str(round(prctile(Num_H(:,ii),2.5))) char(8211) num2str(round(prctile(Num_H(:,ii),97.5))) ' \n'])
end