A=[0.2 0.3 0.4 0.1;
    0.1 0.4 0.25 0.25;
    0.25 0.75 0 0;
    0.5 0.5 0 0];
B=[0 1 0 1;
    1 1 1 0;
    0 0 1 1;
    1 1 0 0];
N=1000; mode='nuclear'; lambda_tol=1e-6; tol=1e-2;

X = IST_MC(y,M,sizeX,err,x_initial,normfac,insweep,tol,decfac)