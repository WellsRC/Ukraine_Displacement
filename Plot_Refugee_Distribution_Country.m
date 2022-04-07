% clear;
% clc;
% close all;
% % 
% LoadData;
% 
% 
% %MARCH 11
% 
% Ref_Num=[105897 1575703 938 185673 235576 84671 104929 304156];
% 
% % 
% load('Kernel_Paremeter.mat','Parameter');
% 
% P=zeros(length(Lon_P),length(vLon_C));
% PCt=ones(length(Lon_P),1);
% PC=zeros(length(Lon_P),length(vLon_C));
% 
% for jj=1:length(vLon_C)
%     P= Kernel_Displacement(vLat_C{jj},vLon_C{jj},Lat_P,Lon_P,Parameter);
%     PCt=PCt.*(1-P);    
%     Pt=Parameter.w.*P+(1-Parameter.w).*Parameter.ScaleC.*(1-PCt);
%     PC(:,jj)=Pt;
% end
% 
% P_Total=1-prod(1-PC,2);
% 
% Pop_Leave=Pop.*P_Total;
% 
% load('Refugee_Country_Distribution_Parameters.mat','lambda_sci','sc_GDP','lambda_bc','sc_bc','s_nato','lambda_GDP');

w_tot=Determine_Weights_Refugee(lambda_sci,lambda_bc,sc_bc,s_nato,lambda_GDP,Ukraine_Pop,Border_Crossing_Country);
Est_Ref=(Pop_Leave')*w_tot;

Country_Name={'Russian Federation','Poland','Belarus','Slovakia','Hungary','Romania','Moldova','Europe (Other)'};
figure('units','normalized','outerposition',[0.15 0.15 0.6 0.8]);
subplot('Position',[0.095070422535211,0.291828793774319,0.892605633802818,0.682230869001297]);

bar([1:length(Ref_Num)],100.*Est_Ref./sum(Est_Ref),'k');
hold on;
scatter([1:length(Ref_Num)],100.*Ref_Num./sum(Ref_Num),40,'r','filled');

ylabel('Percentage of refugees','Fontsize',22);
xlabel('Country','Fontsize',22);

set(gca,'LineWidth',2,'tickdir','out','Xticklabel',Country_Name,'Fontsize',18,'XTick',[1:length(Country_Name)],'YTick',[0:10:70],'Yminortick','on');
ytickformat('percentage')
xtickangle(45);
box off
xlim([0.5 length(Country_Name)+0.5]);
ylim([0 70]);
print(gcf,['Estimated_Percentage_Country_Refugee.png'],'-dpng','-r300');