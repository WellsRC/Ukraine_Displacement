clear;
close all;
Diseases={'HIV','TB','Cancer'};

S1=shaperead('UKR_ADM_1\UKR_adm1.shp','UseGeoCoords',true);
Oblast_Name=cell(length(S1),1);

for ii=1:length(Oblast_Name)
    Oblast_Name{ii}={S1(ii).NAME_1};
end

S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);
Raion_Name=cell(length(S2),1);

for ii=1:length(Raion_Name)
    Raion_Name{ii}={S2(ii).NAME_2};
end

Total_Burden=zeros(length(Diseases),1);
Oblast_Burden=zeros(length(Diseases),length(Oblast_Name));
Raion_Burden=rand(length(Diseases),length(Raion_Name));

% for ii=1:length(Diseases)
%     [Total_Burden(ii),Oblast_Burden(ii,:),Raion_Burden(ii,:)] = Disease_Burden_Displacement(Diseases{ii},Oblast,Raion,Displace_Pop,Oblast_Name,Raion_Name);
% end

figure('units','normalized','outerposition',[0. 0. 1 1]);
axesm miller
for ii=1:length(S2)
    geoshow(S2(ii),'FaceColor','r','Facealpha',Raion_Burden(1,ii),'LineWidth',1.5); hold on
end
axis tight;
set(gca,'Visible','off');

