function dob=DistanceBorder_Polygon(Lon_P,Lat_P,S2,Raion_Index)
    dob=zeros(length(S2),1);
    for jj=1:length(S2)
       dob(jj)=min(deg2km(distance('gc',Lon_P,Lat_P,S2(jj).Lon,S2(jj).Lat)));
    end
    dob(Raion_Index)=0;
end