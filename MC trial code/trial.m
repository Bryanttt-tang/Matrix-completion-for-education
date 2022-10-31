A=[0.2 0.3 0.5;
    0.1 0.4 0.5;
    0.25 0.6 0.15];
B=[0 1 0;
    1 1 1;
    0 0 1];
N=1000; mode='nuclear'; lambda_tol=1e-6; tol=1e-2;
[CompletedMat, ier] = MatrixCompletion(A.*B, B,N, mode, lambda_tol, tol,1);
