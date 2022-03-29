clear;
clc;
close all;

load('Input_Figure3B.mat');

[w_Location]=Estimate_IDP_Displacement(Parameter_IDP,Pop_Raion,SCI_IDPt,Raion_IDPSites,Raion_Dist_BC,Num_BC,Raion_Conflict,DistC,Dist);

Test=w_Location*Pop_Moving_R;
Test(Test==0)=min(Test(Test>0))./1000;
Test=(log10(Test)-min(log10(Test)))./(max(log10(Test))-min(log10(Test)));

S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);

for ii=1:length(S2)
    geoshow(S2(ii),'FaceAlpha',Test(ii),'LineWidth',2,'FaceColor','k');
end