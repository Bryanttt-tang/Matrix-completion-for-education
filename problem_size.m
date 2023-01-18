clear all
close all
clc
%% Problem setup (discuss dimensions)
rng(7) % for reproducibility
% Totally K concepts, K<<Q and N
Q=50; % number of questions
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
Cost_rec_binary_new_2=[]; Cost_rec_new_2=[]; 
Cost_rec_binary_new_3=[]; Cost_rec_new_3=[]; 
rPerm   = randperm(N*Q);
nSamples=round(Q*N*2/3); % observe 2/3 of the entries
observe = sort( rPerm(1:nSamples) ); % observed entries
% Need to convert observe to (i,j) element representation
store=ob_2_ij(observe,nSamples,Q);
R_z_1=[];R_z_2=[];R_z_3=[];
%% Connectivity (W1--randomly increase; W3--gradually increase)
W1=zeros(Q,K); IDX=[]; W3=zeros(Q,K); J=[];
h=waitbar(0,'please wait');
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
%    [Z_rec,Y_rec,cost_rec,cost_rec_binary]=cvx_MC(Y,Z_true,store,observe,W,M) ;
   [Z_rec_new_3,Y_rec_new_3,cost_rec_new_3,cost_rec_binary_new_3]=cvx_MC_new(Y_3,Z_true_3,store,observe,W3,M);
%   Cost_rec=[Cost_rec,cost_rec]; %cost from direct MC completion of Z_rec
%   Cost_rec_binary=[Cost_rec_binary,cost_rec_binary];
  Cost_rec_new_3=[Cost_rec_new_3,cost_rec_new_3]; %cost from direct MC completion of Z_rec
  Cost_rec_binary_new_3=[Cost_rec_binary_new_3,cost_rec_binary_new_3];
  waitbar(i/Q,h)
end
end    

  %% Plot
  close all;
figure(1)
plot([1:Q*K],Cost_rec_binary_new_3)
hold on
plot([1:Q*K],Cost_rec_new_3)
grid on;
xlabel('Number of edges of bipartitie graph')
legend('error_{binary}','error')
title("Recovery error")

figure(3)
plot([1:Q*K],R_z_3); hold off
xlabel('Number of edges of bipartitie graph')
title("Rank of ground true Z matrix")

%% save file
filename = 'D:\ETHz\year 2\SP\dynamic-matrix-completion-problems\large_size_N=50';
save( filename, 'W3','Cost_rec_new_3','Cost_rec_binary_new_3','R_z_3');
example = matfile('large_size_N=50.mat');
NUM = example.W3;


