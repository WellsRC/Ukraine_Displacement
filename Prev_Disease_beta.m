function [beta_d,prev]=Prev_Disease_beta(Disease,Random)

% % PrevNat=[49533	43904	56288;
% 19452	18503	20401;
% 260000	210000	330000;
% 146488	103206	200443;
% 2325000	2101700	2492600;
% 405693	405693	405693;
% 11305246	10382816	12317289];
% 
% bb=zeros(7,1);
% for dd=1:7
%      if(dd~=6)
%         bb(dd)=10.^fminbnd(@(x)sum(((gaminv([0.025 0.975],PrevNat(dd,1)./10.^x,10^x))-PrevNat(dd,2:3)).^2),-3,7);
%      end
% end
if(strcmp(Disease,'CVD'))    
    prev=11305246;
    x=21595.6442375322;
elseif(strcmp(Disease,'Diabetes'))
    prev=2325000;
    x=4221.19831322524;
elseif(strcmp(Disease,'Cancer'))
    prev=405693;
elseif(strcmp(Disease,'HIV'))
    prev=260000;
    x=3704.37180280571;  
elseif(strcmp(Disease,'HIV_T'))
    prev=146488;
    x=4259.60865579872;
elseif(strcmp(Disease,'TB'))
    prev=49533;
    x=203.141006818956;
elseif(strcmp(Disease,'TB_DR'))
    prev=19452;
    x=12.0466405049861;
end

if(Random)
    if(strcmp(Disease,'Cancer'))    
        prev=poissrnd(prev);
    else
        prev=gamrnd(prev./x,x);
    end
    load([Disease '_beta_weighting.mat'],'prev_v','beta_T');
    beta_d=pchip(prev_v,beta_T,prev);
else
    load([Disease '_beta_weighting.mat'],'beta_T_avg');
    beta_d=beta_T_avg;
end

end
    