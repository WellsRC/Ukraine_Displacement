function [Pop_Adjust,Pop_Displace] = Population_Adjustment_Displacement(Pop,P,Random_Sample)
    
    % See if randomness needs to be integrated into the output
    if(~Random_Sample)
        Pop_Displace=Pop.*P;
    else
        Pop_Displace=binornd(round(Pop),P);
    end

    Pop_Adjust=Pop-Pop_Displace;
end

