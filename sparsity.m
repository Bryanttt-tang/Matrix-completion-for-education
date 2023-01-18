clear all
close all
clc
%% Problem setup (discuss sparsity)
% rng(11) % for reproducibility
% % Totally K concepts, K<<Q and N
Q=10; % number of questions
N=100; % number of students ---- Q-by- N matrix
K=5; % number of concepts
% 
% 
% mu_e=2; mu_m=0.5; mu_h=-1;  % easiness of the question i
% Mu_e=repelem(mu_e,N);Mu_m=repelem(mu_m,N);Mu_h=repelem(mu_h,N);
% M_int=[Mu_e;Mu_e;Mu_m;Mu_m;Mu_m;Mu_h;Mu_h]; %2 easy, 3 medium, 2 hard
% M = M_int(randperm(size(M_int, 1)), :); % shuffle the rows
% 
% s2zero=randperm(Q*K);
% %Assume we know ground true W,C,M
% C_true=-5+(5+5)*rand(K,N);
% Cost_rec_binary=[]; Cost_rec=[]; 
% Cost_rec_binary_new_1=[]; Cost_rec_new_1=[]; 
% Cost_rec_binary_new_2=[]; Cost_rec_new_2=[]; 
% Cost_rec_binary_new_3=[]; Cost_rec_new_3=[]; 
% % Cost_random=[];
% rPerm   = randperm(N*Q);
% nSamples=round(Q*N*2/3); % observe 2/3 of the entries
% observe = sort( rPerm(1:nSamples) ); % observed entries
% % Need to convert observe to (i,j) element representation
% store=ob_2_ij(observe,nSamples,Q);
% R_z_1=[];R_z_2=[];R_z_3=[];
%% Connectivity (W1--randomly increase; W3--gradually increase)
Cost_1=[]; Cost_2=[];Cost_3=[];
parfor trial=1:25
    rng(trial) % for reproducibility
% Totally K concepts, K<<Q and N


mu_e=2; mu_m=0.5; mu_h=-1;  % easiness of the question i
mu_e=2; mu_m=0.5; mu_h=-1;  % easiness of the question i; M is Q-by-N matrix
num_e=round(Q/4); num_h=round(Q/4); num_m=Q-num_e-num_h;% the number of e,m,h questions
Mu_e=repmat(mu_e,num_e,1);Mu_m=repmat(mu_m,num_m,1);Mu_h=repmat(mu_h,num_h,1);
M_int=[Mu_e;Mu_m;Mu_h]; 
M_int=M_int(randperm(length(M_int))); % shuffle the rows
M=repmat(M_int,1,N);  % construct the M

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
R_z_1=[];R_z_2=[];R_z_3=[];
W1=zeros(Q,K); IDX=[]; W3=zeros(Q,K); J=[]; 
for it=1:Q*K
   list=find(W1==0);
   idx=list(randsample(length(list),1));
   IDX=[IDX,idx];
   W1(idx)=rand; % randomly add one more edge with random weight to the bipartite graph
   Z_true_1=W1*C_true+M;
   r_z_1=rank(Z_true_1);
   R_z_1=[R_z_1,r_z_1];
   Y_int_1=sig(Z_true_1);
   Y_1=binary_dist(Y_int_1); % ground true binary matrix
%    [Z_rec,Y_rec,cost_rec,cost_rec_binary]=cvx_MC(Y,Z_true,store,observe,W,M) ;
   [Z_rec_new_1,Y_rec_new_1,cost_rec_new_1,cost_rec_binary_new_1]=cvx_MC_new(Y_1,Z_true_1,store,observe,W1,M);
%   Cost_rec=[Cost_rec,cost_rec]; %cost from direct MC completion of Z_rec
%   Cost_rec_binary=[Cost_rec_binary,cost_rec_binary];
  Cost_rec_new_1=[Cost_rec_new_1,cost_rec_new_1]; %cost from direct MC completion of Z_rec
  Cost_rec_binary_new_1=[Cost_rec_binary_new_1,cost_rec_binary_new_1];
end
    
while find(W3==0)
for i=1:Q
    
   list_3=find(W3(i,:)==0); 
   j=list_3(randsample(length(list_3),1));
   J=[J,j];
   W3(i,j)=rand;
   Z_true_3=W3*C_true+M;
   r_z_3=rank(Z_true_3);
   R_z_3=[R_z_3,r_z_3];
   Y_int_3=sig(Z_true_3);
   Y_3=binary_dist(Y_int_3); % ground true binary matrix
%    Y_int_rand=sig(Z_rand);
%    Y_rand=binary_dist(Y_int_rand);
%    [Z_rec,Y_rec,cost_rec,cost_rec_binary]=cvx_MC(Y,Z_true,store,observe,W,M) ;
   [Z_rec_new_3,Y_rec_new_3,cost_rec_new_3,cost_rec_binary_new_3]=cvx_MC_new(Y_3,Z_true_3,store,observe,W3,M);
% 
%  [Z_rec,Y_rec,cost_rec,cost_rec_binary]=cvx_MC(Y_rand,Z_rand,store,observe);
%  Cost_random=[Cost_random,cost_rec_binary];
%   Cost_rec=[Cost_rec,cost_rec]; %cost from direct MC completion of Z_rec
%   Cost_rec_binary=[Cost_rec_binary,cost_rec_binary];
  Cost_rec_new_3=[Cost_rec_new_3,cost_rec_new_3]; %cost from direct MC completion of Z_rec
  Cost_rec_binary_new_3=[Cost_rec_binary_new_3,cost_rec_binary_new_3];
end
end    

% Naively increase edges
for s=1:Q*K % increase the number of edges (sparsity)
   W2=rand(Q,K);% w_i (R^K), weights of question_i to concept_k, assume W to be
   n_zero=Q*K-s; zero_entry=sort( s2zero(1:n_zero) );
   W2(zero_entry)=0; % W is sparese matrix
%     for i=1:size(W,1)
%         if sum(W(i,:))==0
%         W(i,1)=0.5; W(i,end)=0.5; % No all-zero row
%         end
%     end
% W=W./sum(W,2);  % normalize to row-stochastic

Z_true_2=W2*C_true+M;
r_z_2=rank(Z_true_2);1
   R_z_2=[R_z_2,r_z_2];
Y_int_2=sig(Z_true_2);
Y_2=binary_dist(Y_int_2); % ground true binary matrix


%     [Z_rec,Recover,Y_rec,Y_wc,C,cost_rec,cost_rec_binary,cost_wc,cost_wc_binary]=cvx_MC(Y,Z_true,store,observe,W,M) ;

% [Z_rec,Y_rec,cost_rec,cost_rec_binary]=cvx_MC(Y,Z_true,store,observe,W,M);
[Z_rec_new_2,Y_rec_new_2,cost_rec_new_2,cost_rec_binary_new_2]=cvx_MC_new(Y_2,Z_true_2,store,observe,W2,M);
%   Cost_rec=[Cost_rec,cost_rec]; %cost from direct MC completion of Z_rec
%   Cost_rec_binary=[Cost_rec_binary,cost_rec_binary];
   Cost_rec_new_2=[Cost_rec_new_2,cost_rec_new_2]; %add extra constraint Z_rec=WC+M
  Cost_rec_binary_new_2=[Cost_rec_binary_new_2,cost_rec_binary_new_2];
end
Cost_1=[Cost_1;Cost_rec_binary_new_1];
Cost_2=[Cost_2;Cost_rec_binary_new_2];
Cost_3=[Cost_3;Cost_rec_binary_new_3];
end
  %% Plot
  close all;
% figure(1)
% for i=1:size(Cost_1,1)
% plot([1:Q*K],Cost_1(i,:))
% hold on;
% end
% xlabel('Number of edges of bipartitie graph')
% % legend('method_{1}','method_{2}','method_{3}')
% title("Recovery error, Method 1")
% 
% figure(2)
% for i=1:size(Cost_2,1)
% plot([1:Q*K],Cost_2(i,:))
% hold on;
% end
% xlabel('Number of edges of bipartitie graph')
% % legend('method_{1}','method_{2}','method_{3}')
% title("Recovery error, Method 2")
% 
% figure(3)
% for i=1:size(Cost_3,1)
% plot([1:Q*K],Cost_3(i,:))
% hold on;
% end
% xlabel('Number of edges of bipartitie graph')
% % legend('method_{1}','method_{2}','method_{3}')
% title("Recovery error, Method 3")
figure(1)
subplot(3,1,1)
boxplot(Cost_1)
xlabel('Number of edges of bipartitie graph')
ylabel('Error')
title('Method 1')

subplot(3,1,2)
boxplot(Cost_2)
xlabel('Number of edges of bipartitie graph')
ylabel('Error')
title('Method 2')

subplot(3,1,3)
boxplot(Cost_3)
xlabel('Number of edges of bipartitie graph')
ylabel('Error')
title('Method 3')
sgtitle('Recovery error, 25 experiments')

% boxplot(Cost_1)
% xlabel('Number of edges of bipartitie graph')
% ylabel('Error')
% title('15 experiments')
% figure(2)
% plot([1:Q*K],Cost_rec_binary)
% hold on;
% plot([1:Q*K],Cost_rec_binary_new)
% grid on;
% legend('Cost','Cost_{adding Z=WC+M}')
% xlabel('Number of edges of bipartitie graph')
% title("Comparison between adding Z=W*C+M or not")

% figure(3)
% plot([1:Q*K],R_z_1); hold on;
% plot([1:Q*K],R_z_2); hold on;
% plot([1:Q*K],R_z_3); hold off
% xlabel('Number of edges of bipartitie graph')
% legend('method_{1}','method_{2}','method_{3}')
% title("Rank of ground true Z matrix")
%%
filename = 'D:\ETHz\year 2\SP\dynamic-matrix-completion-problems\25_experi_N=100,Q=10';
save( filename, 'Cost_1','Cost_2','Cost_3');
% example = matfile('100_experi_2.mat');
% NUM = example.NUM;
% figure(4)
% boxplot(NUM)
% xlabel('Number of edges of bipartitie graph')
% ylabel('Number of entries to be observed')
% title('100 experiments')