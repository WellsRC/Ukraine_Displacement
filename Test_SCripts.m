part=par;
fv=ObjectiveFunction_Refugee_Dist(part,Ukraine_Pop,Border_Crossing_Country,Pop_Leave,Ref_Num);
sum(fv.^2)

lambda_sci=10^part(1);
sc_GDP=part(2);
lambda_bc=10.^part(3);
sc_bc=part(4);
s_nato=part(5);
lambda_GDP=10^part(6);

w_tot=Determine_Weights_Refugee(lambda_sci,sc_GDP,lambda_bc,sc_bc,s_nato,lambda_GDP,Ukraine_Pop,Border_Crossing_Country);
Est_Ref=(Pop_Leave')*w_tot;

close all;
figure('units','normalized','outerposition',[0. 0. 1 1]);
Country_Name={'Russian Federation','Poland','Belarus','Slovakia','Hungary','Romania','Moldova','Other'};
bar(Est_Ref);
hold on
scatter([1:length(Ref_Num)],Ref_Num,'filled');
set(gca,'XTick',[1:length(Ref_Num)],'XTicklabel',Country_Name,'Yscale','log');
xtickangle(90)