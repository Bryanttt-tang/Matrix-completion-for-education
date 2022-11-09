clear all
clc
%% Problem setup (Sparse Markov chain transition matrix)
N   = 6;       % the matrix is N x N
% M=mcmix(N,Zeros=5).P;   % randomly generated non-sparse matrix (target matrix)
M=[0	0	0.0414	0.2914	0.6672	0;
0	0.4683	0	0.1921	0	0.3397;
0.3072	0.455	0	0	0	0.2378;
0.3214	0.229	0.4496	0	0	0;
0.7867	0	0	0.2133	0	0;
0	0.5297	0.1302	0	0.2507	0.0895];
% B = randi([0 1], 6,6);
% r   = 2;        % the rank of the matrix
% df  = 2*N*r - r^2;  % degrees of freedom of a N x N rank r matrix
% nSamples    = 3*df; 
rng(6)
nSamples=N^2/2; % number of observed entries
rPerm   = randperm(N^2); 
observe   = sort( rPerm(1:nSamples) ); % the place of observed entries
Y = nan(N);
Y(observe) = M(observe);
disp('The "NaN" entries represent unobserved values');
disp(Y) % Our actually observed matrix
digits(5)
vpa(5)
[Z,cost]=cvx_MC(M,observe)
disp(Z)