clear all
clc
%% Recovered result vs connectivity
rng(15) % for reproducibility
n   = 6;       % the matrix is n x n
% M=mcmix(7).P
% M=[0 1 0 0 0 0;
%    1 0 0 0 0 0;
%    0 0 0 1 0 0;
%    0 0 1 0 0 0;
%    0 0 0 0 0 1;
%    0 0 0 0 1 0];
% A=[0 1 0 1 0 0;
%    1 0 0 0 0 0;
%    0 0 0 1 0 0;
%    1 0 1 0 0 0;
%    0 0 0 0 0 1;
%    0 0 0 0 1 0];
% %find the number of connected components
% G = graph(A);
% bins = conncomp(G);
% binnodes = max(bins);
% component= sprintf("Number of connected components: %d",binnodes)
% M=mcmix(6).P;
m1=rand(n,2);M1=m1*m1';
% s2zero=randperm(n^2); n_zero=20; zero_entry=sort( s2zero(1:n_zero) );
% M1(zero_entry)=0; 
M1=M1./sum(M1,2);
mc = dtmc(M1);
graphplot(mc,'ColorNodes',true,'LabelEdges',true,'ColorEdges',true)
  nSamples=25;
  rPerm   = randperm(n^2);
  observe   = sort( rPerm(1:nSamples) ); % the place of observed entries
  [Z,cost]=cvx_MC(M1,observe);
% Y = nan(n);
% Y(observe) = M(observe);
% disp('The "NaN" entries represent unobserved values');
% disp(Y) % Our actually observed matrix
%   %plot the markov chain
% n=7; %number of nodes
% e=9; %number of edges
% s = randi(n, e, 1);
% t = randi(n, e, 1);
% G = graph(s, t, [], n,'omitselfloops');
% plot(G)
% B=incidence(G); A=adjacency(G);
% M=A./sum(A,2);
%   nSamples=35;
%   rPerm   = randperm(n^2);
%   observe   = sort( rPerm(1:nSamples) ); % the place of observed entries
%   [Z,cost]=cvx_MC(M,observe);
% bins = conncomp(G);
% binnodes = max(bins);
% component= sprintf("Number of connected components: %d",binnodes)