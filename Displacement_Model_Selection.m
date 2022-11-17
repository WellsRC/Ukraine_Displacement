clear;
clc;

L=zeros(8,1);
k=zeros(8,1);

RCv=zeros(8,1);
Dayv=zeros(8,1);
for mm=1:8
    load(['Calibration_Kernel_Conflict_Window-Conflcit_Radius_Model=' num2str(mm) '.mat']);
    L(mm)=-min(fval);
    k(mm)=length(x0(1,:));
    Dayv(mm)=day_W_fix(min(fval)==fval);
    RCv(mm)=RC(min(fval)==fval);
end

[aicm]=aicbic(L,k);