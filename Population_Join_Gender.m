function Pop=Population_Join_Gender(Pop_F_Age,Pop_M_Age)

Pop=zeros(2,size(Pop_M_Age,1),size(Pop_M_Age,2));
Pop(1,:,:)=Pop_F_Age;
Pop(2,:,:)=Pop_M_Age;

end