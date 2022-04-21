function [Pop_Displace_Day,Pop_Displace]=Estimate_Displacement(Parameter,vLat_C,vLon_C,Lat_P,Lon_P,Pop,Random_Sample)

nDays=length(vLat_C);
PC=ones(length(Lat_P),1);
if(~Random_Sample)
    
    Pop_Displace=zeros(length(Lon_P),nDays);
    for jj=1:nDays
        P = Kernel_Displacement(vLat_C{jj},vLon_C{jj},Lat_P,Lon_P,Parameter);
        PC=PC.*(1-P);
        [Pop,Pop_Displace(:,jj)] = Population_Adjustment_Displacement(Pop,Parameter.w.*P+(1-Parameter.w).*Parameter.ScaleC.*(1-PC),Random_Sample); %false implies only the average is being returned
    end
    
    Pop_Displace_Day=sum(Pop_Displace,1)';
else
    ProbP=zeros(length(Lon_P),nDays);
    for jj=1:nDays
        P = Kernel_Displacement(vLat_C{jj},vLon_C{jj},Lat_P,Lon_P,Parameter);
        PC=PC.*(1-P);
        ProbP(:,jj)=Parameter.w.*P+(1-Parameter.w).*Parameter.ScaleC.*(1-PC); %false implies only the average is being returned
    end
    
       
    Pop_Displace_Day=zeros(1000,nDays);
    Pop_Displace=zeros(length(Lon_P),1000);
    parfor ns=1:1000
        Pop_Displacet=zeros(length(Lon_P),nDays);
        Popt=floor(Pop);
        r=rand(size(Popt));
        dP=Pop-Popt;
        Popt(dP>=r)=Popt(dP>=r)+1;      
        for jj=1:nDays
            [Popt,Pop_Displacet(:,jj)] = Population_Adjustment_Displacement(Popt,ProbP(:,jj),Random_Sample); %false implies only the average is being returned
        end
        Pop_Displace_Day(ns,:)=sum(Pop_Displacet,1)';
        Pop_Displace(:,ns)=sum(Pop_Displacet,2);
    end
    
end

end