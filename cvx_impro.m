% Convex nuclear-norm optimization
%Input: Target matrix Z & observed entries position in (i,j) form 
%Input: & Weights in Q-by-K matrix, easiness M in Q-by-N matrix
%Output: Recovered matrix & cost=||Z-M||_F & C matrix in K-by-N
function C=cvx_impro(Z,store,observe,W,M)  
 K=size(W,2);
 [Q,N]=size(Z);
cvx_begin
    variable Z_rec(Q,N); 
    variable C(K, N);%C contains info of each student_j to each concept_k   
    minimize norm_nuc(Z_rec);
    subject to

        Z_rec(observe) == Z(observe);
          Z_rec==W*C+M;
%         for i = 1:Q
%             for j=1:N
%                  W(i,:)*C(:,j) == Z(i,j);
%             end
%         end
%         for lamda=1:num_sample
%             i=store(1,lamda); j=store(2,lamda);
%             W(i,:)*C(:,j)+M(i,1)==Z(i,j); %z_ij=w_i'*c_j+mu_i
%         end
cvx_end

