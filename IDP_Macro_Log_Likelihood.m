function L=IDP_Macro_Log_Likelihood(Est_Daily_IDP,IDP_Displacement,Time_Sim,Parameter_Mapping)
L=zeros(length(Est_Daily_IDP.macro_name),1);
N=Est_Daily_IDP.macro_name;

Tot_Data=IDP_Displacement.Macro.Kyiv+IDP_Displacement.Macro.East+IDP_Displacement.Macro.West+IDP_Displacement.Macro.South+IDP_Displacement.Macro.North+IDP_Displacement.Macro.Center;
Tot_Model=zeros(size(Tot_Data'));
for ii=1:length(L)
   if(strcmp('KYIV',N{ii}))
        Data_Points=IDP_Displacement.Macro.Kyiv;
        Model_Est=Est_Daily_IDP.macro(ii,ismember(Time_Sim,datenum(IDP_Displacement.Macro.Kyiv_Date)));
        
   elseif(strcmp('EAST',N{ii}))       
        Data_Points=IDP_Displacement.Macro.East;
        Model_Est=Est_Daily_IDP.macro(ii,ismember(Time_Sim,datenum(IDP_Displacement.Macro.East_Date)));
   elseif(strcmp('WEST',N{ii}))
        Data_Points=IDP_Displacement.Macro.West;
        Model_Est=Est_Daily_IDP.macro(ii,ismember(Time_Sim,datenum(IDP_Displacement.Macro.West_Date)));
   
   elseif(strcmp('SOUTH',N{ii}))
        Data_Points=IDP_Displacement.Macro.South;
        Model_Est=Est_Daily_IDP.macro(ii,ismember(Time_Sim,datenum(IDP_Displacement.Macro.South_Date)));

   elseif(strcmp('NORTH',N{ii}))
        Data_Points=IDP_Displacement.Macro.North;
        Model_Est=Est_Daily_IDP.macro(ii,ismember(Time_Sim,datenum(IDP_Displacement.Macro.North_Date)));

   elseif(strcmp('CENTER',N{ii}))
        Data_Points=IDP_Displacement.Macro.Center;
        Model_Est=Est_Daily_IDP.macro(ii,ismember(Time_Sim,datenum(IDP_Displacement.Macro.Center_Date)));
       
   end
   Tot_Model=Tot_Model+Model_Est;
end

for ii=1:length(L)
   if(strcmp('KYIV',N{ii}))
        Data_Points=IDP_Displacement.Macro.Kyiv;
        Model_Est=Est_Daily_IDP.macro(ii,ismember(Time_Sim,datenum(IDP_Displacement.Macro.Kyiv_Date)));
        
   elseif(strcmp('EAST',N{ii}))       
        Data_Points=IDP_Displacement.Macro.East;
        Model_Est=Est_Daily_IDP.macro(ii,ismember(Time_Sim,datenum(IDP_Displacement.Macro.East_Date)));
   elseif(strcmp('WEST',N{ii}))
        Data_Points=IDP_Displacement.Macro.West;
        Model_Est=Est_Daily_IDP.macro(ii,ismember(Time_Sim,datenum(IDP_Displacement.Macro.West_Date)));
   
   elseif(strcmp('SOUTH',N{ii}))
        Data_Points=IDP_Displacement.Macro.South;
        Model_Est=Est_Daily_IDP.macro(ii,ismember(Time_Sim,datenum(IDP_Displacement.Macro.South_Date)));

   elseif(strcmp('NORTH',N{ii}))
        Data_Points=IDP_Displacement.Macro.North;
        Model_Est=Est_Daily_IDP.macro(ii,ismember(Time_Sim,datenum(IDP_Displacement.Macro.North_Date)));

   elseif(strcmp('CENTER',N{ii}))
        Data_Points=IDP_Displacement.Macro.Center;
        Model_Est=Est_Daily_IDP.macro(ii,ismember(Time_Sim,datenum(IDP_Displacement.Macro.Center_Date)));
       
   end
   if(~strcmp('N/A',N{ii}))
        L(ii)=sum(log(normpdf((Tot_Model(:).*Data_Points(:)./Tot_Data(:)),(Model_Est(:)),Parameter_Mapping.STDEV_MACRO)));
   end 
end
end