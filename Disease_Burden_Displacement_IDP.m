function [Total_Burden_IDP] = Disease_Burden_Displacement_IDP(Pop_Non_IDP,Pop_IDP,Pop_Total,Mapped_Raion_Name,Parameter_IDP,SCI_IDP,Raion_IDPSites,Raion_Dist_BC,Num_BC,Raion_Conflict,DistC,Dist,Pop_Raion,Raion_Zone_R,Raion_Zone_Full)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute weights 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[w_Location]=Estimate_IDP_Displacement(Parameter_IDP,SCI_IDP,Raion_IDPSites,Raion_Dist_BC,Num_BC,Raion_Conflict,DistC,Dist,Pop_Raion);


Raion_IDP=w_Location*Pop_IDP;
Country={'Zone-1 Non-IDP','Zone-1 IDP','Zone-2 Non-IDP','Zone-2 IDP','Zone-3 Non-IDP','Zone-3 IDP'}';
Refugee_State=cell(size(Country));
for jj=1:length(Country)
    Refugee_State{jj}='All';
end

Cases=[sum(Pop_Non_IDP(Raion_Zone_Full==1));sum(Raion_IDP(Raion_Zone_R==1));sum(Pop_Non_IDP(Raion_Zone_Full==2));sum(Raion_IDP(Raion_Zone_R==2));sum(Pop_Non_IDP(Raion_Zone_Full==3));sum(Raion_IDP(Raion_Zone_R==3))];

TotRemain=[sum(Pop_Non_IDP(Raion_Zone_Full==1));sum(Raion_IDP(Raion_Zone_R==1));sum(Pop_Non_IDP(Raion_Zone_Full==2));sum(Raion_IDP(Raion_Zone_R==2));sum(Pop_Non_IDP(Raion_Zone_Full==3));sum(Raion_IDP(Raion_Zone_R==3))];

Prev=Cases./TotRemain;

Per_Cases=[sum(Pop_Non_IDP(Raion_Zone_Full==1));sum(Raion_IDP(Raion_Zone_R==1));sum(Pop_Non_IDP(Raion_Zone_Full==2));sum(Raion_IDP(Raion_Zone_R==2));sum(Pop_Non_IDP(Raion_Zone_Full==3));sum(Raion_IDP(Raion_Zone_R==3))]./(sum(Pop_Non_IDP)+sum(Pop_IDP));
Total_Burden_IDP=table(Country,Refugee_State,Cases,Prev,Per_Cases);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Refugees with chronic illness
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
Disease_Short={'TB';'TB_DR';'HIV';'HIV_T';'Diabetes';'Cancer';'CVD'};
Disese_Description={'Tuberculosis';'Drug resistant tuberculosis';'HIV';'HIV Treatment';'Diabetes';'Cancer';'Cardiovascular disease'};


for dd=1:length(Disease_Short)
      
    Country={'Zone-1 Non-IDP','Zone-1 IDP','Zone-2 Non-IDP','Zone-2 IDP','Zone-3 Non-IDP','Zone-3 IDP'}';
    Burden_Non_IDP=(Pop_Non_IDP./(Pop_IDP+Pop_Non_IDP)).*Disease_Distribution(Disease_Short{dd},Mapped_Raion_Name,false,Pop_Total); % Do not want to consider the males 20-59
    Burden_IDP=(Pop_IDP./(Pop_IDP+Pop_Non_IDP)).*Disease_Distribution(Disease_Short{dd},Mapped_Raion_Name,false,Pop_Total); % Do not want to consider the males 20-59
    Burden_Non_IDP(Pop_Total==0)=0;
    Burden_IDP(Pop_Total==0)=0;
    
    Refugee_State=cell(size(Country));
    for jj=1:length(Country)
        Refugee_State{jj}=Disese_Description{dd};
    end
    
    
    Raion_Burden=w_Location*Burden_IDP;
    Cases=[sum(Burden_Non_IDP(Raion_Zone_Full==1));sum(Raion_Burden(Raion_Zone_R==1));sum(Burden_Non_IDP(Raion_Zone_Full==2));sum(Raion_Burden(Raion_Zone_R==2));sum(Burden_Non_IDP(Raion_Zone_Full==3));sum(Raion_Burden(Raion_Zone_R==3))];
    
       
    Prev=Cases./TotRemain;
    Per_Cases=[sum(Burden_Non_IDP(Raion_Zone_Full==1));sum(Raion_Burden(Raion_Zone_R==1));sum(Burden_Non_IDP(Raion_Zone_Full==2));sum(Raion_Burden(Raion_Zone_R==2));sum(Burden_Non_IDP(Raion_Zone_Full==3));sum(Raion_Burden(Raion_Zone_R==3))]./(sum(Burden_Non_IDP)+sum(Burden_IDP));
    Total_Burden_IDP=[Total_Burden_IDP;table(Country,Refugee_State,Cases,Prev,Per_Cases)];
    
end



end

