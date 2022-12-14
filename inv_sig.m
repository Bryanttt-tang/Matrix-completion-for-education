% Inverse sigmoid {0,1}->R
function Z=inv_sig(Y)
esp=1e-6; % for numerical stability
[Q,N]=size(Y);
for i =1:Q
    for j=1:N
      if Y(i,j)==0
         Y(i,j)=Y(i,j)+esp;
      else
          Y(i,j)=Y(i,j)-esp;
      end    
    end
end
     
     Z=-log(1./Y-1);
end