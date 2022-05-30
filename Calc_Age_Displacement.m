function Age_Displace_Proportion=Calc_Age_Displacement(Pop_Age)

Age_Displace_Proportion=zeros(4,length(Pop_Age(1,:)));
% Age groups 18-29
Age_Displace_Proportion(1,:)=sum(Pop_Age(5:6,:),1)./sum(Pop_Age(5:end,:),1);
% Age groups 30-39
Age_Displace_Proportion(2,:)=sum(Pop_Age(7:8,:),1)./sum(Pop_Age(5:end,:),1);
% Age groups 40-49
Age_Displace_Proportion(3,:)=sum(Pop_Age(9:10,:),1)./sum(Pop_Age(5:end,:),1);
% Age groups 50+
Age_Displace_Proportion(4,:)=sum(Pop_Age(11:end,:),1)./sum(Pop_Age(5:end,:),1);

end

