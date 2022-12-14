% Convex nuclear-norm optimization
%Input: Target matrix Z & observed entries position in (i,j) form 
%Input: & Weights in Q-by-K matrix, easiness M in Q-by-N matrix
%Output: Recovered matrix & cost=||Z-M||_F & C matrix in K-by-N
function [Z_rec,Y_rec,C,cost1,cost_binary]=cvx_MC_new(Y,Z,store,observe,W,M) 
% M is Q-by-N matrix
 K=size(W,2);
 num_sample=size(store,2);
 [Q,N]=size(Z);  
cvx_begin
    variables Z_rec(Q,N) C(K, N);%C contains info of each student_j to each concept_k   
    minimize norm_nuc(Z_rec);
    subject to

        Z_rec(observe) == Z(observe);
        for i = 1:Q
            for j=1:N
                 W(i,:)*C(:,j) == 1;
            end
        end
%         for lamda=1:num_sample
%             i=store(1,lamda); j=store(2,lamda);
%             Z(i,j) == W(i,:)*C(:,j)+M(i,1); %z_ij=w_i'*c_j+mu_i
%         end
cvx_end
% Baseline is Z_rec

Recover=W*C; % no M at the moment
Y_rec_int=sig(Recover);
Y_rec=binary_dist(Y_rec_int);

% Y_rec_int=sig(R);
% Y_rec=binary_dist(Y_rec_int);
cost1=norm(Recover-Z,'fro');
cost_binary=norm(Y_rec-Y,'fro');