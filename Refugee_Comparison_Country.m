clear;
clc;

load('Ukraine_Population_Regions.mat','Ukraine_Pop')

Tot_Pop=sum(Ukraine_Pop.population_size);

clear Ukraine_Pop;

% National disease burden, raion mortality
load('UKR_Disease_Burden.mat','DB_UKR');


Disease_Short={'TB';'TB_DR';'HIV';'HIV_T';'Diabetes';'Cancer';'CVD'};
Disese_Description={'Tuberculosis';'Drug resistant tuberculosis';'HIV';'HIV Treatment';'Diabetes';'Cancer';'Cardiovascular disease'};


Nat_Prev=zeros(7,1);

for ii=1:7
    tf=strcmp(Disease_Short{ii},DB_UKR.Disease);
    Nat_Prev(ii)=DB_UKR.Cases(tf)./Tot_Pop;
end

load('Table_Output_Figure1.mat','Total_Burden_Refugee')

Country=Total_Burden_Refugee.Country(1:8);

Prev_Disease_Country_Refugee=reshape(Total_Burden_Refugee.Prev(9:end),length(Country),length(Disease_Short));


Prev_Disease_All_Refugee=sum(reshape(Total_Burden_Refugee.Cases(9:end),length(Country),length(Disease_Short)),1)./sum(Total_Burden_Refugee.Cases(1:8));

CC=Total_Burden_Refugee.Cases(1:8);



for kk=1:length(Disease_Short)        
    for jj=1:length(Country)
        Country_Name=Country(jj);
        Disease=Disese_Description(kk);
        Rel_Change_UKR=100.*(Prev_Disease_Country_Refugee(jj,kk)./Nat_Prev(kk)-1);
        Rel_Change_Ref=100.*(Prev_Disease_Country_Refugee(jj,kk)./Prev_Disease_All_Refugee(kk)-1);
        if(jj.*kk==1)
            T_RefCvsUKR=table(Country_Name,Disease,Rel_Change_UKR);
            T_RefCvsAllRef=table(Country_Name,Disease,Rel_Change_Ref);
        else
            
            T_RefCvsUKR=[T_RefCvsUKR; table(Country_Name,Disease,Rel_Change_UKR)];
            T_RefCvsAllRef=[T_RefCvsAllRef;table(Country_Name,Disease,Rel_Change_Ref)];
        end
    end
end