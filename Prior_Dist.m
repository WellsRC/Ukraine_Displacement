function P_new=Prior_Dist(x,Model_Num)

[LB,UB]=ParameterBounds(Model_Num);

P_new=floor(sum(x>=LB & x<=UB)./length(LB));

end