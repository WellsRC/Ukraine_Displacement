clear;
p=0.57;
b=fminbnd(@(x)sum((betainv([0.025 0.975],p*x./(1-p),x)-[0.46 0.72]).^2),0,500);
betainv([0.025 0.975],p*b./(1-p),b)
a=p*b./(1-p);
s=fminbnd(@(x)sum((gaminv([0.025 0.975],260000/x,x)-[210000 330000]).^2),10^3,10^4);

HIV_ART=gamrnd(260000/s,s,10^5,1).*betarnd(a,b,10^5,1);