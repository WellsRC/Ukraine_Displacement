function [Pop_Adjust_F,Pop_Adjust_M,Pop_Displace] = Population_Adjustment_Displacement(Pop_F_Age,Pop_M_Age,P,W_Gender_Age)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Female
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    Pop_Displace_F=Pop_F_Age.*(repmat(W_Gender_Age(1,:),length(P),1).*repmat(P,1,length(W_Gender_Age(1,:))));
    Pop_Adjust_F=Pop_F_Age-Pop_Displace_F;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Male
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    Pop_Displace_M=Pop_M_Age.*(repmat(W_Gender_Age(2,:),length(P),1).*repmat(P,1,length(W_Gender_Age(2,:))));
    Pop_Adjust_M=Pop_M_Age-Pop_Displace_M;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Total
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Pop_Displace=Pop_Displace_F+Pop_Displace_M;
end

