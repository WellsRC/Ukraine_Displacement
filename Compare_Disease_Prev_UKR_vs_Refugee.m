clear;
close all;
clc;

D={'CVD';'Diabetes';'Cancer';'HIV';'HIV_T';'TB';'TB_DR'};
prev=zeros(size(D));

load('Load_Data_MCMC.mat','Pop_M_Age','Pop_F_Age');

N=sum(Pop_F_Age(:))+sum(Pop_M_Age(:));

for ii=1:length(D)
    load('UKR_Disease_Burden.mat');
    tf=strcmp(D{ii},DB_UKR.Disease);

    prev(ii)=DB_UKR.Cases(tf)./N;
end

load('Figure1G_Output.mat','Refugee_Disease_t','Country_Name','Disease');

Prev_R=Refugee_Disease_t(2:end,2:end)./repmat(Refugee_Disease_t(1,2:end),length(D),1);

Disease=Disease(2:end);
Country_Name=Country_Name(2:end);

for ii=1:length(Disease)
    temp=Prev_R(ii,:)./prev(ii)-1;
    
    fprintf(['Maximum change in prevalence for ' Disease{ii} ' in ' Country_Name{temp==max(temp)} ' is ' num2str(100.*max(temp),'%4.2f') '\n']);
    fprintf(['Minimum change in prevalence for ' Disease{ii} ' in ' Country_Name{temp==min(temp)} ' is ' num2str(100.*min(temp),'%4.2f') '\n \n']);
end



