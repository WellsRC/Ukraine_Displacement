clear;
clc;
close all;

load('Load_Data_MCMC_Mapping.mat');
load('Macro_Oblast_Map.mat','Macro_Map');
load('Merge_Parameter_MLE.mat')


[Parameter,STDEV_Displace]=Parameter_Return(MLE_KD,RC,Time_Switch,day_W_fix);
    
[Pop_Displace,Pop_IDP,Pop_Refugee]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Time_Sim,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,ML_Indx);
Daily_Refugee=squeeze(sum(Pop_Refugee,[1 3]));
Daily_IDP_Origin=Parameter.w_IDP.*squeeze(sum(Pop_Displace,[1 3])); % Need to examine the new idp only

Daily_IDP_Origin_Age=Parameter.w_IDP.*squeeze(sum(Pop_Displace,[1]));


[Parameter_Map_Refugee,Parameter_Map_IDP]=Parameter_Return_Mapping(MLE_Map);

w_tot_ref=Determine_Weights_Refugee(Parameter_Map_Refugee,Mapping_Data);
w_tot_idp=Determine_Weights_IDP(Parameter_Map_IDP,Mapping_Data);


[Est_Daily_Refugee]=Country_Refuge_Displaced(w_tot_ref,Daily_Refugee);
[Est_Daily_IDP]=IDP_Refuge_Displaced(w_tot_idp,Daily_IDP_Origin,Time_Sim,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Parameter,Macro_Map);


R_IDP=Est_Daily_IDP.raion(:,end);
R_IDP=(R_IDP-min(R_IDP))./(max(R_IDP)-min(R_IDP));

S1=shaperead('UKR_ADM_1\UKR_adm1.shp','UseGeoCoords',true);
open('UKR_0_Map.fig')

for ii=1:length(S2)
	geoshow(S2(ii),'LineStyle','none','FaceAlpha',R_IDP(ii),'Facecolor',hex2rgb('#2E4600'));%'EdgeColor',ColRZ(Raion_Zone_R(ii),:),'FaceColor',ColRZ(Raion_Zone_R(ii),:));
end


load('Macro_Oblast_Map.mat','Macro_Map');
MNR=unique(Macro_Map(:,3));
for ii=1:length(MNR)
   t_mr=find(strcmp(MNR{ii}, Macro_Map(:,3)));
   t_o=false(length(S1),1)';
   for jj=1:length(t_mr)
      t_o=t_o | strcmp(Macro_Map(t_mr(jj),2),{S1.NAME_1}); 
   end
   fS=find(t_o);
   polyout=polyshape(S1(fS(1)).Lon,S1(fS(1)).Lat);
   for jj=2:length(fS)
       polytemp=polyshape(S1(fS(jj)).Lon,S1(fS(jj)).Lat);
       test=intersect(polyout,polytemp);
       if(isempty(test.Vertices))
           polyout = union(polyout,polytemp);  
       else
           polyout = subtract(polyout,polytemp);
       end
   end
   hold on;
   plot(polyout,'FaceColor','none','LineWidth',2,'EdgeColor',[0.4 0.4 0.4])
   if(strcmp(MNR{ii},'KYIV'))
        test=MNR{ii};
        test=[test(1) lower(test(2:end))];
        text(29.05904703547412,52.48141713894448,test,'HorizontalAlignment','center','Fontsize',28);     
        annotation(gcf,'arrow',[0.379755434782609 0.447010869565217],[0.916919959473151 0.753799392097264],'LineWidth',2,'color',[0.4 0.4 0.4]);
   elseif(strcmp(MNR{ii},'SOUTH'))
        test=MNR{ii};
        test=[test(1) lower(test(2:end))];
       text(31.564633464708603,47.2770598612715,test,'HorizontalAlignment','center','Fontsize',28);
   elseif(strcmp(MNR{ii},'NORTH'))
        [x,y] = centroid(polyout);
        test=MNR{ii};
        test=[test(1) lower(test(2:end))];
        text(x.*1.025,y.*1.005,test,'HorizontalAlignment','center','Fontsize',28)
   elseif(~strcmp(MNR{ii},'N/A'))
        [x,y] = centroid(polyout);
        test=MNR{ii};
        test=[test(1) lower(test(2:end))];
        text(x,y,test,'HorizontalAlignment','center','Fontsize',28)
   end
end

axis off;

text(22.000000000000004,52.47793894762959,'A','Fontsize',40,'FontWeight','bold');

xp=linspace(22.15,40.22,1001+1);
     yp=[44 44.3];    
     
for jj=1:1001
    patch([xp(jj) xp(jj) xp(jj+1) xp(jj+1)],[yp(1) yp(2) yp(2) yp(1)],hex2rgb('#2E4600'),'LineStyle','none','FaceAlpha',(jj-1)./1000);
    if(jj==1)
        text(xp(jj+1),yp(1)-0.01,['Low'],'Fontsize',28,'rotation',90,'Horizontalalignment','right')
    elseif(jj==1001)
        text(xp(jj+1),yp(1)-0.01,{'High'},'Fontsize',28,'rotation',90,'Horizontalalignment','right')
    end
end
patch([xp(1) xp(1) xp(end) xp(end)],[yp(1) yp(2) yp(2) yp(1)],'k','Facealpha',0);

text(31.252835977086363,43.412321118918925,['Proportion of IDPs'],'Fontsize',30,'Horizontalalignment','center');

print(gcf,['IDP_Macro_Regions_Map.png'],'-dpng','-r300');


