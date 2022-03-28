function [Total_Burden_Refugee,Total_Burden_UKR] = Disease_Burden_Displacement(Displace_Pop,Pop_Male,Pop_Remain,Pop_Moving,Ukraine_Pop,lambda_sci,sc_GDP,lambda_bc,sc_bc,s_nato,lambda_GDP,Border_Crossing_Country)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute weights 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
w_tot=Determine_Weights_Refugee(lambda_sci,sc_GDP,lambda_bc,sc_bc,s_nato,lambda_GDP,Ukraine_Pop,Border_Crossing_Country);
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NMumber of refugees
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Burden=Displace_Pop;


Country={'Russian Federation','Poland','Belarus','Slovakia','Hungary','Romania','Moldova','Europe (Other)'}';
Refugee_State=cell(size(Country));
for jj=1:length(Country)
    Refugee_State{jj}='All';
end

Cases=sum(w_tot.*repmat(Burden,1,length(Country)),1)';

TotRef=sum(w_tot.*repmat(Burden,1,length(Country)),1)';

Per_Cases=100.*Cases./sum(Cases);   

Prev=Cases./TotRef;
Total_Burden_Refugee=table(Country,Refugee_State,Cases,Prev,Per_Cases);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NMumber of people remaining
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


Country={'UKR','Male (20-59)','All Civilians','IDP'}';
Refugee_State=cell(size(Country));
for jj=1:length(Country)
    Refugee_State{jj}='All';
end

Cases=[sum(Pop_Male+Pop_Remain);sum(Pop_Male);sum(Pop_Remain);sum(Pop_Moving)];

TotRemain=[sum(Pop_Male+Pop_Remain);sum(Pop_Male);sum(Pop_Remain);sum(Pop_Moving)];

Prev=Cases./TotRemain;

Per_Cases=[sum(Pop_Male+Pop_Remain);sum(Pop_Male);sum(Pop_Remain);sum(Pop_Moving)]./sum(Pop_Male+Pop_Remain);
Total_Burden_UKR=table(Country,Refugee_State,Cases,Prev,Per_Cases);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Refugees with chronic illness
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
Disease_Short={'TB';'TB_DR';'HIV';'HIV_T';'Diabetes';'Cancer';'CVD'};
Disese_Description={'Tuberculosis';'Drug resistant tuberculosis';'HIV';'HIV Treatment';'Diabetes';'Cancer';'Cardiovascular disease'};


PopTotal=Ukraine_Pop.population_size;
for dd=1:length(Disease_Short)
    
    Country={'Russian Federation','Poland','Belarus','Slovakia','Hungary','Romania','Moldova','Europe (Other)'}';
    Burden=(Displace_Pop./(Displace_Pop+Pop_Remain)).*Disease_Distribution(Disease_Short{dd},Ukraine_Pop.map_raion,false,PopTotal); % Do not want to consider the males 20-59
    Burden(PopTotal==0)=0;
    Cases=sum(w_tot.*repmat(Burden,1,length(Country)),1)';
    Per_Cases=100.*Cases./sum(Cases);
    
    Refugee_State=cell(size(Country));
    for jj=1:length(Country)
        Refugee_State{jj}=Disese_Description{dd};
    end
    Prev=Cases./TotRef;
    Total_Burden_Refugee=[Total_Burden_Refugee;table(Country,Refugee_State,Cases,Prev,Per_Cases)];
    
    
    Country={'UKR','Male (20-59)','All Civilians','IDP'}';
    Burden_Male=Disease_Distribution(Disease_Short{dd},Ukraine_Pop.map_raion,true,PopTotal); % Want to consider the males 20-59
    Burden_Remain=(Pop_Remain./(Displace_Pop+Pop_Remain)).*Disease_Distribution(Disease_Short{dd},Ukraine_Pop.map_raion,false,PopTotal); % Do not want to consider the males 20-59
    Burden_Moving=(Pop_Moving./(Displace_Pop+Pop_Remain)).*Disease_Distribution(Disease_Short{dd},Ukraine_Pop.map_raion,false,PopTotal); % Do not want to consider the males 20-59
    Burden_Remain(PopTotal==0)=0;
    Burden_Moving(PopTotal==0)=0;
    
    Refugee_State=cell(size(Country));
    for jj=1:length(Country)
        Refugee_State{jj}=Disese_Description{dd};
    end
    Cases=[sum(Burden_Male+Burden_Remain);sum(Burden_Male);sum(Burden_Remain);sum(Burden_Moving)];
    
    Prev=Cases./TotRemain;
    
    Per_Cases=[sum(Burden_Male+Burden_Remain);sum(Burden_Male);sum(Burden_Remain);sum(Burden_Moving)]./sum(Burden_Male+Burden_Remain);
    Total_Burden_UKR=[Total_Burden_UKR;table(Country,Refugee_State,Cases,Prev,Per_Cases)];
    
end



end

