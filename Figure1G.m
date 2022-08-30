clear;
clc;
clear;
clc;

close all;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % Plot Disease Country
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

[~,~,vLat_C,vLon_C,~,~,~,~,~,~,~,Time_Sim,~,~,~]=LoadData;

S1=shaperead('UKR_ADM_1\UKR_adm1.shp','UseGeoCoords',true);
Oblast_S={S1.NAME_1};

load('Macro_Oblast_Map.mat','Macro_Map');
MNR=unique(Macro_Map(:,3));
Conflict_MR=zeros(length(MNR),length(Time_Sim));
Conflict_Oblast=zeros(length(S1),length(Time_Sim));
for tt=1:length(Time_Sim)
    for ii=1:length(S1)
        [p_in,~]=inpolygon(vLon_C{tt},vLat_C{tt},S1(ii).Lon,S1(ii).Lat);
        Conflict_Oblast(ii,tt)=sum(p_in);
    end
end

for jj=1:length(MNR)
    tf=strcmp(MNR{jj},Macro_Map(:,3));
    Conflict_MR(jj,:)=sum(Conflict_Oblast(tf,:),1);
end

CC=sum(Conflict_MR,2);
[~,I]=sort(CC,'descend');


MNR{strcmp(MNR,'N/A')}='Other';
for jj=1:7
   temp=MNR{jj};
   MNR{jj}=[temp(1) lower(temp(2:end))];
end

% CC=[hex2rgb('#c51b7d');
% hex2rgb('#e9a3c9');
% hex2rgb('#fde0ef');
% hex2rgb('#4d9221');
% hex2rgb('#a1d76a');
% hex2rgb('#e6f5d0');
% hex2rgb('#BCBABE')];

CC=[hex2rgb('#2F3131');
hex2rgb('#8D230F');
hex2rgb('#CF3721');
hex2rgb('#DE7A22');
hex2rgb('#C99E10');
hex2rgb('#F4CC70');
hex2rgb('#BCBABE')];

figure('units','normalized','outerposition',[0.2 0.2 0.775 1/2]);
subplot('Position',[0.092391304347826,0.398210290827741,0.902356594811834,0.58165548098434]);
bb=bar(Time_Sim,Conflict_MR(I,:),'stacked','LineStyle','none');

for ii=1:length(bb)
    bb(ii).FaceColor=CC(ii,:);
end

set(gca,'LineWidth',2,'tickdir','out','XTick',Time_Sim(1:7:end),'XTickLabel',datestr(Time_Sim(1:7:end)),'Fontsize',18,'Xminortick','on','YTick',[0:25:150],'Yminortick','on');
box off;
xtickangle(45);
xlabel('Date','Fontsize',20)
ylabel({'Number of','events'},'Fontsize',20)
xlim([Time_Sim(1)-0.5 Time_Sim(end)+0.5]);
ylim([0 150]);
legend(MNR(I),'NumColumns',7)
legend boxoff;
text(738567.6369627455,145,'G','Fontsize',40,'FontWeight','bold');

print(gcf,'Temporal_Conflict_Regions.png','-dpng','-r300');

%%%%%%%%%%%%%%%%%%%%%%
% Macro regions
%%%%%%%%%%%%%%%%%%%%%%

S1=shaperead('UKR_ADM_1\UKR_adm1.shp','UseGeoCoords',true);
open('UKR_0_Map.fig')

load('Macro_Oblast_Map.mat','Macro_Map');
MNR=unique(Macro_Map(:,3));
MNR=MNR(I);
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
   plot(polyout,'FaceColor',CC(ii,:),'LineWidth',2,'EdgeColor',CC(ii,:),'FaceAlpha',1)
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
   elseif(strcmp(MNR{ii},'EAST'))
        [x,y] = centroid(polyout);
        test=MNR{ii};
        test=[test(1) lower(test(2:end))];
        text(x,y,test,'HorizontalAlignment','center','Fontsize',28,'color','w')
   elseif(~strcmp(MNR{ii},'N/A'))
        [x,y] = centroid(polyout);
        test=MNR{ii};
        test=[test(1) lower(test(2:end))];
        text(x,y,test,'HorizontalAlignment','center','Fontsize',28)
   end
end

axis off;

text(22.000000000000004,52.47793894762959,'H','Fontsize',40,'FontWeight','bold');

print(gcf,'Micro-Region_Map.png','-dpng','-r300');