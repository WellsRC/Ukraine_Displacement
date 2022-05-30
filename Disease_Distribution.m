function dpc=Disease_Distribution(Disease,Raion,age_class_v,gender_v,Pop,PopTotal,Random)

U_Raion=unique(Raion);
dpc=zeros(length(gender_v),length(Raion),length(age_class_v));
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
           dpc(gg,t_out,aa)=weightr./sum(PopTotal(gg,t_out,aa));
        end

        tfnz=find(dpc(gg,:,aa)>0);
        if(~isempty(tfnz))
            indxs=dpc(gg,:,aa)==0 & Pop(gg,:,aa) >0;
            dpc(gg,indxs,aa)=dpc(gg,tfnz(randi(length(tfnz),sum(indxs),1)),aa);
        end
    end
end
dpc=dpc.*Pop;

dpc=prev.*dpc./sum(dpc(:));

end