function P=Kernel_Function(d,Parameter)

    P=Parameter.Scale.*normpdf(d,0,Parameter.Breadth)./normpdf(0,0,Parameter.Breadth);

end