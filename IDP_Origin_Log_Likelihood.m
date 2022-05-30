function L=IDP_Origin_Log_Likelihood(Number_Displacement_IDP_Origin,Date_Displacement_IDP_Origin,Daily_IDP_Origin_Macro,Time_Sim,STDEV_Displace_IDP)

L=zeros(length(Date_Displacement_IDP_Origin),6);


M=Daily_IDP_Origin_Macro.Kyiv+Daily_IDP_Origin_Macro.East+Daily_IDP_Origin_Macro.South+Daily_IDP_Origin_Macro.Center+Daily_IDP_Origin_Macro.North+Daily_IDP_Origin_Macro.West;
% D=Number_Displacement_IDP_Origin.Kyiv+Number_Displacement_IDP_Origin.East+Number_Displacement_IDP_Origin.South+Number_Displacement_IDP_Origin.Center+Number_Displacement_IDP_Origin.North+Number_Displacement_IDP_Origin.West;

MV=[Daily_IDP_Origin_Macro.Kyiv;
    Daily_IDP_Origin_Macro.East;
    Daily_IDP_Origin_Macro.South;
    Daily_IDP_Origin_Macro.Center;
    Daily_IDP_Origin_Macro.North;
    Daily_IDP_Origin_Macro.West];

DV=[Number_Displacement_IDP_Origin.Kyiv Number_Displacement_IDP_Origin.East Number_Displacement_IDP_Origin.South Number_Displacement_IDP_Origin.Center Number_Displacement_IDP_Origin.North Number_Displacement_IDP_Origin.West]';
for ii=1:length(Date_Displacement_IDP_Origin)
%     p=MV(:,Time_Sim==Date_Displacement_IDP_Origin(ii))./M(Time_Sim==Date_Displacement_IDP_Origin(ii));
    N=MV(:,Time_Sim==Date_Displacement_IDP_Origin(ii));
    L(ii,:)=log(normpdf(DV(:,ii),N,STDEV_Displace_IDP));
end


end