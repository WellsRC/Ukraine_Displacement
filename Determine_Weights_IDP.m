function [w_Location]=Determine_Weights_IDP(Parameter_Map_IDP,Mapping_Data)
nDays=length(Mapping_Data.IDP.Raion_Conflict(1,:));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Social connectedness
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

Parameter.Scale=1;
Parameter.Breadth=Parameter_Map_IDP.Breadth_SCI;
X=Mapping_Data.IDP.FB;
w_Location=Kernel_Function(log(max(X(:)))-log(X),Parameter);



Parameter.Scale=1;
Parameter.Breadth=Parameter_Map_IDP.Capital;
w_Location=w_Location.*Kernel_Function(Mapping_Data.IDP.Captial,Parameter);

w_Location=repmat(w_Location,1,1,nDays);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Raion distance to conflict
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
X=Mapping_Data.IDP.Raion_Conflict;
X=1-Parameter_Map_IDP.Breadth_Conflict.*(X-min(X(:)))./(1-min(X(:)));
test=repmat(X,1,1,length(w_Location(1,:,1)));

w_Location=w_Location.*permute(test,[1 3 2]);
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Restricted travel due to conflict
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Parameter.Scale=1;
Parameter.Breadth=Parameter_Map_IDP.Breadth_Travel_Conflict;

test=repmat(1-Parameter.Breadth.*Mapping_Data.IDP.Raion_Russian_Control(:,1)-(1-Parameter.Breadth).*Mapping_Data.IDP.Raion_Russian_Control(:,2),1,length(w_Location(1,:,1)),length(w_Location(1,1,:)));

w_Location=w_Location.*test;
% w_Location(w_Location==0)=min(w_Location(w_Location>0));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Normalize weights
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


w_Location=w_Location./repmat(sum(w_Location,1),length(w_Location(:,1,1)),1,1);

end