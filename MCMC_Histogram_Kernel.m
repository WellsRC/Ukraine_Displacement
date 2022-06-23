clear;
clc;
close all;

load('MCMC_out-k=2821.mat','L_V','Parameter_V');

X=[Parameter_V(L_V<0,:) L_V(L_V<0)];

X=X(end-9999:end,:);
r=randi(length(X(:,1)),1000,1);

[LB,UB]=ParameterBounds;
LB=[LB min(L_V(L_V<0))];
UB=[UB max(L_V(L_V<0))];
Var_Name={'Kernel scaler (log_{10}(C))','Scaling adjustment (\psi)','IDP to Refugee (log_{10}(\Phi))','Displaced IDP (\phi)','Max. displacement female','Max. displacement male','Max. displacement 0-19','Max. displacement 20-29','Max. displacement 30-39','Max. displacement 40-49','Max. displacement 50+','STDV. Refugees (log_{10}(\theta_R))','STDV. IDPs (log_{10}(\theta_I))','Log-Likelihood'};
for ii=1:5
    figure('units','normalized','outerposition',[0. 0.3 1 0.6]);

    for jj=1:3
        count=jj+3.*(ii-1);
        if(count<=length(X(1,:))-1)
            subplot('Position',[0.055+(jj-1)./3.1,0.2 0.265, 0.78]);
            histogram(X(r,count),'Normalization','probability','LineStyle','none')
            set(gca,'Fontsize',20,'TickDir','out','linewidth',2,'Xminortick','on','Yminortick','on');
            ylabel('Density','Fontsize',22);
            xlabel(Var_Name{count},'Fontsize',22);
            ylim([0 0.2]);
            xlim([LB(count),UB(count)]);
            text(LB(count)-0.2.*(UB(count)-LB(count)),0.199,char(64+count),'Fontsize',30,'FontWeight','bold');
            box off;
        elseif(count<=length(X(1,:)))
            subplot('Position',[0.06+(jj-1)./3.1,0.2 0.265, 0.78]);
            plot(X(:,end))
            set(gca,'Fontsize',20,'TickDir','out','linewidth',2,'Xminortick','on','Yminortick','on');
            xlabel('Iterations','Fontsize',22);
            ylabel(Var_Name{count},'Fontsize',22);
            ylim([min(X(:,end))-5 max(X(:,end))+5]);
            xlim([0 length(X(:,end))]);
            text(-2257.425742574257,1.0003.*(5+max(X(:,end))),char(64+count),'Fontsize',30,'FontWeight','bold');
            box off;
        end
    end
end
jj=3;
subplot('Position',[0.03+(jj-1)./3.1,0.2 0.265, 0.78]);
C=corr(X(:,1:end-1));
C=[zeros(1,1+length(C(:,1))); C zeros(length(C(:,1)),1)];
pcolor(flip(C))
caxis([-1 1]);
set(gca,'Fontsize',20,'TickDir','out','linewidth',2,'Xminortick','off','Yminortick','off','YTick',[1.5:length(C(1,:))-0.5],'XTick',[1.5:length(C(1,:))-0.5],'XTickLabel',num2str([1:length(X(1,1:end-1))]'),'YTickLabel',flip(num2str([1:length(X(1,1:end-1))]')));
box off;
c=colorbar;
c.Position=[0.945,0.200328407224959,0.011204481792717,0.779967159277504];
c.Limits=[-1 1];
c.Label.String='Correlation';
c.Label.Rotation=270;
c.Label.FontSize=22;