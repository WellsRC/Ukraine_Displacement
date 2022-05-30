function x_new=Jumping_Dist(x_old,lambda_J,Sigma_J)

x_new=mvnrnd(x_old,lambda_J.^2.*Sigma_J); 
end