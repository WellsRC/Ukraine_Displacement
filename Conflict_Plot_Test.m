%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
%% Conflict data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
T=readtable('2022-02-15-2022-05-18-Ukraine.csv');

ET=T.sub_event_type;

tf=strcmp(ET,'Attack');

T=T(tf,:);

DT=datenum(T.event_date);

T=T(DT>=datenum('February 24, 2022'),:);

vLat_C=cell(length(Time_Sim),1);
vLon_C=cell(length(Time_Sim),1);

Date_Conflict=zeros(height(T),1);
for ii=1:length(Date_Conflict)
    Date_Conflict(ii)=datenum(T.event_date(ii));
end
