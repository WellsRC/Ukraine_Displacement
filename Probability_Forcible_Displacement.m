function Prob=Probability_Forcible_Displacement(PC,Parameter,szData,ML_Indx)


Prob=zeros(2,szData(1),szData(2));

% Females
for jj=1:szData(2)
    Prob(1,:,jj)=(Parameter.Age(jj)).*(Parameter.Female_w).*PC;
end

% Males
for jj=1:szData(2)
    if(~ismember(jj,ML_Indx))
        Prob(2,:,jj)=(Parameter.Age(jj)).*(Parameter.Male_w).*PC;
    end
end