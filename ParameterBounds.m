function [LB,UB]=ParameterBounds(Model_Num)

% Parameter.Scale=10.^x(1);
% Parameter.Breadth=RC;
% Parameter.Switch=Time_Switch;
% Parameter.Switch_Scaled=x(2);
% Parameter.w_IDP_Refugee=10.^x(3);
% Parameter.w_IDP=x(4);
% Parameter.day_W=day_W_fix;
% 
% Parameter.Female_w=x(5);
% Parameter.Male_w=x(6);
% Parameter.Age=[x(7) x(7) x(7) x(7) x(8) x(8) x(9) x(9) x(10) x(10) x(11).*ones(1,7)];

LB=[-3 0 -4 0.5  3 4]; 
UB=[ 0 1 -2 1  6 7];


if(Model_Num==5 || Model_Num==8) % Age and Gender
    LB=[LB zeros(1,7)];
    UB=[UB ones(1,7)];
    if(Model_Num==8)
        LB=[LB 2];
        UB=[UB 3];
    end
elseif(Model_Num==2 || Model_Num==6)        %Age
    LB=[LB zeros(1,5)];
    UB=[UB ones(1,5)];
    if(Model_Num==6)
        LB=[LB 2];
        UB=[UB 3];
    end
elseif(Model_Num==3 || Model_Num==7)   % gender
    LB=[LB zeros(1,2)];
    UB=[UB ones(1,2)];
    if(Model_Num==7)
        LB=[LB 2];
        UB=[UB 3];
    end
else        
    if(Model_Num==4)
        LB=[LB 2];
        UB=[UB 3];
    end
end
    
end