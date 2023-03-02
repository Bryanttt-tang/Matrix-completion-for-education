clear all
close all
clc
%% Problem setup (discuss sparsity)
rng(66) % for reproducibility
% % Totally K concepts, K<<Q and N
Q=7; % number of questions
N=6; % number of students ---- Q-by- N matrix
K=3; % number of concepts
% 
mu_e=2; mu_m=0.5; mu_h=-1;  % easiness of the question i; M is Q-by-N matrix
num_e=round(Q/4); num_h=round(Q/4); num_m=Q-num_e-num_h;% the number of e,m,h questions
Mu_e=repmat(mu_e,num_e,1);Mu_m=repmat(mu_m,num_m,1);Mu_h=repmat(mu_h,num_h,1);
M_int=[Mu_e;Mu_m;Mu_h]; 
M_int=M_int(randperm(length(M_int))); % shuffle the rows
M_true=repmat(M_int,1,N);  % construct the M


s2zero=randperm(Q*K);
%Assume we know ground true W,C,M
C_true=-5+(5+5)*rand(K,N);
Cost_rec_binary=[]; Cost_rec=[]; 
Cost_rec_binary_new_1=[]; Cost_rec_new_1=[]; 
Cost_rec_binary_new_2=[]; Cost_rec_new_2=[]; 
Cost_rec_binary_new_3=[]; Cost_rec_new_3=[]; 
% Cost_random=[];
rPerm   = randperm(N*Q);
nSamples=round(Q*N*2/3); % observe 2/3 of the entries
observe = sort( rPerm(1:nSamples) ); % observed entries
% Need to convert observe to (i,j) element representation
store=ob_2_ij(observe,nSamples,Q);

%%
W1=zeros(Q,K); IDX=[]; 
for it=1:Q*K-18
   list=find(W1==0);
   idx=list(randsample(length(list),1));
   IDX=[IDX,idx];
   W1(idx)=rand; % randomly add one more edge with random weight to the bipartite graph
end
   Z_1=W1*C_true+M_true;
   Y_int_1=sig(Z_1);
   Y_1=binary_dist(Y_int_1); % ground true binary matrix
%%
 Z=[]; C=[]; W=[]; M=[];
Z(:,:,1)=Z_1; W(:,:,1)=W1; M(:,:,1)=M_true;
% C1=cvx_impro(Z_1,store,observe,W1,M_true);
% iter=1;
% while iter<=10
%     
%    C(:,:,iter)=cvx_impro(Z(:,:,iter),store,observe,W(:,:,iter),M(:,:,iter));
%    
% [Z(:,:,iter+1),W(:,:,iter+1),M(:,:,iter+1)]=cvx_Z_hat(N, C(:,:,iter),W1,M_true);
%  iter=iter+1;
% % C2=cvx_impro(Z_hat,store,observe,W_hat,M_hat);
% % [Z_hat_2,W_hat_2,M_hat_2]=cvx_Z_hat(N,C2,W_hat,M_hat);
% end
iter=1;
C(:,:,1)=cvx_impro(Z_1,store,observe,W1,M_true);
while iter<=25
  [Z(:,:,iter),W(:,:,iter),M(:,:,iter)]=cvx_Z_hat(N,C(:,:,iter)+0.3*randn(K,N),W1,M_true);
C(:,:,iter+1)=cvx_impro(Z(:,:,iter),store,observe,W(:,:,iter),M(:,:,iter));
  iter=iter+1;
%[Z(:,:,2),W(:,:,2),M(:,:,2)]=cvx_Z_hat(N,C2,W(:,:,1),M(:,:,1));
end
%% Plot of trend of Z
for i=1:size(Z,3)
   z(i)=sum(Z(:,:,i),'all' );
   y(:,:,i)=sig(Z(:,:,i));
   Y(:,:,i)=binary_dist(y(:,:,i));
   norm_y(i)=norm(Y(:,:,i))
end
figure(1)
plot([1:size(Z,3)],z)
xlabel('Iterations')
ylabel('Sum of entries of Z')
title("Change of estimated students' performance (Z matrix)")
figure(2)
plot([1:size(Z,3)],norm_y)
xlabel('Iterations')
ylabel('Sum of entries of Y')
title("Change of estimated students' performance (Binary Y matrix)")
%% 
 Z=[]; W=[]; M=[];
  C1=cvx_impro(Z_1,store,observe,W1,M_true);
  [Z(:,:,1),W(:,:,1),M(:,:,1)]=cvx_Z_hat(N,C1,W1,M_true);
C2=cvx_impro(Z(:,:,1),store,observe,W(:,:,1),M(:,:,1));
[Z(:,:,2),W(:,:,2),M(:,:,2)]=cvx_Z_hat(N,C2,W1,M_true);

%% step 1-(1)
W1=zeros(Q,K); IDX=[]; 
for it=1:Q*K-18
   list=find(W1==0);
   idx=list(randsample(length(list),1));
   IDX=[IDX,idx];
   W1(idx)=rand; % randomly add one more edge with random weight to the bipartite graph
end
   Z_1=W1*C_true+M_true;
   Y_int_1=sig(Z_1);
   Y_1=binary_dist(Y_int_1); % ground true binary matrix
   C1=cvx_impro(Z_1,store,observe,W1,M_true);
   
  w_bound=norm(W1);
%% step 1-(2)
[Z_hat,W_hat,M_hat]=cvx_Z_hat(N,C1,W1,M_true);
%W=fmincon(@(W) objective(W,C1,M_true), rand(Q,K),[],[],[],[],zeros(Q,K),[],@(W) circlecon(W,w_bound))
%% Step 2 -(1)
C2=cvx_impro(Z_hat,store,observe,W_hat,M_hat);
%% Step 2 -(2)
[Z_hat_2,W_hat_2,M_hat_2]=cvx_Z_hat(N,C2,W_hat,M_hat);
%%
filename = 'D:\ETHz\year 2\SP\dynamic-matrix-completion-problems\large_size_C_sum';
save( filename, 'Cost_1','Cost_2','Cost_3','C_impro_1','C_impro_2','C_impro_3');
% example = matfile('100_experi_2.mat');
% NUM = example.NUM;
% figure(4)
boxplot(C_impro_1)
ylim([-80,80])

%%
function [c,ceq] = circlecon(W,w_bound)
c(1) = norm(W)-w_bound;
c(2) = sum(W(1,:)~=0)-1;
% c(3)=sum(~W(2,:))>=1;

ceq = [];
end

function fval = objective(W,C1,M)
   z=W*C1+M;
    fval =  -sum(z(:));
end