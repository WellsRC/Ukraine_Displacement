function [day_W_fix,RC,MLE_FD,MLE_Map_Ref,MLE_Map_IDP,FD_Model,Model_IDP,Model_Refugee] = Selected_Model_Parameters_MLE

L=zeros(8,1);
k=zeros(8,1);
for ii=1:8
    load(['Calibration_Kernel_Conflict_Window-Conflcit_Radius_Model=' num2str(ii) '.mat'],'fval','x0');
    L(ii)=-min(fval);
    k(ii)=length(x0(1,:));
end
aics=aicbic(L,k);

daics=aics-min(aics);

FD_Model=find(daics==0);

load(['Calibration_Kernel_Conflict_Window-Conflcit_Radius_Model=' num2str(FD_Model) '.mat'],'day_W_fix','RC','fval');
day_W_fix=day_W_fix(fval==min(fval));
RC=RC(fval==min(fval));

load('Merge_Parameter_MLE.mat','MLE_FD','MLE_Map_Ref','MLE_Map_IDP','Model_IDP','Model_Refugee')

end

