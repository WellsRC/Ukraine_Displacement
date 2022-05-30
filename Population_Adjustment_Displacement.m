function [Pop_Adjust_F,Pop_Adjust_M,Pop_Displace] = Population_Adjustment_Displacement(Pop_F_Age,Pop_M_Age,P)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Female
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    Pop_Displace_F=Pop_F_Age.*squeeze(P(1,:,:));
    Pop_Adjust_F=Pop_F_Age-Pop_Displace_F;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Male
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    Pop_Displace_M=Pop_M_Age.*squeeze(P(2,:,:));
    Pop_Adjust_M=Pop_M_Age-Pop_Displace_M;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Total
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    sz=size(Pop_Displace_M);
    Pop_Displace=zeros(2,sz(1),sz(2));
    Pop_Displace(1,:,:)=Pop_Displace_F;
    Pop_Displace(2,:,:)=Pop_Displace_M;
end

