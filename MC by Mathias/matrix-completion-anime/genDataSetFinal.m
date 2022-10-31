clear all; close all; clc;

% open censored anime

rating = readtable('rating_upload.csv');
anime  = readtable('anime_upload.csv');

[n_rat,~] = size(rating);
[n_ani,~] = size(anime);


% get scifi and psy animes

psy_ID = [];
psy_IN = [];

for ii = 1:n_ani
    if contains(anime{ii,3},'Sci-Fi') == 1 || contains(anime{ii,3},'Psychological') == 1
        % record ID
        psy_ID = [psy_ID, anime{ii,1}];
        psy_IN = [psy_IN, ii];        
    end
end

% delete all non-sci-fi/psychological anime
anime_out_psy = anime;
anime_out_psy = anime_out_psy(psy_IN,:);

% delete all references to non-sci-fi/psychological and -1's in the ratings
rat_ID = [];
tic
for ii = 1:n_rat
    if mod(ii,100000) == 0
        fprintf('iteration %i\n',ii)
    end
    if ismember(rating{ii,2},psy_ID)==1 && rating{ii,3} > -1
        rat_ID = [rat_ID, ii];
    end
end
toc
rating_out_psy = rating;
rating_out_psy = rating_out_psy(rat_ID,:);

% redo IDS
index_to_ID = anime_out_psy{:,1};
[n_ani_psy,~] = size(anime_out_psy);
ID_to_index = zeros(max(index_to_ID),1);
ID_to_index(index_to_ID) = 1:n_ani_psy;

rating_out_psy{:,2} = ID_to_index(rating_out_psy{:,2});
anime_out_psy{:,1}  = ID_to_index(anime_out_psy{:,1});


% remove all users with empty ratings
rem_usr = unique(rating_out_psy{:,1});
usr_to_ind = zeros(max(rem_usr),1);
usr_to_ind(rem_usr) = 1:length(rem_usr);
rating_out_psy{:,1} = usr_to_ind(rating_out_psy{:,1});

% number of users left
n_usr = length(rem_usr);
max_usr= 200;
rating_out_psy = rating_out_psy(rating_out_psy{:,1} <= max_usr,:);

writetable(rating_out_psy,'rating_upload_psy_scifi_new_index.csv')
writetable(anime_out_psy,'anime_upload_psy_scifi_new_index.csv')

% get scifi animes only
sci_ID = [];
sci_IN = [];

for ii = 1:n_ani
    if contains(anime{ii,3},'Sci-Fi') == 1 
        % record ID
        sci_ID = [sci_ID, anime{ii,1}];
        sci_IN = [sci_IN, ii];        
    end
end


% delete all non-sci-fi
anime_out_sci = anime;
anime_out_sci = anime_out_sci(sci_IN,:);

% delete all references to non-sci-fi and -1's in the ratings
rat_ID = [];
tic
for ii = 1:n_rat
    if mod(ii,100000) == 0
        fprintf('iteration %i\n',ii)
    end
    if ismember(rating{ii,2},sci_ID)==1 && rating{ii,3} > -1
        rat_ID = [rat_ID, ii];
    end
end
toc
rating_out_sci = rating;
rating_out_sci = rating_out_sci(rat_ID,:);

% redo IDS
index_to_ID = anime_out_sci{:,1}; % THIS IS REWRITTEN HERE
[n_ani_sci,~] = size(anime_out_sci);
ID_to_index = zeros(max(index_to_ID),1);
ID_to_index(index_to_ID) = 1:n_ani_sci;

rating_out_sci{:,2} = ID_to_index(rating_out_sci{:,2});
anime_out_sci{:,1}  = ID_to_index(anime_out_sci{:,1});


% remove all users with empty ratings
rem_usr = unique(rating_out_sci{:,1});
usr_to_ind = zeros(max(rem_usr),1);
usr_to_ind(rem_usr) = 1:length(rem_usr);
rating_out_sci{:,1} = usr_to_ind(rating_out_sci{:,1});

% number of users left
n_usr = length(rem_usr);
max_usr= 200;
rating_out_sci = rating_out_sci(rating_out_sci{:,1} <= max_usr,:);

writetable(rating_out_sci,'rating_upload_scifi_new_index.csv')
writetable(anime_out_sci,'anime_upload_scifi_new_index.csv')

