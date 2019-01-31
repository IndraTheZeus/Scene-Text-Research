function [output_images] = ReduceToMainCCs(rgb_BinImages)
   
     min_size_threshold = 5;
     min_vol_threshold = 25;
    
    [row,col,numImages] = size(rgb_BinImages);
    output_images = false(size(rgb_BinImages));
    temp_img = false(row,col);
    for img_no = 1:numImages
        img = rgb_BinImages(:,:,img_no);
        CCimg = bwconncomp(img);
        
        temp_img(:,:) = 0;
        
        stat = regionprops(CCimg,'BoundingBox');
        
        for comp_no = 1:CCimg.NumObjects
           
            if max(stat(comp_no).BoundingBox(3),stat(comp_no).BoundingBox(4)) > min_size_threshold && numel(CCimg.PixelIdxList{comp_no}) > min_vol_threshold
                temp_img(CCimg.PixelIdxList{comp_no}) = 1; 
            end
            
        end
        
        output_images(:,:,img_no) = temp_img;
    end

end