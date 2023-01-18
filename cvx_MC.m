% Convex nuclear-norm optimization
%Input: Target matrix Z & observed entries position in (i,j) form 
%Input: & Weights in Q-by-K matrix, easiness M in Q-by-N matrix
%Output: Recovered matrix & cost=||Z-M||_F & C matrix in K-by-N
function [Z_rec,Y_rec,cost_rec,cost_rec_binary]=cvx_MC(Y,Z,store,observe) 
% M is Q-by-N matrix
%  K=size(W,2);
 num_sample=size(store,2);
 [Q,N]=size(Z);  
cvx_begin
    variable Z_rec(Q,N); 
    %variable C(K, N);%C contains info of each student_j to each concept_k   
    minimize norm_nuc(Z_rec);
    subject to

        Z_rec(observe) == Z(observe);
     %     Z_rec==W*C+M;
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


% Recover=W*C+M; % no M at the moment
Y_rec_int=sig(Z_rec);
Y_rec=binary_dist(Y_rec_int);

%Cost using direct MC of Z_rec
cost_rec=norm(Z_rec-Z,'fro')/norm(Z,'fro');
cost_rec_binary=norm(Y_rec-Y,'fro')/norm(Y,'fro');
%Cost consider equality Z=WC+M
% cost_wc=norm(Recover-Z,'fro');
% Y_wc_int=sig(Recover);
% Y_wc=binary_dist(Y_wc_int);
% cost_wc_binary=norm(Y_wc-Y,'fro');