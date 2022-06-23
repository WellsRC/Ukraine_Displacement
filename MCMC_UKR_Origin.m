function [Parameter_V,Parameter_V_Map,L_V,a_V] = MCMC_UKR_Origin(MCMC_Parameters,vLat_C,vLon_C,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,RC,Time_Switch,Time_Sim,ML_Indx,day_W_fix,Mapping_Data,Refugee_Displacement,IDP_Displacement,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Tot_Refugee_Data,Macro_Map)

x_old_map=MCMC_Parameters.x0_map;
x_old=MCMC_Parameters.x0;

[Parameter,~]=Parameter_Return(x_old,RC,Time_Switch,day_W_fix);

[Pop_Displace,~,Pop_Refugee]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Time_Sim,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,ML_Indx);
Daily_Refugee=squeeze(sum(Pop_Refugee,[1 3]));
Daily_IDP_Origin=Parameter.w_IDP.*squeeze(sum(Pop_Displace,[1 3])); % Need to examine the new idp only

L_old = -ObjectiveFunction_IDP_Refugee(x_old_map,Daily_Refugee,Daily_IDP_Origin,Mapping_Data,Refugee_Displacement,IDP_Displacement,Time_Sim,Parameter,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Tot_Refugee_Data,Macro_Map);
         
L_old= L_old + MCMC_Parameters.L_0;

Parameter_V=zeros(MCMC_Parameters.Size,length(x_old));
Parameter_V_Map=zeros(MCMC_Parameters.Size,length(x_old_map));
L_V=zeros(MCMC_Parameters.Size,1);
a_V=zeros(MCMC_Parameters.Size,1);

Parameter_V(1,:)=x_old;
Parameter_V_Map(1,:)=x_old_map;
L_V(1)=L_old;

count=1;

Sigma_J=MCMC_Parameters.Sigma_J;
lambda_J=MCMC_Parameters.lambda_J;
a=0;

Parameter_Last=zeros(MCMC_Parameters.Last_Sample_COV,length(x_old));
Parameter_Last_Mapping=zeros(MCMC_Parameters.Last_Sample_COV,length(x_old_map));
L_Last=zeros(MCMC_Parameters.Last_Sample_COV,1);
L_Last(:)=-Inf;
L_MD=L_Last;
Parameter_Last(1,:)=x_old;
Parameter_Last_Mapping(1,:)=x_old_map;
Parameter_MD=Parameter_Last;
Parameter_MD_Mapping=Parameter_Last_Mapping;
L_Last(1)=L_old;
k=1;
count_sample=1;

P_old=Prior_Dist_Mapping(x_old_map);

while(count<MCMC_Parameters.Size)
    if(rem(count_sample,MCMC_Parameters.Last_Sample_COV)==0)        
        save(['MCMC_out_Mapping-k=' num2str(k) '.mat']);
        [~,Sigma_J]=Update_Jump(lambda_J,Sigma_J,Parameter_Last_Mapping,L_Last,a./count_sample,k,MCMC_Parameters);
        [lambda_J,~]=Update_Jump(lambda_J,Sigma_J,Parameter_Last_Mapping(count_sample-(MCMC_Parameters.Last_Sample_LAMBDA-1):count_sample,:),L_Last(count_sample-(MCMC_Parameters.Last_Sample_LAMBDA-1):count_sample),a./MCMC_Parameters.Last_Sample_LAMBDA,k,MCMC_Parameters);
        k=k+1;
        save(['MCMC_out_Mapping-k=' num2str(k) '.mat']);
        a=0;
        Parameter_Last(1,:)=Parameter_Last(end,:);
        Parameter_Last(2:end)=0.*Parameter_Last(2:end);
        
        Parameter_Last_Mapping(1,:)=Parameter_Last_Mapping(end,:);
        Parameter_Last_Mapping(2:end)=0.*Parameter_Last_Mapping(2:end);
        
        L_Last(1)=L_Last(end);
        L_Last(2:end)=-Inf;
        Parameter_MD=Parameter_Last;
        Parameter_MD_Mapping=Parameter_Last_Mapping;
        L_MD=L_Last;
        count_sample=1;
    elseif(rem(count_sample,MCMC_Parameters.Last_Sample_LAMBDA)==0) 
        [lambda_J,~]=Update_Jump(lambda_J,Sigma_J,Parameter_Last_Mapping(count_sample-(MCMC_Parameters.Last_Sample_LAMBDA-1):count_sample,:),L_Last(count_sample-(MCMC_Parameters.Last_Sample_LAMBDA-1):count_sample),a./MCMC_Parameters.Last_Sample_LAMBDA,k,MCMC_Parameters);
        k=k+1;
        a=0;
    end
    x_new_map=Jumping_Dist(x_old_map,lambda_J,Sigma_J);
    [x_new,L_new]=Random_Select_MCMC(MCMC_Parameters.Baseline);
    P_new=Prior_Dist_Mapping(x_new_map);
    count_sample=count_sample+1;
    if(P_new>0)
        
        [Parameter,~]=Parameter_Return(x_new,RC,Time_Switch,day_W_fix);

        [Pop_Displace,~,Pop_Refugee]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Time_Sim,Lat_P,Lon_P,Pop_F_Age,Pop_M_Age,ML_Indx);
        Daily_Refugee=squeeze(sum(Pop_Refugee,[1 3]));
        Daily_IDP_Origin=Parameter.w_IDP.*squeeze(sum(Pop_Displace,[1 3])); % Need to examine the new idp only

        L_new = L_new +(-ObjectiveFunction_IDP_Refugee(x_new_map,Daily_Refugee,Daily_IDP_Origin,Mapping_Data,Refugee_Displacement,IDP_Displacement,Time_Sim,Parameter,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Tot_Refugee_Data,Macro_Map));

        Parameter_MD(count_sample,:)=x_new;
        Parameter_MD_Mapping(count_sample,:)=x_new_map;
        
        L_MD(count_sample)=L_new;
        r=min(exp(L_new + log(P_new)-L_old - log(P_old)),1);
        
        if(rand(1)<r)
           x_old=x_new;
           x_old_map=x_new_map;
           L_old=L_new;
           P_old=P_new;
           L_V(count+1)=L_new;
           Parameter_V(count+1,:)=x_new;
           Parameter_V_Map(count+1,:)=x_new_map;
           a=a+1;
           
           a_V(count+1)=a./(rem(count_sample-1,MCMC_Parameters.Last_Sample_LAMBDA)+1);
           count=count+1;
           Parameter_Last(count_sample,:)=x_new;
           Parameter_Last_Mapping(count_sample,:)=x_new_map;
           L_Last(count_sample)=L_new;
        end
    end
    
end

end

