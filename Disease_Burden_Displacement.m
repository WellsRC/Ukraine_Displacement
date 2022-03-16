function [Total_Burden_Refugee,Total_Burden_UKR] = Disease_Burden_Displacement(Displace_Pop,Pop_Male,Pop_Remain,Ukraine_Pop)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute weights 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% w=[Ukraine_Pop.per_Poland Ukraine_Pop.per_Slovakia Ukraine_Pop.per_Hungary Ukraine_Pop.per_Romania Ukraine_Pop.per_Moldva Ukraine_Pop.per_Other];

%     wd=exp(-lambda_D.*[Ukraine_Pop.db_Poland Ukraine_Pop.db_Slovakia Ukraine_Pop.db_Hungary Ukraine_Pop.db_Romania Ukraine_Pop.db_Moldva]).*(exp(lambda_GDP.*[Ukraine_Pop.GDP_Poland Ukraine_Pop.GDP_Slovakia Ukraine_Pop.GDP_Hungary Ukraine_Pop.GDP_Romania Ukraine_Pop.GDP_Moldva]));
%     wd=w(:,1:5).*wd.*[wt.*ones(length(Ukraine_Pop.per_Poland),4) (1-wt).*ones(length(Ukraine_Pop.per_Poland),1)];
%     wd=wd./(repmat(sum(wd,2),1,5));
%     wd=wd.*(1-repmat(w(:,6),1,5));
%     w(:,1:5)=wd;

% w=w./(repmat(sum(w,2),1,6));
% Wyback machine (based on numebrs of March 3)
w=[649903 144734 110876 103254 90329 57192 53300 384];
w=w./sum(w);
w=repmat(w,length(Displace_Pop),1);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NMumber of refugees
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Burden=Displace_Pop;


Country={'Poland','Hungary','European (Other)','Moldova','Slovakia','Romania','Russia','Belarus'}';
Refugee_State=cell(size(Country));
for jj=1:length(Country)
    Refugee_State{jj}='All';
end

Cases=sum(w.*repmat(Burden,1,length(Country)),1)';

TotRef=sum(w.*repmat(Burden,1,length(Country)),1)';

Per_Cases=100.*Cases./sum(Cases);   

Prev=Cases./TotRef;
Total_Burden_Refugee=table(Country,Refugee_State,Cases,Prev,Per_Cases);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NMumber of people remaining
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


Country={'UKR','Male (20-59)','Civilians'}';
Refugee_State=cell(size(Country));
for jj=1:length(Country)
    Refugee_State{jj}='All';
end

Cases=[sum(Pop_Male+Pop_Remain);sum(Pop_Male);sum(Pop_Remain)];

TotRemain=[sum(Pop_Male+Pop_Remain);sum(Pop_Male);sum(Pop_Remain)];

Prev=Cases./TotRemain;

Per_Cases=[sum(Pop_Male+Pop_Remain);sum(Pop_Male);sum(Pop_Remain)]./sum(Pop_Male+Pop_Remain);
Total_Burden_UKR=table(Country,Refugee_State,Cases,Prev,Per_Cases);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Refugees with chronic illness
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
Disease_Short={'TB';'TB_DR';'HIV';'HIV_T';'Diabetes';'Cancer';'CVD'};
Disese_Description={'Tuberculosis';'Drug resistant tuberculosis';'HIV';'HIV Treatment';'Diabetes';'Cancer';'Cardiovascular disease'};


PopTotal=Ukraine_Pop.population_size;
for dd=1:length(Disease_Short)
    
    Country={'Poland','Hungary','European (Other)','Moldova','Slovakia','Romania','Russia','Belarus'}';
    Burden=(Displace_Pop./(Displace_Pop+Pop_Remain)).*Disease_Distribution(Disease_Short{dd},Ukraine_Pop.map_raion,false,PopTotal); % Do not want to consider the males 20-59
    Burden(PopTotal==0)=0;
    Cases=sum(w.*repmat(Burden,1,length(Country)),1)';
    Per_Cases=100.*Cases./sum(Cases);
    
    Refugee_State=cell(size(Country));
    for jj=1:length(Country)
        Refugee_State{jj}=Disese_Description{dd};
    end
    Prev=Cases./TotRef;
    Total_Burden_Refugee=[Total_Burden_Refugee;table(Country,Refugee_State,Cases,Prev,Per_Cases)];
    
    
    Country={'UKR','Male (20-59)','Civilians'}';
    Burden_Male=Disease_Distribution(Disease_Short{dd},Ukraine_Pop.map_raion,true,PopTotal); % Want to consider the males 20-59
    Burden_Remain=(Pop_Remain./(Displace_Pop+Pop_Remain)).*Disease_Distribution(Disease_Short{dd},Ukraine_Pop.map_raion,false,PopTotal); % Do not want to consider the males 20-59
    Burden_Remain(PopTotal==0)=0;
    
    Refugee_State=cell(size(Country));
    for jj=1:length(Country)
        Refugee_State{jj}=Disese_Description{dd};
    end
    Cases=[sum(Burden_Male+Burden_Remain);sum(Burden_Male);sum(Burden_Remain)];
    
    Prev=Cases./TotRemain;
    
    Per_Cases=[sum(Burden_Male+Burden_Remain);sum(Burden_Male);sum(Burden_Remain)]./sum(Burden_Male+Burden_Remain);
    Total_Burden_UKR=[Total_Burden_UKR;table(Country,Refugee_State,Cases,Prev,Per_Cases)];
    
end



end

