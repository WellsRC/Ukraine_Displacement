function Disease_Burden_Displacement(Daily_IDP_Origin,Pop_Refugee_Origin,Pop_Total,Mapped_Raion_Name,Raion_All,Raion_Full,Oblast_All,Oblast_Full,w_tot_idp,w_tot_ref,Parameter,Time_Sim,Sample)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Refugees with chronic illness
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
Disease_Short={'All';'TB';'TB_DR';'HIV';'HIV_T';'Diabetes';'Cancer';'CVD'};
Country={'Poland','Slovakia','Hungary','Romania','Belarus','Moldova','Russia','Europe (Other)'}';
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
        [Burden_Non_IDP,Burden_IDP,Burden_Refugee]=Disease_Distribution(Disease_Short{dd},Mapped_Raion_Name,age_class,gender,Pop_Non_IDP,Daily_IDP_Origin,Pop_Refugee_Origin,Pop_Total,false);
    end
    
    
    Non_IDP_Raion=zeros(length(gender),length(Raion_All),length(age_class));
    
    
    temp=permute(Burden_Refugee,[1 3 2]);
    temp=reshape(temp,length(gender)*length(age_class),length(Burden_Refugee(1,:,1)));
    Refugee_Country=reshape(temp*w_tot_ref,length(gender),length(age_class),length(Country));
    Refugee_Country=permute(Refugee_Country,[1 3 2]);
    
    
    temp=reshape(permute(Burden_IDP,[1 3 2 4]),length(gender)*length(age_class),length(Burden_Refugee(1,:,1)),nDays);
    
    for tt=1:nDays
        if(tt==1)
            IDP_Raion=(squeeze(w_tot_idp(:,:,tt))*(temp(:,:,tt)'))';
        else
            IDP_Raion=(1-Parameter.w_IDP_Refugee).*IDP_Raion+(squeeze(w_tot_idp(:,:,tt))*(temp(:,:,tt)'))';
        end
    end
    
    IDP_Raion=reshape(IDP_Raion,length(gender),length(age_class),length(Raion_All));
    IDP_Raion=permute(IDP_Raion,[1 3 2]);
    
    
    
    for rr=1:length(Raion_All)
        % Non-IDP
        tf=strcmp(Raion_Full,Raion_All{rr}) & strcmp(Oblast_Full,Oblast_All{rr});
        Non_IDP_Raion(:,rr,:)=sum(Burden_Non_IDP(:,tf,:),2);
    end
    
    
    
    
    % Non-IDP
    Non_IDP=sum(Non_IDP_Raion,[1 3])';
    Non_IDP_Gender=(sum(Non_IDP_Raion,3)./repmat(Non_IDP',2,1))';
    Non_IDP_Age_Female=squeeze(Non_IDP_Raion(1,:,:))./repmat(sum(Non_IDP_Raion(1,:,:),3)',1,length(Non_IDP_Raion(1,1,:)));
    Non_IDP_Age_Male=squeeze(Non_IDP_Raion(2,:,:))./repmat(sum(Non_IDP_Raion(2,:,:),3)',1,length(Non_IDP_Raion(2,1,:)));

    % IDP
    IDP=sum(IDP_Raion,[1 3])';
    IDP_Gender=(sum(IDP_Raion,3)./repmat(IDP',2,1))';
    IDP_Age_Female=squeeze(IDP_Raion(1,:,:))./repmat(sum(IDP_Raion(1,:,:),3)',1,length(IDP_Raion(1,1,:)));
    IDP_Age_Male=squeeze(IDP_Raion(2,:,:))./repmat(sum(IDP_Raion(2,:,:),3)',1,length(IDP_Raion(2,1,:)));
    
    %Refugee
    Refugee=sum(Refugee_Country,[1 3])';
    Refugee_Gender=(sum(Refugee_Country,3)./repmat(Refugee',2,1))';
    Refugee_Age_Female=squeeze(Refugee_Country(1,:,:))./repmat(sum(Refugee_Country(1,:,:),3)',1,length(Refugee_Country(1,1,:)));
    Refugee_Age_Male=squeeze(Refugee_Country(2,:,:))./repmat(sum(Refugee_Country(2,:,:),3)',1,length(Refugee_Country(2,1,:)));
    
    Raion=Raion_All';
    Oblast=Oblast_All';
    Table_Non_IDP=table(Oblast,Raion,Non_IDP,Non_IDP_Gender,Non_IDP_Age_Female,Non_IDP_Age_Male);
    Table_IDP=table(Oblast,Raion,IDP,IDP_Gender,IDP_Age_Female,IDP_Age_Male);
    Table_Refugee=table(Country,Refugee,Refugee_Gender,Refugee_Age_Female,Refugee_Age_Male);
    save([pwd '\Tables\Table_IDP_' Disease_Short{dd} '-' num2str(Sample) '.mat'],'Table_IDP');
    save([pwd '\Tables\Table_Non_IDP_' Disease_Short{dd} '-' num2str(Sample) '.mat'],'Table_Non_IDP');
    save([pwd '\Tables\Table_Refugee_' Disease_Short{dd} '-' num2str(Sample) '.mat'],'Table_Refugee');
    
    
end


end

