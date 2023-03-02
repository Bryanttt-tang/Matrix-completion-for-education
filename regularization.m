clear all
close all
clc
%% Problem setup (Sparse Markov chain transition matrix)
rng(7) % for reproducibility
% Totally K concepts, K<<Q and N
Q=7; % number of questions
N=6; % number of students ---- Q-by- N matrix
K=3; % number of concepts

mu_e=2; mu_m=0.5; mu_h=-1;  % easiness of the question i
Mu_e=repelem(mu_e,N);Mu_m=repelem(mu_m,N);Mu_h=repelem(mu_h,N);
M_int=[Mu_e;Mu_e;Mu_m;Mu_m;Mu_m;Mu_h;Mu_h]; %2 easy, 3 medium, 2 hard
M = M_int(randperm(size(M_int, 1)), :); % shuffle the rows
%W=zeros(Q,K);% w_i (R^K), weights of question_i to concept_k, assume W to be
s2zero=randperm(Q*K);
%Assume we know ground true W,C,M
C_true=-5+(5+5)*rand(K,N);
%C_true=sqrt(5)*rand(K,N);
% for s=1:Q*K % increase the number of edges (sparsity)
%    n_zero=Q*K-s; zero_entry=sort( s2zero(1:n_zero) );
%    W(zero_entry)=0; % W is sparese matrix
% %     for i=1:size(W,1)
% %         if sum(W(i,:))==0
% %         W(i,1)=0.5; W(i,end)=0.5; % No all-zero row
% %         end
% %     end
% % W=W./sum(W,2);  % normalize to row-stochastic
% 
% Z_true=W*C_true+M;
% 
% Y_int=sig(Z_true);
% Y=binary_dist(Y_int); % ground true binary matrix
% 
% end
Cost_rec_binary=[]; Cost_rec=[]; 
Cost_rec_binary_new=[]; Cost_rec_new=[]; 
rPerm   = randperm(N*Q);
nSamples=round(Q*N*3/4);
observe = sort( rPerm(1:nSamples) ); % observed entries
%Need to convert observe to (i,j) element representation
store=ob_2_ij(observe,nSamples,Q);
W=zeros(Q,K);
for it=1:Q*K
   list=find(W==0);
   idx=list(randsample(length(list),1));
   W(idx)=rand; % randomly add one more edge with random weight to the bipartite graph
   Z_true=W*C_true+M;
   Y_int=sig(Z_true);
   Y=binary_dist(Y_int); 

% observe = sort( rPerm(1:nSamples) ); % observed entries
% % Need to convert observe to (i,j) element representation
% store=ob_2_ij(observe,nSamples,Q);
 [Z_rec,Y_rec,cost_rec,cost_rec_binary]=cvx_MC(Y,Z_true,store,observe);
[Z_rec_new,Y_rec_new,C,cost_rec_new,cost_rec_binary_new]=cvx_MC_new(Y,Z_true,store,observe,W,M);
   Cost_rec=[Cost_rec,cost_rec]; %cost from direct MC completion of Z_rec
   Cost_rec_binary=[Cost_rec_binary,cost_rec_binary];
   Cost_rec_new=[Cost_rec_new,cost_rec_new]; %add extra constraint Z_rec=WC+M
  Cost_rec_binary_new=[Cost_rec_binary_new,cost_rec_binary_new];
end
%%
  close all
figure(1)
plot([1:Q*K],Cost_rec)
hold on;
plot([1:Q*K],Cost_rec_new)
grid on;
xlim([0,Q*K])
xlabel('Number of edges of bipartite graph')
ylabel('Reconstruction Error')
legend('Cost_{no regularization}','Cost_{with regularization}')
title("E_Z")
set(gca,'FontSize',11,'FontName','Times');
f1=figure(1);
print(f1,'figure.eps')

figure(2)
plot([1:Q*K],Cost_rec_binary)
hold on;
plot([1:Q*K],Cost_rec_binary_new)
grid on;
xlim([0,Q*K])
xlabel('Number of edges of bipartite graph')
ylabel('Reconstruction Error')
legend('Cost_{no regularization}','Cost_{with regularization}')
title("E_Y")
set(gca,'FontSize',11,'FontName','Times');
f2=figure(2);
print(f2,'figure.eps')
