%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
clear;
close all;
LoadData;
load('Kernel_Paremeter.mat','Parameter');
load('Refugee_Country_Distribution_Parameters.mat');
% 
% [Pop_Displace_Day,Pop_Displace]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Lat_P,Lon_P,Pop,false);
% 
% Displace_Pop=sum(Pop_Displace,2);
% Pop_Remain=Pop-Displace_Pop;
% 
% nDays=length(vLat_C);
% PC=ones(length(Lon_P),1);
% PC_IDP=ones(length(Lon_P),nDays);
% 
% for jj=1:nDays    
%     P = Kernel_Displacement(vLat_C{jj},vLon_C{jj},Lat_P,Lon_P,Parameter);
%     PC=PC.*(1-P);
%     Ptemp=(Parameter.w.*P+(1-Parameter.w).*Parameter.Scale.*(1-PC));
%     PC_IDP(:,jj)=Ptemp;
% end
% load('Scale_Conflict_Fucntion_IDP.mat','ScaleConflict');
% PC_IDP=1-prod(1-ScaleConflict.*PC_IDP,2);
% Pop_Moving=PC_IDP.*Pop_Remain;

w_tot=Determine_Weights_Refugee(lambda_sci,lambda_bc,sc_bc,s_nato,lambda_GDP,Ukraine_Pop,Border_Crossing_Country);
for ii=1:8
figure(ii)
scatter(Ukraine_Pop.longitude,Ukraine_Pop.latitude,5,(w_tot(:,ii)),'filled');
end