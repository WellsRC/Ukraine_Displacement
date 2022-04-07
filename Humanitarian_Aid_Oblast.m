clear;

S1=shaperead('UKR_ADM_1\UKR_adm1.shp','UseGeoCoords',true);

Num_Org=readtable('Data_ Ukraine 3W Round 4 2022-03-31.xlsx','Sheet','Num_of_Orgs_by_Oblast');
Reached=readtable('Data_ Ukraine 3W Round 4 2022-03-31.xlsx','Sheet','People_Reached_by_Oblast');


T=zeros(length(S1),2);

for ii=1:length(S1)
    tf=strcmp(Num_Org.HASC_1,S1(ii).HASC_1);
    if(sum(tf)>0)
        T(ii,1)=Num_Org.Health(tf);
    end
    
    
    tf=strcmp(Reached.HASC_1,S1(ii).HASC_1);
    if(sum(tf)>0)
        T(ii,2)=Reached.Health(tf);
    end
end

Z=T(:,2)./T(:,1);
Z(T(:,1)==0)=NaN;


Z=(Z-min(Z(~isnan(Z))))./(max(Z(~isnan(Z)))-min(Z(~isnan(Z))));

for ii=1:length(S1)
    if(~isnan(Z(ii)))
        geoshow(S1(ii),'FaceAlpha',Z(ii),'FaceColor','b'); 
    else
        geoshow(S1(ii),'FaceAlpha',1,'FaceColor',[0.1 0.1 0.1]); 
    end
end


