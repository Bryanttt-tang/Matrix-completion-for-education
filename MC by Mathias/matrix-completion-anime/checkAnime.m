clear all; close all; clc;

% this script is to check if my watched animes are included
rating  = table2array(readtable('rating_upload_scifi_new_index.csv'));
anime   = readtable('anime_upload_scifi_new_index.csv');

[n_ani,~] = size(anime);


for ii = 1:n_ani
    if contains(anime{ii,2},'Magi')==1
        anime{ii,2}
        anime{ii,1}
    end
%     if contains(anime{ii,2},'RWBY')==1
%         anime{ii,2}
%     end
%     if contains(anime{ii,2},'Lain')==1
%         anime{ii,2}
%         anime{ii,3}
%     end
%     if contains(anime{ii,2},'Shinsekai')==1
%         anime{ii,2}
%     end
    
end


%shinsekai yori
%steins;gate and 0
% Mahou Shoujo Madoka★Magica
