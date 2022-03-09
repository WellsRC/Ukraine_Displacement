% https://www.bmj.com/content/323/7304/75.long

N=[856 779 10529 16851 4090 8006 4472 1505];
d=[3.5 4.4 5 5.3 6.1 6.9 4.5 2.0];
Ndeath=[84 153 396 262 313 193 192 46];

p=1-(1-Ndeath./N).^(1./d);

p_year=sum(p.*N./sum(N));

p_5year=1-(1-p_year)^5;
