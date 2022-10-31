clear all; close all; clc;

% for the last homework, the students are asked to do a Netflix problem on
% a dataset of anime taken from Kaggle. Unfortunately, the dataset also
% rates hentai, which is not appropriate for the school environment. This
% script removes all of the hentai from the dataset.



rating = readtable('rating.csv');
anime  = readtable('anime.csv');

[n_rat,~] = size(rating);
[n_ani,~] = size(anime);

hen_ID = [];
hen_IN = [];
% gather ID's of all hentai
for ii = 1:n_ani
    if contains(anime{ii,3},'Hentai') == 1
        % record ID
        hen_ID = [hen_ID, anime{ii,1}];
        hen_IN = [hen_IN, ii];        
    end
end

% delete all hentai from anime table
anime_out = anime;
anime_out(hen_IN,:) = [];

% check success
for ii = 1:n_ani-length(hen_ID)
    if contains(anime_out{ii,3},'Hentai') == 1
        fprintf('censorship failed\n')
    end
end

% delete all references to hentai in the ratings
rat_ID = [];
tic
for ii = 1:n_rat
    if mod(ii,100000) == 0
        fprintf('iteration %i\n',ii)
    end
    if ismember(rating{ii,2},hen_ID)==1
        rat_ID = [rat_ID, ii];
    end
end
toc
rating_out = rating;
rating_out(rat_ID,:) = [];

writetable(anime_out, 'anime_upload.csv')
writetable(rating_out, 'rating_upload.csv')