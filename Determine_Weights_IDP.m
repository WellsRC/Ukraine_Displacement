function [w_Location]=Determine_Weights_IDP(Parameter_Map_IDP,Mapping_Data,w_tot_ref)
nDays=length(Mapping_Data.IDP.Raion_Conflict(1,:));
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Preference of raion relative to distance to border crossing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Parameter.Scale=1;
Parameter.Breadth=Parameter_Map_IDP.Breadth_Border_Distance; 
w_Location=Kernel_Function(Mapping_Data.IDP.Distance_Border,Parameter)*(w_tot_ref');
 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % Social connectedness
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

Parameter.Scale=1;
Parameter.Breadth=Parameter_Map_IDP.Breadth_SCI;
X=Mapping_Data.IDP.FB;
w_Location=w_Location.*Kernel_Function(log(max(X(:)))-log(X),Parameter);

%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % Population
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Parameter.Scale=1;
Parameter.Breadth=Parameter_Map_IDP.Breadth_Population_Sites;
w_Location=w_Location.*Kernel_Function(Mapping_Data.IDP.Population_Ratio,Parameter);


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % Capital per capita
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Parameter.Scale=Parameter_Map_IDP.Scale_Capital;
Parameter.Breadth=Parameter_Map_IDP.Breadth_Capital;
w_Location=w_Location.*(1-Kernel_Function(Mapping_Data.IDP.Captial,Parameter));


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % Location of sites relative to pixels
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Parameter.Scale=Parameter_Map_IDP.Scale_Distance;
Parameter.Breadth=Parameter_Map_IDP.Breadth_Distance;
w_Location=w_Location.*(1-Kernel_Function(Mapping_Data.IDP.Distance,Parameter));


%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % Raion distance to conflict
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
Parameter.Scale=1;
Parameter.Breadth=Parameter_Map_IDP.Breadth_Distance_Conflict;
X=Mapping_Data.IDP.Raion_Conflict;
test=repmat(Kernel_Function(log(1-(X-min(X(:)))./(1-min(X(:)))),Parameter),1,1,length(w_tot_ref(:,1)));

w_Location=repmat(w_Location,1,1,nDays).*permute(test,[1 3 2]);



w_Location(w_Location==0)=min(w_Location(w_Location>0));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Normalize weights
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


w_Location=w_Location./repmat(sum(w_Location,1),length(w_Location(:,1,1)),1,1);

end