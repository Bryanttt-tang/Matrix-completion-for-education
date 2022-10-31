clear all; close all; clc;


rating  = table2array(readtable('rating_upload_scifi_new_index.csv'));
anime   = readtable('anime_upload_scifi_new_index.csv');

[n_rat,~] = size(rating);
[n_ani,~] = size(anime);
n_use = max(rating(:,1));

tic
% cvx_solver scs
cvx_begin

    variable X(n_use+1, n_ani)
    
    minimize norm_nuc(X)
    subject to
    for ii = 1:n_rat
        if mod(ii,100)==0
            fprintf('iteration %i\n',ii)
        end
        X(rating(ii,1),rating(ii,2))== rating(ii,3);
    end
    % mathias
    %ratings in full dataset
    X(n_use+1,2) == 10;
    X(n_use+1,2154) == 8;
    X(n_use+1,29) == 5;
    X(n_use+1,137) == 10;
    X(n_use+1,95) == 6;
    
    % madoka magica
%     X(n_use+1,31) == 9;



    
cvx_end
toc

Mathias_rec = X(n_use+1,:)';
animes_for_mathias = anime(Mathias_rec>6,:);

% max 10 animes
[B,I] = maxk(Mathias_rec,10);


