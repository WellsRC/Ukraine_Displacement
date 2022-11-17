function L=Refugee_Country_Log_Likelihood(Est_Daily_Refugee,Refugee_Displacement,Parameter_Map_Refugee,Number_Displacement)

Data=zeros(8,1);
Model=zeros(8,1);
for ii=1:8
    switch ii
        case 1
            Data_point=Refugee_Displacement.Cumulative_Poland(end);
            Model_Est=sum(Est_Daily_Refugee.Poland);
        case 2
            Data_point=Refugee_Displacement.Cumulative_Slovakia(end);
            Model_Est=sum(Est_Daily_Refugee.Slovakia);
        case 3
            Data_point=Refugee_Displacement.Cumulative_Hungary(end);
            Model_Est=sum(Est_Daily_Refugee.Hungary);
        case 4
            Data_point=Refugee_Displacement.Cumulative_Romania(end);
            Model_Est=sum(Est_Daily_Refugee.Romania);
        case 5
            Data_point=Refugee_Displacement.Cumulative_Belarus(end);
            Model_Est=sum(Est_Daily_Refugee.Belarus);
        case 6
            Data_point=Refugee_Displacement.Cumulative_Moldova(end);
            Model_Est=sum(Est_Daily_Refugee.Moldova);
        case 7
            Data_point=Refugee_Displacement.Cumulative_Russia(end);
            Model_Est=sum(Est_Daily_Refugee.Russia);        
        case 8
            NBC=Refugee_Displacement.Cumulative_Poland(end)+Refugee_Displacement.Cumulative_Slovakia(end)+Refugee_Displacement.Cumulative_Hungary(end)+Refugee_Displacement.Cumulative_Romania(end)+Refugee_Displacement.Cumulative_Belarus(end)+Refugee_Displacement.Cumulative_Moldova(end)+Refugee_Displacement.Cumulative_Russia(end);
            Data_point=sum(Number_Displacement.Refugee)-NBC;
            Model_Est=sum(Est_Daily_Refugee.Europe_Other);
    end
    Data(ii)=Data_point;
    Model(ii)=Model_Est;
end
Tot_Model=sum(Model);
Tot_Ref_Data=sum(Number_Displacement.Refugee);

L=log(normpdf(Tot_Model.*Data./Tot_Ref_Data,Model,Parameter_Map_Refugee.STDEV)); % Determines the distribution among these different regions only

end