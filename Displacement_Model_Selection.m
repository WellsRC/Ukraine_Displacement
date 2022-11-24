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

daic=aicm-min(aicm);


Model_Type={'Location','Location and Age','Location and Gender','Location and Socio-economic status','Location, Age, and Gender','Location, Age, and Socio-economic status','Location, Gender, and Socio-economic status','Location, Age, Gender, and Socio-economic status'}';

T=table(Model_Type,L,k,daic);