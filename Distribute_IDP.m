function [Pop_IDP] = Distribute_IDP(Lat,Lon,Pop_Remain,Pop,Conflict,w_FB_UKR,Oblast,SCF)
    
  
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
    % Conflict
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
    
    f_no_conflict=find(Conflict<=median(Conflict(Conflict>0)));
    f_conflict=find(Conflict>median(Conflict(Conflict>0)));
    
    d_c=zeros(size(Pop_Remain));
    
    NNC=length(f_no_conflict);
    
    d_ct=zeros(length(f_no_conflict),1);
    parfor ii=1:NNC
        d_ct(ii)=min(deg2km(distance('gc',Lat(f_conflict),Lon(f_conflict),Lat(f_no_conflict(ii)),Lon(f_no_conflict(ii)))));
    end
    
    d_c(f_no_conflict)=d_ct;    
    w_c=1-exp(-d_c);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
    % Population
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
    w_p=exp(-log10(Pop));
    w_p(Pop<1)=0;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
    % Other Weights
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
    
    Conflict=SCF.*Conflict;   
    
    Pop_IDP=Pop_Remain.*(1-Conflict); % The people that remain
    
    Pop_Move=Pop_Remain.*Conflict;    
    
    f_conflict=find(Pop_Move>0);
    
    for ii=1:length(f_conflict)
        w_d=deg2km(distance('gc',Lat(f_conflict(ii)),Lon(f_conflict(ii)),Lat,Lon));
        w_d=exp(-w_d);
        
        w_sc=w_FB_UKR(Oblast(f_conflict(ii)),Oblast)';   
                
        
        w=w_d.*w_sc.*w_c.*w_p;
        
        w=w./sum(w);
        Pop_IDP=Pop_IDP+w.*Pop_Move(f_conflict(ii));
    end

end

