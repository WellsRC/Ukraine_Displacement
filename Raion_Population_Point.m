function PopR=Raion_Population_Point(Pop,Pop_oblast,Pop_raion)


S2=shaperead('UKR_ADM_2\UKR_adm2.shp','UseGeoCoords',true);
Raion_S={S2.NAME_2};
Oblast_S={S2.NAME_1};

PopR=zeros(size(Pop));
for ii=1:length(Raion_S)
   tf=strcmp(Pop_raion,Raion_S{ii}) &  strcmp(Pop_oblast,Oblast_S{ii});
   for aa=1:size(Pop,3)
       for gg=1:2
            PopR(gg,tf,aa)=sum(Pop(gg,tf,aa));
       end
   end
end

end