%% DAPI_Analysis
% For plotting images from DAPI_Segmentation function
function DAPI_Analysis(output_table,query,coordinates)
plot_raw_img     = output_table{1,1};
plot_adapt_img   = output_table{2,1};
plot_binary_img  = output_table{3,1};
plot_open_img    = output_table{4,1};
plot_fill_img    = output_table{5,1};
plot_watershed_img=output_table{6,1};
plot_final_img   = output_table{7,1};

select_raw = {};
select_adapt = {};
select_binary = {};
select_open = {};
select_fill = {};
select_watershed = {};

switch query
    case 'Patch'
        for ii = 1:size(coordinates,1)
            select_raw{1,ii} = plot_raw_img{coordinates(ii,1),coordinates(ii,2)};
            select_adapt{1,ii} = plot_adapt_img{coordinates(ii,1),coordinates(ii,2)};
            select_binary{1,ii} = plot_binary_img{coordinates(ii,1),coordinates(ii,2)};
            select_open{1,ii} = plot_open_img{coordinates(ii,1),coordinates(ii,2)};
            select_fill{1,ii} = plot_fill_img{coordinates(ii,1),coordinates(ii,2)};
            select_watershed{1,ii} = plot_watershed_img{coordinates(ii,1),coordinates(ii,2)};
        end
        
        subplot_count = 0;
        subplot_width = size(coordinates,1);
        
        figure('Name','Segmentation Pipeline','NumberTitle','Off')
        for ii = 1:size(coordinates,1)
            subplot_count = subplot_count + 1;
            subplot(6,subplot_width,subplot_count)
            imshow(select_raw{1,ii})
            if ii == ceil(size(coordinates,1)/2)
                title('Raw Image')
            else
            end
            txt_coordinate = ['[' int2str(coordinates(ii,1)) ',' int2str(coordinates(ii,2)) ']'];
            subtitle(txt_coordinate)
        end
        
        for ii = 1:size(coordinates,1)
            subplot_count = subplot_count + 1;
            subplot(6,subplot_width,subplot_count)
            imshow(select_adapt{1,ii})
            if ii == ceil(size(coordinates,1)/2)
                title('Adaptive Threshold Histogram')
            else
            end
        end
        
        for ii = 1:size(coordinates,1)
            subplot_count = subplot_count + 1;
            subplot(6,subplot_width,subplot_count)
            imshow(select_binary{1,ii})
            if ii == ceil(size(coordinates,1)/2)
                title('Intensity Thresholded Binary')
            else
            end
        end
        
        for ii = 1:size(coordinates,1)
            subplot_count = subplot_count + 1;
            subplot(6,subplot_width,subplot_count)
            imshow(select_open{1,ii})
            if ii == ceil(size(coordinates,1)/2)
                title('Closing w/ disk of selected radius')
            else
            end
        end
        
        for ii = 1:size(coordinates,1)
            subplot_count = subplot_count + 1;
            subplot(6,subplot_width,subplot_count)
            imshow(select_fill{1,ii})
            if ii == ceil(size(coordinates,1)/2)
                title('Filled Image')
            else
            end
        end
        
        for ii = 1:size(coordinates,1)
            subplot_count = subplot_count + 1;
            subplot(6,subplot_width,subplot_count)
            imshow(select_watershed{1,ii})
            if ii == ceil(size(coordinates,1)/2)
                title('Watershed Segmentation')
            else
            end
        end
        
        figure('Name','Final Compiled Image','NumberTitle','off')
        imshow(plot_final_img)
        title('Final Compiled Image')
        
    case 'Bulk'
        conversion_window = 256;
        coordinates(:,1) = ((coordinates(:,1)-1).*conversion_window)+1;
        coordinates(:,2) = ((coordinates(:,2)-1).*conversion_window)+1;
        
        for ii = 1:size(coordinates,1)
            select_raw{1,ii} = plot_raw_img{1,1}(coordinates(ii,1):coordinates(ii,1)+conversion_window-1,coordinates(ii,2):coordinates(ii,2)+conversion_window-1);
            select_adapt{1,ii} = plot_adapt_img{1,1}(coordinates(ii,1):coordinates(ii,1)+conversion_window-1,coordinates(ii,2):coordinates(ii,2)+conversion_window-1);
            select_binary{1,ii} = plot_binary_img{1,1}(coordinates(ii,1):coordinates(ii,1)+conversion_window-1,coordinates(ii,2):coordinates(ii,2)+conversion_window-1);
            select_open{1,ii} = plot_open_img{1,1}(coordinates(ii,1):coordinates(ii,1)+conversion_window-1,coordinates(ii,2):coordinates(ii,2)+conversion_window-1);
            select_fill{1,ii} = plot_fill_img{1,1}(coordinates(ii,1):coordinates(ii,1)+conversion_window-1,coordinates(ii,2):coordinates(ii,2)+conversion_window-1);
            select_watershed{1,ii} = plot_watershed_img{1,1}(coordinates(ii,1):coordinates(ii,1)+conversion_window-1,coordinates(ii,2):coordinates(ii,2)+conversion_window-1,:);
        end
        
        subplot_count = 0;
        subplot_width = size(coordinates,1);
        
        for ii = 1:size(coordinates,1)
            subplot_count = subplot_count + 1;
            subplot(6,subplot_width,subplot_count)
            imshow(select_raw{1,ii})
            if ii == ceil(size(coordinates,1)/2)
                title('Raw Image')
            else
            end
            txt_coordinate = ['[' int2str(coordinates(ii,1)) ',' int2str(coordinates(ii,2)) ']'];
            subtitle(txt_coordinate)
        end
        
        for ii = 1:size(coordinates,1)
            subplot_count = subplot_count + 1;
            subplot(6,subplot_width,subplot_count)
            imshow(select_adapt{1,ii})
            if ii == ceil(size(coordinates,1)/2)
                title('Adaptive Threshold Histogram')
            else
            end
        end
        
        for ii = 1:size(coordinates,1)
            subplot_count = subplot_count + 1;
            subplot(6,subplot_width,subplot_count)
            imshow(select_binary{1,ii})
            if ii == ceil(size(coordinates,1)/2)
                title('Intensity Thresholded Binary')
            else
            end
        end
        
        for ii = 1:size(coordinates,1)
            subplot_count = subplot_count + 1;
            subplot(6,subplot_width,subplot_count)
            imshow(select_open{1,ii})
            if ii == ceil(size(coordinates,1)/2)
                title('Opening w/ disk of selected radius')
            else
            end
        end
        
        for ii = 1:size(coordinates,1)
            subplot_count = subplot_count + 1;
            subplot(6,subplot_width,subplot_count)
            imshow(select_fill{1,ii})
            if ii == ceil(size(coordinates,1)/2)
                title('Filled Image')
            else
            end
        end
        
        for ii = 1:size(coordinates,1)
            subplot_count = subplot_count + 1;
            subplot(6,subplot_width,subplot_count)
            imshow(select_watershed{1,ii})
            if ii == ceil(size(coordinates,1)/2)
                title('Watershed Segmentation')
            else
            end
        end
        
        figure('Name','Final Compiled Image','NumberTitle','off')
        imshow(plot_final_img)
        title('Final Compiled Image')
end
end