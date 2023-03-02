clear all
close all
clc
%% Problem setup (Sparse Markov chain transition matrix)
rng(77) % for reproducibility
% Totally K concepts, K<<Q and N
Q=10; % number of questions
N=50; % number of students ---- Q-by- N matrix
K=5; % number of concepts

mu_e=2; mu_m=0.5; mu_h=-1;  % easiness of the question i; M is Q-by-N matrix
num_e=round(Q/3); num_h=round(Q/4); num_m=Q-num_e-num_h;% the number of e,m,h questions
Mu_e=repmat(mu_e,num_e,1);Mu_m=repmat(mu_m,num_m,1);Mu_h=repmat(mu_h,num_h,1);
M_int=[Mu_e;Mu_m;Mu_h]; 
M_int=M_int(randperm(length(M_int))); % shuffle the rows
M=repmat(M_int,1,N);  % construct the M

W=rand(Q,K);% w_i (R^K), weights of question_i to concept_k, assume W to be
s2zero=randperm(Q*K);
%Assume we know ground true W,C,M
%C_true=sqrt(5)*rand(K,N);
C_true=-5+(5+5)*rand(K,N);
   n_zero=6; zero_entry=sort( s2zero(1:n_zero) );
   W(zero_entry)=0; % W is sparese matrix
% %     for i=1:size(W,1)
% %         if sum(W(i,:))==0
% %         W(i,1)=0.5; W(i,end)=0.5; % No all-zero row
% %         end
% %     end
% % W=W./sum(W,2);  % normalize to row-stochastic
% 
Z_true=W*C_true+M;

Y_int=sig(Z_true);
Y=binary_dist(Y_int); % ground true binary matrix
% 
% end
Cost_rec_binary=[]; Cost_rec=[]; 
Cost_rec_binary_new=[]; Cost_rec_new=[]; 
rPerm   = randperm(N*Q);
for nSamples=1:Q*N
observe = sort( rPerm(1:nSamples) ); % observed entries
% Need to convert observe to (i,j) element representation
store=ob_2_ij(observe,nSamples,Q);
 %[Z_rec,Y_rec,cost_rec,cost_rec_binary]=cvx_MC(Y,Z_true,store,observe);
[Z_rec_new,Y_rec_new,C,cost_rec_new,cost_rec_binary_new]=cvx_MC_new(Y,Z_true,store,observe,W,M);
 % Cost_rec=[Cost_rec,cost_rec]; %cost from direct MC completion of Z_rec
  % Cost_rec_binary=[Cost_rec_binary,cost_rec_binary];
   Cost_rec_new=[Cost_rec_new,cost_rec_new]; %add extra constraint Z_rec=WC+M
  Cost_rec_binary_new=[Cost_rec_binary_new,cost_rec_binary_new];
end
%%
  close all
figure(1)
plot([1:Q*N],Cost_rec_new)
hold on;
plot([1:Q*N],Cost_rec_binary_new)
grid on;
xlim([0,Q*N])
xlabel('Number of observations')
ylabel('Reconstruction Error')
legend('E_Z','E_Y')
set(gca,'FontSize',11,'FontName','Times');
f1=figure(1);
print(f1,'figure.eps')



% figure(2)
% plot([1:Q*N],Cost_rec_binary)
% hold on;
% plot([1:Q*N],Cost_rec_binary_new)
% grid on;
% xlim([0,Q*N])
% xlabel('Number of observations')
% ylabel('Reconstruction Error')
% legend('Cost_{no regularization}','Cost_{with regularization}')
% title("E_Y")
