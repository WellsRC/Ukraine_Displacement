function [Total_Burden_UKR_Trapped] = Disease_Burden_Trapped(Trapped_Pop,IDP_Pop,Pop_Male,Ukraine_Pop)
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NMumber of idp and trapped
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


Country={'In need','Trapped','IDP'}';
Refugee_State=cell(size(Country));
for jj=1:length(Country)
    Refugee_State{jj}='All';
end

Cases=[sum(Trapped_Pop+IDP_Pop);sum(Trapped_Pop);sum(IDP_Pop)];

TotRef=[sum(Trapped_Pop+IDP_Pop);sum(Trapped_Pop);sum(IDP_Pop)];

Per_Cases=100.*Cases./sum(Trapped_Pop+IDP_Pop);   

Prev=Cases./TotRef;
Total_Burden_UKR_Trapped=table(Country,Refugee_State,Cases,Prev,Per_Cases);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Refugees with chronic illness
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
Disease_Short={'TB';'TB_DR';'HIV';'HIV_T';'Diabetes';'Cancer';'CVD'};
Disese_Description={'Tuberculosis';'Drug resistant tuberculosis';'HIV';'HIV Treatment';'Diabetes';'Cancer';'Cardiovascular disease'};


PopTotal=Ukraine_Pop.population_size;
for dd=1:length(Disease_Short)
    
    Burden_Trapped=Disease_Distribution(Disease_Short{dd},Ukraine_Pop.map_raion,false,Trapped_Pop,PopTotal-Pop_Male); % Do not want to consider the males 20-59
    Burden_IDP=Disease_Distribution(Disease_Short{dd},Ukraine_Pop.map_raion,false,IDP_Pop,PopTotal-Pop_Male); % Do not want to consider the males 20-59
    Burden_Trapped(PopTotal==0)=0;
    Burden_IDP(PopTotal==0)=0;
    
    Refugee_State=cell(size(Country));
    for jj=1:length(Country)
        Refugee_State{jj}=Disese_Description{dd};
    end
    
    Cases=[sum(Burden_Trapped+Burden_IDP);sum(Burden_Trapped);sum(Burden_IDP)];

    Per_Cases=100.*Cases./sum(Trapped_Pop+IDP_Pop);   
    
    
    Prev=Cases./TotRef;

    Total_Burden_UKR_Trapped=[Total_Burden_UKR_Trapped; table(Country,Refugee_State,Cases,Prev,Per_Cases)];
    
end



end

