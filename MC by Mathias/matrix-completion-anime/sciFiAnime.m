clear all; close all; clc;

% from the dataset with no hentai, get all sci-fi

rating = readtable('rating_upload_psy_scifi.csv');
anime  = readtable('anime_upload_psy_scifi.csv');

% rating = readtable('rating_upload.csv');
% anime  = readtable('anime_upload.csv');

[n_rat,~] = size(rating);
[n_ani,~] = size(anime);

sci_ID = [];
sci_IN = [];
% gather ID's of all sci-fi + psychological
% madoka magica is {'Drama, Magic, Psychological, Thriller'}
% pick the one with the smallest dataset
% Psychological = 2189

for ii = 1:n_ani
    if contains(anime{ii,3},'Sci-Fi') == 1 || contains(anime{ii,3},'Psychological') == 1
        % record ID
        sci_ID = [sci_ID, anime{ii,1}];
        sci_IN = [sci_IN, ii];        
    end
end

% delete all non-sci-fi/psychological anime
anime_out = anime;
anime_out = anime_out(sci_IN,:);

% check success



% % delete all references to non-sci-fi/psychological and -1's in the ratings
% rat_ID = [];
% tic
% for ii = 1:n_rat
%     if mod(ii,100000) == 0
%         fprintf('iteration %i\n',ii)
%     end
%     if ismember(rating{ii,2},sci_ID)==1 && rating{ii,3} > -1
%         rat_ID = [rat_ID, ii];
%     end
% end
% toc
% rating_out = rating;
% rating_out = rating_out(rat_ID,:);
% % output this so I don't have to do it again
% writetable(rating_out,'rating_upload_psy_scifi.csv')
% writetable(anime_out,'anime_upload_psy_scifi.csv')


% redo all of the anime IDs

index_to_ID = anime{:,1};
ID_to_index = zeros(max(index_to_ID),1);
ID_to_index(index_to_ID) = 1:n_ani;

rating_out = rating;
rating_out{:,2} = ID_to_index(rating_out{:,2});
anime_out{:,1}  = ID_to_index(anime_out{:,1});


% remove all users with empty ratings
rem_usr = unique(rating_out{:,1});
usr_to_ind = zeros(max(rem_usr),1);
usr_to_ind(rem_usr) = 1:length(rem_usr);
rating_out{:,1} = usr_to_ind(rating_out{:,1});

% number of users left
n_usr = length(rem_usr);
max_usr= 200;
rating_out = rating_out(rating_out{:,1} <= max_usr,:);


writetable(rating_out,'rating_upload_psy_scifi_new_index.csv')
writetable(anime_out,'anime_upload_psy_scifi_new_index.csv')

