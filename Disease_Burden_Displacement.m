function Disease_Burden_Displacement(Pop_IDP_Origin,Pop_Refugee_Origin,Pop_Total,Mapped_Raion_Name,Raion_All,Raion_Full,Oblast_All,Oblast_Full)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Refugees with chronic illness
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
Disease_Short={'All','TB';'TB_DR';'HIV';'HIV_T';'Diabetes';'Cancer';'CVD'};
Country={'Russian','Poland','Belarus','Slovakia','Hungary','Romania','Moldova','Europe (Other)'};
age_class={'0-4','5-9','10-14','15-19','20-24','25-29','30-34','35-39','40-44','45-49','50-54','55-59','60-64','65-69','70-74','75-79','80+'};
gender={'m','f'};

Pop_Non_IDP=Pop_Total-Pop_IDP_Origin-Pop_Refugee_Origin;

for dd=1:length(Disease_Short)        
    if(strcmp(Disease_Short{dd},Disease_Short{1}))
        Burden_Non_IDP=Pop_Non_IDP;
        Burden_IDP=Pop_IDP_Origin;
        Burden_Refugee=Pop_Refugee_Origin;
        
    else            
        Burden_Non_IDP=Disease_Distribution(Disease_Short{dd},Mapped_Raion_Name,age_class,gender,Pop_Non_IDP,Pop_Total);
        Burden_IDP=Disease_Distribution(Disease_Short{dd},Mapped_Raion_Name,age_class,gender,Pop_IDP_Origin,Pop_Total);
        Burden_Refugee=Disease_Distribution(Disease_Short{dd},Mapped_Raion_Name,age_class,gender,Pop_Refugee_Origin,Pop_Total);
    end
    
    IDP_Raion=zeros(length(gender),length(Raion_All),length(age_class));
    Refugee_Country=zeros(length(gender),length(Country),length(age_class));
    for gg=1:length(gender)  
        for aa=1:length(age_class)
                IDP_Raion(gg,:,aa)=w_Raion_IDP*squeeze(Burden_IDP(gg,:,aa));
                Refugee_Country(gg,:,aa)=w_Country_Refugee*squeeze(Burden_Refugee(gg,:,aa));
        end
    end
    
    for rr=1:length(Raion_All)
        
        % Non-IDP
        tf=strcmp(Raion_Full,Raion_All{rr}) & strcmp(Oblast_Full,Oblast_All{rr});
        
        Non_IDP=sum(Burden_Non_IDP(:,tf,:),[1 2 3]);
        Non_IDP_Gender=sum(Burden_Non_IDP(:,tf,:),[2 3])./Non_IDP;
        Non_IDP_Age_Female=sum(Burden_Non_IDP(1,tf,:),2)./Non_IDP_Gender(1);
        Non_IDP_Age_Male=sum(Burden_Non_IDP(2,tf,:),2)./Non_IDP_Gender(2);
        
        % IDP
        IDP=sum(IDP_Raion(:,rr,:),[1 2 3]);
        IDP_Gender=sum(IDP_Raion(:,rr,:),[2 3])./IDP;
        IDP_Age_Female=sum(IDP_Raion(1,rr,:),2)./IDP_Gender(1);
        IDP_Age_Male=sum(IDP_Raion(2,rr,:),2)./IDP_Gender(2);
        
        if(~isfile(['Table_IDP_' Raion{rr} '_' Disease_Short{dd} '.mat']))
            Table_Non_IDP=table(Non_IDP,Non_IDP_Gender,Non_IDP_Age_Female,Non_IDP_Age_Male);
            Table_IDP=table(IDP,IDP_Gender,IDP_Age_Female,IDP_Age_Male);
        
        else
            load(['Table_IDP_' Raion{rr} '_' Disease_Short{dd} '.mat'],'Table_IDP');
            load(['Table_Non_IDP_' Raion{rr} '_' Disease_Short{dd} '.mat'],'Table_Non_IDP');
            
            Table_Non_IDP_t=table(Non_IDP,Non_IDP_Gender,Non_IDP_Age_Female,Non_IDP_Age_Male);
            Table_IDP_t=table(IDP,IDP_Gender,IDP_Age_Female,IDP_Age_Male);
            
            Table_Non_IDP=[Table_Non_IDP;Table_Non_IDP_t];
            Table_IDP=[Table_IDP;Table_IDP_t];
        end
        
        save(['Table_IDP_' Raion{rr} '_' Disease_Short{dd} '.mat'],'Table_IDP');
        save(['Table_Non_IDP_' Raion{rr} '_' Disease_Short{dd} '.mat'],'Table_Non_IDP');
    end
    
    for cc=1:length(Country)
        
        % Refugee
        Refugee=sum(Refugee_Country(:,cc,:),[1 2 3]);
        Refugee_Gender=sum(Refugee_Country(:,cc,:),[2 3])./Refugee;
        Refugee_Age_Female=sum(Refugee_Country(1,cc,:),2)./Refugee_Gender(1);
        Refugee_Age_Male=sum(Refugee_Country(2,cc,:),2)./Refugee_Gender(2);
        if(~isfile(['Table_Refugee_' Country{cc} '_' Disease_Short{dd} '.mat']))
            Table_Refugee=table(Refugee,Refugee_Gender,Refugee_Age_Female,Refugee_Age_Male);
        else
            load(['Table_Refugee_' Country{cc} '_' Disease_Short{dd} '.mat'],'Table_Refugee');
            Table_Refugee_t=table(Refugee,Refugee_Gender,Refugee_Age_Female,Refugee_Age_Male);
            Table_Refugee=[Table_Refugee;Table_Refugee_t];
        end
        save(['Table_Refugee_' Country{cc} '_' Disease_Short{dd} '.mat'],'Table_Refugee');
    end
end


end

