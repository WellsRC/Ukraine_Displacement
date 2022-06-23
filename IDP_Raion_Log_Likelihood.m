function L=IDP_Raion_Log_Likelihood(Est_Daily_IDP,IDP_Displacement,Time_Sim,Parameter_Mapping_IDP)

Data_Points=zeros(length(IDP_Displacement.raion.IDP),1);
Model_Est=Data_Points;
for ii=1:length(Data_Points)
    Data_Points(ii)=IDP_Displacement.raion.IDP(ii,:);
    if(Data_Points(ii)>0)
        Model_Est(ii)=Est_Daily_IDP.raion(ii,ismember(Time_Sim,datenum(IDP_Displacement.raion.Date)));
    end
end

L=(log(normpdf(sum(Model_Est(Data_Points>0)).*(Data_Points(Data_Points>0))./sum(Data_Points(Data_Points>0)),(Model_Est(Data_Points>0)),Parameter_Mapping_IDP.STDEV_RAION)));
end