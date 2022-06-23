function Est_Pop=Macro_Return(Pop,Oblast_Pixel,Macro_Map)
% Macro

Pop_Est=zeros(length(unique(Macro_Map(:,3))),1);
N_Macro=unique(Macro_Map(:,3));
N_Macro_Oblast=Macro_Map(:,3);
Macro_Region_Oblast=Macro_Map(:,2);
for jj=1:length(Pop_Est(:,1))
    tf=find(strcmp(N_Macro_Oblast,N_Macro{jj}));
    for kk=1:length(tf)
        t_oblast=strcmp(Oblast_Pixel,Macro_Region_Oblast{tf(kk)});
        Pop_Est(jj,:)=Pop_Est(jj,:)+sum(Pop(t_oblast));    
    end
end

Est_Pop.macro=Pop_Est;
Est_Pop.macro_name=N_Macro;

end