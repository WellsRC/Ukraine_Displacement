function Est_Daily_Refugee=Country_Refuge_Displaced(w_tot,Daily_Refugee)
% Reference for order [Data.Refugee.Poland.FB Data.Refugee.Slovakia.FB Data.Refugee.Hungary.FB Data.Refugee.Romania.FB Data.Refugee.Belarus.FB Data.Refugee.Moldova.FB Data.Refugee.Russia.FB]
for country=1:8


    switch country
        case 1
            Est_Daily_Refugee.Poland=(w_tot(:,country)')*Daily_Refugee;
        case 2
            Est_Daily_Refugee.Slovakia=(w_tot(:,country)')*Daily_Refugee;
        case 3
            Est_Daily_Refugee.Hungary=(w_tot(:,country)')*Daily_Refugee;
        case 4
            Est_Daily_Refugee.Romania=(w_tot(:,country)')*Daily_Refugee;
        case 5
            Est_Daily_Refugee.Belarus=(w_tot(:,country)')*Daily_Refugee;
        case 6
            Est_Daily_Refugee.Moldova=(w_tot(:,country)')*Daily_Refugee;
        case 7
            Est_Daily_Refugee.Russia=(w_tot(:,country)')*Daily_Refugee;
        case 8
            Est_Daily_Refugee.Europe_Other=(w_tot(:,country)')*Daily_Refugee;
    end
end
end