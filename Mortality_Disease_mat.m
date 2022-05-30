clear;

D={'TB';'TB_DR';'HIV';'HIV_T';'Diabetes';'Cancer';'CVD'};

age_class={'0-4','5-9','10-14','15-19','20-24','25-29','30-34','35-39','40-44','45-49','50-54','55-59','60-64','65-69','70-74','75-79','80+'};
gender={'m','f'};
for ii=1:length(D)
    load('UKR_Disease_Burden.mat');
    tf=strcmp(D{ii},DB_UKR.Disease);

    prev=DB_UKR.Cases(tf);

    IDN=DB_UKR.search_name{tf};
    tdf=strcmp(UKR_Mortality.search_name,IDN);
    UKR_Mortality=UKR_Mortality(tdf,:);
    tf=~strcmp(UKR_Mortality.age_group,'N/A');
    UKR_Mortality_t=UKR_Mortality(tf,:);
    for aa=1:length(age_class)
        for g=1:2        
            if(strcmp(age_class{aa},age_class{end}))
              tf=strcmp(UKR_Mortality_t.sex,gender{g}) & (strcmp(UKR_Mortality_t.age_group,'80-84') | strcmp(UKR_Mortality_t.age_group,'85-89') | strcmp(UKR_Mortality_t.age_group,'90-94') | strcmp(UKR_Mortality_t.age_group,'95-99') | strcmp(UKR_Mortality_t.age_group,'100+'));
            else
                tf=strcmp(UKR_Mortality_t.sex,gender{g}) & (strcmp(UKR_Mortality_t.age_group,age_class{aa}));
            end

            UKR_Mortality=UKR_Mortality_t(tf,:); 
            
            raj_name=UKR_Mortality.raj_name;
            deaths=UKR_Mortality.deaths;
            
            save(['UKR_Disease_Burden_' D{ii} '_Genger=' gender{g} '_Age=' age_class{aa} '.mat'],'prev','raj_name','deaths');
        end
    end
end
