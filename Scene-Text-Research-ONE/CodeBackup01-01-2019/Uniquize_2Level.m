function [rgb_UImages] = Uniquize_2Level(rgb_BinImages,BinSizes,MAX_DISTANCE)


[row,col,num] = size(rgb_BinImages);
rgb_UImages = false(row,col,num);


check_top_img = false(row,col);
check_bottom_img = false(row,col);

q_offset = 0;
  for i = 1:numel(BinSizes)
   main_offset = ceil(MAX_DISTANCE/BinSizes(i));
  
   
   %%Uniquize the main bins 
   for img_no = (q_offset+1):(q_offset+main_offset)
       count = 0;       
       img = rgb_BinImages(:,:,img_no);
       CCImage = bwconncomp(img);
       
       temp_img = rgb_UImages(:,:,img_no);
       
       
       if img_no~=(q_offset+main_offset)
           check_top_img = rgb_BinImages(:,:,(img_no+main_offset));
       else
           check_top_img(:,:) = 0;
       end
       
       if img_no~=(q_offset+1)
           check_bottom_img = rgb_BinImages(:,:,(img_no+main_offset-1));
       else
           check_bottom_img(:,:) = 0;
       end
       
       for obj_no = 1:CCImage.NumObjects
       
           if(check_top_img(CCImage.PixelIdxList{obj_no})~=1)
              if(check_bottom_img(CCImage.PixelIdxList{obj_no})~=1)
                 temp_img(CCImage.PixelIdxList{obj_no}) = 1;
              else
                count = count+1;  
              end
          else
              count = count+1;
          end
          
       end
       
       
       rgb_UImages(:,:,img_no) = temp_img;
       rgb_BinImages(:,:,img_no) = temp_img;
      fprintf('For Image:%d Checked with:%d and %d --> No of Components removed: %d Components Retained: %d \n',(img_no),(img_no+main_offset),(img_no+main_offset-1),count,(CCImage.NumObjects-count)); 
   end
       
   %%Uniquize the secondary bins
   for img_no = (q_offset+main_offset+1):(q_offset+2*main_offset-1)
       count = 0;       
       img = rgb_BinImages(:,:,img_no);
       CCImage = bwconncomp(img);
       
       temp_img = rgb_UImages(:,:,img_no);
       
       
       
      check_top_img = rgb_BinImages(:,:,(img_no-main_offset+1));
      check_bottom_img = rgb_BinImages(:,:,(img_no-main_offset));
       
  
       for obj_no = 1:CCImage.NumObjects
       
           if(check_top_img(CCImage.PixelIdxList{obj_no})~=1)
              if(check_bottom_img(CCImage.PixelIdxList{obj_no})~=1)
                 temp_img(CCImage.PixelIdxList{obj_no}) = 1;
              else
                count = count+1;  
              end
          else
              count = count+1;
          end
          
       end
       
       
       rgb_UImages(:,:,img_no) = temp_img(:,:);
       
      fprintf('For Image: %d Checked With: %d and %d ----> Checked No of Components removed: %d Components Retained: %d \n',img_no,(img_no-main_offset+1),(img_no-main_offset),count,(CCImage.NumObjects-count)); 
   end
    
    
    q_offset = q_offset+2*main_offset-1;
 end
  

end