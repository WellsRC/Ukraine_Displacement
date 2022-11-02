function [Parameter,STDEV_Displace]=Parameter_Return(x,RC,Time_Switch,day_W_fix,Model_Num)
    Parameter.Scale=10.^x(1);
    Parameter.Breadth=RC;
    Parameter.Switch=Time_Switch;
    Parameter.Switch_Scaled=x(2);
    Parameter.w_IDP_Refugee=10.^x(3);
    Parameter.w_IDP=x(4);
    Parameter.day_W=day_W_fix;
    
    
    STDEV_Displace.Refugee=10.^x(5);
    STDEV_Displace.IDP=10.^x(6);
    
    Parameter.SES=0;
    if(Model_Num==5 || Model_Num==8) % Age and Gender
        Parameter.Male_w=[x(7) x(7) x(7) x(7) 0 0 0 0 0 0 0 0 x(8).*ones(1,5)];
        Parameter.Female_w=[x(9) x(9) x(9) x(9) x(10) x(10) x(11) x(11) x(12) x(12) x(13).*ones(1,7)];
        if(Model_Num==8)
            Parameter.SES=10.^x(14);
        end
    elseif(Model_Num==2 || Model_Num==6)        %Age
        Parameter.Male_w=[x(7) x(7) x(7) x(7) x(8) x(8) x(9) x(9) x(10) x(10) x(11).*ones(1,7)];
        Parameter.Female_w=[x(7) x(7) x(7) x(7) x(8) x(8) x(9) x(9) x(10) x(10) x(11).*ones(1,7)];
        if(Model_Num==6)
            Parameter.SES=10.^x(12);
        end
    elseif(Model_Num==3 || Model_Num==7)   % gender
        Parameter.Male_w=x(7).*ones(1,17);
        Parameter.Female_w=x(8).*ones(1,17);
        if(Model_Num==7)
            Parameter.SES=10.^x(9);
        end
    else        
        Parameter.Male_w=ones(1,17);
        Parameter.Female_w=ones(1,17);
        if(Model_Num==4)
            Parameter.SES=10.^x(7);
        end
    end
    
    
end