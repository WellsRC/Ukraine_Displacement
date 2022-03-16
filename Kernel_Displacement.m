function P = Kernel_Displacement(Lat_C,Lon_C,Lat_P,Lon_P,Parameter)

d=zeros(length(Lat_P),length(Lat_C));

parfor ii=1:length(Lat_C)
    d(:,ii) = deg2km(distance('gc',Lat_C(ii),Lon_C(ii),Lat_P,Lon_P));
end

Pt=1-Kernel_Function(d,Parameter);

P=1-prod(Pt,2);

end

