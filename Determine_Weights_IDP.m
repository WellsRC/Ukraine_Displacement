function [w_Location]=Determine_Weights_IDP(Parameter_Map_IDP,Mapping_Data,IDP_Mv)
nDays=length(Mapping_Data.IDP.Raion_Conflict(1,:));


w_Location=ones(size(Mapping_Data.IDP.FB,1),size(Mapping_Data.IDP.FB,2),nDays);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Social connectedness
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
if(IDP_Mv(1)>0)
    Parameter.Scale=1;
    Parameter.Breadth=Parameter_Map_IDP.Breadth_SCI;
    X=Mapping_Data.IDP.FB;
    w_Location=w_Location.*repmat(Kernel_Function(log(max(X(:)))-log(X),Parameter),1,1,nDays);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Raion distance to conflict
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(IDP_Mv(2)>0)
    X=Mapping_Data.IDP.Raion_Conflict;
    X=1-Parameter_Map_IDP.Breadth_Conflict.*(X-min(X(:)))./(1-min(X(:)));
    test=repmat(X,1,1,length(w_Location(1,:,1)));

    w_Location=w_Location.*permute(test,[1 3 2]);
end 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Restricted travel due to conflict
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(IDP_Mv(3)>0)
    Parameter.Scale=1;
    Parameter.Breadth=Parameter_Map_IDP.Breadth_Travel_Conflict;

    test=repmat(1-Parameter.Breadth.*Mapping_Data.IDP.Raion_Russian_Control(:,1)-(1-Parameter.Breadth).*Mapping_Data.IDP.Raion_Russian_Control(:,2),1,length(w_Location(1,:,1)),length(w_Location(1,1,:)));

    w_Location=w_Location.*test;
end
% w_Location(w_Location==0)=min(w_Location(w_Location>0));




 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Capital
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(IDP_Mv(4)>0)
    Parameter.Scale=1;
    Parameter.Breadth=Parameter_Map_IDP.Capital;
    w_Location=w_Location.*repmat(Kernel_Function(Mapping_Data.IDP.Captial,Parameter),1,1,nDays);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Normalize weights
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


w_Location=w_Location./repmat(sum(w_Location,1),length(w_Location(:,1,1)),1,1);

end