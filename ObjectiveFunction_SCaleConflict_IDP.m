function F=ObjectiveFunction_SCaleConflict_IDP(x,PC_IDP,Pop_Remain,Tot_IDP)

ScaleConflict=10^x;

PC_IDPt=1-prod(1-ScaleConflict.*PC_IDP,2);

Est_IDP=sum(PC_IDPt.*Pop_Remain);

F= (log10(Est_IDP)-log10(Tot_IDP)).^2;

end
