clear all
close all
clc
%% Problem setup (Sparse Markov chain transition matrix)
rng(7) % for reproducibility
% Totally K concepts, K<<Q and N
Q=7; % number of questions
N=6; % number of students ---- Q-by- N matrix
K=3; % number of concepts


mu_e=3; mu_m=0.5; mu_h=-1;  % easiness of the question i
Mu_e=repelem(mu_e,N);Mu_m=repelem(mu_m,N);Mu_h=repelem(mu_h,N);
M_int=[Mu_e;Mu_e;Mu_m;Mu_m;Mu_m;Mu_h;Mu_h]; %2 easy, 3 medium, 2 hard
M = M_int(randperm(size(M_int, 1)), :); % shuffle the rows

W=rand(Q,K);% w_i (R^K), weights of question_i to concept_k, assume W to be
s2zero=randperm(Q*K); n_zero=10; zero_entry=sort( s2zero(1:n_zero) );
W(zero_entry)=0; % W is sparese matrix
for i=1:size(W,1)
   if sum(W(i,:))==0
       W(i,1)=0.5; W(i,end)=0.5; % No all-zero row
   end
end
W=W./sum(W,2);  % normalize to row-stochastic
%Assume we know ground true W,C,M
C_true=-20+(20+20)*rand(K,N);
Z_true=W*C_true+M;

% z1=rand(Q,3); z2=-5+(5+5)*rand(3,N); Z=z1*z2;
% Y_int=sig(Z);
Y_int=sig(Z_true);
Y=binary_dist(Y_int); % ground true binary matrix


Cost_rec_binary=[]; Cost_rec=[]; 
Cost_wc_binary=[]; Cost_wc=[]; 
rPerm   = randperm(N*Q);
for nSamples=1:Q*N
observe = sort( rPerm(1:nSamples) ); % observed entries
% Need to convert observe to (i,j) element representation
store=ob_2_ij(observe,nSamples,Q);
    [Z_rec,Recover,Y_rec,Y_wc,C,cost_rec,cost_rec_binary,cost_wc,cost_wc_binary]=cvx_MC(Y,Z_true,store,observe,W,M) ;
    
  Cost_rec=[Cost_rec,cost_rec]; %cost from direct MC completion of Z_rec
  Cost_rec_binary=[Cost_rec_binary,cost_rec_binary];
  
   Cost_wc=[Cost_wc,cost_wc]; %cost from Z=WC+M
  Cost_wc_binary=[Cost_wc_binary,cost_wc_binary];
end
%nSamples=35;
%observe = sort( rPerm(1:nSamples) ); % observed entries
% Need to convert observe to (i,j) element representation
% store=ob_2_ij(observe,nSamples,Q);
%     [Z_rec,Recover,Y_rec,Y_wc,C,cost_rec,cost_rec_binary,cost_wc,cost_wc_binary]=cvx_MC(Y,Z_true,store,observe,W,M) ;
%     
%   Cost_rec=[Cost_rec,cost_rec]; %cost from direct MC completion of Z_rec
%   Cost_rec_binary=[Cost_rec_binary,cost_rec_binary];
  
figure(1)
plot([1:Q*N],Cost_rec_binary)
hold on;
plot([1:Q*N],Cost_rec)
grid on;
legend('Cost_{binary}','Cost_{rec}')
title("Use direct MC of Z_{rec}")

figure(2)
plot([1:Q*N],Cost_wc_binary)
hold on;
plot([1:Q*N],Cost_wc)
grid on;
legend('Cost_{wc,binary}','Cost_{wc}')
title("Use Z=WC+M")
%% try beta distribution (continuous bernouli distribution) shape parameters
close all
x = 0:0.01:1;
y1 = betapdf(x,0.99,3);


y2 = betapdf(x,3,0.999);

plot(x,y1)
hold on
plot(x,y2)
legend(["y1","y2"]);
hold off