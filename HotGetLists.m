clc;clear;
% [userVoteMat,user_id,item_id] = hotGet();
userHot = load('userVoteMat20140419_hsp.mat');
userVoteMat =userHot.userVoteMat;
user_id =userHot.user_id;
item_id = userHot.item_id;
recommend_list = {};
cut_value = [20,45,100,200];
for j = 1:size(userVoteMat,1)
    user_item_id = [];
    ind_train=find(userVoteMat(j,:)>0);
    num_topk = size(ind_train,2);
    %-----------------------------------
    temp = userVoteMat(j,:);
    [~,top_id] = sort(temp,'descend');
    if num_topk<=cut_value(1) 
        item_id_top = item_id(top_id(1:3));
    elseif num_topk<=cut_value(2)
        item_id_top = item_id(top_id(1:5));
%     elseif num_topk<=cut_value(3)
%          item_id_top = item_id(top_id(1:6));
    elseif num_topk<=cut_value(4)
         item_id_top = item_id(top_id(1:6));
    else
         item_id_top = item_id(top_id(1:7));
    end
    
    %-----------------------------------
    user_item_id (1) =  user_id(j);
    user_item_id = [user_item_id item_id_top];
    recommend_list{j} = user_item_id;
end
num_pBrands = 0;
%20130401 808user 4961¸ö
save('rec2.mat','recommend_list');
fid = fopen('result_hsp0419.txt','wt');
    for k=1:size(recommend_list,2)
        disp(k);
        fprintf(fid,'%d\t',recommend_list{k}(1));
        num_pBrands =num_pBrands+size(recommend_list{k},2);
        for kk =2: size(recommend_list{k},2)-1
            fprintf(fid,'%d,',recommend_list{k}(kk));
        end
        fprintf(fid,'%d\n',recommend_list{k}(size(recommend_list{k},2)));
    end
    fclose(fid);
    disp(num_pBrands);