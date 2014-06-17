clc;clear;

rec11 = load('rec1.mat');
rec2 = rec11.users_items_recid;
rec22 = load('rec2.mat');
rec1 = rec22.recommend_list;
clear rec11 rec22
recommend_list ={};
for idx = 1:size(rec2,2)
    user_item_id = [];
    item_id_top = [];
    size1 =size(rec1{idx},2);
    size2 = size(rec2{idx},2);
    rec1_temp = rec1{idx}(2:size1);
    rec2_temp = rec2{idx}(2:size2);
    %交集
    
    inter_set = intersect(rec1_temp,rec2_temp);
    item_id_top = inter_set;
    if size(inter_set,2) < size1 -1
        size_diff1 = size1 - size(inter_set,2) ;
        size_diff2 = size2 - size(inter_set,2) ;
        size_diff1 = floor(size_diff1/2);
        size_diff2 = floor(size_diff2/2);
        
        set_diff1 = setdiff(rec1_temp,inter_set);
        set_diff2 = setdiff(rec2_temp,inter_set);
        
        item_id_top = [item_id_top set_diff1(1:size_diff1) set_diff2(1:size_diff2)];
    end
    user_item_id (1) =  rec1{idx}(1);
    user_item_id = [user_item_id item_id_top];
    recommend_list{idx} = user_item_id;
end
%20130401 808用户， 5339个
fid = fopen('result_lalala0419.txt','wt');
num_pBrands = 0;
for k=1:size(recommend_list,2)
    disp(k);
    fprintf(fid,'%d\t',recommend_list{k}(1));
    num_pBrands = num_pBrands+size(recommend_list{k},2);
    for kk =2: size(recommend_list{k},2)-1
        fprintf(fid,'%d,',recommend_list{k}(kk));
    end
    fprintf(fid,'%d\n',recommend_list{k}(size(recommend_list{k},2)));
end
fclose(fid);
disp(num_pBrands);