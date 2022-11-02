function F=Objective_Burden(x,prev,Disease,Raion,age_class_v,gender_v,PopTotal,PopR)
beta_d=10^x;
U_Raion=unique(Raion);
weight=zeros(length(gender_v),length(Raion),length(age_class_v));
for gg=1:length(gender_v)
    for aa=1:length(age_class_v)
        % National disease burden, raion mortality
        load(['UKR_Disease_Burden_' Disease '_Genger=' gender_v{gg} '_Age=' age_class_v{aa} '.mat'],'deaths','raj_name');


        for jj=1:length(U_Raion)
           tf=strcmp(raj_name,U_Raion{jj});
           weightr=(sum(deaths(tf)));
           t_out=strcmp(Raion,U_Raion{jj});
           total_r=length(unique(PopR(gg,t_out,aa)));
           weightr=(weightr./total_r);
           weight(gg,t_out,aa)=(1-exp(-beta_d.*weightr./PopR(gg,t_out,aa)));           
        end

        tfnz=find(weight(gg,:,aa)>0);
        if(~isempty(tfnz))
            indxs=weight(gg,:,aa)==0 & PopTotal(gg,:,aa) >0;
            weight(gg,indxs,aa)=mean(weight(gg,tfnz,aa));%./PopTotal(gg,tfnz,aa)).*PopTotal(gg,indxs,aa);
        end
    end
end

test_p=weight.*PopTotal;

test_PT=sum(test_p(:));

F=(prev-test_PT).^2;

end
% 
% 
% nDays=length(Pop_IDP(1,1,1,:));
% if(length(size(Pop_Non_IDP))==3)
%     Burden_Non_IDP=(prev.*weight./sum(weight(:))).*(Pop_Non_IDP./PopTotal);
%     Burden_Non_IDP(PopTotal==0)=0;
% else
%     Burden_Non_IDP=zeros(size(Pop_Non_IDP));
%     for jj=1:nDays
%         temp=(prev.*weight./sum(weight(:))).*(Pop_Non_IDP(:,:,:,jj)./PopTotal);
%         temp(PopTotal==0)=0;
%         Burden_Non_IDP(:,:,:,jj)=temp;
%     end
% end
% 
% if(length(size(Pop_Refugee))==3)
%     Burden_Refugee=(prev.*weight./sum(weight(:))).*(Pop_Refugee./PopTotal);
%     Burden_Refugee(PopTotal==0)=0;
% else
%     Burden_Refugee=zeros(size(Pop_Refugee));
%     for jj=1:nDays
%         temp=(prev.*weight./sum(weight(:))).*(Pop_Refugee(:,:,:,jj)./PopTotal);
%         temp(PopTotal==0)=0;
%         Burden_Refugee(:,:,:,jj)=temp;
%     end
% end
% 
% for jj=1:nDays
%     temp=(prev.*weight./sum(weight(:))).*(Pop_IDP(:,:,:,jj)./PopTotal);
%     temp(PopTotal==0)=0;
%     Burden_IDP(:,:,:,jj)=temp;
% end
% 
% Burden_Baseline=(prev.*weight./sum(weight(:))).*(PopTotal./PopTotal);
% Burden_Baseline(PopTotal==0)=0;
    
% end