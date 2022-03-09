function [Total_Burden,Oblast_Burden,Raion_Burden] = Disease_Burden_Displacement(Disease,Oblast,Raion,Displace_Pop,Oblast_Name,Raion_Name)

Burden=Displace_Pop.*Disease_per_Capita(Disease,Raion);

Total_Burden=sum(Burden);

Oblast_Burden=zeros(length(Oblast_Name),1);
for ii=1:length(Oblast_Name)
    tf=strcmp(Oblast,Oblast_Name{ii});
    Oblast_Burden(ii)=sum(Burden(tf));
end


Raion_Burden=zeros(length(Raion_Name),1);

for ii=1:length(Raion_Name)
    tf=strcmp(Raion,Raion_Name{ii});
    Raion_Burden(ii)=sum(Burden(tf));
end


end

