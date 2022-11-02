function web_spider_disease=Spider_Web_Patch(female_prev,male_prev,Nat_Prev)

theta_v=linspace(0,2*pi,35);
d_theta=(theta_v(2)-theta_v(1))./2;
x=cos(theta_v);
y=sin(theta_v);

web_spider_disease=figure('units','normalized','outerposition',[0 0 1 1]);

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


theta_temp=theta_v(theta_v~=0);

theta_temp_1=theta_temp(theta_temp<=pi);
for ii=1:length(theta_temp_1)
    text(1.05.*cos(theta_temp_1(ii)),1.05.*sin(theta_temp_1(ii)),[gender_v{1} ': ' age_class_v{ii}],'Horizontalalignment','center','VerticalAlignment','middle'); 
end

age_class_vf=flip(age_class_v);
theta_temp_2=theta_temp(theta_temp>pi);
for ii=1:length(theta_temp_2)
    text(1.05.*cos(theta_temp_2(ii)),1.05.*sin(theta_temp_2(ii)),[gender_v{2} ': ' age_class_vf{ii}],'Horizontalalignment','center','VerticalAlignment','middle'); 
end



female_prev_scaled=female_prev./max([max(female_prev(:)) max(male_prev(:)) Nat_Prev]); 
male_prev_scaled=male_prev./max([max(female_prev(:)) max(male_prev(:)) Nat_Prev]);
Nat_prev_scaled=Nat_Prev./max([max(female_prev(:)) max(male_prev(:)) Nat_Prev]);

for ii=1:length(theta_temp_1)
    if(female_prev_scaled(ii,1)+10^(-2)<female_prev_scaled(ii,2))
        xx=[cos(theta_temp_1(ii)-d_theta).*female_prev_scaled(ii,1) cos(theta_temp_1(ii)-d_theta).*female_prev_scaled(ii,2) cos(theta_temp_1(ii)+d_theta).*female_prev_scaled(ii,2) cos(theta_temp_1(ii)+d_theta).*female_prev_scaled(ii,1)];

        yy=[sin(theta_temp_1(ii)-d_theta).*female_prev_scaled(ii,1) sin(theta_temp_1(ii)-d_theta).*female_prev_scaled(ii,2) sin(theta_temp_1(ii)+d_theta).*female_prev_scaled(ii,2) sin(theta_temp_1(ii)+d_theta).*female_prev_scaled(ii,1)];
        patch(xx,yy,'r','FaceAlpha',0.3,'LineStyle','none');
    else
        xx=[cos(theta_temp_1(ii)-d_theta).*female_prev_scaled(ii,1) cos(theta_temp_1(ii)+d_theta).*female_prev_scaled(ii,2)];

        yy=[sin(theta_temp_1(ii)-d_theta).*female_prev_scaled(ii,1) sin(theta_temp_1(ii)+d_theta).*female_prev_scaled(ii,2)];
        plot(xx,yy,'r','LineWidth',2);
    end
end

male_prev_scaled=flip(male_prev_scaled);
for ii=1:length(theta_temp_2)    
    if(male_prev_scaled(ii,1)+10^(-2)<male_prev_scaled(ii,2))
        xx=[cos(theta_temp_2(ii)-d_theta).*male_prev_scaled(ii,1) cos(theta_temp_2(ii)-d_theta).*male_prev_scaled(ii,2) cos(theta_temp_2(ii)+d_theta).*male_prev_scaled(ii,2) cos(theta_temp_2(ii)+d_theta).*male_prev_scaled(ii,1)];    
        yy=[sin(theta_temp_2(ii)-d_theta).*male_prev_scaled(ii,1) sin(theta_temp_2(ii)-d_theta).*male_prev_scaled(ii,2) sin(theta_temp_2(ii)+d_theta).*male_prev_scaled(ii,2) sin(theta_temp_2(ii)+d_theta).*male_prev_scaled(ii,1)];
        patch(xx,yy,'r','FaceAlpha',0.3,'LineStyle','none');
    else
        
        xx=[cos(theta_temp_2(ii)-d_theta).*male_prev_scaled(ii,1) cos(theta_temp_2(ii)+d_theta).*male_prev_scaled(ii,2)];

        yy=[sin(theta_temp_2(ii)-d_theta).*male_prev_scaled(ii,1) sin(theta_temp_2(ii)+d_theta).*male_prev_scaled(ii,2)];
        plot(xx,yy,'r','LineWidth',2);
    end
end

plot(Nat_prev_scaled.*x,Nat_prev_scaled.*y,'k','LineWidth',2.5); hold on

end