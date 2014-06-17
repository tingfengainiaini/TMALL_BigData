function [userVoteMat,user_id,item_id] = dataReader( )%numUsersLimit )
%DATAREADER Summary of this function goes here
%   Detailed explanation goes here
%     userVoteMat = csvread('t_alibaba_data.csv',1,0,[1,0,2,1]);
%     size(userVoteMat)
    if ~exist(fullfile('t_alibaba_data.csv'),'file')
        userVoteMat = zero(1,1);
        return;
    end
    mat=[];
    fid = fopen('t_alibaba_data.csv');
    tile = textscan(fid, '%s%s%s%s',1,'delimiter',',');
    fileReadMat = textscan(fid, '%f%f%f%s','delimiter',',');
      %userVoteMat = textscan(fid, '%d%d%d');
    
    
    fileReadMat_mat(:,1) = fileReadMat{1};
    fileReadMat_mat(:,2) = fileReadMat{2};
    fileReadMat_mat(:,3) = fileReadMat{3};
    fileReadMat_mat_date = dateTrans(fileReadMat{4});
    
%     [~,ix] = sort(fileReadMat_mat_temp(:,1));
%     fileReadMat_mat = fileReadMat_mat_temp(ix,:);
    
    user_id_temp = fileReadMat_mat(1,1);
    brand_id_temp = fileReadMat_mat(1,2);
    score_temp = transformVote(fileReadMat_mat(1,3),fileReadMat_mat_date(1));
    
    for row_idx = 1:size(fileReadMat_mat,1)
        if fileReadMat_mat(row_idx,1) ~= user_id_temp || fileReadMat_mat(row_idx,2) ~= brand_id_temp
            if size(mat,1) == 0
                mat = [mat; user_id_temp brand_id_temp score_temp];
            elseif ~any(mat(find(mat(:,1) == fileReadMat_mat(row_idx,1)), 2) == fileReadMat_mat(row_idx,2)) 
                mat = [mat; user_id_temp brand_id_temp score_temp];
            else
                y = findrows(mat,[fileReadMat_mat(row_idx,1) fileReadMat_mat(row_idx,2)]);
                if size(y,1) == 2
                    fprintf('ddd');
                end
                if mat(y(1),3) < fileReadMat_mat(row_idx,3)
                    mat(y(1),3) = fileReadMat_mat(row_idx,3);
                end
            end
            user_id_temp = fileReadMat_mat(row_idx,1);
            brand_id_temp = fileReadMat_mat(row_idx,2);
            score_temp = transformVote(fileReadMat_mat(row_idx,3),fileReadMat_mat_date(row_idx));
        else
%             if transformVote(fileReadMat_mat(row_idx,3),fileReadMat_mat_date(row_idx)) > score_temp/2
                score_temp = transformVote(fileReadMat_mat(row_idx,3),fileReadMat_mat_date(row_idx)) + score_temp;
%             else
%                 score_temp = score_temp + transformVote(fileReadMat_mat(row_idx,3),fileReadMat_mat_date(row_idx));
%             end
        end
    end
    userVoteMat=spconvert(mat);
    [userVoteMat,user_id,item_id] = compressUserVoteMat(userVoteMat);
    fclose(fid);
return

function y = findrows(mat_det,value_tofind)
    [row_x,colomn_x]=size(mat_det);
    j=1;
    for i=1:row_x
        if(mat_det(i,1)==value_tofind(1) && mat_det(i,2) == value_tofind(2))
                y(j)=i;
                j=j+1;
        end
    end
return

function score=transformVote(type_temp,date)
% Transforms the original eachmovie votes
% (0,0.2,0.4,0.6,0.8,1) to the scale 1-6.
if date > 515 && date <= 615
    date = date*1.2;
elseif date > 615 && date <= 700
    date = date*1.4;
elseif date > 700 && date <= 715
    date = date*1.6;
elseif date>715
    date = date*1.8;
end
time_value = date/1000;
switch type_temp, 
case 0
    score = 0.2;
case 1
    score = 2;
case 2
    score = 1;
case 3
    score = 1;
end
score = score * time_value;
return

function [userVoteMat,user_id,item_id]=compressUserVoteMat(userVoteMat);
% Removes extremely unseen movies (seen by < 4 users)
% and users with few votes 
%
% FUNCTION userVoteMat=compressUserVoteMat(userVoteMat);
%
% Guy Lebanon June 2003
%删除很冷门的物品
userVoteBinary=spones(userVoteMat);
ind1=find(sum(userVoteBinary)<4);
ind1(find(sum(userVoteMat(:,ind1)) >10)) = [];

item_id = [1:size(userVoteBinary,2)];
item_id(ind1) = [];
userVoteMat(:,ind1)=[];
%删除
userVoteBinary=spones(userVoteMat);
ind2=find(sum(userVoteBinary,2)<20);
ind2(find(sum(userVoteMat(ind2,:),2) > 20)) = [];
user_id = [1:size(userVoteBinary,1)];
user_id(ind2) = [];
userVoteMat(ind2,:)=[];

userVoteBinary=spones(userVoteMat);
ind3=find(sum(userVoteBinary)==0);
item_id(ind3) = [];
userVoteMat(:,ind3)=[];
return 
