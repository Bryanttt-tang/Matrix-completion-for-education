clear all
close all
clc
%%
% Totally K concepts, K<<Q and N
Q=10; % number of questions
N=50; % number of students ---- Q-by- N matrix
K=5; % number of concepts
%% Problem setup (discuss sparsity)
NUM=[];
parfor exper=1:25
rng(exper) % for reproducibility

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
rPerm   = randperm(N*Q);
%nSamples=round(Q*N*2/3); % observe 2/3 of the entries
R_z_1=[];R_z_2=[];R_z_3=[];

W3=zeros(Q,K); J=[]; N_sam=[];
while find(W3==0)
for i=1:Q
    
   list_3=find(W3(i,:)==0); 
   j=list_3(randsample(length(list_3),1));
   J=[J,j];
   W3(i,j)=rand;
   Z_true_3=W3*C_true+M;
%    r_z_3=rank(Z_true_3);
%    R_z_3=[R_z_3,r_z_3];
   Y_int_3=sig(Z_true_3);
   Y_3=binary_dist(Y_int_3); % ground true binary matrix
 for nSamples=1:Q*N
 observe = sort( rPerm(1:nSamples) ); % observed entries
 % Need to convert observe to (i,j) element representation
  store=ob_2_ij(observe,nSamples,Q);
   [Z_rec_new_3,Y_rec_new_3,cost_rec_new_3,cost_rec_binary_new_3]=cvx_MC_new(Y_3,Z_true_3,store,observe,W3,M);
   if cost_rec_binary_new_3 <=1e-6
       break
   end
 end
 N_sam=[N_sam,nSamples];
end
end    

NUM(exper,:)=N_sam;
end
  %% Plot
  close all;
figure(1)
plot([1:Q*K],N_sam)
grid on
xlabel('Number of edges of bipartitie graph')
ylabel('Number of entries to be observed')
xlim([1 Q*K])
title("Recovery error")
%% save file
filename = 'D:\ETHz\year 2\SP\dynamic-matrix-completion-problems\25_experi_observations';
save( filename, 'NUM' );
example = matfile('25_experi_observations.mat');
NUM = example.NUM;
% figure(4)
% boxplot(NUM)
% xlabel('Number of edges of bipartitie graph')
% ylabel('Number of entries to be observed')
% title('25 experiments')