function dpc=Disease_per_Capita(Disease,Raion)

dpc=zeros(size(Raion));
load('UKR_Disease_Burden.mat');

tf=strcmp(Disease,DB_UKR.Disease);

DB_UKR=DB_UKR(tf,:);

U_Raion=unique(Raion);

for jj=1:length(U_Raion)
   tf=strcmp(DB_UKR.Raion,U_Raion{jj});
   t_out=strcmp(Raion,U_Raion{jj});
   dpc(t_out)=DB_UKR(tf).prev;
end

end