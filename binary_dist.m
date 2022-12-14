% from [0,1] to {0,1} distribution
function Y=binary_dist(Y_int)
 [Q,N]=size(Y_int);
 Y=zeros(Q,N);
 p=0.5;
 for i=1:Q*N
     if Y_int(i)>=p
        Y(i)=1;
     else
         Y(i)=0;
     end
 end
end