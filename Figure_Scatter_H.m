clear;
clc;
H=shaperead('Health/hotosm_ukr_health_facilities_points.shp','UseGeoCoords',true);

N={H.amenity};
tfh=strcmp(N,'hospital')|strcmp(N,'cancer');
H=H(tfh);

HLon=[H.Lon];
HLat=[H.Lat];

S1=shaperead('UKR_ADM_1\UKR_adm1.shp','UseGeoCoords',true);
open('UKR_0_Map.fig')

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
        text(29.05904703547412,52.48141713894448,test,'HorizontalAlignment','center','Fontsize',20);     
        annotation(gcf,'arrow',[0.379755434782609 0.447010869565217],[0.916919959473151 0.753799392097264],'LineWidth',2,'color',[0.4 0.4 0.4]);
   elseif(strcmp(MNR{ii},'SOUTH'))
        test=MNR{ii};
        test=[test(1) lower(test(2:end))];
       text(31.564633464708603,47.2770598612715,test,'HorizontalAlignment','center','Fontsize',20);
   elseif(strcmp(MNR{ii},'NORTH'))
        [x,y] = centroid(polyout);
        test=MNR{ii};
        test=[test(1) lower(test(2:end))];
        text(x.*1.025,y.*1.005,test,'HorizontalAlignment','center','Fontsize',20)
   elseif(~strcmp(MNR{ii},'N/A'))
        [x,y] = centroid(polyout);
        test=MNR{ii};
        test=[test(1) lower(test(2:end))];
        text(x,y,test,'HorizontalAlignment','center','Fontsize',20)
   end
end


xp=linspace(22.15,40.22,1001+1);
     yp=[44 44.3];    
     
for jj=1:1001
    patch([xp(jj) xp(jj) xp(jj+1) xp(jj+1)],[yp(1) yp(2) yp(2) yp(1)],hex2rgb('#A11F0C'),'LineStyle','none','FaceAlpha',(jj-1)./1000);
    if(jj==1)
        text(xp(jj+1),yp(1)-0.01,['Low'],'Fontsize',28,'rotation',90,'Horizontalalignment','right')
    elseif(jj==1001)
        text(xp(jj+1),yp(1)-0.01,{'High'},'Fontsize',28,'rotation',90,'Horizontalalignment','right')
    end
end
patch([xp(1) xp(1) xp(end) xp(end)],[yp(1) yp(2) yp(2) yp(1)],'k','Facealpha',0);

text(median(xp),yp(1)-1.27,['Proportion of hospitals affected'],'Fontsize',30,'Horizontalalignment','center');

axis off;
