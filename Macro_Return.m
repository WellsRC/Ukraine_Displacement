function Est_Pop=Macro_Return(Pop,Raion_Pixel,Oblast_Pixel,Shapefile_Raion_Name,Shapefile_Raion_Oblast_Name,Shapefile_Oblast_Name,Macro_Map)

% Raion level
IDP=zeros(length(Shapefile_Raion_Name),length(Pop(1,:)));

for dd=1:length(Shapefile_Raion_Name)
    tf=strcmp(Raion_Pixel,Shapefile_Raion_Name{dd}) & strcmp(Oblast_Pixel,Shapefile_Raion_Oblast_Name{dd});
    IDP(dd,:)=sum(Pop(tf,:),1);
end
Est_Pop.raion=IDP;
Est_Pop.raion_name=Shapefile_Raion_Name;


% Oblast
IDP_t=zeros(length(Shapefile_Oblast_Name),length(Pop(1,:)));
for jj=1:length(Shapefile_Oblast_Name)
    tf=strcmp(Shapefile_Oblast_Name{jj},Shapefile_Raion_Oblast_Name);
    IDP_t(jj,:)=sum(IDP(tf,:),1);
end
Est_Pop.oblast=IDP_t;
Est_Pop.oblast_name=Shapefile_Oblast_Name;
% Macro

% Macro

Pop_Est=zeros(length(unique(Macro_Map(:,3))),length(Pop(1,:)));
N_Macro=unique(Macro_Map(:,3));
N_Macro_Oblast=Macro_Map(:,3);
Macro_Region_Oblast=Macro_Map(:,2);
for jj=1:length(Pop_Est(:,1))
    tf=find(strcmp(N_Macro_Oblast,N_Macro{jj}));
    for kk=1:length(tf)
        t_oblast=strcmp(Oblast_Pixel,Macro_Region_Oblast{tf(kk)});
        Pop_Est(jj,:)=Pop_Est(jj,:)+sum(Pop(t_oblast,:),1);    
    end
end

Est_Pop.macro=Pop_Est;
Est_Pop.macro_name=N_Macro;

end