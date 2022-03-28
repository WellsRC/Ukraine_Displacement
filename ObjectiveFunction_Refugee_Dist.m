function F=ObjectiveFunction_Refugee_Dist(x,Ukraine_Pop,Border_Crossing_Country,Pop_Leave,Ref_Num)

lambda_sci=10^x(1);
sc_GDP=x(2);
lambda_bc=10.^x(3);
sc_bc=x(4);
s_nato=x(5);
lambda_GDP=10^x(6);

w_tot=Determine_Weights_Refugee(lambda_sci,sc_GDP,lambda_bc,sc_bc,s_nato,lambda_GDP,Ukraine_Pop,Border_Crossing_Country);
Est_Ref=(Pop_Leave')*w_tot;

% Fit the percentage and not the number
F=log10(Est_Ref./sum(Est_Ref))-log10(Ref_Num./sum(Ref_Num));

end