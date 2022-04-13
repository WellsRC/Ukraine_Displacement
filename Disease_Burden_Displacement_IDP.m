function [Total_Burden_IDP] = Disease_Burden_Displacement_IDP(Pop_Non_IDP,Pop_IDP,Pop_Male,Pop_Total,Mapped_Raion_Name,Parameter_IDP,Pop_Raion_M,SCI_IDPt,Raion_Dist_BC,Num_BC,Raion_Conflict_M,DistC,Dist,Raion_Zone_R,Raion_Zone_Full)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute weights 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 for dd=1:length(Pop_IDP(1,:))
    [w_Location]=Estimate_IDP_Displacement(Parameter_IDP,Pop_Raion_M,SCI_IDPt,Raion_Dist_BC,Num_BC,squeeze(Raion_Conflict_M(:,:,dd)),DistC(:,dd),Dist);
    if(dd==1)
        Raion_IDP=w_Location*Pop_IDP(:,dd);
    else
        Raion_IDP=Raion_IDP+w_Location*Pop_IDP(:,dd);
    end
end
Country={'Zone-1 Non-IDP','Zone-1 IDP','Zone-1 Male (20-59)','Zone-2 Non-IDP','Zone-2 IDP','Zone-2 Male (20-59)','Zone-3 Non-IDP','Zone-3 IDP','Zone-3 Male (20-59)'}';
Refugee_State=cell(size(Country));
for jj=1:length(Country)
    Refugee_State{jj}='All';
end

Cases=[sum(Pop_Non_IDP(Raion_Zone_Full==1));sum(Raion_IDP(Raion_Zone_R==1));sum(Pop_Male(Raion_Zone_Full==1));sum(Pop_Non_IDP(Raion_Zone_Full==2));sum(Raion_IDP(Raion_Zone_R==2));sum(Pop_Male(Raion_Zone_Full==2));sum(Pop_Non_IDP(Raion_Zone_Full==3));sum(Raion_IDP(Raion_Zone_R==3));sum(Pop_Male(Raion_Zone_Full==3))];

TotRemain=[sum(Pop_Non_IDP(Raion_Zone_Full==1));sum(Raion_IDP(Raion_Zone_R==1));sum(Pop_Male(Raion_Zone_Full==1));sum(Pop_Non_IDP(Raion_Zone_Full==2));sum(Raion_IDP(Raion_Zone_R==2));sum(Pop_Male(Raion_Zone_Full==2));sum(Pop_Non_IDP(Raion_Zone_Full==3));sum(Raion_IDP(Raion_Zone_R==3));sum(Pop_Male(Raion_Zone_Full==3))];

Prev=Cases./TotRemain;

Per_Cases=Cases./sum(Cases);
Total_Burden_IDP=table(Country,Refugee_State,Cases,Prev,Per_Cases);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Refugees with chronic illness
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
Disease_Short={'TB';'TB_DR';'HIV';'HIV_T';'Diabetes';'Cancer';'CVD'};
Disese_Description={'Tuberculosis';'Drug resistant tuberculosis';'HIV';'HIV Treatment';'Diabetes';'Cancer';'Cardiovascular disease'};


for dd=1:length(Disease_Short)
      
    Burden_Non_IDP=Disease_Distribution(Disease_Short{dd},Mapped_Raion_Name,false,Pop_Non_IDP,Pop_Total-Pop_Male); % Do not want to consider the males 20-59
    
    Burden_Male=Disease_Distribution(Disease_Short{dd},Mapped_Raion_Name,true,Pop_Male,Pop_Male); % Want to consider the males 20-59
    Burden_Non_IDP(Pop_Total==0)=0;
    
    Burden_Male(Pop_Male==0)=0;
    
    
     for xx=1:length(Pop_IDP(1,:))
        [w_Location]=Estimate_IDP_Displacement(Parameter_IDP,Pop_Raion_M,SCI_IDPt,Raion_Dist_BC,Num_BC,squeeze(Raion_Conflict_M(:,:,xx)),DistC(:,xx),Dist);
        Burden_IDP=Disease_Distribution(Disease_Short{dd},Mapped_Raion_Name,false,Pop_IDP(:,xx),Pop_Total-Pop_Male);
        
        Burden_IDP(Pop_Total==0)=0;
        if(xx==1)
            Raion_Burden=w_Location*Burden_IDP;
        else
            Raion_Burden=Raion_Burden+w_Location*Burden_IDP;
        end
     end            
    
    
    Refugee_State=cell(size(Country));
    for jj=1:length(Country)
        Refugee_State{jj}=Disese_Description{dd};
    end
    
    Cases=[sum(Burden_Non_IDP(Raion_Zone_Full==1));sum(Raion_Burden(Raion_Zone_R==1));sum(Burden_Male(Raion_Zone_Full==1));sum(Burden_Non_IDP(Raion_Zone_Full==2));sum(Raion_Burden(Raion_Zone_R==2));sum(Burden_Male(Raion_Zone_Full==1));sum(Burden_Non_IDP(Raion_Zone_Full==3));sum(Raion_Burden(Raion_Zone_R==3));sum(Burden_Male(Raion_Zone_Full==3))];
    
       
    Prev=Cases./TotRemain;
    Per_Cases=Cases./sum(Cases);
    Total_Burden_IDP=[Total_Burden_IDP;table(Country,Refugee_State,Cases,Prev,Per_Cases)];
    
end



end

