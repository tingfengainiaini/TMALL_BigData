function date_loc = dateTrans( fileReadMat_mat_date )
%DATETRANS Summary of this function goes here
%   Detailed explanation goes here
    N = size(fileReadMat_mat_date,1);
    date_loc = ones(N,1);
    for i = 1:N
        size_date = size(fileReadMat_mat_date{i},2);
        if size_date == 5
            temp = str2num([fileReadMat_mat_date{i}([1 3 4])]);
        else
            temp = str2num([fileReadMat_mat_date{i}(1) '0' fileReadMat_mat_date{i}(3)]);
        end
        date_loc(i) = temp;
    end
end

