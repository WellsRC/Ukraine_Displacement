function Disease_Burden_Displacement(Daily_IDP_Origin,Pop_Refugee_Origin,Pop_Total,Mapped_Raion_Name,Raion_All,Raion_Full,Oblast_All,Oblast_Full,w_tot_idp,w_tot_ref,Parameter,Time_Sim)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Refugees with chronic illness
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
Disease_Short={'All';'TB';'TB_DR';'HIV';'HIV_T';'Diabetes';'Cancer';'CVD'};
Country={'Poland','Slovakia','Hungary','Romania','Belarus','Moldova','Russia','Europe (Other)'};
age_class={'0-4','5-9','10-14','15-19','20-24','25-29','30-34','35-39','40-44','45-49','50-54','55-59','60-64','65-69','70-74','75-79','80+'};
gender={'f','m'};

Pop_Non_IDP=Pop_Total-sum(Daily_IDP_Origin,4)-Pop_Refugee_Origin;
nDays=length(Daily_IDP_Origin(1,1,1,:));
for dd=1:length(Disease_Short)        
    if(strcmp(Disease_Short{dd},Disease_Short{1}))
        
        Burden_Non_IDP=Pop_Non_IDP;
        Burden_IDP=Daily_IDP_Origin;
        Burden_Refugee=Pop_Refugee_Origin;
        
    else            
        Burden_Non_IDP=Disease_Distribution(Disease_Short{dd},Mapped_Raion_Name,age_class,gender,Pop_Non_IDP,Pop_Total,false);
        Burden_IDP=zeros(size(Daily_IDP_Origin));
        for jj=1:nDays
            Burden_IDP(:,:,:,jj)=Disease_Distribution(Disease_Short{dd},Mapped_Raion_Name,age_class,gender,Daily_IDP_Origin(:,:,:,jj),Pop_Total,false);
        end
        Burden_Refugee=Disease_Distribution(Disease_Short{dd},Mapped_Raion_Name,age_class,gender,Pop_Refugee_Origin,Pop_Total,false);
    end
    
    IDP_Raion=zeros(length(gender),length(Raion_All),length(age_class));
    Refugee_Country=zeros(length(gender),length(Country),length(age_class));
    for gg=1:length(gender)  
        for aa=1:length(age_class)
                IDP_Raion(gg,:,aa)=Table_Return_IDP(w_tot_idp,squeeze(Burden_IDP(gg,:,aa,:)),Time_Sim,Raion_All,Parameter);
                Refugee_Country(gg,:,aa)=Table_Return_Refugee(w_tot_ref,Burden_Refugee(gg,:,aa));
        end
    end
    
    for rr=1:length(Raion_All)
        
        % Non-IDP
        tf=strcmp(Raion_Full,Raion_All{rr}) & strcmp(Oblast_Full,Oblast_All{rr});
        
        Non_IDP=sum(Burden_Non_IDP(:,tf,:),[1 2 3]);
        Non_IDP_Gender=(sum(Burden_Non_IDP(:,tf,:),[2 3])./Non_IDP)';
        Non_IDP_Age_Female=squeeze(sum(Burden_Non_IDP(1,tf,:),2)./(sum(Burden_Non_IDP(1,tf,:),[2 3])))';
        Non_IDP_Age_Male=squeeze(sum(Burden_Non_IDP(2,tf,:),2)./(sum(Burden_Non_IDP(2,tf,:),[2 3])))';
        
        % IDP
        IDP=sum(IDP_Raion(:,rr,:),[1 2 3]);
        IDP_Gender=(sum(IDP_Raion(:,rr,:),[2 3])./IDP)';
        IDP_Age_Female=squeeze(IDP_Raion(1,rr,:)./(sum(IDP_Raion(1,rr,:),3)))';
        IDP_Age_Male=squeeze(IDP_Raion(2,rr,:)./(sum(IDP_Raion(2,rr,:),3)))';
        
        if(~isfile([pwd '\Tables\Table_IDP_' Raion_All{rr} '_' Disease_Short{dd} '.mat']))
            Table_Non_IDP=table(Non_IDP,Non_IDP_Gender,Non_IDP_Age_Female,Non_IDP_Age_Male);
            Table_IDP=table(IDP,IDP_Gender,IDP_Age_Female,IDP_Age_Male);
        
        else
            load([pwd '\Tables\Table_IDP_' Raion_All{rr} '_' Disease_Short{dd} '.mat'],'Table_IDP');
            load([pwd '\Tables\Table_Non_IDP_' Raion_All{rr} '_' Disease_Short{dd} '.mat'],'Table_Non_IDP');
            
            Table_Non_IDP_t=table(Non_IDP,Non_IDP_Gender,Non_IDP_Age_Female,Non_IDP_Age_Male);
            Table_IDP_t=table(IDP,IDP_Gender,IDP_Age_Female,IDP_Age_Male);
            
            Table_Non_IDP=[Table_Non_IDP;Table_Non_IDP_t];
            Table_IDP=[Table_IDP;Table_IDP_t];
        end
        
        save([pwd '\Tables\Table_IDP_' Raion_All{rr} '_' Disease_Short{dd} '.mat'],'Table_IDP');
        save([pwd '\Tables\Table_Non_IDP_' Raion_All{rr} '_' Disease_Short{dd} '.mat'],'Table_Non_IDP');
    end
    
    for cc=1:length(Country)
        
        % Refugee
        Refugee=sum(Refugee_Country(:,cc,:),[1 2 3]);
        Refugee_Gender=(sum(Refugee_Country(:,cc,:),[2 3])./Refugee)';
        Refugee_Age_Female=squeeze(Refugee_Country(1,cc,:)./(sum(Refugee_Country(1,cc,:),3)))';
        Refugee_Age_Male=squeeze(Refugee_Country(2,cc,:)./(sum(Refugee_Country(2,cc,:),3)))';
        
        if(~isfile([pwd '\Tables\Table_Refugee_' Country{cc} '_' Disease_Short{dd} '.mat']))
            Table_Refugee=table(Refugee,Refugee_Gender,Refugee_Age_Female,Refugee_Age_Male);
        else
            load([pwd '\Tables\Table_Refugee_' Country{cc} '_' Disease_Short{dd} '.mat'],'Table_Refugee');
            Table_Refugee_t=table(Refugee,Refugee_Gender,Refugee_Age_Female,Refugee_Age_Male);
            Table_Refugee=[Table_Refugee;Table_Refugee_t];
        end
        save([pwd '\Tables\Table_Refugee_' Country{cc} '_' Disease_Short{dd} '.mat'],'Table_Refugee');
    end
end


end

