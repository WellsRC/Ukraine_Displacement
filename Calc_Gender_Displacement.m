function Female_Displace_Proportion=Calc_Gender_Displacement(Pop_Gender)

% Female
Female_Displace_Proportion=Pop_Gender(1,:)./sum(Pop_Gender,1);

end

