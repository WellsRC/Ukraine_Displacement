function L=Refugee_Country_Log_Likelihood(Est_Daily_Refugee,Refugee_Displacement,Parameter_Map_Refugee)

Data=zeros(7,1);
Model=zeros(7,1);
for ii=1:7
    switch ii
        case 1
            Data_point=Refugee_Displacement.Cumulative_Poland;
            Data_time=Refugee_Displacement.Date_Poland;
            Model_Est=Est_Daily_Refugee.Poland;
        case 2
            Data_point=Refugee_Displacement.Cumulative_Slovakia;
            Data_time=Refugee_Displacement.Date_Slovakia;
            Model_Est=Est_Daily_Refugee.Slovakia;
        case 3
            Data_point=Refugee_Displacement.Cumulative_Hungary;
            Data_time=Refugee_Displacement.Date_Hungary;
            Model_Est=Est_Daily_Refugee.Hungary;
        case 4
            Data_point=Refugee_Displacement.Cumulative_Romania;
            Data_time=Refugee_Displacement.Date_Romania;
            Model_Est=Est_Daily_Refugee.Romania;
        case 5
            Data_point=Refugee_Displacement.Cumulative_Belarus;
            Data_time=Refugee_Displacement.Date_Belarus;
            Model_Est=Est_Daily_Refugee.Belarus;
        case 6
            Data_point=Refugee_Displacement.Cumulative_Moldova;
            Data_time=Refugee_Displacement.Date_Moldova;
            Model_Est=Est_Daily_Refugee.Moldova;
        case 7
            Data_point=Refugee_Displacement.Cumulative_Russia;
            Data_time=Refugee_Displacement.Date_Russia;
            Model_Est=Est_Daily_Refugee.Russia;
    end
    Data(ii)=Data_point(end);
    Model(ii)=Model_Est(end);
end
Tot_Model=sum(Model)+Est_Daily_Refugee.Europe_Other(end);

L=log(normpdf(Tot_Model.*Data./sum(Data),Model,Parameter_Map_Refugee.STDEV));

end