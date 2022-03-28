
w_tot=Determine_Weights_Refugee(lambda_sci,sc_GDP,lambda_bc,sc_bc,s_nato,lambda_GDP,Ukraine_Pop,Border_Crossing_Country);
Est_Ref=(Pop_Leave')*w_tot;

close all;
figure('units','normalized','outerposition',[0. 0. 1 1]);
Country_Name={'Russian Federation','Poland','Belarus','Slovakia','Hungary','Romania','Moldova','Other'};
bar(Est_Ref./sum(Est_Ref));
hold on
scatter([1:length(Ref_Num)],Ref_Num./sum(Ref_Num),'filled');
set(gca,'XTick',[1:length(Ref_Num)],'XTicklabel',Country_Name,'Yscale','log');
xtickangle(90)