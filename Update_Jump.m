function [lambda_J,Sigma_J]=Update_Jump(lambda_J,Sigma_J,Parameter_LS,L_Last,a_r,k,MCMC_Parameters)

lambda_J=lambda_J.*exp((a_r-MCMC_Parameters.alpha_F)./k);

Sigma_J=MCMC_Parameters.p.*Sigma_J+(1-MCMC_Parameters.p).*cov(Parameter_LS(~isinf(L_Last),:));
end
