function L=Refugee_Log_Likelihood(Number_Displacement_Refugee,Date_Displacement_Refugee,Daily_Refugee,Time_Sim,STDEV_Displace)

L=zeros(length(Date_Displacement_Refugee),1);

for ii=1:length(L)
    L(ii)=log(normpdf(Number_Displacement_Refugee(ii),Daily_Refugee(Time_Sim==Date_Displacement_Refugee(ii)),STDEV_Displace));
end

end