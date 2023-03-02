clear all
close all
clc
%%
% Totally K concepts, K<<Q and N
Q=10; % number of questions
N=50; % number of students ---- Q-by- N matrix
K=5; % number of concepts

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
rPerm   = randperm(N*Q);

nSamples=round(2/3*Q*N);
 observe = sort( rPerm(1:nSamples) ); % observed entries
 % Need to convert observe to (i,j) element representation
  store=ob_2_ij(observe,nSamples,Q);
  W3=rand(Q,K);
     n_zero=Q*K/2; zero_entry=sort( s2zero(1:n_zero) );
   W3(zero_entry)=0;
    Z_true_3=W3*C_true+M;
   Y_int_3=sig(Z_true_3);
   Y_3=binary_dist(Y_int_3); % ground true binary matrix
   % at j-th year
 [Z_rec_new_3,Y_rec_new_3,C,cost_rec_new_3,cost_rec_binary_new_3]=cvx_MC_new(Y_3,Z_true_3,store,observe,W3,M);
 % improve at j+1 year
  list_3=find(W3(:)==0); 
   j=list_3(randsample(length(list_3),1));

   W3(i,j)=rand;

%% save file
% filename = 'D:\ETHz\year 2\SP\dynamic-matrix-completion-problems\25_experi_N=50,Q=10,K=5';
% save( filename, 'NUM' );
example = matfile('25_experi_N=50,Q=10,K=5.mat');
NUM = example.NUM;
figure(4)
boxplot(NUM)
xlabel('Number of edges of bipartitie graph')
ylabel('Number of entries to be observed')
title('25 experiments')

%%
a= [1 2 4 6; 5 8 6 3;4 7 9 1] ;
[m,n] = size(a) ;
idx = randperm(n) ;
b = a ;
b(1,idx) = a(1,:)  % first row arranged randomly