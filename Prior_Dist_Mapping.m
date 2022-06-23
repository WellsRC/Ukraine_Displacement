function P_new=Prior_Dist_Mapping(x)

[LB,UB]=ParameterBounds_Mapping;

P_new=floor(sum(x>=LB & x<=UB)./length(LB));

end