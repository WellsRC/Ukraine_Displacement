function L=Refugee_Country_Log_Likelihood(Est_Daily_Refugee,Refugee_Displacement,Parameter_Map_Refugee,Number_Displacement)

Data=zeros(8,1);
Model=zeros(8,1);

% HARDCODED MAY 12 AS THE TIME POINT AS Belarus and Russia data is up to
% that time point
for ii=1:8
    switch ii
        case 1
            Data_point=Refugee_Displacement.Cumulative_Poland(end-1); % End May 13
            Model_Est=sum(Est_Daily_Refugee.Poland(1:end-1)); % End May 13
        case 2
            Data_point=Refugee_Displacement.Cumulative_Slovakia(end-1);  % End May 13
            Model_Est=sum(Est_Daily_Refugee.Slovakia(1:end-1)); % End May 13
        case 3
            Data_point=Refugee_Displacement.Cumulative_Hungary(end-1);  % End May 13
            Model_Est=sum(Est_Daily_Refugee.Hungary(1:end-1)); % End May 13
        case 4
            Data_point=Refugee_Displacement.Cumulative_Romania(end-1);  % End May 13
            Model_Est=sum(Est_Daily_Refugee.Romania(1:end-1)); % End May 13
        case 5
            Data_point=Refugee_Displacement.Cumulative_Belarus(end);  % End May 12
            Model_Est=sum(Est_Daily_Refugee.Belarus(1:end-1)); % End May 13
        case 6
            Data_point=Refugee_Displacement.Cumulative_Moldova(end-1);  % End May 13
            Model_Est=sum(Est_Daily_Refugee.Moldova(1:end-1)); % End May 13
        case 7
            Data_point=Refugee_Displacement.Cumulative_Russia(end); % End May 12
            Model_Est=sum(Est_Daily_Refugee.Russia(1:end-1));  % End May 13      
        case 8
            NBC=Refugee_Displacement.Cumulative_Poland(end-1)+Refugee_Displacement.Cumulative_Slovakia(end-1)+Refugee_Displacement.Cumulative_Hungary(end-1)+Refugee_Displacement.Cumulative_Romania(end-1)+Refugee_Displacement.Cumulative_Belarus(end)+Refugee_Displacement.Cumulative_Moldova(end-1)+Refugee_Displacement.Cumulative_Russia(end);
            Data_point=sum(Number_Displacement.Refugee(1:end-1))-NBC;
            Model_Est=sum(Est_Daily_Refugee.Europe_Other(1:end-1)); % End May 13
    end
    Data(ii)=Data_point;
    Model(ii)=Model_Est;
end
Tot_Model=sum(Model);
Tot_Ref_Data=sum(Number_Displacement.Refugee(1:end-1)); % End May 13

L=log(normpdf(Tot_Model.*Data./Tot_Ref_Data,Model,Parameter_Map_Refugee.STDEV)); % Determines the distribution among these different regions only

end