% clear;
% NS=10^4;
% 
% Refugee_UI=zeros(NS,1);
% Refugee_Country_UI=zeros(NS,8);
% Disease_Country_UI=zeros(NS,8,7);
% 
% 
% IDP_UI=zeros(NS,1);
% Disease_IDP_UI=zeros(NS,7);
% 
% IDP_Zones_UI=zeros(NS,3);
% Disease_IDP_Zones_UI=zeros(NS,3,7);
% 
% Non_IDP_Zones_UI=zeros(NS,3);
% Disease_Non_IDP_Zones_UI=zeros(NS,3,7);
% 
% 
% Male_Zones_UI=zeros(NS,3);
% Disease_Male_Zones_UI=zeros(NS,3,7);
% 
% 
% load('Ukraine_Population_Regions.mat','Ukraine_Pop');
% 
% Pop=sum(Ukraine_Pop.population_size.*(1-Ukraine_Pop.per_male_fight));
% 
% 
% 
% clear Ukraine_Pop
% 
% 
% load('Input_Figure3D.mat','Total_Burden_IDP','Pop_Total_R','Raion_Zone_Full','Pop_Male_R')
% 
% load('Table_Output_Figure1.mat');
% Tot_Ref=sum(Total_Burden_Refugee.Cases(1:8));
% P_Country_Ref=Total_Burden_Refugee.Per_Cases(1:8)./100;
% 
% 
% 
% Tot_IDP=Total_Burden_UKR.Cases(4);
% 
% Pop_Tot_Zone=[sum(Pop_Total_R(Raion_Zone_Full==1)) sum(Pop_Total_R(Raion_Zone_Full==2)) sum(Pop_Total_R(Raion_Zone_Full==3))]';
% Pop_Male_Zone=[sum(Pop_Male_R(Raion_Zone_Full==1)) sum(Pop_Male_R(Raion_Zone_Full==2)) sum(Pop_Male_R(Raion_Zone_Full==3))]';
% P_Zone_IDP=Total_Burden_IDP.Cases([2 5 8])./(Pop_Tot_Zone-Pop_Male_Zone);
%  P_Zone_Non_IDP=Total_Burden_IDP.Cases([1 4 7])./(Pop_Tot_Zone-Pop_Male_Zone);
% 
% clear Raion_Zone_Full
% 
% 
% Country_Name=Total_Burden_Refugee.Country(1:8);
% 
% Prev_Disease_Ref=reshape(Total_Burden_Refugee.Prev(9:end),length(Country_Name),7);
% 
% Prev_IDP=reshape(Total_Burden_UKR.Prev(8:4:end),1,7);
% 
% Prev_IDP_Zone=reshape(Total_Burden_IDP.Prev(11:3:end),3,7);
% 
% Prev_Non_IDP_Zone=reshape(Total_Burden_IDP.Prev(10:3:end),3,7);
% 
% Prev_Male_Zone=reshape(Total_Burden_IDP.Prev(12:3:end),3,7);
% 
% load('Affected_Hospitals.mat');
% UKR_H=length(PC_IDP);
% p_UKRH=sum(PC_IDP)./UKR_H;
% 
% Hospitals_Affected_UKR=binornd(UKR_H,p_UKRH,NS,1);
% 
% P_ZoneH=1-Hosp_Zone_Weighted./Hosp_Zone;
% 
% Hospitals_Affected_Zones=zeros(NS,3);
% 
% 
% Prev_UI=zeros(1,7);
% 
% PrevNat=[49533	43904	56288;
% 19452	18503	20401;
% 260000	210000	330000;
% 146488	103206	200443;
% 2325000	2101700	2492600;
% 405693	405693	405693;
% 11305246	10382816	12317289];
% 
% bb=zeros(7,1);
% for dd=1:7
%      if(dd~=6)
%         bb(dd)=10.^fminbnd(@(x)sum(((gaminv([0.025 0.975],PrevNat(dd,1)./10.^x,10^x))-PrevNat(dd,2:3)).^2),-3,7);
%      end
% end
% 
% Nat_Prev_disease=zeros(NS,7);
% for ii=1:NS
%     for dd=1:7
%         if(dd~=6)
%             Prev_UI(dd)=gamrnd(PrevNat(dd,1)./bb(dd),bb(dd));
%         else
%             Prev_UI(dd)=poissrnd(PrevNat(dd,1));
%         end
%     end
%     Nat_Prev_disease(ii,:)=Prev_UI;
    
%     Prev_UI=Nat_Prev_disease(ii,:)./[49533 19452 260000 146488 2325000 405693 11305246];
%     Hospitals_Affected_Zones(ii,:)=bnldev(Hosp_Zone,P_ZoneH);
%     Refugee_UI(ii)=bnldev(round(Pop),Tot_Ref./Pop);
%     Refugee_Country_UI(ii,:)=mnrnd(Refugee_UI(ii),P_Country_Ref);
%     
%     
%     IDP_UI(ii)=bnldev(round(Pop),Tot_IDP./Pop);
%     Disease_IDP_UI(ii,:)=bnldev(IDP_UI(ii).*ones(size(Prev_IDP)),Prev_IDP.*Prev_UI);
%     
%     IDP_Zones_UI(ii,:)=bnldev(round(Pop_Tot_Zone-Pop_Male_Zone),P_Zone_IDP);
%     Non_IDP_Zones_UI(ii,:)=bnldev(round(Pop_Tot_Zone-Pop_Male_Zone),P_Zone_Non_IDP);
%     Male_Zones_UI(ii,:)=round(Pop_Male_Zone);
%     for dd=1:7
%         Disease_Country_UI(ii,:,dd)=bnldev(Refugee_Country_UI(ii,:)',Prev_Disease_Ref(:,dd).*Prev_UI(dd));
%         Disease_IDP_Zones_UI(ii,:,dd)=bnldev(IDP_Zones_UI(ii,:)',Prev_IDP_Zone(:,dd).*Prev_UI(dd));
%         Disease_Non_IDP_Zones_UI(ii,:,dd)=bnldev(Non_IDP_Zones_UI(ii,:)',Prev_Non_IDP_Zone(:,dd).*Prev_UI(dd));
%         Disease_Male_Zones_UI(ii,:,dd)=bnldev(Male_Zones_UI(ii,:)',Prev_Male_Zone(:,dd).*Prev_UI(dd));
%     end
% end
% 
% Disease_Refugee_UI=squeeze(sum(Disease_Country_UI,2));

% load('Input_Figure3D.mat');
% Disease_Short={'TB';'TB_DR';'HIV';'HIV_T';'Diabetes';'Cancer';'CVD'};
% Pre_WAR_Disease=zeros(3,length(Disease_Short)+1);
% 
% WAR_Disease=zeros(3,length(Disease_Short)+1);
% TempC=Total_Burden_IDP.Cases;
% 
% for dd=0:length(Disease_Short)
%     if(dd>0)
%         temp=Disease_Distribution(Disease_Short{dd},Mapped_Raion_Name,false,Pop_Total_R-Pop_Male_R,Pop_Total_R-Pop_Male_R)+Disease_Distribution(Disease_Short{dd},Mapped_Raion_Name,true,Pop_Male_R,Pop_Male_R);
%     else
%         temp=Pop_Total_R;
%     end
%     for ii=1:3
%         Pre_WAR_Disease(ii,dd+1)=sum(temp(Raion_Zone_Full==ii));
%     end
%    
% end

Prev_PREWAR_Disease_UI=zeros(NS,3,7);

for ii=1:NS
    Prev_UI=Nat_Prev_disease(ii,:)./[49533 19452 260000 146488 2325000 405693 11305246];
    for dd=1:7
        Prev_PREWAR_Disease_UI(ii,:,dd)=bnldev(Pre_WAR_Disease(:,1),Pre_WAR_Disease(:,dd+1).*Prev_UI(dd)./Pre_WAR_Disease(:,1));
    end
end


