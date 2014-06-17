function [L1err,L2err,rankedErr]=evalPDEachMovie(activeMatTrain,...
    activeMatTest,otherMat,K,coeff,sigma,numValues, cutValue)

valVec=1:numValues;
num_pBrands = 0;
num_hitBrands = 0;
num_bBrands = 0;

for j=1:size(activeMatTest,1),
    [pred,predMean]=predictPreferencePD(activeMatTrain(j,:), otherMat,...
        numValues,sigma);
    ind = find(activeMatTest(j,:)>0);
    predPref = predMean(ind);
    truePref = full(activeMatTest(j,ind));
    ind_train=find(activeMatTrain(j,:)>0);
    activeUserMean=full(mean(activeMatTrain(j,ind_train)));
    predPref1=predictPreferenceMemBased(simMat(j,:), otherMat, activeUserMean);
    L2err(j)=mean((predPref-truePref).^2);
    L1err(j)=norm(predPref-truePref,1)/length(predPref);
    rankedErr(j)=rankedEvalCF(predPref,truePref,K,coeff);
    
%     ind_test = find(activeMatTest(j,:)>0);
%     predPref = predPref1(ind_test);
%     [~,idx] = sort(predPref,'descend');
%     
%     %Make the value of items bought in train to be mean.
%     ind_train_get = find(activeMatTrain(j,:) == S.numValues);
%     predPref1(ind_train_get) = mean(activeMatTrain(j, ind_train));
%     [~,idx_pref] = sort(predPref1,'descend');
%     %Recommend the top 10 items 
%     size_recomment = 6;
%     idx_recomment = idx_pref(1:size_recomment);
%     true_loc_full = find(activeMatTest(j,:) == S.numValues);
%     
%     for i = 1:size(idx_recomment,2)
%         if any(idx_recomment(i) == true_loc_full)
%             num_hitBrands = num_hitBrands + 1;
%         end
%     end
%     num_pBrands = num_pBrands + size_recomment;
%     num_bBrands = num_bBrands + size(true_loc_full,2);

end