function w_tot=Determine_Weights_Refugee(sc_sci,lambda_bc,sc_bc,sc_nbc,s_nato,Ukraine_Pop,Border_Crossing_Country)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute weights 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
w_sci=[Ukraine_Pop.per_Poland Ukraine_Pop.per_Belarus Ukraine_Pop.per_Slovakia Ukraine_Pop.per_Hungary Ukraine_Pop.per_Romania Ukraine_Pop.per_Moldova Ukraine_Pop.per_Other];

w_sci=[sc_sci.*ones(size(Ukraine_Pop.per_Poland)) (1-sc_sci).*w_sci];

Country_Name={'Russian Federation','Poland','Belarus','Slovakia','Hungary','Romania','Moldova'};

w_nato=[1-s_nato s_nato 1-s_nato s_nato s_nato s_nato 1-s_nato s_nato];
w_nato=w_nato./sum(w_nato);
w_nato=repmat(w_nato,length(Ukraine_Pop.per_Poland),1);

w_bc=zeros(length(Ukraine_Pop.per_Poland),length(Country_Name));
w_nbc=zeros(length(Ukraine_Pop.per_Poland),length(Country_Name));

w_c=ones(1,length(Country_Name)+1);

dist_BC=Ukraine_Pop.distance_bc;
Parameter.Scale=1;
Parameter.Breadth=lambda_bc;

for ii=1:length(Country_Name)
    f_BC=strcmp(Border_Crossing_Country,Country_Name{ii});
    w_bc(:,ii)=Kernel_Function(median(dist_BC(:,f_BC),2),Parameter);
    w_nbc(:,ii)=sum(f_BC).*ones(size(w_nbc(:,ii)));
end

w_c=w_c./sum(w_c);

w_c=repmat(w_c,length(Ukraine_Pop.per_Poland),1);

w_bc=w_bc./(repmat(sum(w_bc,2),1,length(Country_Name)));
w_bc=[(1-sc_bc).*w_bc sc_bc.*ones(size(Ukraine_Pop.per_Poland))];

w_nbc=w_nbc./(repmat(sum(w_nbc,2),1,length(Country_Name)));
w_nbc=[(1-sc_nbc).*w_nbc sc_nbc.*ones(size(Ukraine_Pop.per_Poland))];

w_tot=nthroot(w_sci.*w_bc.*w_nbc.*w_c,4);

w_tot=w_tot./repmat(sum(w_tot,2),1,length(Country_Name)+1);

end