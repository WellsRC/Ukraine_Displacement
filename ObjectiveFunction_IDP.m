function L = ObjectiveFunction_IDP(x,Pop_Moving_R,Pop_Raion_M,SCI_IDP,Raion_Dist_BC,Num_BC,Raion_Conflict,DistC,Dist,Raion_IDP,Raion_Zone_R)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    % Population_Sites
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Parameter_IDP.Scale_Population_Sites=10.^x(1);
    Parameter_IDP.Breadth_Population_Sites=10.^x(2);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    % Location of sites relative to pixels
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Parameter_IDP.Scale_Distance=10.^x(3);
    Parameter_IDP.Breadth_Distance=10.^x(4);
    
    
    Parameter_IDP.Scale_Border_Distance=10.^x(5);
    Parameter_IDP.Breadth_Border_Distance=10.^x(6);
    
    Parameter_IDP.Breadth_SCI=10^x(7);
    
    Parameter_IDP.Scale_Border_Number=10^x(8);
    Parameter_IDP.Breadth_Border_Number=10^x(9);
    
    Parameter_IDP.Scale_Distance_Conflict=10^x(10);
    Parameter_IDP.Breadth_Distance_Conflict=10^x(11);
    
    Parameter_IDP.Scale_Level_Conflict=10^x(12);
    Parameter_IDP.Breadth_Level_Conflict=10^x(13);
    
    [w_Location]=Estimate_IDP_Displacement(Parameter_IDP,Pop_Raion_M,SCI_IDP,Raion_Dist_BC,Num_BC,Raion_Conflict,DistC,Dist);
    
    Est_Raion_IDP=w_Location*Pop_Moving_R;
    
    Zone_IDP=zeros(length(unique(Raion_Zone_R)),1);
    Est_Zone_IDP=zeros(length(unique(Raion_Zone_R)),1);
    
    for ii=1:length(Zone_IDP)
       Zone_IDP(ii)=sum(Raion_IDP(Raion_Zone_R==ii)); 
       Est_Zone_IDP(ii)=sum(Est_Raion_IDP(Raion_Zone_R==ii));
    end
    L=0;
    for ii=1:3
        L=L+sqrt(sum((Raion_IDP(Raion_Zone_R==ii)./sum(Raion_IDP(Raion_Zone_R==ii))-Est_Raion_IDP(Raion_Zone_R==ii)./sum(Est_Raion_IDP(Raion_Zone_R==ii))).^2))./length(Raion_IDP(Raion_Zone_R==ii));
    end
    L=L+ sqrt(sum((log10(Zone_IDP)-log10(Est_Zone_IDP)).^2))./length(Zone_IDP); %using lsqnonlin to estimate the parameters for the kernel function
        
end

