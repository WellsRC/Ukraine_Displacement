function [Total_Burden_Refugee,Total_Burden_UKR] = Disease_Burden_Displacement(Displace_Pop,Pop_Male,Pop_Remain,Ukraine_Pop)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute weights 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
w=[Ukraine_Pop.per_Poland Ukraine_Pop.per_Slovakia Ukraine_Pop.per_Hungary Ukraine_Pop.per_Romania Ukraine_Pop.per_Moldva Ukraine_Pop.per_Other];

%     wd=exp(-lambda_D.*[Ukraine_Pop.db_Poland Ukraine_Pop.db_Slovakia Ukraine_Pop.db_Hungary Ukraine_Pop.db_Romania Ukraine_Pop.db_Moldva]).*(exp(lambda_GDP.*[Ukraine_Pop.GDP_Poland Ukraine_Pop.GDP_Slovakia Ukraine_Pop.GDP_Hungary Ukraine_Pop.GDP_Romania Ukraine_Pop.GDP_Moldva]));
%     wd=w(:,1:5).*wd.*[wt.*ones(length(Ukraine_Pop.per_Poland),4) (1-wt).*ones(length(Ukraine_Pop.per_Poland),1)];
%     wd=wd./(repmat(sum(wd,2),1,5));
%     wd=wd.*(1-repmat(w(:,6),1,5));
%     w(:,1:5)=wd;

% w=w./(repmat(sum(w,2),1,6));
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NMumber of refugees
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Burden=Displace_Pop;


Country={'Poland','Slovakia','Hungary','Romania','Moldva','European (Other)'}';
Refugee_State=cell(size(Country));
for jj=1:length(Country)
    Refugee_State{jj}='All';
end

Cases=sum(w.*repmat(Burden,1,6),1)';
Per_Cases=100.*Cases./sum(Cases);   
    
Total_Burden_Refugee=table(Country,Refugee_State,Cases,Per_Cases);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NMumber of people remaining
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


Country={'UKR','Male (20-59)','Civilians'}';
Refugee_State=cell(size(Country));
for jj=1:length(Country)
    Refugee_State{jj}='All';
end

Cases=[sum(Pop_Male+Pop_Remain);sum(Pop_Male);sum(Pop_Remain)];
Per_Cases=100.*Cases./sum(Cases);   
    
Total_Burden_UKR=table(Country,Refugee_State,Cases,Per_Cases);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Refugees with chronic illness
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
Disease_Short={'TB';'TB_DR';'HIV';'HIV_T';'Diabetes';'Cancer';'CVD'};
Disese_Description={'Tuberculosis';'Drug resistant tuberculosis';'HIV';'HIV Treatment';'Diabetes';'Cancer';'Cardiovascular disease'};

for dd=1:length(Disease_Short)
    Burden=Displace_Pop.*Disease_per_Capita(Disease_Short{dd},Raion,false); % Do not want to consider the males 20-59

    Cases=sum(w.*repmat(Burden,1,6),1)';
    Per_Cases=100.*Cases./sum(Cases);
    
    Country={'Poland','Slovakia','Hungary','Romania','Moldva','European (Other)'}';
    Refugee_State=cell(size(Country));
    for jj=1:length(Country)
        Refugee_State{jj}=Disese_Description{dd};
    end
    Total_Burden_Refugee=[Total_Burden_Refugee;table(Country,Refugee_State,Cases,Per_Cases)];
    
    Burden_Male=Pop_Male.*Disease_per_Capita(Disease_Short{dd},Raion,true); % Want to consider the males 20-59
    Burden_Remain=Pop_Remain.*Disease_per_Capita(Disease_Short{dd},Raion,true); % Do not want to consider the males 20-59
    
    Country={'UKR','Male (20-59)','Civilians'}';
    Refugee_State=cell(size(Country));
    for jj=1:length(Country)
        Refugee_State{jj}=Disese_Description{dd};
    end
    Cases=[sum(Burden_Male+Burden_Remain);sum(Burden_Male);sum(Burden_Remain)];
    Total_Burden_UKR=[Total_Burden_UKR;table(Country,Refugee_State,Cases,Per_Cases)];
    
end



end

