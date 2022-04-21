function [Pop_Adjust,Pop_Displace] = Population_Adjustment_Displacement(Pop,P,Random_Sample)
    
    % See if randomness needs to be integrated into the output
    if(~Random_Sample)
        Pop_Displace=Pop.*P;
    else
        Pop_Displace=zeros(size(Pop));
        Pt=betarnd(P(P>0 & Pop>0).*Pop(P>0 & Pop>0),(1-P(P>0 & Pop>0)).*Pop(P>0 & Pop>0));
        Pop_Displace(P>0 & Pop>0)=bnldev(Pop(P>0 & Pop>0),Pt);
    end

    Pop_Adjust=Pop-Pop_Displace;
end

