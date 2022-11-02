function Prob=Probability_Forcible_Displacement(PC,Parameter,Pop_SES,szData)


Prob=zeros(2,szData(1),szData(2));
if(Parameter.SES>0)
% Females
    Prob(1,:,:)=(Parameter.Female_w).*(PC.*Prob_SES(Pop_SES,Parameter.SES));

% Males
        Prob(2,:,:)=(Parameter.Male_w).*(PC.*Prob_SES(Pop_SES,Parameter.SES));
else
    
% Females
    Prob(1,:,:)=(Parameter.Female_w).*PC;

% Males
        Prob(2,:,:)=(Parameter.Male_w).*PC;
end
end