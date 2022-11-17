function L=Refugee_Log_Likelihood(Number_Displacement_Refugee,Date_Displacement_Refugee,Daily_Refugee,Time_Sim,STDEV_Displace)

L=zeros(length(Date_Displacement_Refugee),1);

CDaily_Refugee=cumsum(Daily_Refugee);
ii=1;
L(ii)=log(normpdf(Number_Displacement_Refugee(ii),CDaily_Refugee(Time_Sim==Date_Displacement_Refugee(ii)),STDEV_Displace));

for ii=2:length(L)
    Refugee_Inc=CDaily_Refugee(Time_Sim==Date_Displacement_Refugee(ii))-CDaily_Refugee(Time_Sim==Date_Displacement_Refugee(ii-1)); % In case the data is not in daily increments 
    L(ii)=log(normpdf(Number_Displacement_Refugee(ii),Refugee_Inc,STDEV_Displace));
end

end