function [day_W_fix,RC,Par_FD,Par_Map_Ref,Par_Map_IDP,Model_FD,Model_IDP,Model_Refugee] = Selected_Model_Parameters_Uncertainty

L=zeros(8,1);
k=zeros(8,1);
for ii=1:8
    load(['Calibration_Kernel_Conflict_Window-Conflcit_Radius_Model=' num2str(ii) '.mat'],'fval','x0');
    L(ii)=-min(fval);
    k(ii)=length(x0(1,:));
end
aics=aicbic(L,k);

daics=aics-min(aics);

Model_FD=find(daics==0);

load(['Calibration_Kernel_Conflict_Window-Conflcit_Radius_Model=' num2str(Model_FD) '.mat'],'day_W_fix','RC');
day_W_fix=day_W_fix(fval==min(fval));
RC=RC(fval==min(fval));

load('Merge_Parameter_Uncertainty.mat','Par_FD','Par_Map_IDP','Par_Map_Ref','L_T','Model_Refugee','Model_IDP');

end

