clear all`
close all
clc
%% Problem setup (discuss dimensions)
Cost_rec_binary_new=[]; Cost_rec_new=[];
% Totally K concepts, K<<Q and N
Q=7; % number of questions
N=6; % number of students ---- Q-by- N matrix
K=3; % number of concepts

parfor trial=1:100
rng(trial) % for reproducibility


mu_e=2; mu_m=0.5; mu_h=-1;  % easiness of the question i; M is Q-by-N matrix
num_e=round(Q/4); num_h=round(Q/4); num_m=Q-num_e-num_h;% the number of e,m,h questions
Mu_e=repmat(mu_e,num_e,1);Mu_m=repmat(mu_m,num_m,1);Mu_h=repmat(mu_h,num_h,1);
M_int=[Mu_e;Mu_m;Mu_h]; 
M_int=M_int(randperm(length(M_int))); % shuffle the rows
M=repmat(M_int,1,N);  % construct the M

s2zero=randperm(Q*K);
%Assume we know ground true W,C,M
C_true=-5+(5+5)*rand(K,N);
% C_true=sqrt(5)*rand(K,N);
rPerm   = randperm(N*Q);
nSamples=round(Q*N*2/3); % observe 2/3 of the entries
observe = sort( rPerm(1:nSamples) ); % observed entries
% Need to convert observe to (i,j) element representation
store=ob_2_ij(observe,nSamples,Q);
W=rand(Q,K);% w_i (R^K), weights of question_i to concept_k, assume W to be
s2zero=randperm(Q*K);
%Assume we know ground true W,C,M
   n_zero=round(2*Q*K/5); zero_entry=sort( s2zero(1:n_zero) );
   W(zero_entry)=0; % W is sparese matrix
Z_true=W*C_true+M;

Y_int=sig(Z_true);
Y=binary_dist(Y_int); % ground true binary matrix

   [Z_rec_new,Y_rec_new,C1,cost_rec_new,cost_rec_binary_new]=cvx_MC_new(Y,Z_true,store,observe,W,M);
  Cost_rec_new=[Cost_rec_new,cost_rec_new]; %cost from direct MC completion of Z_rec
  Cost_rec_binary_new=[Cost_rec_binary_new,cost_rec_binary_new];

end

  %% Plot
  close all;
figure(1)
boxplot(Cost_rec_new)
xlabel('Number of edges of bipartitie graph')
legend('error_{binary}','error')
title("Recovery error")

% figure(3)
% plot([1:Q*K],R_z_3); hold off
% xlabel('Number of edges of bipartitie graph')
% title("Rank of ground true Z matrix")

%% save file
filename = 'D:\ETHz\year 2\SP\dynamic-matrix-completion-problems\small_size';
save( filename, 'Cost_rec_new','Cost_rec_binary_new');
%%
example1 = matfile('small_size.mat');
example2 = matfile('medium_size.mat');
example3 = matfile('large_3_size.mat');
example4 = matfile('large_size.mat');
example5 = matfile('large_5_size.mat');
cost1=example1.Cost_rec_new;
cost2=example2.Cost_rec_new;
cost3=example3.Cost_rec_new;
cost4=example4.Cost_rec_new;
cost5=example5.Cost_rec_new;
Cost=[cost1',cost2',cost4',cost5'];
close all
figure;
h=boxplot(Cost,'Labels',{'Small Size','Large Size','High dimensional size','Higher dimensional size'})
set(h,{'linew'},{1})
ylabel('E_Z')
set(gca,'FontSize',16,'FontName','Times');
%print(h,'figure.eps')