function F=ObjectiveFunction_SCaleConflict_IDP(x,PC_IDP,Pop_Remain,Tot_IDP)

ScaleConflict=10^x;

PC_IDPt=ScaleConflict.*PC_IDP;
Est_IDP=0;
for dd=1:length(PC_IDPt(1,:))
    Est_IDP=Est_IDP+sum(PC_IDPt(:,dd).*Pop_Remain);
    Pop_Remain=Pop_Remain-PC_IDPt(:,dd).*Pop_Remain;
end


F= (log10(Est_IDP)-log10(Tot_IDP)).^2;

end
