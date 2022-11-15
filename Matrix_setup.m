clear all
clc
%% Problem setup (Sparse Markov chain transition matrix)
rng(7) % for reproducibility
n   = 7;       % the matrix is n x n
r1=2; r2 = 3; r3=4;     % the rank of the matrix
% df  = 2*N*r - r^2;  % degrees of freedom of a N x N rank r matrix
% nSamples    = 3*df; 
m1=rand(n,r1);M1=m1*m1'; m2=rand(n,r2); M2=m2*m2'; m3=rand(n,r3); M3=m3*m3';% create n-by-n matrix with rank r
% assert some entries to be zero
s2zero=randperm(n^2); n_zero=35; zero_entry=sort( s2zero(1:n_zero) );
M1(1:10)=0;M1(21:25)=0; M1(30:37)=0;M2(zero_entry)=1e-3*rand(n_zero,1);M3(zero_entry)=1e-3*rand(n_zero,1);
M1=M1./sum(M1,2); M2=M2./sum(M2,2); M3=M3./sum(M3,2);% normalize to row-stochastic
%plot the error wrt the number of observed entries
rPerm   = randperm(n^2);

% nsamples=n^2*(3/5);
% observe   = sort( rPerm(1:nSamples) ); % the place of observed entries
% [Z,cost]=cvx_MC(M,observe);

Cost1=[];Cost2=[];Cost3=[];
for nSamples=1:n^2
  observe   = sort( rPerm(1:nSamples) ); % the place of observed entries
  [Z1,cost1]=cvx_MC(M1,observe);[Z2,cost2]=cvx_MC(M2,observe);[Z3,cost3]=cvx_MC(M3,observe);
  Cost1=[Cost1,cost1];Cost2=[Cost2,cost2];Cost3=[Cost3,cost3];
end
subplot(3,1,1)
plot([1:n^2],Cost1)
grid on; hold on;
p1= sprintf("Error vs number of observed entries. Size=%d,  Rank=%d ",n,r1);
title(p1)
subplot(3,1,2)
plot([1:n^2],Cost2)
grid on; hold on;
p2= sprintf("Error vs number of observed entries. Size=%d,  Rank=%d ",n,r2);
title(p2)
subplot(3,1,3)
plot([1:n^2],Cost3)
grid on; hold on;
p3= sprintf("Error vs number of observed entries. Size=%d,  Rank=%d ",n,r3);
title(p3)
 
% d= sprintf("Observed entries rplog(p)=",n*r1*log(n));
% disp(d);

% Y = nan(n);
% Y(observe) = M(observe);
% disp('The "NaN" entries represent unobserved values');
% disp(Y) % Our actually observed matrix
% digits(5)
% vpa(5)
