function L=IDP_Log_Likelihood(Number_Displacement_IDP_Origin,Date_Displacement_IDP_Origin,Daily_IDP_Origin_Macro,Time_Sim,STDEV_Displace)

L=zeros(length(Date_Displacement_IDP_Origin),1);


M=Daily_IDP_Origin_Macro.Kyiv+Daily_IDP_Origin_Macro.East+Daily_IDP_Origin_Macro.South+Daily_IDP_Origin_Macro.Center+Daily_IDP_Origin_Macro.North+Daily_IDP_Origin_Macro.West;
D=Number_Displacement_IDP_Origin.Kyiv+Number_Displacement_IDP_Origin.East+Number_Displacement_IDP_Origin.South+Number_Displacement_IDP_Origin.Center+Number_Displacement_IDP_Origin.North+Number_Displacement_IDP_Origin.West;

for ii=1:length(Date_Displacement_IDP_Origin)
    L(ii)=log(normpdf(D(ii),M(Time_Sim==Date_Displacement_IDP_Origin(ii)),STDEV_Displace));
end


end