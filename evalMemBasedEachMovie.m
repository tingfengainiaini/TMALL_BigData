function recommend_list=evalMemBasedEachMovie(activeMatTrain,...
    activeMatTest,otherMat,simMethod,K,coeff, S,user_id,item_id, mod, size_recomment, cut_value, rec_num)
% function [L1err,L2err,rankedErr]=evalMemBasedEachMovie(activeMatTrain,...
%    activeMatTest,otherMat,simMethod,K,coeff)
%
% Train and tests a memory based CF model with respect to predicting
% the preferences of the active user given in activeMatTest based on
% the prediction of the active user given in activeMatTrain and the
% prediction of the other users in otherMat. 
%
% Guy Lebanon, August 2003.

% transform training data to cell arrays for mex file call
activeCellVecTrain = sparseMat2CellVec(activeMatTrain);
otherCellVec = sparseMat2CellVec(otherMat);
[numActive,numItems] = size(activeMatTrain);

% Obtain similarity matrices for memory base prediction
 simMat=memoryBasedModels(activeCellVecTrain,otherCellVec,simMethod,-1,numItems);
save('simMat0419wbq.mat','simMat');
% simMat1 = load('simMat0328wbq.mat');
% simMat = simMat1.simMat;
% clear simMat1;

% Predict preferences for each active user and evaluate the predictions
num_pBrands = 0;
num_hitBrands = 0;
num_bBrands = 0;
recommend_list = {};
for j=1:numActive,
    user_item_id = [];
    ind_train=find(activeMatTrain(j,:)>0);
    activeUserMean=full(mean(activeMatTrain(j,ind_train)));
    predPref1=predictPreferenceMemBased(simMat(j,:), otherMat, activeUserMean);
    
    
    %得到在Train中已经买的物品
    ind_train_get = find(activeMatTrain(j,:) >= S.numValues);
    if mod == 1%代表去除已经买的物品，即尽量不推荐已经买的商品
        %不算是去除，就是将权值降低为均值
        predPref1(ind_train_get) = mean(activeMatTrain(j, ind_train));
    end
    [~,top_id] = sort(predPref1,'descend');
    %找出推荐的前几个商品
    num_topk = size(ind_train,2);
    if num_topk<=cut_value(2) 
        item_id_top = item_id(top_id(1:rec_num(1)));
    elseif num_topk<=cut_value(3)
        item_id_top = item_id(top_id(1:rec_num(2)));
%     elseif num_topk<=cut_value(4)
%          item_id_top = item_id(top_id(1:6));
    elseif num_topk<=cut_value(5)
         item_id_top = item_id(top_id(1:rec_num(4)));
    else
         item_id_top = item_id(top_id(1:rec_num(5)));
    end
    user_item_id (1) =  user_id(j);
    user_item_id = [user_item_id item_id_top];
    recommend_list{j} = user_item_id;
    disp(j);
%     idx_recomment = idx_pref(1:size_recomment);
%     true_loc_full = find(activeMatTest(j,:) == S.numValues);
    
%     for i = 1:size(idx_recomment,2)
%         if any(idx_recomment(i) == true_loc_full)
%             num_hitBrands = num_hitBrands + 1;
%         end
%     end
%     num_pBrands = num_pBrands + size_recomment;
%     num_bBrands = num_bBrands + size(true_loc_full,2);
%     if size(predPref,2) >= 10
%         predPref(idx)
%     end
%     truePref = full(activeMatTest(j,ind_test));
%     true_loc = find(truePref == 10);
%     
%     if size(predPref, 2) >=10
%         size_for = 10;
%     else
%         size_for = size(predPref, 2);
%     end
%     for i = 1:size_for
%         if any(idx(i) == true_loc)
%             num_hitBrands = num_hitBrands + 1;
%         end
%     end
%     num_pBrands = num_pBrands + size_for;
%     num_bBrands = num_bBrands + size(true_loc,2);
    %convert the matrix to binary
%     predPref_binary(predPref < S.cutValue) = 0;
%     predPref_binary(predPref >= S.cutValue) = 1;
%     truePref_binary(truePref ~= S.numValues) =0;
%     truePref_binary(truePref == S.numValues) =1;
%     
%     num_pBrands = num_pBrands + sum(predPref_binary);
%     num_bBrands = num_bBrands + sum(truePref_binary);
%     num_hitBrands = num_hitBrands + sum(truePref_binary( find(predPref_binary==1) ) == 1);
    
%     L2err(j)=mean((predPref-truePref).^2);
%     L1err(j)=norm(predPref-truePref,1)/length(predPref);
%     rankedErr(j)=rankedEvalCF(predPref,truePref,K,coeff);
end

% %compute the precision and recall
% precision = num_hitBrands/num_pBrands;
% recall = num_hitBrands/num_bBrands;
% f1 = 2*precision*recall / (precision + recall);
