clear all
clc
%% Recovered result vs connectivity
rng(7) % for reproducibility
n   = 6;       % the matrix is n x n
% M=mcmix(7).P
M=[0 1 0 0 0 0;
   1 0 0 0 0 0;
   0 0 0 1 0 0;
   0 0 1 0 0 0;
   0 0 0 0 0 1;
   0 0 0 0 1 0];
%find the number of connected components
G = graph(M);
bins = conncomp(G);
binnodes = max(bins);
component= sprintf("Number of connected components: %d",binnodes)
  nSamples=32;
  rPerm   = randperm(n^2);
  observe   = sort( rPerm(1:nSamples) ); % the place of observed entries
  [Z,cost]=cvx_MC(M,observe);
Y = nan(n);
Y(observe) = M(observe);
disp('The "NaN" entries represent unobserved values');
disp(Y) % Our actually observed matrix
  %plot the markov chain
% mc = dtmc(M);
% graphplot(mc,'ColorNodes',true,'ColorEdges',true)
% subplot(3,1,1)
% plot([1:n^2],Cost1)
% grid on; hold on;
% p1= sprintf("Error vs number of observed entries. Size=%d,  Rank=%d ",n,r1);
% title(p1)
% subplot(3,1,2)
% plot([1:n^2],Cost2)
% grid on; hold on;
% p2= sprintf("Error vs number of observed entries. Size=%d,  Rank=%d ",n,r2);
% title(p2)
% subplot(3,1,3)
% plot([1:n^2],Cost3)
% grid on; hold on;
% p3= sprintf("Error vs number of observed entries. Size=%d,  Rank=%d ",n,r3);
% title(p3)
%  