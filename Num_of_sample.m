clear all
close all
clc
%% Problem setup (Sparse Markov chain transition matrix)
rng(7) % for reproducibility
% Totally K concepts, K<<Q and N
Q=7; % number of questions
N=6; % number of students ---- Q-by- N matrix
K=3; % number of concepts
% Z = -5 + (5+5)*rand(Q,N); % uniform distributed [-5,5]
% Y_int=sig(Z); % we want to recover matrix Z, and then ground true matrix Y
  z1=rand(Q,3); z2=-5+(5+5)*rand(3,N); Z=z1*z2;
Y_int=sig(Z);
%  Y_int=rand(Q,N);
%  Z=inv_sig(Y_int)
 Y=binary_dist(Y_int); % ground true binary matrix


mu_e=0.5; mu_m=0.25; mu_h=-0.2;  % easiness of the question i
Mu_e=repelem(mu_e,N);Mu_m=repelem(mu_m,N);Mu_h=repelem(mu_h,N);
M_int=[Mu_e;Mu_e;Mu_m;Mu_m;Mu_m;Mu_h;Mu_h]; %2 easy, 3 medium, 2 hard
M = M_int(randperm(size(M_int, 1)), :); % shuffle the rows
W=rand(Q,K);% w_i (R^K), weights of question_i to concept_k, assume W to be
W=W./sum(W,2);  % row-stochastic
Cost_binary=[]; Cost1=[]; rPerm   = randperm(N*Q);
for nSamples=1:Q*N
    observe = sort( rPerm(1:nSamples) ); % observed entries
% Need to convert observe to (i,j) element representation
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
    [R,Y_rec,cost1,cost_binary]=cvx_MC_new(Y,Z,store,observe,W,M) ;
    Cost1=[Cost1,cost1];
  Cost_binary=[Cost_binary,cost_binary];
  
  
end
plot([1:Q*N],Cost_binary)
hold on;
plot([1:Q*N],Cost1)
grid on;
legend('Cost_{binary}','Cost1')

% [Recover,C,Y_rec,cost_binary]=cvx_MC(Y,Z,store,W,M) ;

% for nSamples=1:Q*N
%   observe   = sort( rPerm(1:nSamples) ); % the place of observed entries
%   [Z1,cost1]=cvx_MC(M1,observe);
%   Cost1=[Cost1,cost1];
% end