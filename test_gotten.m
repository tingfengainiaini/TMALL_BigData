import containers.Map

fid = fopen('t_alibaba_data.csv');
tile = textscan(fid, '%s%s%s%s',1,'delimiter',',');
fileReadMat = textscan(fid, '%f%f%f%s','delimiter',',');

fileReadMat_mat(:,1) = fileReadMat{1};
fileReadMat_mat(:,2) = fileReadMat{2};
fileReadMat_mat(:,3) = fileReadMat{3};
fileReadMat_mat_date = fileReadMat{4};

user_id_temp = fileReadMat_mat(1,1);
brand_id_temp = fileReadMat_mat(1,2);
% score_temp = transformVote(fileReadMat_mat(1,3));

map_data = Map;

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
            score_temp = transformVote(fileReadMat_mat(row_idx,3));
        else
            if transformVote(fileReadMat_mat(row_idx,3)) > score_temp
                score_temp = transformVote(fileReadMat_mat(row_idx,3));
            end
        end
    end

