function dpc=Disease_per_Capita(Disease,Raion,MartialLaw)

dpc=zeros(size(Raion));

% National disease burden, raion mortality
load('UKR_Disease_Burden.mat');

tf=strcmp(Disease,DB_UKR.Disease);

prev=DB_UKR.Cases(tf);

U_Raion=unique(Raion);

IDN=DB_UKR.class_name{tf};
if(isempty(IDN))
    IDN=DB_UKR.uicd_name{tf};
    tdf=strcmp(UKR_Mortality.uicd_name,IDN);
else    
    tdf=strcmp(UKR_Mortality.class_name,IDN);
end

UKR_Mortality=UKR_Mortality(tdf,:);

NC=sum(UKR_Mortality.deaths);

tf=strcmp(UKR_Mortality.sex,'m') & (strcmp(UKR_Mortality.age_group,'20-24')| strcmp(UKR_Mortality.age_group,'25-29')|strcmp(UKR_Mortality.age_group,'30-34')| strcmp(UKR_Mortality.age_group,'35-39')|strcmp(UKR_Mortality.age_group,'40-44')| strcmp(UKR_Mortality.age_group,'45-49')|strcmp(UKR_Mortality.age_group,'50-54')| strcmp(UKR_Mortality.age_group,'55-59')) ;
if(MartialLaw)
    UKR_Mortality=UKR_Mortality(tf,:); % only can determine from those who fall under martial law;
else
    UKR_Mortality=UKR_Mortality(~tf,:); % only can determine from those who do not fall under martial law;
end

for jj=1:length(U_Raion)
   tf=strcmp(UKR_Mortality.raj_name,U_Raion{jj});
   weightr=sum(UKR_Mortality.deaths(tf))./NC;
   t_out=strcmp(Raion,U_Raion{jj});
   dpc(t_out)=prev.*weightr./NC;
end

end