% Convex nuclear-norm optimization
%Input: Target matrix Z & observed entries position in (i,j) form 
%Input: & Weights in Q-by-K matrix, easiness M in Q-by-N matrix
%Output: Recovered matrix & cost=||Z-M||_F & C matrix in K-by-N
function [Z_hat,W_hat,M_hat]=cvx_Z_hat(N,C,W,M) 
% M is Q-by-N matrix
  [Q,K]=size(W);
 %[Q,N]=size(Z);  
 w_bound=norm(W);
 m_bound=norm(M);
 conne=zeros(Q,1);
cvx_begin
    variable Z_hat(Q,N); 
    variable W_hat(Q,K) Nonnegative;
    variable M_hat(Q,N);
    %variable C(K, N);%C contains info of each student_j to each concept_k   
    maximize sum(Z_hat(:));
    subject to

        Z_hat == W_hat*C+M_hat;
        norm(W_hat)<= w_bound;
        norm(M_hat) <= m_bound;
        norm_nuc(W_hat)<=2;
        sum(M_hat,2)== N*M_hat(:,1);
        % number of non-zero in each row of W, l1 norm relaxation
        for i=1:Q
            norm(W_hat(i,:),1)<=1.5;
            %norm(W_hat(i,:),1)>=1;
        end
cvx_end
