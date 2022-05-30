function P_new=Prior_Dist(x)

[LB,UB]=ParameterBounds;

P_new=floor(sum(x>=LB & x<=UB)./length(LB));

end