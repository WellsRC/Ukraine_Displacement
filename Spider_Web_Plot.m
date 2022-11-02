function web_spider_disease=Spider_Web_Plot(female_prev,male_prev,Nat_Prev,nat_female_prev,nat_male_prev,Disease)

if(strcmp('Cardiovascular disease',Disease))
CC=[hex2rgb('#FB6542')]; % CVD
sub_p='A';
elseif(strcmp('Diabetes',Disease))
    CC=hex2rgb('#807dba'); %Diabetes
    sub_p='B';
elseif(strcmp('Cancer',Disease))    
    CC=hex2rgb('#FFBB00'); % Cancer
    sub_p='C';
elseif(strcmp('HIV',Disease))    
    CC=hex2rgb('#034e76'); % HIV
    sub_p='D';
elseif(strcmp('Tuberculosis',Disease))    
    CC=[hex2rgb('#8c2d04');]; %TB
    sub_p='E';
end

theta_v=linspace(0,2*pi,35);
d_theta=(theta_v(2)-theta_v(1))./2;
theta_v=theta_v-d_theta;
theta_v=theta_v(2:end);
theta_v=[theta_v theta_v(1)];
x=cos(theta_v);
y=sin(theta_v);

prev_joint=[female_prev flip(male_prev,2)];

nat_prev_joint=[nat_female_prev flip(nat_male_prev,2) nat_female_prev(1)];


SCF=max([max(prev_joint(:)) max(nat_prev_joint(:)) Nat_Prev]);

web_spider_disease=figure('units','normalized','outerposition',[0 0 0.5 1]);
subplot('Position',[0.1,0.08,0.8,0.8]);

for jj=0:0.25:1
    plot(jj.*x,jj.*y,'color',[0.9 0.9 0.9],'LineWidth',1.5); hold on
end
for jj=1:length(theta_v)
   m=y(jj)./x(jj);
   if(x(jj)~=0)
        plot(linspace(0,x(jj),101), m.*linspace(0,x(jj),101),'color',[0.9 0.9 0.9],'LineWidth',1.5);
   else
        plot(linspace(0,x(jj),101),linspace(0,y(jj),101),'color',[0.9 0.9 0.9],'LineWidth',1.5);
   end
end

age_class_v={'0-4','5-9','10-14','15-19','20-24','25-29','30-34','35-39','40-44','45-49','50-54','55-59','60-64','65-69','70-74','75-79','80+'};
gender_v={'f','m'};


theta_temp=theta_v(1:end-1);

theta_temp_1=theta_temp(theta_temp<=pi-d_theta);
for ii=1:length(theta_temp_1)
    text(1.1.*cos(theta_temp_1(ii)),1.1.*sin(theta_temp_1(ii)),[gender_v{1} ': ' age_class_v{ii}],'Horizontalalignment','center','VerticalAlignment','middle','Fontsize',14); 
end

age_class_vf=flip(age_class_v);
theta_temp_2=theta_temp(theta_temp>pi-d_theta);
for ii=1:length(theta_temp_2)
    text(1.1.*cos(theta_temp_2(ii)),1.1.*sin(theta_temp_2(ii)),[gender_v{2} ': ' age_class_vf{ii}],'Horizontalalignment','center','VerticalAlignment','middle','Fontsize',14); 
end

prev_joint_scaled=prev_joint./SCF;
nat_prev_joint_scaled=nat_prev_joint./SCF;
Nat_prev_scaled=Nat_Prev./SCF;

for ii=1:length(prev_joint_scaled(:,1))
   s_oblast=scatter(x(1:end-1).*prev_joint_scaled(ii,:),y(1:end-1).*prev_joint_scaled(ii,:),'MarkerFaceColor',CC,'MarkerEdgeColor',CC,'LineWidth',1.2,'MarkerFaceAlpha',0.2,'MarkerEdgeAlpha',0.2);
end

p1=plot(Nat_prev_scaled.*x,Nat_prev_scaled.*y,'color',CC,'LineWidth',3); hold on
p2=plot(nat_prev_joint_scaled.*x,nat_prev_joint_scaled.*y,'color',CC,'LineStyle','-.','LineWidth',2); hold on
title(Disease,'Position',[0.000001275660628,1.2,0],'Fontsize',24);
xlim([-1 1]);
ylim([-1 1]);
legend([p1 p2 s_oblast],{'National','National: age and gender','Oblast: age and gender'},'Position',[0.713806502621011,0.876730835989331,0.276483044217704,0.078014182223133],'FontSize',14);
text(-1.21957671957672,1.245,sub_p,'Fontsize',32,'FontWeight','bold');
axis off
end