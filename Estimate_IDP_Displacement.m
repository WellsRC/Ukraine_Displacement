function [w_Location]=Estimate_IDP_Displacement(Parameter_IDP,Pop_Raion,SCI_IDP,Raion_IDPSites,Raion_Dist_BC,Num_BC,Raion_Conflict,DistC,Dist)

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Population_Border_Number
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Parameter.Scale=Parameter_IDP.Scale_Border_Distance;
    Parameter.Breadth=Parameter_IDP.Breadth_Border_Distance;
%     
    w_Location=1-prod(1-Kernel_Function(Raion_Dist_BC,Parameter),2);
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Border_Number
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 Parameter.Scale=Parameter_IDP.Scale_Border_Number;
    Parameter.Breadth=Parameter_IDP.Breadth_Border_Number;
 w_Location=w_Location.*(Pop_Raion.*(1+Parameter.Scale.*Num_BC)).^Parameter.Breadth;
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Population_Sites
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Parameter.Scale=Parameter_IDP.Scale_Population_Sites;
    Parameter.Breadth=Parameter_IDP.Breadth_Population_Sites;
    w_Location=w_Location.*((Pop_Raion.*(1+Parameter.Scale.*Raion_IDPSites)).^Parameter.Breadth);
    
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Distance Conflict
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
Parameter.Scale=Parameter_IDP.Scale_Distance_Conflict;
Parameter.Breadth=Parameter_IDP.Breadth_Distance_Conflict;
w_Location=w_Location.*(1-Raion_Conflict.*Kernel_Function(median(DistC,2),Parameter));
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Level Conflict
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
Parameter.Scale=Parameter_IDP.Scale_Level_Conflict;
Parameter.Breadth=Parameter_IDP.Breadth_Level_Conflict;
w_Location=w_Location.*(1-Parameter.Scale.*Raion_Conflict.^Parameter.Breadth);
    
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % SCI 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
Parameter.Scale=1;
Parameter.Breadth=Parameter_IDP.Breadth_SCI;
w_Location=Kernel_Function(SCI_IDP,Parameter).*repmat(w_Location,1,length(SCI_IDP(1,:)));
% 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Location of sites relative to pixels
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Parameter.Scale=Parameter_IDP.Scale_Distance;
Parameter.Breadth=Parameter_IDP.Breadth_Distance;
w_Location=w_Location.*(1-Kernel_Function(Dist,Parameter));


w_Location=w_Location./repmat(sum(w_Location,1),length(Raion_Conflict),1);
w_Location(isnan(w_Location))=0;
end