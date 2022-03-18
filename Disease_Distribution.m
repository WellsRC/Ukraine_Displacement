function dpc=Disease_Distribution(Disease,Raion,MartialLaw,Pop,Random_Sample)


% National disease burden, raion mortality
load('UKR_Disease_Burden.mat');

tf=strcmp(Disease,DB_UKR.Disease);

prev=DB_UKR.Cases(tf);

U_Raion=unique(Raion);

IDN=DB_UKR.search_name{tf};
tdf=strcmp(UKR_Mortality.search_name,IDN);
UKR_Mortality=UKR_Mortality(tdf,:);

NC=sum(UKR_Mortality.deaths);

tf=strcmp(UKR_Mortality.sex,'m') & (strcmp(UKR_Mortality.age_group,'20-24')| strcmp(UKR_Mortality.age_group,'25-29')|strcmp(UKR_Mortality.age_group,'30-34')| strcmp(UKR_Mortality.age_group,'35-39')|strcmp(UKR_Mortality.age_group,'40-44')| strcmp(UKR_Mortality.age_group,'45-49')|strcmp(UKR_Mortality.age_group,'50-54')| strcmp(UKR_Mortality.age_group,'55-59')) ;

if(Random_Sample)
    
    dpc_citizen=zeros(size(Raion));
    dpc_male=zeros(size(Raion));
    
    UKR_Mortality_Male=UKR_Mortality(tf,:);
    UKR_Mortality_Citizen=UKR_Mortality(~tf,:);
    
    for jj=1:length(U_Raion)
       tf=strcmp(UKR_Mortality_Citizen.raj_name,U_Raion{jj});
       weightr=sum(UKR_Mortality_Citizen.deaths(tf));
       t_out=strcmp(Raion,U_Raion{jj});
       dpc_citizen(t_out)=weightr.*Pop(t_out)./sum(Pop(t_out));
       
       
       tf=strcmp(UKR_Mortality_Male.raj_name,U_Raion{jj});
       weightr=sum(UKR_Mortality_Male.deaths(tf));
       t_out=strcmp(Raion,U_Raion{jj});
       dpc_male(t_out)=weightr.*Pop(t_out)./sum(Pop(t_out));
    end
    
    dpc=[dpc_citizen;dpc_male]./NC;
    
    dpc=mnrnd(prev,dpc');
    if(MartialLaw)
        dpc=dpc(length(dpc_citizen)+1:end);
    else
        dpc=dpc(1:length(dpc_citizen));
    end
else
    
    dpc=zeros(size(Raion));
    if(MartialLaw)
        UKR_Mortality=UKR_Mortality(tf,:); % only can determine from those who fall under martial law;
    else
        UKR_Mortality=UKR_Mortality(~tf,:); % only can determine from those who do not fall under martial law;
    end

    for jj=1:length(U_Raion)
       tf=strcmp(UKR_Mortality.raj_name,U_Raion{jj});
       weightr=sum(UKR_Mortality.deaths(tf));
       t_out=strcmp(Raion,U_Raion{jj});
       dpc(t_out)=weightr.*Pop(t_out)./sum(Pop(t_out));
    end
    dpc=prev.*dpc./NC;
end
end