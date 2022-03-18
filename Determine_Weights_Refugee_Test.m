function w_tot=Determine_Weights_Refugee_Test(lambda_sci,sc_sci,lambda_bc,sc_bc,s_nato,lambda_GDP,Ukraine_Pop,Border_Crossing_Country)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute weights 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
w_sci=1-exp(-lambda_sci.*[Ukraine_Pop.per_Poland Ukraine_Pop.per_Belarus Ukraine_Pop.per_Slovakia Ukraine_Pop.per_Hungary Ukraine_Pop.per_Romania Ukraine_Pop.per_Moldova Ukraine_Pop.per_Other]);

w_sci=[sc_sci.*ones(size(Ukraine_Pop.per_Poland)) w_sci];

%https://tradingeconomics.com/country-list/gdp?continent=europe
GDP=[1484 594 60.26 105 155 249 11.91 15276./27];
w_GDP=1-exp(-lambda_GDP.*GDP);
w_GDP=repmat(w_GDP,length(Ukraine_Pop.per_Poland),1);
Country_Name={'Russian Federation','Poland','Belarus','Slovakia','Hungary','Romania','Moldova'};

w_nato=[s_nato 1 s_nato 1 1 1 s_nato 1];

w_bc=zeros(length(Ukraine_Pop.per_Poland),length(Country_Name));

dist_BC=Ukraine_Pop.distance_bc;
Parameter.Scale=1;
Parameter.Breadth=lambda_bc;

for ii=1:length(Country_Name)
    f_BC=strcmp(Border_Crossing_Country,Country_Name{ii});
    w_bc(:,ii)=Kernel_Function(median(dist_BC(:,f_BC),2),Parameter).^(1./sum(f_BC));
end

w_bc=[w_bc sc_bc.*ones(size(Ukraine_Pop.per_Poland))];


w_tot=w_sci.*w_nato.*w_GDP.*w_bc;

w_tot=w_tot./repmat(sum(w_tot,2),1,length(Country_Name)+1);

end