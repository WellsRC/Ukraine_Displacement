function L=IDP_Female_Log_Likelihood(Number_Displacement_Proportion_IDP_Female,Date_Displacement_Proportion_IDP_Female,Number_Displacement_IDP_Origin,Daily_IDP_Female,Daily_IDP_Origin_Macro,Time_Sim,STDEV_Displace_IDP)

M_Tot=Daily_IDP_Origin_Macro.Kyiv+Daily_IDP_Origin_Macro.East+Daily_IDP_Origin_Macro.South+Daily_IDP_Origin_Macro.Center+Daily_IDP_Origin_Macro.North+Daily_IDP_Origin_Macro.West;
D_Tot=Number_Displacement_IDP_Origin.Kyiv+Number_Displacement_IDP_Origin.East+Number_Displacement_IDP_Origin.South+Number_Displacement_IDP_Origin.Center+Number_Displacement_IDP_Origin.North+Number_Displacement_IDP_Origin.West;

L=zeros(size(Number_Displacement_Proportion_IDP_Female));

for ii=1:length(Date_Displacement_Proportion_IDP_Female)
    p=Daily_IDP_Female(:,Time_Sim==Date_Displacement_Proportion_IDP_Female(ii));
    N=M_Tot(Time_Sim==Date_Displacement_Proportion_IDP_Female(ii));
    D=Number_Displacement_Proportion_IDP_Female(ii).*D_Tot(ii);
    L(ii)=log(normpdf(D,N.*p,STDEV_Displace_IDP));     
end

end