function [x_new,L_new]=Random_Select_MCMC(Parameters)
    r=randi(length(Parameters.Likelihood));
    x_new=Parameters.x(r,:);
    L_new=Parameters.Likelihood(r);
end