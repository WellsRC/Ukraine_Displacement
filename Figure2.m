clear;
close all;

clear;
clc;
close all;
L=zeros(8,1);
k=zeros(8,1);
for ii=1:8
    load(['Calibration_Kernel_Conflict_Window-Conflcit_Radius_Model=' num2str(ii) '.mat']);
    L(ii)=-min(fval);
    k(ii)=length(x0(1,:));
end
aics=aicbic(L,k);

daics=aics-min(aics);

AIC_model_num=find(daics==0);


load('Calibration_Conflict_Kernel.mat');
load(['Calibration_Kernel_Conflict_Window-Conflcit_Radius_Model=' num2str(AIC_model_num) '.mat']);
day_W_fix=day_W_fix(fval==min(fval));
RC=RC(fval==min(fval));

load('Merge_Parameter_MLE.mat','MLE_FD','MLE_Map_Ref','MLE_Map_IDP','Model_IDP','Model_Refugee')

load('Macro_Oblast_Map.mat','Macro_Map');

load('Load_Data_Mapping.mat');

[Parameter,STDEV_Displace]=Parameter_Return(MLE_FD,RC,Time_Switch,day_W_fix,AIC_model_num);
    
[Pop_Displace,Pop_IDP,Pop_Refugee]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Time_Sim,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,Pop_SES);
Daily_Refugee=squeeze(sum(Pop_Refugee,[1 3]));
Daily_IDP_Origin=Parameter.w_IDP.*squeeze(sum(Pop_Displace,[1 3])); % Need to examine the new idp only

Daily_IDP_Origin_Age=Parameter.w_IDP.*squeeze(sum(Pop_Displace,[1]));


[Parameter_Map_Refugee,Refugee_Mv]=Parameter_Return_Mapping_Refugee(MLE_Map_Ref,Model_Refugee);
w_tot_ref=Determine_Weights_Refugee(Parameter_Map_Refugee,Mapping_Data,Refugee_Mv);


[Parameter_Map_IDP,IDP_Mv]=Parameter_Return_Mapping_IDP(MLE_Map_IDP,Model_IDP);
w_tot_idp=Determine_Weights_IDP(Parameter_Map_IDP,Mapping_Data,IDP_Mv);


[Est_Daily_Refugee]=Country_Refuge_Displaced(w_tot_ref,Daily_Refugee);
[Est_Daily_IDP]=IDP_Refuge_Displaced(w_tot_idp,Daily_IDP_Origin,Time_Sim,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Parameter,Macro_Map);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Temporal population change
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('Ukraine_Population_Reduced.mat','Ukraine_Pop')
Mapped_Raion_Name=Ukraine_Pop.map_raion;
Oblast_Pixel=Ukraine_Pop.oblast;
Raion_Pixel=Ukraine_Pop.raion;

age_class_v={'0-4','5-9','10-14','15-19','20-24','25-29','30-34','35-39','40-44','45-49','50-54','55-59','60-64','65-69','70-74','75-79','80+'};
gender_v={'f','m'};

clear Ukraine_Pop


S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);
Raion_S={S2.NAME_2};
Oblast_S={S2.NAME_1};


Pop=zeros(length(gender_v),length(Pop_raion),length(age_class_v));
Pop(1,:,:)=Pop_F_Age;
Pop(2,:,:)=Pop_M_Age;

PopR=zeros(size(Pop));
for ii=1:length(Raion_S)
   tf=strcmp(Pop_raion,Raion_S{ii}) &  strcmp(Pop_oblast,Oblast_S{ii});
   for aa=1:length(Pop_F_Age(1,:))
       for gg=1:2
            PopR(gg,tf,aa)=sum(Pop(gg,tf,aa));
       end
   end
end

Num_Refugee=cumsum(Pop_Refugee,4);
Num_Non_Displaced=repmat(Pop,1,1,1,length(Time_Sim))-Pop_IDP-Num_Refugee;

Num_Non_Displaced_T=squeeze(sum(Num_Non_Displaced,1));
Disease_Short={'CVD';'Diabetes';'Cancer';'HIV';'TB'};

IDP_Disease=zeros(length(Disease_Short)+1,17,7,length(Time_Sim)+1);
non_IDP_Disease=zeros(length(Disease_Short)+1,17,7,length(Time_Sim)+1);


Daily_IDP_Origin=Parameter.w_IDP.*Pop_Displace;
Pop_S=squeeze(sum(Pop,1));
for dd=1:length(Disease_Short)+1
    if(dd==1)
        for ii=1:17
            [Est_Daily_IDP]=IDP_Refuge_Displaced(w_tot_idp,squeeze(Daily_IDP_Origin_Age(:,ii,:)),Time_Sim,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Parameter,Macro_Map);
            IDP_Disease(dd,ii,:,2:end)=Est_Daily_IDP.macro;
            Est_Pop_NIDP=Macro_Return(squeeze(Num_Non_Displaced_T(:,ii,:)),Raion_Pixel,Oblast_Pixel,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Macro_Map);
            non_IDP_Disease(dd,ii,:,2:end)=Est_Pop_NIDP.macro;
            
            
            Est_Pop_PW=Macro_Return(squeeze(Pop_S(:,ii)),Raion_Pixel,Oblast_Pixel,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Macro_Map);
            non_IDP_Disease(dd,ii,:,1)=Est_Pop_PW.macro;
        end
    else
        [test_non_idp,test_idp,test_pop_pw]=Disease_Distribution_beta(Disease_Short{dd-1},Mapped_Raion_Name,age_class_v,gender_v,Num_Non_Displaced,Daily_IDP_Origin,Pop,Pop,PopR,false);
        test_idp=squeeze(sum(test_idp,1));
        test_non_idp=squeeze(sum(test_non_idp,1));
        test_pop_pw=squeeze(sum(test_pop_pw,1));
        for ii=1:17
            [Est_Daily_IDP]=IDP_Refuge_Displaced(w_tot_idp,squeeze(test_idp(:,ii,:)),Time_Sim,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Parameter,Macro_Map);
            IDP_Disease(dd,ii,:,2:end)=Est_Daily_IDP.macro;
            Est_Pop_NIDP=Macro_Return(squeeze(test_non_idp(:,ii,:)),Raion_Pixel,Oblast_Pixel,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Macro_Map);
            non_IDP_Disease(dd,ii,:,2:end)=Est_Pop_NIDP.macro;
            Est_Pop_PW=Macro_Return(squeeze(test_pop_pw(:,ii)),Raion_Pixel,Oblast_Pixel,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Macro_Map);
            non_IDP_Disease(dd,ii,:,1)=Est_Pop_PW.macro;
        end
    end
end
N_Macro=Est_Pop_PW.macro_name;
for ii=1:length(N_Macro)
    if(~strcmp(N_Macro{ii},'N/A'))
        tt=N_Macro{ii};
        N_Macro{ii}=[tt(1) lower(tt(2:end))];
    else
        N_Macro{ii}='Other';
    end
end

age_class_v={'0-4','5-9','10-14','15-19','20-24','25-29','30-34','35-39','40-44','45-49','50-54','55-59','60-64','65-69','70-74','75-79','80+'};

age_class_text={'0-9','10-19','20-29','30-39','40-49','50-59','60-69','70+'};
age_c_V={[1:2],[3:4],[5:6],[7:8],[9:10],[11:12],[13:14],[15:17]};
% age_c_text={'0-19','20-59','60+'};
Pop_M=zeros(6, length(age_c_V),7,80);
PT=non_IDP_Disease+IDP_Disease;
for ii=1:length(age_c_V)
    Pop_M(:,ii,:,:)=squeeze(sum(PT(:,age_c_V{ii},:,:),2));
end

Time_Sim=[datenum('February 12, 2022') datenum('February 24, 2022'):datenum('May 13, 2022')];

Disease_Short={'Population';'Cardiovascular disease';'Diabetes';'Cancer';'HIV';'Tuberculosis'};

smt={'v','h','s','d','p','o','>'};
% CC=[191,211,230
% 158,188,218
% 140,150,198
% 140,107,177
% 136,65,157
% 129,15,124
% 77,0,75]./255;

CC=[  
hex2rgb('#F4CC70'); % Center
 hex2rgb('#2F3131'); %East
 hex2rgb('#DE7A22'); %Kyiv
 hex2rgb('#BCBABE'); %Other
 hex2rgb('#8D230F'); % North
 hex2rgb('#CF3721'); %South
 hex2rgb('#C99E10')]; %West

CC=CC(flip([2 5 6 3 7 1 4]),:);

Pop_M=Pop_M(:,:,flip([2 5 6 3 7 1 4]),:);

N_Macro=N_Macro(flip([2 5 6 3 7 1 4]));
close all;
for dd=1:6
    RR=squeeze(sum(Pop_M(dd,:,:,:),[1 2]));
    figure('units','normalized','outerposition',[0. 0.05 0.5 1]);
    subplot('Position',[0.1165,0.257345491388045,0.4354,0.702127659574468])
    for ii=1:7        
        dt=linspace(Time_Sim(1),Time_Sim(2),101);
        semilogy(dt(1:end-1),RR(ii,1).*ones(100,1),'-.','color',CC(ii,:),'LineWidth',2); hold on; 
        semilogy(Time_Sim(2:end),RR(ii,2:end),'color',CC(ii,:),'LineWidth',2); hold on; 
        pl(ii)=scatter(Time_Sim(1),RR(ii,1),100,CC(ii,:),smt{ii},'MarkerFacecolor',CC(ii,:),'LineWidth',2);
        scatter(Time_Sim(2),RR(ii,2),100,CC(ii,:),smt{ii},'LineWidth',2);
    end
    
    patch([Time_Sim(1) Time_Sim(1) Time_Sim(2) Time_Sim(2)],[10^(min(log10(RR(:)))-0.1) 10^(0.1+max(log10(RR(:)))) 10^(0.1+max(log10(RR(:)))) 10^(min(log10(RR(:)))-0.1)],'k','LineStyle','none','FaceAlpha',0.2)
    title(Disease_Short{dd},'Fontsize',28);
    set(gca,'tickdir','out','LineWidth',2,'XTick',[(Time_Sim(1)+Time_Sim(2))./2  Time_Sim(2:14:end)],'XTickLabel',{'Pre-invasion' datestr(Time_Sim(2:14:end))},'Fontsize',24);
    xlabel('Date','Fontsize',28);
    ylabel('Number of people','Fontsize',28);
    box off
    xlim([Time_Sim(1) Time_Sim(end)]);
    ylim([10^(min(log10(RR(:)))-0.1) 10^(max(log10(RR(:)))+0.1)]);
    xtickangle(90);
    if(dd==1)
        legend(flip(pl),flip(N_Macro),'Fontsize',20,'Numcolumns',3,'Position',[0.155014131176101,0.696386358950115,0.393008467693955,0.105369804508176]);
    end
    text(-0.253313884114664,1.03068878316403,char(64+dd),'Units','normalized','Fontsize',40,'FontWeight','bold')
    subplot('Position',[0.7,0.090172239108409,0.270338983050848,0.904761904761907])
    RR=squeeze(sum(Pop_M(dd,:,:,:),[1]));
    YT=[];
    for ii=1:7
        AgD=RR(:,ii,end)./sum(RR(:,ii,end));
        AgPW=RR(:,ii,1)./sum(RR(:,ii,1));
        for jj=1:length(age_c_V)            
            patch([0 0 AgD(jj) AgD(jj)],ii+ 0.9.*(jj-4.5)./length(age_c_V) +0.9.*[-0.5 0.5 0.5 -0.5]./length(age_c_V),CC(ii,:),'LineStyle','none','FaceAlpha',0.5); hold on
        end
        plot(AgPW,ii+ 0.9.*([1:length(age_c_V)]-4.5)./length(age_c_V),['-' smt{ii}],'LineWidth',2,'color',CC(ii,:),'MarkerFaceColor',CC(ii,:));
        
        YT=[YT ii+ 0.9.*([1:length(age_c_V)]-4.5)./length(age_c_V)];
    end
    
    ylim([0.5 7.5]);
    set(gca,'tickdir','out','LineWidth',2,'Fontsize',14,'YTick',YT,'YTickLabel',age_class_text,'Xminortick','on');  
    hAxes=gca;
    hAxes.XAxis.FontSize = 24;
    ylabel('Macro-region age distribution','Fontsize',28,'Position',[-0.38.*max(xlim),4,-0.999999999999986]);
    xlabel('Proportion','Fontsize',28,'Position',[mean(xlim),0.155,-0.999999999999986]);
    for ii=1:7
       text(-0.33.*max(xlim),ii, N_Macro{ii},'Fontsize',24,'Rotation',90,'HorizontalAlignment','center');
    end
    
    print(gcf,['Temporal_' Disease_Short{dd} '_Age_Dist.png'],'-dpng','-r300');
end
