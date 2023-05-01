%% Final Project
clc;clear;
close all;

%% Data Loading
tic
raw_img = tiffreadVolume('registered_images_60.tif');
DAPI_img = raw_img(:,:,1);
DAPI_img = uint8(DAPI_img');
time_loading = toc;

%% Variables
binary_mult = 0;
answer_1 = questdlg('Do you watch patch or bulk segmentation?', ...
	'Style Query', ...
	'Patch','Bulk','Bulk');
switch answer_1
    case 'Patch'
        partition_x = 256;
        partition_y = 256;
        binary_mult = 1.21;
    case 'Bulk'
        partition_x = size(DAPI_img,2);
        partition_y = size(DAPI_img,1);
        binary_mult = 1.65;
end

se = strel("disk",1);

%% Segmentation Function
tic
output_table = DAPI_Segmentation(DAPI_img,partition_x,partition_y,binary_mult,se);
time_segmentation = toc;

%% Plotting Function
coordinates =[15,7;30 5;22 3;34 6;31 2]; % Enter x by 2 matrix for coordinates of patch you wish to view
% Coordinates currently set up assuming original patch dimensions of 256 by
% 256.
tic
DAPI_Analysis(output_table,answer_1,coordinates);
time_plotting = toc;

%% Comparing Ground Truth
output_img = output_table{9};
% grey_output=im2gray(output_img{1,1});
output_bin = imbinarize(output_img,0.00001);
figure
imshow(output_bin')

GT_img = tiffreadVolume('gt_dapi.tif');
GT_img = GT_img';
%GT_img = flipud(GT_img);

% corrected_bin = imresize(output_bin,2)';
% corrected_bin = flipud(corrected_bin);
% grey_output=rgb2gray(output_bin);
corrected_bin=output_bin;
corrected_bin = corrected_bin';
imwrite(corrected_bin, 'DAPI_mask.tif');

figure;
subplot(211)
imshow(GT_img)
title('Ground Truth')
subplot(212)
imshow(corrected_bin)
title('Produced Mask')

statistics = GTcomp(corrected_bin,GT_img);