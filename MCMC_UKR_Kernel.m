function [Parameter_V,L_V,a_V] = MCMC_UKR_Kernel(MCMC_Parameters,vLat_C,vLon_C,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,Pop_MACRO,Number_Displacement,Date_Displacement,RC,Time_Switch,Time_Sim,ML_Indx,day_W_fix,L_V,Parameter_V,a_V,k)

x_old=MCMC_Parameters.x0;
L_old = -ObjectiveFunction(x_old,vLat_C,vLon_C,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,Pop_MACRO,Number_Displacement,Date_Displacement,RC,Time_Switch,Time_Sim,ML_Indx,day_W_fix);
P_old=Prior_Dist(x_old);


Parameter_V(1,:)=x_old;
L_V(1)=L_old;

count=1;

Sigma_J=MCMC_Parameters.Sigma_J;
lambda_J=MCMC_Parameters.lambda_J;
a=0;

Parameter_Last=zeros(MCMC_Parameters.Last_Sample_COV,length(x_old));
L_Last=zeros(MCMC_Parameters.Last_Sample_COV,1);
L_Last(:)=-Inf;
L_MD=L_Last;
Parameter_Last(1,:)=x_old;
Parameter_MD=Parameter_Last;
L_Last(1)=L_old;
count_sample=1;
while(count<MCMC_Parameters.Size)
    if(rem(count_sample,MCMC_Parameters.Last_Sample_COV)==0)        
        save(['MCMC_out-k=' num2str(k) '.mat']);
        [~,Sigma_J]=Update_Jump(lambda_J,Sigma_J,Parameter_Last,L_Last,a./count_sample,k,MCMC_Parameters);
        [lambda_J,~]=Update_Jump(lambda_J,Sigma_J,Parameter_Last(count_sample-(MCMC_Parameters.Last_Sample_LAMBDA-1):count_sample,:),L_Last(count_sample-(MCMC_Parameters.Last_Sample_LAMBDA-1):count_sample),a./MCMC_Parameters.Last_Sample_LAMBDA,k,MCMC_Parameters);
        k=k+1;
        save(['MCMC_out-k=' num2str(k) '.mat']);
        a=0;
        Parameter_Last(1,:)=Parameter_Last(end,:);
        Parameter_Last(2:end)=0.*Parameter_Last(2:end);
        L_Last(1)=L_Last(end);
        L_Last(2:end)=-Inf;
        Parameter_MD=Parameter_Last;
        L_MD=L_Last;
        count_sample=1;
    elseif(rem(count_sample,MCMC_Parameters.Last_Sample_LAMBDA)==0) 
        [lambda_J,~]=Update_Jump(lambda_J,Sigma_J,Parameter_Last(count_sample-(MCMC_Parameters.Last_Sample_LAMBDA-1):count_sample,:),L_Last(count_sample-(MCMC_Parameters.Last_Sample_LAMBDA-1):count_sample),a./MCMC_Parameters.Last_Sample_LAMBDA,k,MCMC_Parameters);
        k=k+1;
        a=0;
    end
    x_new=Jumping_Dist(x_old,lambda_J,Sigma_J);
    P_new=Prior_Dist(x_new);
    count_sample=count_sample+1;
    if(P_new>0)
        L_new = -ObjectiveFunction(x_new,vLat_C,vLon_C,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,Pop_MACRO,Number_Displacement,Date_Displacement,RC,Time_Switch,Time_Sim,ML_Indx,day_W_fix);

        Parameter_MD(count_sample,:)=x_new;
        L_MD(count_sample)=L_new;
        r=min(exp(L_new + log(P_new)-L_old - log(P_old)),1);
        
        if(rand(1)<r)
           x_old=x_new;
           L_old=L_new;
           P_old=P_new;
           L_V(count+1)=L_new;
           Parameter_V(count+1,:)=x_new;
           a=a+1;
           
           a_V(count+1)=a./(rem(count_sample-1,MCMC_Parameters.Last_Sample_LAMBDA)+1);
           count=count+1;
           Parameter_Last(count_sample,:)=x_new;
           L_Last(count_sample)=L_new;
        end
    end
    
end

end

