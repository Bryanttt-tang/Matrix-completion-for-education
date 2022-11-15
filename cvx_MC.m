% Convex nuclear-norm optimization
%Input: Target matrix M & observed entries position, a vector
%Output: Recovered matrix Z & cost=||Z-M||_F
function [Z,cost]=cvx_MC(M,observe) 
 N=size(M,1);
cvx_begin
    variable Z(N, N) nonnegative%Z is the recovered matrix    
    minimize norm_nuc(Z)
    subject to
%     for i = 1:N^2
%         Z(i)>=0; % Z_ij>=0
%     end
    Z(observe)==M(observe); %Z_ij=M_ij for (i,j) in omega
    Z*ones(N,1)==ones(N,1); % row stochasticity
    
cvx_end

cost=norm(Z-M,'fro')