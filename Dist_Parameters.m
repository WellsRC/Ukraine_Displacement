clear;
close all;
load('Merge_Parameter_Uncertainty.mat','Par_FD','Par_Map_IDP','Par_Map_Ref')
NS=length(Par_FD(:,1));

figure('units','normalized','outerposition',[0 0.05 1 1]);
Par_Name_FD={'Kernel scaling parameter (C)','Saturating effect of conflict (\psi)','IDPs who become refugees (\Phi)','Displaced become IDP (\phi)','Refugee hyper-parameter (log_{10}(\theta_R))','IDP hyper-parameter (log_{10}(\theta_I))',' Age [0,20) displacement',' Age [20,30) displacement',' Age [30,40) displacement',' Age [40,50) displacement','Age 50+ displacement','SES saturation (log_{10}(\lambda_f))'};
Par_Name_Refugee={'Weight Europe (w_E)','Hyper-parameter Refugee (log_{10}(\Delta_R))','Dispersion social connectedness (\lambda_S)','Dispersion GDP (log_{10}(\lambda_G))','Dispersion GDP per capita (log_{10}(\lambda_g))','NATO weight (w_n)','Dispersion border distance (log_{10}(\lambda_B))'};    
Par_Name_IDP={'Hyper-parameter IDP UKR (log_{10}(\Delta_I))','Scaled conflict (\alpha_C)'};


load('Calibration_Conflict_Kernel.mat','Time_Switch');
Par_Map_Ref(:,3)=10.^Par_Map_Ref(:,3);
Test=zeros(NS,1);
[day_W_fix,RC,Par_FD,~,~,Model_FD,~,~] = Selected_Model_Parameters_Uncertainty;
for jj=1:NS    
    [Parameter,STDEV_Displace]=Parameter_Return(Par_FD(jj,:),RC,Time_Switch,day_W_fix,Model_FD);
    Test(jj)=Parameter.Scale./normpdf(0,0,Parameter.Breadth);
end


Par_FD(:,[3])=10.^Par_FD(:,[3]);
Par_FD(:,[1])=Test;

wd=0.16;
ht=0.12;
xs=linspace(0.03,0.99-wd,5);
ys=flip(linspace(0.05,0.97-ht,5));

[yv,xv]=meshgrid(ys,xs);
xv=xv(:);
yv=yv(:);
for ii=1:12
    subplot('Position',[xv(ii) yv(ii) wd ht]);
    histogram(Par_FD(:,ii),'FaceColor','k','LineStyle','none');
    box off;
    set(gca,'LineWidth',2,'tickdir','out','Fontsize',16);
    
    title(Par_Name_FD{ii},'Fontsize',13.5);
    text(-0.185314712237191,1.172,char(64+ii),'Fontsize',20,'FontWeight','bold','units','normalized');
end

for ii=1:7    
    subplot('Position',[xv(ii+12) yv(ii+12) wd ht]);
    histogram(Par_Map_Ref(:,ii),'FaceColor','k','LineStyle','none')
    box off;
    set(gca,'LineWidth',2,'tickdir','out','Fontsize',16);
    title(Par_Name_Refugee{ii},'Fontsize',13.5);
    text(-0.185314712237191,1.172,char(64+ii+12),'Fontsize',20,'FontWeight','bold','units','normalized');
end

for ii=8:9    
    subplot('Position',[xv(ii+12) yv(ii+12) wd ht]);
    histogram(Par_Map_IDP(:,ii-7),'FaceColor','k','LineStyle','none')
    box off;
    set(gca,'LineWidth',2,'tickdir','out','Fontsize',16);
    title(Par_Name_IDP{ii-7},'Fontsize',13.5);
    text(-0.185314712237191,1.172,char(64+ii+12),'Fontsize',20,'FontWeight','bold','units','normalized');
end

print(gcf,['Distribution_Parameters.png'],'-dpng','-r300');