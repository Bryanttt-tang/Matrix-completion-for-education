%convert observe entries to (i,j) element representation
%Output: store is a 2-by-nSamples matrix; each column stores the (i,j)
%representation of the observe entries.
function store=ob_2_ij(observe,nSamples,Q)

store=zeros(2,nSamples); % store the info of (i,j) in observe
for i =1:nSamples
    r=rem(observe(i),Q);
    if r==0
    row=Q;
    col=(observe(i)-r)/Q;
    else
    row=r;
    col=(observe(i)-r)/Q+1;
    end

    store(1,i)=row;
    store(2,i)=col;
end
%%
A=rand(3);
Z_copy=zeros(3,3);
for i = 1:3
       for j=1:3
              Z_copy(i,j) = A(i,j);
       end
  end