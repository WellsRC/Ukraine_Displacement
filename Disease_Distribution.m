function [Burden_Non_IDP,Burden_IDP,Burden_Refugee]=Disease_Distribution(Disease,Raion,age_class_v,gender_v,Pop_Non_IDP,Pop_IDP,Pop_Refugee,PopTotal,PopR,Random)

U_Raion=unique(Raion);
Burden_IDP=zeros(size(Pop_IDP));
weight=zeros(length(gender_v),length(Raion),length(age_class_v));
test_w=zeros(length(U_Raion),2);
for gg=1:length(gender_v)
    for aa=1:length(age_class_v)
        % National disease burden, raion mortality
        load(['UKR_Disease_Burden_' Disease '_Genger=' gender_v{gg} '_Age=' age_class_v{aa} '.mat']);


        for jj=1:length(U_Raion)
           tf=strcmp(raj_name,U_Raion{jj});
           if(Random)
                weightr=poissrnd(sum(deaths(tf)));
           else
               weightr=(sum(deaths(tf)));
           end
           t_out=strcmp(Raion,U_Raion{jj});
           total_r=length(unique(PopR(gg,t_out,aa)));
           weight(gg,t_out,aa)=(weightr./total_r).*PopTotal(gg,t_out,aa)./PopR(gg,t_out,aa);           
        end

        tfnz=find(weight(gg,:,aa)>0);
        if(~isempty(tfnz))
            indxs=weight(gg,:,aa)==0 & PopTotal(gg,:,aa) >0;
            if(Random)
                r=randi(length(tfnz),sum(indxs),1);
                weight(gg,indxs,aa)=(weight(gg,tfnz(r),aa)./PopTotal(gg,tfnz(r),aa)).*PopTotal(gg,indxs,aa);
            else
                weight(gg,indxs,aa)=mean(weight(gg,tfnz,aa)./PopTotal(gg,tfnz,aa)).*PopTotal(gg,indxs,aa);
            end
        end
    end
end

Burden_Non_IDP=(prev.*weight./sum(weight(:))).*(Pop_Non_IDP./PopTotal);
Burden_Non_IDP(PopTotal==0)=0;
Burden_Refugee=(prev.*weight./sum(weight(:))).*(Pop_Refugee./PopTotal);
Burden_Refugee(PopTotal==0)=0;
nDays=length(Pop_IDP(1,1,1,:));
for jj=1:nDays
    temp=(prev.*weight./sum(weight(:))).*(Pop_IDP(:,:,:,jj)./PopTotal);
    temp(PopTotal==0)=0;
    Burden_IDP(:,:,:,jj)=temp;
end


end