% M=mcmix(6).P;
% B = randi([0 1], 6,6);
% % B(1,3)=1;B(2,4)=1;B(4,6)=1;
% N=1000; mode='nuclear'; lambda_tol=1e-2; tol=1e-2;
% [X, ier] = MatrixCompletion(M.*B, B,N, mode, lambda_tol, tol,1);
% disp(norm(X-M,"fro"))
% sympref('FloatingPointOutput',1);
 
rng(1); % For reproducibility
numStates = 10;
mc1 = mcmix(numStates,'Zeros',10)
mc1.P