clear;
close all;
load('Merge_Parameter_Uncertainty.mat')
NS=length(Par_KD(:,1));

figure('units','normalized','outerposition',[0 0.05 1 1]);
Par_Name={'Kernel scaling parameter (C)','Saturating effect of conflict (\psi)','IDPs who become refugees (\Phi)','Displaced become IDP (\phi)','Female displacement','Male displacement',' Age [0,20) displacement',' Age [20,30) displacement',' Age [30,40) displacement',' Age [40,50) displacement','Age 50+ displacement','Refugee hyper-parameter (log_{10}(\theta_R))','IDP hyper-parameter (log_{10}(\theta_I))','Dispersion social connectedness (\lambda_S)','Dispersion GDP (log_{10}(\lambda_G))','Dispersion GDP per capita (log_{10}(\lambda_g))','NATO weight (w_n)','Dispersion border distance (log_{10}(\lambda_B))','Weight Europe (w_E)','Hyper-parameter Refugee (log_{10}(\Delta_R))','Dispersion social connectedness (\lambda_{S,r})','Scaled conflict (\alpha_C)','Scale partial Russian control (\rho)','Dispersion capital (\lambda_C)','Hyper-parameter IDP UKR (log_{10}(\Delta_I))'};

Par_KD(:,[1 3])=10.^Par_KD(:,[1 3]);
Par_Map(:,[1 8 11])=10.^Par_Map(:,[1 8 11]);

wd=0.16;
ht=0.12;
xs=linspace(0.03,0.99-wd,5);
ys=flip(linspace(0.05,0.97-ht,5));

[yv,xv]=meshgrid(ys,xs);
xv=xv(:);
yv=yv(:);
for ii=1:13
    subplot('Position',[xv(ii) yv(ii) wd ht]);
    histogram(Par_KD(:,ii),'FaceColor','k','LineStyle','none');
    box off;
    set(gca,'LineWidth',2,'tickdir','out','Fontsize',16);
    
    title(Par_Name{ii},'Fontsize',13.5);
    text(-0.185314712237191,1.172,char(64+ii),'Fontsize',20,'FontWeight','bold','units','normalized');
end

for ii=1:12    
    subplot('Position',[xv(ii+13) yv(ii+13) wd ht]);
    histogram(Par_Map(:,ii),'FaceColor','k','LineStyle','none')
    box off;
    set(gca,'LineWidth',2,'tickdir','out','Fontsize',16);
    title(Par_Name{ii+13},'Fontsize',13.5);
    text(-0.185314712237191,1.172,char(64+ii+13),'Fontsize',20,'FontWeight','bold','units','normalized');
end

print(gcf,['Distribution_Parameters.png'],'-dpng','-r300');