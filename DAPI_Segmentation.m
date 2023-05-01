%% DAPI_Segmentation
function output_table = DAPI_Segmentation(img,partition_x,partition_y,binary_mult,se)
%% Image Partitioning
x_cutoffs = 1:partition_x:size(img,2);
y_cutoffs = 1:partition_y:size(img,1);

if x_cutoffs(end) ~= size(img,2)
    x_cutoffs = [x_cutoffs,size(img,2)+1];
else
end

if y_cutoffs(end) ~= size(img,1)
    y_cutoffs = [y_cutoffs,size(img,1)+1];
else
end

img_table = {};
for ii = 1:length(x_cutoffs)-1
    for jj = 1:length(y_cutoffs)-1
        x_dims = x_cutoffs(ii):x_cutoffs(ii+1)-1;
        y_dims = y_cutoffs(jj):y_cutoffs(jj+1)-1;
        img_table(jj,ii) = {img(y_dims,x_dims)}; %#ok<*AGROW>
    end
end

%% Adaptive Histogram Equalization
adapt_table = {};
for ii = 1:size(img_table,1)
    for jj = 1:size(img_table,2)
        adapt_table(ii,jj) = {adapthisteq(img_table{ii,jj})};
    end
end

%% Binarization
all_thresh=[];

for ii = 1:size(img_table,1)
    thresh=[];
    for jj = 1:size(img_table,2)
        gray_threshold = graythresh(adapt_table{ii,1})*binary_mult;
% %         gray_threshold=0.35;
%          if gray_threshold<0.2
%              gray_threshold=0.25;
%          end
%          gray_threshold=0.35;


        thresh=[thresh,gray_threshold];
%         binary_table(ii,jj) = {imbinarize(adapt_table{ii,jj},gray_threshold)};
    end
    all_thresh=[all_thresh;thresh];
end
mean_graythresh=mean(all_thresh,'all');
max_greythresh=max(max(all_thresh));
new_thresh=(mean_graythresh+max_greythresh)/2;

binary_table = {};
for ii = 1:size(img_table,1)
    for jj = 1:size(img_table,2)
        binary_table(ii,jj) = {imbinarize(adapt_table{ii,jj},new_thresh)};
    end
end

%% Closing
open_table  = {};
for ii = 1:size(img_table,1)
    for jj = 1:size(img_table,2)
        open_table(ii,jj) = {imclose(binary_table{ii,jj},se)};
    end
end

%% Filling
fill_table = {};
for ii = 1:size(img_table,1)
    for jj = 1:size(img_table,2)
        fill_table(ii,jj) = {imfill(open_table{ii,jj},"holes")};
    end
end

%% Watershed Segmentation
watershed_table = {};
all_label={};
for ii = 1:size(img_table,1)
    for jj = 1:size(img_table,2)
        BW_img = fill_table{ii,jj};
        D = ~bwdist(BW_img);
        D = -D;
        label = watershed(D,8);
        label(~BW_img) = 0;
        all_label(ii,jj)={label};
        rgb = label2rgb(label,'jet',[0.5 0.5 0.5]);
        watershed_table(ii,jj) = {rgb};
    end
end

%% Image Recombination
img_rows = {};
l_rows={};
for ii = 1:size(img_table,1)
    img_grow = [];
    l_grow=[];
    for jj = 1:size(img_table,2)
        img_grow = [img_grow watershed_table{ii,jj}];
        l_grow=[l_grow all_label{ii,jj}];
    end
    img_rows{ii,1} = img_grow;
    l_rows{ii,1} = l_grow;
end

img_final = [];
l_final=[];
for ii = 1:size(img_rows,1)
    img_final = [img_final;img_rows{ii,1}];
    l_final = [l_final;l_rows{ii,1}];
end

%% Output
output_table{1,1} = img_table;
output_table{2,1} = adapt_table;
output_table{3,1} = binary_table;
output_table{4,1} = open_table;
output_table{5,1} = fill_table;
output_table{6,1} = watershed_table;
output_table{7,1} = img_final;
output_table{8,1} = label;
output_table{9,1} = l_final;

end