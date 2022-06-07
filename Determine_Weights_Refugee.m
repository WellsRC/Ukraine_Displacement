function w_tot=Determine_Weights_Refugee(Parameter_Map_Refugee,Data)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute weights 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Social connectedness
Parameter.Scale=1;
Parameter.Breadth=Parameter_Map_Refugee.lambda_sci;
X=([Data.Refugee.Poland.FB Data.Refugee.Slovakia.FB Data.Refugee.Hungary.FB Data.Refugee.Romania.FB Data.Refugee.Belarus.FB Data.Refugee.Moldova.FB Data.Refugee.Russia.FB]);
w_sci=Kernel_Function(log(max(X(:)))-log(X),Parameter);

% GDP
GDP=([Data.Refugee.Poland.GDP Data.Refugee.Slovakia.GDP Data.Refugee.Hungary.GDP Data.Refugee.Romania.GDP Data.Refugee.Belarus.GDP Data.Refugee.Moldova.GDP Data.Refugee.Russia.GDP]);
GDP=max(GDP)-GDP;
Parameter.Scale=1;
Parameter.Breadth=Parameter_Map_Refugee.lambda_GDP;
w_GDP=Kernel_Function(GDP,Parameter);
w_GDP=repmat(w_GDP,length(Data.Refugee.Poland.Distance_Border),1);

% GDP per capita
GDPc=([Data.Refugee.Poland.GDP_per_Capita Data.Refugee.Slovakia.GDP_per_Capita Data.Refugee.Hungary.GDP_per_Capita Data.Refugee.Romania.GDP_per_Capita Data.Refugee.Belarus.GDP_per_Capita Data.Refugee.Moldova.GDP_per_Capita Data.Refugee.Russia.GDP_per_Capita]);
GDPc=max(GDPc)-GDPc;
Parameter.Scale=1;
Parameter.Breadth=Parameter_Map_Refugee.lambda_GDPc;
w_GDPc=Kernel_Function(GDPc,Parameter);
w_GDPc=repmat(w_GDPc,length(Data.Refugee.Poland.Distance_Border),1);

% NATO
NATO=max([Data.Refugee.Poland.NATO Data.Refugee.Slovakia.NATO Data.Refugee.Hungary.NATO Data.Refugee.Romania.NATO Data.Refugee.Belarus.NATO Data.Refugee.Moldova.NATO Data.Refugee.Russia.NATO],Parameter_Map_Refugee.weight_NATO);
w_nato=repmat(NATO,length(Data.Refugee.Poland.Distance_Border),1);

% Distance to Border Crossing
X=[Data.Refugee.Poland.Distance_Border Data.Refugee.Slovakia.Distance_Border Data.Refugee.Hungary.Distance_Border Data.Refugee.Romania.Distance_Border Data.Refugee.Belarus.Distance_Border Data.Refugee.Moldova.Distance_Border Data.Refugee.Russia.Distance_Border];
Y=[Data.Refugee.Poland.Number_Border_Crossings Data.Refugee.Slovakia.Number_Border_Crossings Data.Refugee.Hungary.Number_Border_Crossings Data.Refugee.Romania.Number_Border_Crossings Data.Refugee.Belarus.Number_Border_Crossings Data.Refugee.Moldova.Number_Border_Crossings Data.Refugee.Russia.Number_Border_Crossings];
Parameter.Scale=1;
Parameter.Breadth=Parameter_Map_Refugee.lambda_border;
w_bc=Kernel_Function(X,Parameter).^repmat(1./Y,length(X(:,1)),1);

w_tot=(w_sci.*w_nato.*w_GDP.*w_bc.*w_GDPc);

w_tot=w_tot./repmat(sum(w_tot,2),1,7);

w_tot=[(1-Parameter_Map_Refugee.weight_Europe).*w_tot Parameter_Map_Refugee.weight_Europe.*ones(size(w_tot(:,1)))];
end