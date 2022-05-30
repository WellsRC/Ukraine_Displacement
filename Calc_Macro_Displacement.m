function Displacement_Macro=Calc_Macro_Displacement(Displace_Pop,Pop_MACRO)
% KYIV
tf=strcmp(Pop_MACRO,'KYIV');
Displacement_Macro.Kyiv=sum(Displace_Pop(tf,:),1);

% EAST
tf=strcmp(Pop_MACRO,'EAST');
Displacement_Macro.East=sum(Displace_Pop(tf,:),1);

% SOUTH
tf=strcmp(Pop_MACRO,'SOUTH');
Displacement_Macro.South=sum(Displace_Pop(tf,:),1);

% CENTER
tf=strcmp(Pop_MACRO,'CENTER');
Displacement_Macro.Center=sum(Displace_Pop(tf,:),1);

% NORTH
tf=strcmp(Pop_MACRO,'NORTH');
Displacement_Macro.North=sum(Displace_Pop(tf,:),1);

% WEST
tf=strcmp(Pop_MACRO,'WEST');
Displacement_Macro.West=sum(Displace_Pop(tf,:),1);
end