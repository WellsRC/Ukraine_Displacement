clear;
clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Load data and determine the dispacement per day
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
LoadData;

load('Kernel_Paremeter.mat','Parameter');
load('Refugee_Country_Distribution_Parameters.mat');

[Pop_Displace_Day,Pop_Displace]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Lat_P,Lon_P,Pop,false);

Displace_Pop=sum(Pop_Displace,2);
Pop_Remain=Pop-Displace_Pop;

nDays=length(vLat_C);
PC=ones(length(Lon_P),1);
PC_IDP=ones(length(Lon_P),nDays);

for jj=1:nDays    
    P = Kernel_Displacement(vLat_C{jj},vLon_C{jj},Lat_P,Lon_P,Parameter);
    PC=PC.*(1-P);
    Ptemp=(Parameter.w.*P+(1-Parameter.w).*Parameter.Scale.*(1-PC));
    PC_IDP(:,jj)=Ptemp;
end
load('Scale_Conflict_Fucntion_IDP.mat','ScaleConflict');
PC_IDP=1-prod(1-ScaleConflict.*PC_IDP,2);
Pop_IDP=PC_IDP.*Pop_Remain;

[Total_Burden_Refugee,Total_Burden_UKR] = Disease_Burden_Displacement(Displace_Pop,Pop_Male,Pop_Remain,Pop_IDP,Ukraine_Pop,lambda_sci,lambda_bc,sc_bc,s_nato,lambda_GDP,Border_Crossing_Country);

save('Table_Output_Figure1.mat','Total_Burden_Refugee','Total_Burden_UKR');

figure('units','normalized','outerposition',[0.15 0.15 0.6 0.8]);
subplot('Position',[0.087147887323944,0.224383916990921,0.900528169014085,0.765239948119325]);
bar(Pop_Displace_Day./10000,'k');
hold on
scatter([1:length(Number_Displacement)],Number_Displacement./10000,60,'r','filled');
box off;
XTL=datestr(Date_Displacement');
set(gca,'LineWidth',2,'tickdir','out','Xticklabel',XTL,'Fontsize',18,'XTick',[1:length(Number_Displacement)])
xtickangle(45);
xlim([0.5 length(Number_Displacement)+0.5]);
ylim([0 22]);

ylabel('Daily number Ukrainian refugees (10,000)','Fontsize',22);
xlabel('Date','Fontsize',22);

print(gcf,['Daily_Refugee_Fit.png'],'-dpng','-r300');
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % Plot Disease Country
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% 

figure('units','normalized','outerposition',[0. 0.2 1 0.6]);
subplot('Position',[0.064600840336134,0.131531531531532,0.930147058823529,0.832432432432433]);

Country_Namev={'Russia','Poland','Belarus','Slovakia','Hungary','Romania','Moldova','Europe (Other)','Ukraine (IDP)'};
Disesev={'Total refugees';'TB';'Drug-resistant TB';'HIV';'HIV Treatment';'Diabetes';'Cancer';'CVD'};
UKR_Cases=Total_Burden_UKR.Cases;
IDP_Cases=UKR_Cases(4:4:end);
T=[Total_Burden_Refugee.Cases];
Tv=[reshape(T,length(Country_Namev)-1,length(Disesev))];

Tv=[Tv ; IDP_Cases'];

[Ts,srt_indx]=sortrows(Tv,1,'descend');
[Tsc,srt_dindx]=sortrows(Ts',1,'descend');
Country_Name=Country_Namev(srt_indx);
Disese=Disesev(srt_dindx);
T=Tsc';
% Ref_Num=[105897 1575703 938 185673 235576 84671 104929 304156 10^(-16)]; % 10^(-16) is so that it does not show on the graph

CC=[hex2rgb('#FB6542'); % CVD
    hex2rgb('#807dba'); %Diabetes
    hex2rgb('#FFBB00'); % Cancer
    hex2rgb('#034e76'); % HIV
    hex2rgb('#9ebcda'); % HIV Treatment
    hex2rgb('#8c2d04'); %TB
    hex2rgb('#DE7a22');]; %TB drug-resitant
bb=bar(T);
for ii=1:7
   bb(ii+1).FaceColor=CC(ii,:); 
   bb(ii+1).EdgeColor=CC(ii,:);
end
bb(1).FaceColor='k';
xlim([0.5 length(Country_Name)+0.5]);
set(gca,'Tickdir','out','linewidth',2,'XTick',[1:length(Country_Name)],'XTicklabel',Country_Name,'Fontsize',24,'YSCale','log','YTick',10.^[0:7]);

hold on;
% xtickformat('percentage');

legend(flip(bb),flip(Disese),'Location','NorthEast','NumColumns',8);
legend boxoff;
box off;
% xlabel('Country','Fontsize',30,'Position',[5.000004291534425,0.062691391491044,-1]);
ylabel('Number of Refugees','Fontsize',30);
ylim([0.5 10^7]);
text(-0.116664381313886,10613961.8691112,'G','Fontsize',40,'FontWeight','bold');

print(gcf,['Refugee_Disease_Distribution.png'],'-dpng','-r300');