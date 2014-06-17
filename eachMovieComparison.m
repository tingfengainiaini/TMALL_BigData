    % function [sim1Err,sim2Err,PDErr,avgErr,constErr,S]=eachMovieComparison(S)
% 
%  %userVoteMat=eachMovieReader(S.numUsersLimit);
% userVoteMat=dataReader();
% save userVoteMat; 
clear
clc

S.numUsersLimit=2000;
S.activePerc=0.3;
S.percReported=0.5;
S.percPredicted=0.5;
S.crossValNum=1;
S.K=10;
S.coeff=0.5;
S.sigma=0.7;
S.numValues=8;
S.cutValue = 10;

userVoteMat1 = load('userVoteMat20140419_wang.mat');
userVoteMat = userVoteMat1.userVoteMat;
user_id = userVoteMat1.user_id;
item_id = userVoteMat1.item_id;
clear userVotemat1;
if size(userVoteMat,1) == 1
    fprintf('Read file error');
    return;
end
S.numUsersLimit = size(userVoteMat,1);

[S.numUsers,S.numItems]=size(userVoteMat);
S.numActive = floor(S.numUsers * S.activePerc);
S.numOther = S.numUsers - S.numActive;
activeMatTrain=sparse(S.numActive,S.numItems);
activeMatTest=sparse(S.numActive,S.numItems);

for i=1:S.crossValNum,
    % randomly split the into active and other users
    [activeMat,otherMat]=splitUsers(userVoteMat, S.numActive,S.numOther);
    clear userVoteMat;

    % For each active user, split the items into reported and predicted
    activePat=spones(activeMat);
    numReported=full(floor(sum(activePat,2) * S.percReported));
    numPredicted=sum(activePat,2)-numReported;
    clear activePat;    
%     for j=1:S.numActive,
%         ind=find(activeMat(j,:)>0);
%         nvu=length(ind);nru=numReported(j);npu=numPredicted(j);
%         randPerm=randperm(length(ind));
%         activeMatTrain(j,ind(randPerm(1:nru)))=activeMat(j,ind(randPerm(1:nru)));
%         activeMatTest(j,ind(randPerm(nru+1:nvu)))=...
%             activeMat(j,ind(randPerm(nru+1:nvu)));
%     end
    activeMatTrain = activeMat;
    activeMatTest = activeMat;
    % Perform training and testing of the different models
    %20130401 808 user ÍÆ¼ö4944¸ö
    cut_value = [7,20,45,100,200];
    rec_num = [3,5,6,6,8];
    users_items_recid = evalMemBasedEachMovie(activeMatTrain,...
        activeMatTest,otherMat,1,S.K,S.coeff,S, user_id,item_id, 2, 6,cut_value,rec_num);
    num_pBrands = 0;
    save('rec1.mat','users_items_recid');
    fid = fopen('result_doublewang0419.txt','wt');
    for k=1:size(users_items_recid,2)
        disp(k);
        fprintf(fid,'%d\t',users_items_recid{k}(1));
        num_pBrands = num_pBrands +  size(users_items_recid{k},2);
        for kk =2: size(users_items_recid{k},2)-1
            fprintf(fid,'%d,',users_items_recid{k}(kk));
        end
        fprintf(fid,'%d\n',users_items_recid{k}(size(users_items_recid{k},2)));
    end
    fclose(fid);
    disp(num_pBrands);
%     sim1Err{i}=[err1;err2;err3];
%     evalMemBasedEachMovie(activeMatTrain,...
%          activeMatTest,otherMat,2,S.K,S.coeff,S, user_id,item_id, 1, 6,cut_value);
%     sim2Err{i}=[err1;err2;err3]; 
%       evalPDEachMovie(activeMatTrain,...
%          activeMatTest,otherMat,S.K,S.coeff,S.sigma,S.numValues,S.cutValue);
%     PDErr{i}=[err1;err2;err3];
%       evalAvgEachMovie(activeMatTrain,activeMatTest,...
%          S.K,S.coeff,S.cutValue);
%     avgErr{i}=[err1;err2;err3];
%     [err1,err2,err3]=evalConstEachMovie(activeMatTrain,activeMatTest,...
%         S.numValues,S.K,S.coeff,S.cutValue);
%     constErr{i}=[err1;err2;err3];
end