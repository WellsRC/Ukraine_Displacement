function L=IDP_Oblast_Log_Likelihood(Est_Daily_IDP,IDP_Displacement,Time_Sim,Parameter_Mapping)

Data_Points=zeros(length(IDP_Displacement.Oblast.Index),1);
Model_Est=Data_Points;
for ii=1:length(Data_Points)
    Data_Points(ii)=IDP_Displacement.Oblast.IDP(ii,:);
    Model_Est(ii)=Est_Daily_IDP.oblast(IDP_Displacement.Oblast.Index(ii),ismember(Time_Sim,datenum(IDP_Displacement.Oblast.Date)));
end

L=sum(log(normpdf(sum(Model_Est(:)).*(Data_Points(:))./sum(Data_Points(:)),(Model_Est(:)),Parameter_Mapping.STDEV_OBLAST)));
end