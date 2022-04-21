clear;
% https://www.bmj.com/content/323/7304/75.long

N=[856 779 10529 16851 4090 8006 4472 1505];
d=[3.5 4.4 5 5.3 6.1 6.9 4.5 2.0];
Ndeath=[84 153 396 262 313 193 192 46];

p=1-(1-Ndeath./N).^(1./d);

p_year=sum(p.*N./sum(N));

p_5year=1-(1-p_year)^5;

CVD=round(403114./p_5year)

CVD_UI=zeros(10^5,1);

w=cumsum(N./sum(N));
for ii=1:10^6
    r=rand(500,1);
    f=zeros(500,1);
    for jj=1:500
        f(jj)=find(r(jj)<=w,1);
    end
        pv=mean(p(f));
    p_5yearv=1-(1-pv)^5;
    CVD_UI(ii)=round(403114./p_5yearv);
end
