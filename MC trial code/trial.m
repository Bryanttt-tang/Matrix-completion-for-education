% M=mcmix(6).P;
% B = randi([0 1], 6,6);
% % B(1,3)=1;B(2,4)=1;B(4,6)=1;
% N=1000; mode='nuclear'; lambda_tol=1e-2; tol=1e-2;
% [X, ier] = MatrixCompletion(M.*B, B,N, mode, lambda_tol, tol,1);
% disp(norm(X-M,"fro"))
% sympref('FloatingPointOutput',1);
 
% adjacencyMatrix =[0 1 1 0 1 0 1 0 1 0
%     1 0 1 0 1 0 1 0 1 0
%     1 1 0 0 1 0 1 0 1 0
%     0 0 0 0 0 0 0 1 0 0
%     1 1 1 0 0 0 1 0 1 0
%     0 0 0 0 0 0 0 0 0 1
%     1 1 1 0 1 0 0 0 1 0
%     0 0 0 1 0 0 0 0 0 1
%     1 1 1 0 1 0 1 0 0 0
%     0 0 0 0 0 1 0 1 0 0]
% G = graph(adjacencyMatrix);
% plot(G);  %view the graph
% bins = conncomp(G);
% binnodes = accumarray(bins', 1:numel(bins), [], @(v) {sort(v')});
% fprintf('number of Regions = %d\n\n', numel(binnodes));
% for binidx = 1:numel(binnodes)
%     fprintf('All these nodes are connected:%s\n', sprintf(' %d', binnodes{binidx}));
% end
% fprintf('\n');
G = digraph([1 1 1 2 3 4],[2 3 4 4 2 3],[5 6 7 8 9 10]);
G.Edges;
plot(G)
