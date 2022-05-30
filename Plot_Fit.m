clear;
close all;

[Number_Displacement,Date_Displacement,vLat_C,vLon_C,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,Pop_MACRO,Time_Sim,ML_Indx,RC,Time_Switch]=LoadData;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Run Fitting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('Kernel_Paremeter-Window_Conflict=7_days','Parameter');

[~,Pop_IDP,Pop_Refugee]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Time_Sim,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,ML_Indx);
 
Daily_Refugee=squeeze(sum(Pop_Refugee,[1:3]));
Daily_IDP_Origin_Macro=Calc_Macro_Displacement(squeeze(sum(Pop_IDP,[1 3])),Pop_MACRO);
Daily_IDP_Age=Calc_Age_Displacement(squeeze(sum(Pop_IDP,[1 2])));
Daily_IDP_Female=Calc_Gender_Displacement(squeeze(sum(Pop_IDP,[2 3])));

% Refugee
Y=zeros(length(Date_Displacement.Refugee),1);

for ii=1:length(Y)
    Y(ii)=Daily_Refugee(Time_Sim==Date_Displacement.Refugee(ii));
end
figure('units','normalized','outerposition',[0. 0. 1 1]);
bar(Y,'k'); hold on
scatter([1:length(Number_Displacement.Refugee)],Number_Displacement.Refugee,40,'r','filled');


% IDP
Y=zeros(length(Date_Displacement.IDP_Origin),6);
Z=Y;
for ii=1:length(Y(:,1))
    M=Daily_IDP_Origin_Macro.Kyiv;

   Z(ii,1)=Number_Displacement.IDP_Origin.Kyiv(ii); 
   Y(ii,1)=M(Time_Sim==Date_Displacement.IDP_Origin(ii));
   % EAST 
   M=Daily_IDP_Origin_Macro.East;

   Z(ii,2)=Number_Displacement.IDP_Origin.East(ii); 
   Y(ii,2)=M(Time_Sim==Date_Displacement.IDP_Origin(ii));
   % SOUTH 
   M=Daily_IDP_Origin_Macro.South;

   Z(ii,3)=Number_Displacement.IDP_Origin.South(ii); 
   Y(ii,3)=M(Time_Sim==Date_Displacement.IDP_Origin(ii));
   % CENTER 
   M=Daily_IDP_Origin_Macro.Center;

   Z(ii,4)=Number_Displacement.IDP_Origin.Center(ii); 
   Y(ii,4)=M(Time_Sim==Date_Displacement.IDP_Origin(ii));
   % NORTH 
   M=Daily_IDP_Origin_Macro.North;

   Z(ii,5)=Number_Displacement.IDP_Origin.North(ii); 
   Y(ii,5)=M(Time_Sim==Date_Displacement.IDP_Origin(ii));
   % WEST 
   M=Daily_IDP_Origin_Macro.West;

   Z(ii,6)=Number_Displacement.IDP_Origin.West(ii); 
   Y(ii,6)=M(Time_Sim==Date_Displacement.IDP_Origin(ii));
    
end

figure('units','normalized','outerposition',[0. 0. 1 1]);
for ii=1:4
    subplot(2,2,ii);

    bar(Y(ii,:)./sum(Y(ii,:),2),'k'); hold on
    scatter(1:6,Z(ii,:)./sum(Z(ii,:),2),40,'r','filled');
end


figure('units','normalized','outerposition',[0. 0. 1 1]);
    bar(sum(Y,2),'k'); hold on
    scatter(1:length(Date_Displacement.IDP_Origin),sum(Z,2),40,'r','filled');

Y=zeros(length(Date_Displacement.Proportion_IDP_Age),length(Daily_IDP_Age(:,1)));
Z=Y;
for ii=1:length(Date_Displacement.Proportion_IDP_Age)
    Y(ii,:)=Daily_IDP_Age(:,Time_Sim==Date_Displacement.Proportion_IDP_Age(ii));
    Z(ii,:)=Number_Displacement.Proportion_IDP_Age(ii,:);
end

figure('units','normalized','outerposition',[0. 0. 1 1]);
for ii=1:4
    subplot(2,2,ii);

    bar(Y(ii,:),'k'); hold on
    scatter(1:4,Z(ii,:),40,'r','filled');
end

Y=zeros(length(Date_Displacement.Proportion_IDP_Female),1);
Z=Y;
for ii=1:length(Date_Displacement.Proportion_IDP_Female)
    Y(ii)=Daily_IDP_Female(:,Time_Sim==Date_Displacement.Proportion_IDP_Female(ii));
    Z(ii)=Number_Displacement.Proportion_IDP_Female(ii);
end

figure('units','normalized','outerposition',[0. 0. 1 1]);

    bar(Y,'k'); hold on
    scatter(1:4,Z,40,'r','filled');
