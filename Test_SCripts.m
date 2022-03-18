% clear;
% 
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
% 
% 
% cLat=cell2mat(vLat_C);
% cLon=cell2mat(vLon_C);
% 
% BC=readtable('ukr_border_crossings_170322.xlsx','Sheet','Border Crossings');
% rLat=BC.Lat;
% rLon=BC.Long;

x=[-3 0.05 3 0.6 0.00001 -3];
lambda_sci=10^x(1);
sc_sci=x(2);
lambda_bc=10.^x(3);
sc_bc=x(4);
s_nato=x(5);
lambda_GDP=10^x(6);

w_tot=Determine_Weights_Refugee_Test(lambda_sci,sc_sci,lambda_bc,sc_bc,s_nato,lambda_GDP,Ukraine_Pop,Border_Crossing_Country);
Est_Ref=(Pop_Leave')*w_tot;

% close all;
figure('units','normalized','outerposition',[0. 0. 1 1]);
Country_Name={'Russian Federation','Poland','Belarus','Slovakia','Hungary','Romania','Moldova','Other'};
bar(Est_Ref);
hold on
scatter([1:length(Ref_Num)],Ref_Num,'filled');
set(gca,'XTick',[1:length(Ref_Num)],'XTicklabel',Country_Name);
xtickangle(90)