function L=Refugee_Country_Log_Likelihood(Est_Daily_Refugee,Refugee_Displacement,Parameter_Map_Refugee)

Data=zeros(7,1);
Model=zeros(7,1);
for ii=1:7
    switch ii
        case 1
            Data_point=Refugee_Displacement.Cumulative_Poland;
            Model_Est=cumsum(Est_Daily_Refugee.Poland);
        case 2
            Data_point=Refugee_Displacement.Cumulative_Slovakia;
            Model_Est=cumsum(Est_Daily_Refugee.Slovakia);
        case 3
            Data_point=Refugee_Displacement.Cumulative_Hungary;
            Model_Est=cumsum(Est_Daily_Refugee.Hungary);
        case 4
            Data_point=Refugee_Displacement.Cumulative_Romania;
            Model_Est=cumsum(Est_Daily_Refugee.Romania);
        case 5
            Data_point=Refugee_Displacement.Cumulative_Belarus;
            Model_Est=cumsum(Est_Daily_Refugee.Belarus);
        case 6
            Data_point=Refugee_Displacement.Cumulative_Moldova;
            Model_Est=cumsum(Est_Daily_Refugee.Moldova);
        case 7
            Data_point=Refugee_Displacement.Cumulative_Russia;
            Model_Est=cumsum(Est_Daily_Refugee.Russia);
    end
    Data(ii)=Data_point(end);
    Model(ii)=Model_Est(end);
end
Tot_Model=sum(Model);

L=log(normpdf(Tot_Model.*Data./sum(Data),Model,Parameter_Map_Refugee.STDEV)); % Determines the distribution among these different regions only

end