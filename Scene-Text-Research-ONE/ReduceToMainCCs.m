function [images] = ReduceToMainCCs(images)

width_Thres = 0.05;
height_Thres = 0.25;
area_Thres = 0.03;

[row,col,numImages] = size(images);

for img_no = 1:numImages
    img = images(:,:,img_no);
    CCimg = bwconncomp(img);
    
    temp_img = zeros(row,col);

    
    stat = regionprops(CCimg,'BoundingBox');
    
    for comp_no = 1:CCimg.NumObjects
        width = stat(comp_no).BoundingBox(3);
        height = stat(comp_no).BoundingBox(4);
        pixel_count = numel(CCimg.PixelIdxList{comp_no});
        if width > width_Thres*col && height > height_Thres*row && pixel_count > area_Thres*(row*col)
            temp_img(CCimg.PixelIdxList{comp_no}) = 1;
        end
        
    end
    
    images(:,:,img_no) = temp_img;
end

end