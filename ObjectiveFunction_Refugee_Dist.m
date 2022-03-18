function F=ObjectiveFunction_Refugee_Dist(x,Ukraine_Pop,Border_Crossing_Country,Pop_Leave,Ref_Num)

sc_sci=x(1);
lambda_bc=10.^x(2);
sc_bc=x(3);
sc_nbc=x(4);
s_nato=x(5);

w_tot=Determine_Weights_Refugee(sc_sci,lambda_bc,sc_bc,sc_nbc,s_nato,Ukraine_Pop,Border_Crossing_Country);
Est_Ref=(Pop_Leave')*w_tot;


F=sqrt(sum((Est_Ref-Ref_Num).^2))./length(Ref_Num);

end