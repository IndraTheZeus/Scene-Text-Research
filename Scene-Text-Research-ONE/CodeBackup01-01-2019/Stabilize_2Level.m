
function [rgb_SUImages] = Stabilize_2Level(rgb_BinImages,BinSizes,MAX_DISTANCE)

stability_threshold = 1.2;

[row,col,num] = size(rgb_BinImages);
rgb_SUImages = false(row,col,num);


check_top_img = false(row,col);
check_bottom_img = false(row,col);

q_offset = 0;
  for i = 1:numel(BinSizes)
   main_offset = ceil(MAX_DISTANCE/BinSizes(i));
  
   
   %%Stabilize the main bins 
   for img_no = (q_offset+1):(q_offset+main_offset)
       count = 0;       
       img = rgb_BinImages(:,:,img_no);
       CCImage = bwconncomp(img);
       
       temp_img = rgb_SUImages(:,:,img_no);
       
       
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
       
       stability_check_img = check_top_img | check_bottom_img | img;
       
       check_CCImage = bwconncomp(stability_check_img);
       check_LabelImage = bwlabel(stability_check_img);
       
       for obj_no = 1:CCImage.NumObjects
           label_matrix = findLabels(check_LabelImage(CCImage.PixelIdxList{obj_no}),5);
           if label_matrix(1,2)~=0
               fprintf("\n!!!More than two componenets found!\n");
           end
           
          if(numel(check_CCImage.PixelIdxList{label_matrix(1,1)}) < numel(CCImage.PixelIdxList{obj_no}))
              fprintf("\n!!!ERROR IN ASSUMPTION!\n");
              error = 1
          end
          
           if((numel(check_CCImage.PixelIdxList{label_matrix(1,1)})) < (stability_threshold*numel(CCImage.PixelIdxList{obj_no})))
              temp_img(check_CCImage.PixelIdxList{label_matrix(1,1)}) = 1;
          else
              count = count+1;
          end
          
       end
       
       
       rgb_SUImages(:,:,img_no) = temp_img;
    %   rgb_BinImages(:,:,img_no) = temp_img;
      fprintf('For Image:%d Checked with:%d and %d --> No of Components removed: %d Components Retained: %d \n',(img_no),(img_no+main_offset),(img_no+main_offset-1),count,(CCImage.NumObjects-count)); 
   end
       
   %%Uniquize the secondary bins
   for img_no = (q_offset+main_offset+1):(q_offset+2*main_offset-1)
       count = 0;       
       img = rgb_BinImages(:,:,img_no);
       CCImage = bwconncomp(img);
       
       temp_img = rgb_SUImages(:,:,img_no);
       
       
       
      check_top_img = rgb_BinImages(:,:,(img_no-main_offset+1));
      check_bottom_img = rgb_BinImages(:,:,(img_no-main_offset));
       
  
       stability_check_img = check_top_img | check_bottom_img | img;
       
       check_CCImage = bwconncomp(stability_check_img);
       check_LabelImage = bwlabel(stability_check_img);
       
       for obj_no = 1:CCImage.NumObjects
           label_matrix = findLabels(check_LabelImage(CCImage.PixelIdxList{obj_no}),5);
           if label_matrix(1,2)~=0
               fprintf("\n!!!More than two componenets found!\n");
           end
           
          if(numel(check_CCImage.PixelIdxList{label_matrix(1,1)}) < numel(CCImage.PixelIdxList{obj_no}))
              fprintf("\n!!!ERROR IN ASSUMPTION!\n");
              error = 1
          end
          
           if((numel(check_CCImage.PixelIdxList{label_matrix(1,1)})) < (stability_threshold*numel(CCImage.PixelIdxList{obj_no})))
              temp_img(check_CCImage.PixelIdxList{label_matrix(1,1)}) = 1;
          else
              count = count+1;
          end
          
       end
       
       
       rgb_SUImages(:,:,img_no) = temp_img;
      
       
      fprintf('For Image: %d Checked With: %d and %d ----> Checked No of Components removed: %d Components Retained: %d \n',img_no,(img_no-main_offset+1),(img_no-main_offset),count,(CCImage.NumObjects-count)); 
   end
    
    
    q_offset = q_offset+2*main_offset-1;
 end
  


end