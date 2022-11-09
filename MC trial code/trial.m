% M=mcmix(6).P;
% B = randi([0 1], 6,6);
% % B(1,3)=1;B(2,4)=1;B(4,6)=1;
% N=1000; mode='nuclear'; lambda_tol=1e-2; tol=1e-2;
% [X, ier] = MatrixCompletion(M.*B, B,N, mode, lambda_tol, tol,1);
% disp(norm(X-M,"fro"))
% sympref('FloatingPointOutput',1);
 
% rng(1); % For reproducibility
% numStates = 10;
% num_zero = 3;
% mc1 = mcmix(numStates,Zeros=num_zero)
M=[0.1093	0.1156	0.2334	0	0.3135	0.2283;
0.099	0.4675	0	0.2475	0	0.1861;
0	0.2092	0.2118	0	0	0.579;
0.0387	0.3186	0.2954	0.1661	0	0.1811;
0.2258	0.0741	0	0.2608	0.2475	0.1918;
0.2568	0	0.6413	0.0541	0.0477	0]