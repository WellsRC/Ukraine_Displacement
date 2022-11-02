function P=Prob_SES(Pop_SES,Parameter_SES)

P=(exp(Parameter_SES.*Pop_SES)-1)./(exp(Parameter_SES.*Pop_SES)+1);

end