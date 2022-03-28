function L = ObjectiveFunction_IDP(x,Pop_Moving_R,Pop_Raion,SCI_IDP,Raion_IDPSites,Raion_Dist_BC,Num_BC,Raion_Conflict,DistC,Dist,Raion_IDP,Raion_Zone_R)
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%     % Location of sites relative to conflict
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     
%     Parameter_IDP.Scale_Conflict_Distance=10.^x(1);
%     Parameter_IDP.Breadth_Conflict_Distance=10.^x(2);
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%     % Location of sites relative to conflict
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%     
%     Parameter_IDP.Breadth_Border_Distance=10.^x(3);
% 
% 
% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%     % Number of border crossings
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%     Parameter_IDP.Scale_Border_Number=10.^x(4);
%     Parameter_IDP.Breadth_Border_Number=10.^x(5);
% 
% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%     % Conflict in the Raion
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%     
%     Parameter_IDP.Breadth_Conflict_Level=10.^x(6);
%     Parameter_IDP.Conflict_Non_Linear=10^x(7);
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%     % Population
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%     Parameter_IDP.Scale_Population=10.^x(8);
%     Parameter_IDP.Breadth_Population=10.^x(9);

%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%     % SCI 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%     Parameter_IDP.Scale_SCI=10.^x(1);
%     Parameter_IDP.Breadth_SCI=10.^x(2);
% 
% 
    
%     
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
    
    [w_Location]=Estimate_IDP_Displacement(Parameter_IDP,Pop_Raion,SCI_IDP,Raion_IDPSites,Raion_Dist_BC,Num_BC,Raion_Conflict,DistC,Dist);
    
    Est_Raion_IDP=w_Location*Pop_Moving_R;
    
    Zone_IDP=zeros(length(unique(Raion_Zone_R)),1);
    Est_Zone_IDP=zeros(length(unique(Raion_Zone_R)),1);
    
    for ii=1:length(Zone_IDP)
       Zone_IDP(ii)=sum(Raion_IDP(Raion_Zone_R==ii)); 
       Est_Zone_IDP(ii)=sum(Est_Raion_IDP(Raion_Zone_R==ii));
    end
    L=sqrt(sum((Raion_IDP./sum(Raion_IDP)-Est_Raion_IDP./sum(Est_Raion_IDP)).^2))./length(Raion_IDP)+ sqrt(sum((log10(Zone_IDP)-log10(Est_Zone_IDP)).^2))./length(Zone_IDP); %using lsqnonlin to estimate the parameters for the kernel function
        
end

