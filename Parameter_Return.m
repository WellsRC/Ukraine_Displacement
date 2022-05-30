function [Parameter,STDEV_Displace]=Parameter_Return(x,RC,Time_Switch,day_W_fix)
    Parameter.Scale=10.^x(1);
    Parameter.Breadth=RC;
    Parameter.Switch=Time_Switch;
    Parameter.Switch_Scaled=x(2);
    Parameter.w_IDP_Refugee=10.^x(3);
    Parameter.w_IDP=x(4);
    Parameter.day_W=day_W_fix;
    
    Parameter.Female_w=x(5);
    Parameter.Male_w=x(6);
    Parameter.Age=[x(7) x(7) x(7) x(7) x(8) x(8) x(9) x(9) x(10) x(10) x(11).*ones(1,7)];
    
    STDEV_Displace.Refugee=10.^x(12);
    STDEV_Displace.IDP=10.^x(13);
end