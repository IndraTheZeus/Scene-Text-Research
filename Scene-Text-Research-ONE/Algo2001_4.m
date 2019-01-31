
image = imread('03_00.jpg');
  %Parameters
  min_size = 10;
  max_size_factor = 0.25;
  %fitting_factor = 0.5;  
  base_line_factor = 0.25;
  aligned_distance_factor = 1;
  
  na_density_factor = 0.5;
  na_form_factor = 4;
  na_uniformity_factor =0.25;
  
  a_density_factor = 0.85;
  a_form_factor = 4.5;
  a_uniformity_factor = 0.25;
  
% %image = imread('00_06.jpg');
 [row,col,~] = size(image);
 %image = rgb2gray(image);
%  unf_binary = zeros(row,col,729);

gray_image = rgb2gray(image);

%  gray_binary = zeros(row,col,186);
%  red_binary = zeros(row,col,186);
%  green_binary = zeros(row,col,186);
%  blue_binary = zeros(row,col,186);

  stage = 1
 q = [16 32 47 61 75 89 103 115 127];
 q_offset = 0;
 for i = 1:9
   main_offset = ceil(256/q(i));
   k = ceil((q(i)/2)) -1;
   for r = 1:row
        for c = 1:col
           
          value = gray_image(r,c);
         x = q_offset+floor((value)/q(i))+1;

          gray_binary(r,c,x) = 1;
         if value>k && value<255-k
            y = q_offset+main_offset+ceil((value-k)/q(i));
            gray_binary(r,c,y) = 1;
         end
          
         
          
          value = image(r,c,1);
          x = q_offset+floor((value)/q(i))+1;

          red_binary(r,c,x) = 1;
         if value>k && value<255-k
            y = q_offset+main_offset+ceil((value-k)/q(i));
            red_binary(r,c,y) = 1;
         end
%          
%          
           value = image(r,c,2);
         
          x = q_offset+floor(value/q(i))+1;
          green_binary(r,c,x) = 1;
         if value>k && value<255-k
            y = q_offset+main_offset+ceil((value-k)/q(i));
            green_binary(r,c,y) = 1;
         end
         
%          
% %          
         value = image(r,c,3);
       
         x = q_offset+floor(value/q(i))+1;
          blue_binary(r,c,x) = 1;
         if value>k && value<255-k
            y = q_offset+main_offset+ceil((value-k)/q(i));
            blue_binary(r,c,y) = 1;
         end
% % %          
%        
        end   
   end
    
    q_offset = q_offset+2*main_offset-1;
 end

stage=2

% %Invert Images
    
   for sub = 1:93
       gray_binary(:,:,(sub+93)) = not(gray_binary(:,:,sub));
       red_binary(:,:,(sub+93)) = not(red_binary(:,:,sub));
       green_binary(:,:,(sub+93)) = not(green_binary(:,:,sub));
       blue_binary(:,:,(sub+93)) = not(blue_binary(:,:,sub));
   end
   
% %End of Invertor

% upper_size_factor = 0.25*0.25;
% lower_size_factor = 0;

stage=3
palate  = zeros(row,col);


for sub=1:186    %Go through each sub-image and delete large and small components
  
   
   red_img=red_binary(:,:,sub);
   green_img=green_binary(:,:,sub);
   blue_img=blue_binary(:,:,sub);
   gray_img=gray_binary(:,:,sub);

   
   
   CC_red = bwconncomp(red_img);
   CC_green = bwconncomp(green_img);
   CC_blue = bwconncomp(blue_img);
   CC_gray = bwconncomp(gray_img);
   
    red_img_stats = regionprops(CC_red);
   green_img_stats = regionprops(CC_green);
   blue_img_stats = regionprops(CC_blue);
   gray_img_stats = regionprops(CC_gray);
   
   for obj = 1:CC_red.NumObjects
       
       stats = red_img_stats(obj);
       
       if numel(CC_red.PixelIdxList{obj})<10 || max(stats.BoundingBox(3),stats.BoundingBox(4))<min_size || stats.BoundingBox(3)>max_size_factor*col || stats.BoundingBox(4)>max_size_factor*row
           red_img(CC_red.PixelIdxList{obj})=0;
           continue;
       end
          palate(CC_red.PixelIdxList{obj}) = 1;
       
                left = floor(stats.BoundingBox(1));
                if left == 0
                    left = 1;
                end
                right = left+stats.BoundingBox(3)+1;
                if right >col
                    right = col;
                end
                
                top = floor(stats.BoundingBox(2));
                if top == 0
                    top = 1;
                end
                bottom = top + stats.BoundingBox(4)+1;
                if bottom >row
                    bottom = row;
                end
                
          red_img(top:bottom,left:right) = MySmear(palate(top:bottom,left:right));
          palate(top:bottom,left:right) = 0;
   end
   
   for obj = 1:CC_green.NumObjects
       
      stats = green_img_stats(obj);
       
       if numel(CC_green.PixelIdxList{obj}) < 10 || max(stats.BoundingBox(3),stats.BoundingBox(4))<min_size || stats.BoundingBox(3)>max_size_factor*col || stats.BoundingBox(4)>max_size_factor*row
           green_img(CC_green.PixelIdxList{obj})=0;
           continue;
       end
       
        palate(CC_green.PixelIdxList{obj}) = 1;
       
                left = floor(stats.BoundingBox(1));
                if left == 0
                    left = 1;
                end
                right = left+stats.BoundingBox(3)+1;
                if right >col
                    right = col;
                end
                
                top = floor(stats.BoundingBox(2));
                if top == 0
                    top = 1;
                end
                bottom = top + stats.BoundingBox(4)+1;
                if bottom >row
                    bottom = row;
                end
                
          green_img(top:bottom,left:right) = MySmear(palate(top:bottom,left:right));
          palate(top:bottom,left:right) = 0;
     
     
   end
   
     for obj = 1:CC_blue.NumObjects
         
        stats = blue_img_stats(obj);
       
       if numel(CC_blue.PixelIdxList{obj})<10 || max(stats.BoundingBox(3),stats.BoundingBox(4))<min_size || stats.BoundingBox(3)>max_size_factor*col || stats.BoundingBox(4)>max_size_factor*row
           blue_img(CC_blue.PixelIdxList{obj})=0;
           continue;
       end
       
         palate(CC_blue.PixelIdxList{obj}) = 1;
       
                left = floor(stats.BoundingBox(1));
                if left == 0
                    left = 1;
                end
                right = left+stats.BoundingBox(3)+1;
                if right >col
                    right = col;
                end
                
                top = floor(stats.BoundingBox(2));
                if top == 0
                    top = 1;
                end
                bottom = top + stats.BoundingBox(4)+1;
                if bottom >row
                    bottom = row;
                end
                
          blue_img(top:bottom,left:right) = MySmear(palate(top:bottom,left:right));
          palate(top:bottom,left:right) = 0;
       
%      
     
     end
   
    for obj = 1:CC_gray.NumObjects
        
       stats = gray_img_stats(obj);
       
       if max(stats.BoundingBox(3),stats.BoundingBox(4))<min_size || stats.BoundingBox(3)>max_size_factor*col || stats.BoundingBox(4)>max_size_factor*row
           gray_img(CC_gray.PixelIdxList{obj})=0;
           continue;
       end
       
        palate(CC_gray.PixelIdxList{obj}) = 1;
       
                left = floor(stats.BoundingBox(1));
                if left == 0
                    left = 1;
                end
                right = left+stats.BoundingBox(3)+1;
                if right >col
                    right = col;
                end
                
                top = floor(stats.BoundingBox(2));
                if top == 0
                    top = 1;
                end
                bottom = top + stats.BoundingBox(4)+1;
                if bottom >row
                    bottom = row;
                end
                
          gray_img(top:bottom,left:right) = MySmear(palate(top:bottom,left:right));
          palate(top:bottom,left:right) = 0;
%      
     
   end
   
  red_binary(:,:,sub) = red_img;
  green_binary(:,:,sub) = green_img;
  blue_binary(:,:,sub) = blue_img;
  gray_binary(:,:,sub) = gray_img;
end

%  
%   palate = zeros(row,col);
%   aligned_map = zeros(100,1);
%   img_comp_map = zeros(300,1);
  
% stage = 41
% 
%      %Gray Binary
%   for sub = 1:186
%      
%       CC = bwconncomp(gray_binary(:,:,sub));
%       img = gray_binary(:,:,sub);
%       
%      if CC.NumObjects < 1
%          continue;
%      end
%  
%      
% 
%       img_comp_map(:,:) = 0;
%      img_comp_map(1:CC.NumObjects,1) = 1;
%      
%      img_stats = regionprops(CC);
% 
%      
%      for comp = 1:CC.NumObjects
%         
%          
%          if img_comp_map(comp,1) == 0
%              continue;
%          end
%          
%          aligned_map(:,:) = 0;
%          aligns=0;
%          
%          
%          stats = img_stats(comp);
%          height = stats.BoundingBox(4);
%          y_cord = stats.BoundingBox(1)+stats.BoundingBox(3);
%          
% %          upper_top_margin = stats.BoundingBox(2)+height*0.25;
% %          lower_top_margin = stats.BoundingBox(2)-height*0.25;
%          
%          upper_bottom_margin = stats.BoundingBox(2)+height+height*base_line_factor;
%          lower_bottom_margin = stats.BoundingBox(2)+height -height*base_line_factor;
%          
%          for check_comp = 1:CC.NumObjects
%              
%             if check_comp == comp || img_comp_map(check_comp,1) == 0
%                 continue;
%             end
%             
%            
%             
%             stats = img_stats(check_comp);
%             
%             if abs(stats.BoundingBox(1)-y_cord)>aligned_distance_factor*height
%                 continue;
%             end
%             
%             
%           %  height = stats.BoundingBox(4);
%             
%             top_margin = stats.BoundingBox(2);
%             bottom_margin = top_margin + stats.BoundingBox(4);
%             
%             %top_margin>lower_top_margin && top_margin<upper_top_margin && 
%             
%             if bottom_margin>lower_bottom_margin && bottom_margin<upper_bottom_margin
%                
%                 if aligns == 0
%                     aligns = aligns+1;
%                    img_comp_map(comp,1) = 0;
%                    aligned_map(aligns,1) = comp;
%                 end
%                 
%                 height = max(height,stats.BoundingBox(4));
%                 y_cord = stats.BoundingBox(1)+stats.BoundingBox(3); % Possible Error if the next comp is not immediate next
%                 
%                 aligns = aligns+1;
%                 
%                 img_comp_map(check_comp,1) =0;
%                 aligned_map(aligns,1)=check_comp;
%                 
%             end
%             
%          end
%           
%          if aligns == 0
%                %Check Density to eliminate Heavy Non_aligns
%                 stats = img_stats(comp);
%                 left = floor(stats.BoundingBox(1));
%                 if left == 0
%                     left = 1;
%                 end
%                 right = left+stats.BoundingBox(3)+1;
%                 if right >col
%                     right = col;
%                 end
%                 
%                 top = floor(stats.BoundingBox(2));
%                 if top == 0
%                     top = 1;
%                 end
%                 bottom = top + stats.BoundingBox(4)+1;
%                 if bottom >row
%                     bottom = row;
%                 end
%                 palate(CC.PixelIdxList{comp}) = 1;
%                 img_matrix = palate(top:bottom,left:right);
%                 palate(CC.PixelIdxList{comp}) = 0;
%                 if density_check(img_matrix)>na_density_factor || form_factor(img_matrix)>na_form_factor || uniformity_factor(img_matrix)>na_uniformity_factor
%                     img(CC.PixelIdxList{comp}) = 0;
%                 end
%                % img(CC.PixelIdxList{comp}) = 0;
%                %End 
%              %img_na(CC.PixelIdxList{comp}) = comp;   
%          end
%          
%          if aligns>0
%              temp = aligns;
%            
%             total_density=0;
%             total_ff = 0;
%            total_uff = 0;
% 
%             
%            while temp>0
%              stats = img_stats(aligned_map(temp,1));
%                 left = floor(stats.BoundingBox(1));
%                 if left == 0
%                     left = 1;
%                 end
%                 right = left+stats.BoundingBox(3)+1;
%                 if right > col
%                     right = col;
%                 end
%                 
%                 top = floor(stats.BoundingBox(2));
%                 if top == 0
%                     top = 1;
%                 end
%                 bottom = top + stats.BoundingBox(4)+1;
%                 
%                 if bottom > row
%                     bottom = row;
%                 end
%                 palate(CC.PixelIdxList{aligned_map(temp,1)}) = 1;
%                 img_matrix = palate(top:bottom,left:right);
%                 palate(CC.PixelIdxList{aligned_map(temp,1)}) = 0;
%                 total_density = total_density + density_check(img_matrix);
%                 total_ff = total_ff + form_factor(img_matrix);
%           total_uff = total_uff + uniformity_factor(img_matrix);
% 
%                 temp = temp-1;
%            end
%                 
%          end
%             if aligns>0 && ( (total_density/aligns)>a_density_factor || (total_ff/aligns)>a_form_factor  || (total_uff/aligns)>a_uniformity_factor )
%               while aligns>0 
%                  
%                
%                  img(CC.PixelIdxList{aligned_map(aligns,1)}) =0;
%                 
%                  aligns = aligns-1;
%              
%               end
%             end
%          
%          
%          
%      end
%      gray_binary(:,:,sub) = img;
%      
%   end
%   
%      %End
%      
%  stage = 42
%      palate(:,:) = 0;
%      aligned_map(:,:) = 0;
%      img_comp_map(:,:) = 0;
%   
%      %Red Binary
%   for sub = 1:186
%      
%       CC = bwconncomp(red_binary(:,:,sub));
%       img = red_binary(:,:,sub);
%       
%      if CC.NumObjects < 1
%          continue;
%      end
%  
%      
% 
%       img_comp_map(:,:) = 0;
%      img_comp_map(1:CC.NumObjects,1) = 1;
%      
%      img_stats = regionprops(CC);
% 
%      
%      for comp = 1:CC.NumObjects
%         
%          
%          if img_comp_map(comp,1) == 0
%              continue;
%          end
%          
%          aligned_map(:,:) = 0;
%          aligns=0;
%          
%          
%          stats = img_stats(comp);
%          height = stats.BoundingBox(4);
%          y_cord = stats.BoundingBox(1)+stats.BoundingBox(3);
%          
% %          upper_top_margin = stats.BoundingBox(2)+height*0.25;
% %          lower_top_margin = stats.BoundingBox(2)-height*0.25;
%          
%          upper_bottom_margin = stats.BoundingBox(2)+height+height*base_line_factor;
%          lower_bottom_margin = stats.BoundingBox(2)+height -height*base_line_factor;
%          
%          for check_comp = 1:CC.NumObjects
%              
%             if check_comp == comp || img_comp_map(check_comp,1) == 0
%                 continue;
%             end
%             
%            
%             
%             stats = img_stats(check_comp);
%             
%             if abs(stats.BoundingBox(1)-y_cord)>aligned_distance_factor*height
%                 continue;
%             end
%             
%             
%           %  height = stats.BoundingBox(4);
%             
%             top_margin = stats.BoundingBox(2);
%             bottom_margin = top_margin + stats.BoundingBox(4);
%             
%             %top_margin>lower_top_margin && top_margin<upper_top_margin && 
%             
%             if bottom_margin>lower_bottom_margin && bottom_margin<upper_bottom_margin
%                
%                 if aligns == 0
%                     aligns = aligns+1;
%                    img_comp_map(comp,1) = 0;
%                    aligned_map(aligns,1) = comp;
%                 end
%                 
%                 height = max(height,stats.BoundingBox(4));
%                 y_cord = stats.BoundingBox(1)+stats.BoundingBox(3); % Possible Error if the next comp is not immediate next
%                 
%                 aligns = aligns+1;
%                 
%                 img_comp_map(check_comp,1) =0;
%                 aligned_map(aligns,1)=check_comp;
%                 
%             end
%             
%          end
%           
%          if aligns == 0
%                %Check Density to eliminate Heavy Non_aligns
%                 stats = img_stats(comp);
%                 left = floor(stats.BoundingBox(1));
%                 if left == 0
%                     left = 1;
%                 end
%                 right = left+stats.BoundingBox(3)+1;
%                 if right >col
%                     right = col;
%                 end
%                 
%                 top = floor(stats.BoundingBox(2));
%                 if top == 0
%                     top = 1;
%                 end
%                 bottom = top + stats.BoundingBox(4)+1;
%                 if bottom >row
%                     bottom = row;
%                 end
%                 palate(CC.PixelIdxList{comp}) = 1;
%                 img_matrix = palate(top:bottom,left:right);
%                 palate(CC.PixelIdxList{comp}) = 0;
%                 if density_check(img_matrix)>na_density_factor || form_factor(img_matrix)>na_form_factor || uniformity_factor(img_matrix)>na_uniformity_factor
%                     img(CC.PixelIdxList{comp}) = 0;
%                 end
%                % img(CC.PixelIdxList{comp}) = 0;
%                %End 
%              %img_na(CC.PixelIdxList{comp}) = comp;   
%          end
%          
%          if aligns>0
%              temp = aligns;
%            
%             total_density=0;
%             total_ff = 0;
%            total_uff = 0;
% 
%             
%            while temp>0
%              stats = img_stats(aligned_map(temp,1));
%                 left = floor(stats.BoundingBox(1));
%                 if left == 0
%                     left = 1;
%                 end
%                 right = left+stats.BoundingBox(3)+1;
%                 if right > col
%                     right = col;
%                 end
%                 
%                 top = floor(stats.BoundingBox(2));
%                 if top == 0
%                     top = 1;
%                 end
%                 bottom = top + stats.BoundingBox(4)+1;
%                 
%                 if bottom > row
%                     bottom = row;
%                 end
%                 palate(CC.PixelIdxList{aligned_map(temp,1)}) = 1;
%                 img_matrix = palate(top:bottom,left:right);
%                 palate(CC.PixelIdxList{aligned_map(temp,1)}) = 0;
%                 total_density = total_density + density_check(img_matrix);
%                 total_ff = total_ff + form_factor(img_matrix);
%           total_uff = total_uff + uniformity_factor(img_matrix);
% 
%                 temp = temp-1;
%            end
%                 
%          end
%             if aligns>0 && ( (total_density/aligns)>a_density_factor || (total_ff/aligns)>a_form_factor  || (total_uff/aligns)>a_uniformity_factor )
%               while aligns>0 
%                  
%                
%                  img(CC.PixelIdxList{aligned_map(aligns,1)}) =0;
%                 
%                  aligns = aligns-1;
%              
%               end
%             end
%          
%          
%          
%      end
%      red_binary(:,:,sub) = img;
%      
%   end
%    
%   %End
%   
% stage = 43
%    
%        palate(:,:) = 0;
%      aligned_map(:,:) = 0;
%      img_comp_map(:,:) = 0;
% 
%      %Green Binary
%   for sub = 1:186
%     
%       CC = bwconncomp(green_binary(:,:,sub));
%       img = green_binary(:,:,sub);
%       
%      if CC.NumObjects < 1
%          continue;
%      end
%  
%      
% 
%       img_comp_map(:,:) = 0;
%      img_comp_map(1:CC.NumObjects,1) = 1;
%      
%      img_stats = regionprops(CC);
% 
%      
%      for comp = 1:CC.NumObjects
%         
%          
%          if img_comp_map(comp,1) == 0
%              continue;
%          end
%          
%          aligned_map(:,:) = 0;
%          aligns=0;
%          
%          
%          stats = img_stats(comp);
%          height = stats.BoundingBox(4);
%          y_cord = stats.BoundingBox(1)+stats.BoundingBox(3);
%          
% %          upper_top_margin = stats.BoundingBox(2)+height*0.25;
% %          lower_top_margin = stats.BoundingBox(2)-height*0.25;
%          
%          upper_bottom_margin = stats.BoundingBox(2)+height+height*base_line_factor;
%          lower_bottom_margin = stats.BoundingBox(2)+height -height*base_line_factor;
%          
%          for check_comp = 1:CC.NumObjects
%              
%             if check_comp == comp || img_comp_map(check_comp,1) == 0
%                 continue;
%             end
%             
%            
%             
%             stats = img_stats(check_comp);
%             
%             if abs(stats.BoundingBox(1)-y_cord)>aligned_distance_factor*height
%                 continue;
%             end
%             
%             
%           %  height = stats.BoundingBox(4);
%             
%             top_margin = stats.BoundingBox(2);
%             bottom_margin = top_margin + stats.BoundingBox(4);
%             
%             %top_margin>lower_top_margin && top_margin<upper_top_margin && 
%             
%             if bottom_margin>lower_bottom_margin && bottom_margin<upper_bottom_margin
%                
%                 if aligns == 0
%                     aligns = aligns+1;
%                    img_comp_map(comp,1) = 0;
%                    aligned_map(aligns,1) = comp;
%                 end
%                 
%                 height = max(height,stats.BoundingBox(4));
%                 y_cord = stats.BoundingBox(1)+stats.BoundingBox(3); % Possible Error if the next comp is not immediate next
%                 
%                 aligns = aligns+1;
%                 
%                 img_comp_map(check_comp,1) =0;
%                 aligned_map(aligns,1)=check_comp;
%                 
%             end
%             
%          end
%           
%          if aligns == 0
%                %Check Density to eliminate Heavy Non_aligns
%                 stats = img_stats(comp);
%                 left = floor(stats.BoundingBox(1));
%                 if left == 0
%                     left = 1;
%                 end
%                 right = left+stats.BoundingBox(3)+1;
%                 if right >col
%                     right = col;
%                 end
%                 
%                 top = floor(stats.BoundingBox(2));
%                 if top == 0
%                     top = 1;
%                 end
%                 bottom = top + stats.BoundingBox(4)+1;
%                 if bottom >row
%                     bottom = row;
%                 end
%                 palate(CC.PixelIdxList{comp}) = 1;
%                 img_matrix = palate(top:bottom,left:right);
%                 palate(CC.PixelIdxList{comp}) = 0;
%                 if density_check(img_matrix)>na_density_factor || form_factor(img_matrix)>na_form_factor || uniformity_factor(img_matrix)>na_uniformity_factor
%                     img(CC.PixelIdxList{comp}) = 0;
%                 end
%                % img(CC.PixelIdxList{comp}) = 0;
%                %End 
%              %img_na(CC.PixelIdxList{comp}) = comp;   
%          end
%          
%          if aligns>0
%              temp = aligns;
%            
%             total_density=0;
%             total_ff = 0;
%            total_uff = 0;
% 
%             
%            while temp>0
%              stats = img_stats(aligned_map(temp,1));
%                 left = floor(stats.BoundingBox(1));
%                 if left == 0
%                     left = 1;
%                 end
%                 right = left+stats.BoundingBox(3)+1;
%                 if right > col
%                     right = col;
%                 end
%                 
%                 top = floor(stats.BoundingBox(2));
%                 if top == 0
%                     top = 1;
%                 end
%                 bottom = top + stats.BoundingBox(4)+1;
%                 
%                 if bottom > row
%                     bottom = row;
%                 end
%                 palate(CC.PixelIdxList{aligned_map(temp,1)}) = 1;
%                 img_matrix = palate(top:bottom,left:right);
%                 palate(CC.PixelIdxList{aligned_map(temp,1)}) = 0;
%                 total_density = total_density + density_check(img_matrix);
%                 total_ff = total_ff + form_factor(img_matrix);
%           total_uff = total_uff + uniformity_factor(img_matrix);
% 
%                 temp = temp-1;
%            end
%                 
%          end
%             if aligns>0 && ( (total_density/aligns)>a_density_factor || (total_ff/aligns)>a_form_factor  || (total_uff/aligns)>a_uniformity_factor )
%               while aligns>0 
%                  
%                
%                  img(CC.PixelIdxList{aligned_map(aligns,1)}) =0;
%                 
%                  aligns = aligns-1;
%              
%               end
%             end
%          
%          
%          
%      end
%      green_binary(:,:,sub) = img;
%      
%   end
%    
%     %End 
%     
% stage = 44
%     
%      palate(:,:) = 0;
%      aligned_map(:,:) = 0;
%      img_comp_map(:,:) = 0;
%   
%   %Blue Binary
%   for sub = 1:186
%     
%       CC = bwconncomp(blue_binary(:,:,sub));
%       img = blue_binary(:,:,sub);
%       
%      if CC.NumObjects < 1
%          continue;
%      end
%  
%      
% 
%       img_comp_map(:,:) = 0;
%      img_comp_map(1:CC.NumObjects,1) = 1;
%      
%      img_stats = regionprops(CC);
% 
%      
%      for comp = 1:CC.NumObjects
%         
%          
%          if img_comp_map(comp,1) == 0
%              continue;
%          end
%          
%          aligned_map(:,:) = 0;
%          aligns=0;
%          
%          
%          stats = img_stats(comp);
%          height = stats.BoundingBox(4);
%          y_cord = stats.BoundingBox(1)+stats.BoundingBox(3);
%          
% %          upper_top_margin = stats.BoundingBox(2)+height*0.25;
% %          lower_top_margin = stats.BoundingBox(2)-height*0.25;
%          
%          upper_bottom_margin = stats.BoundingBox(2)+height+height*base_line_factor;
%          lower_bottom_margin = stats.BoundingBox(2)+height -height*base_line_factor;
%          
%          for check_comp = 1:CC.NumObjects
%              
%             if check_comp == comp || img_comp_map(check_comp,1) == 0
%                 continue;
%             end
%             
%            
%             
%             stats = img_stats(check_comp);
%             
%             if abs(stats.BoundingBox(1)-y_cord)>aligned_distance_factor*height
%                 continue;
%             end
%             
%             
%           %  height = stats.BoundingBox(4);
%             
%             top_margin = stats.BoundingBox(2);
%             bottom_margin = top_margin + stats.BoundingBox(4);
%             
%             %top_margin>lower_top_margin && top_margin<upper_top_margin && 
%             
%             if bottom_margin>lower_bottom_margin && bottom_margin<upper_bottom_margin
%                
%                 if aligns == 0
%                     aligns = aligns+1;
%                    img_comp_map(comp,1) = 0;
%                    aligned_map(aligns,1) = comp;
%                 end
%                 
%                 height = max(height,stats.BoundingBox(4));
%                 y_cord = stats.BoundingBox(1)+stats.BoundingBox(3); % Possible Error if the next comp is not immediate next
%                 
%                 aligns = aligns+1;
%                 
%                 img_comp_map(check_comp,1) =0;
%                 aligned_map(aligns,1)=check_comp;
%                 
%             end
%             
%          end
%           
%          if aligns == 0
%                %Check Density to eliminate Heavy Non_aligns
%                 stats = img_stats(comp);
%                 left = floor(stats.BoundingBox(1));
%                 if left == 0
%                     left = 1;
%                 end
%                 right = left+stats.BoundingBox(3)+1;
%                 if right >col
%                     right = col;
%                 end
%                 
%                 top = floor(stats.BoundingBox(2));
%                 if top == 0
%                     top = 1;
%                 end
%                 bottom = top + stats.BoundingBox(4)+1;
%                 if bottom >row
%                     bottom = row;
%                 end
%                 palate(CC.PixelIdxList{comp}) = 1;
%                 img_matrix = palate(top:bottom,left:right);
%                 palate(CC.PixelIdxList{comp}) = 0;
%                 if density_check(img_matrix)>na_density_factor || form_factor(img_matrix)>na_form_factor || uniformity_factor(img_matrix)>na_uniformity_factor
%                     img(CC.PixelIdxList{comp}) = 0;
%                 end
%                % img(CC.PixelIdxList{comp}) = 0;
%                %End 
%              %img_na(CC.PixelIdxList{comp}) = comp;   
%          end
%          
%          if aligns>0
%              temp = aligns;
%            
%             total_density=0;
%             total_ff = 0;
%            total_uff = 0;
% 
%             
%            while temp>0
%              stats = img_stats(aligned_map(temp,1));
%                 left = floor(stats.BoundingBox(1));
%                 if left == 0
%                     left = 1;
%                 end
%                 right = left+stats.BoundingBox(3)+1;
%                 if right > col
%                     right = col;
%                 end
%                 
%                 top = floor(stats.BoundingBox(2));
%                 if top == 0
%                     top = 1;
%                 end
%                 bottom = top + stats.BoundingBox(4)+1;
%                 
%                 if bottom > row
%                     bottom = row;
%                 end
%                 palate(CC.PixelIdxList{aligned_map(temp,1)}) = 1;
%                 img_matrix = palate(top:bottom,left:right);
%                 palate(CC.PixelIdxList{aligned_map(temp,1)}) = 0;
%                 total_density = total_density + density_check(img_matrix);
%                 total_ff = total_ff + form_factor(img_matrix);
%           total_uff = total_uff + uniformity_factor(img_matrix);
% 
%                 temp = temp-1;
%            end
%                 
%          end
%             if aligns>0 && ( (total_density/aligns)>a_density_factor || (total_ff/aligns)>a_form_factor  || (total_uff/aligns)>a_uniformity_factor )
%               while aligns>0 
%                  
%                
%                  img(CC.PixelIdxList{aligned_map(aligns,1)}) =0;
%                 
%                  aligns = aligns-1;
%              
%               end
%             end
%          
%          
%          
%      end
%      blue_binary(:,:,sub) = img;
%      
%   end
%   
%    %End of Blue Binary




% 
%   fitting_factor = 0.5;
%   edge_image = edge(gray_image,'Canny')+edge(gray_image,'Prewitt') + edge(gray_image,'Sobel');
%      Palate = zeros(row,col);
%      for sub = 1:186
%         sub 
%          CC_gray = bwconncomp(gray_binary(:,:,sub));
%         CC_red = bwconncomp(red_binary(:,:,sub));
%          CC_green = bwconncomp(green_binary(:,:,sub));
%           CC_blue = bwconncomp(blue_binary(:,:,sub));
%           
%          gray_img_stats = regionprops(CC_gray);                       %Speed Up Code
%         red_img_stats = regionprops(CC_red);
%          green_img_stats = regionprops(CC_green);
%          blue_img_stats = regionprops(CC_blue);
%          
%         %gray Puzzle Fitting
%          img = gray_binary(:,:,sub);
%          CC = CC_gray;
%          img_stats = gray_img_stats;
%          
%        for comp = 1:CC.NumObjects
%             
%        primary_region = CC.PixelIdxList{comp};
%       
%        Palate(primary_region) = 1;
%        stats = img_stats(comp);
%       
%        left = floor(stats.BoundingBox(1));
%        if left <1
%            left = 1;
%        end
%        right = left + stats.BoundingBox(3)+1;
%        if right > col
%            right = col;
%        end
%        top = floor(stats.BoundingBox(2));
%        if top == 0
%            top=1;
%        end
%        bottom = top + stats.BoundingBox(4)+1;
%        if bottom > row
%            bottom = row;
%        end
%        
%        Palate(top:bottom,left:right) = MyEdge(Palate(top:bottom,left:right));      %Speed Up adjustment
%        
%        if fitting_ratio(Palate(top:bottom,left:right),edge_image(top:bottom,left:right))<fitting_factor
%            
%            img(primary_region) = 0;
%        end
%        
%        Palate(primary_region) = 0;
%             
%       end
%          gray_binary(:,:,sub) = img;
%          
%          %End of Gray Puzzle Fitting
%          
%          %Red Puzzle Fitting
%          
%          img = red_binary(:,:,sub);
%          CC = CC_red;
%          img_stats = red_img_stats;
%            
%      for comp = 1:CC.NumObjects
%             
%        primary_region = CC.PixelIdxList{comp};
%       
%        Palate(primary_region) = 1;
%        stats = img_stats(comp);
%       
%        left = floor(stats.BoundingBox(1));
%        if left == 0
%            left = 1;
%        end
%        right = left + stats.BoundingBox(3)+1;
%        if right >col
%            right = col;
%        end
%        top = floor(stats.BoundingBox(2));
%        if top == 0
%            top=1;
%        end
%        bottom = top + stats.BoundingBox(4)+1;
%        if bottom >row
%            bottom = row;
%        end
%        
%        Palate(top:bottom,left:right) = MyEdge(Palate(top:bottom,left:right));      %Speed Up adjustment
%        
%        if fitting_ratio(Palate(top:bottom,left:right),edge_image(top:bottom,left:right))<fitting_factor
%            
%            img(primary_region) = 0;
%        end
%        
%        Palate(primary_region) = 0;
%             
%      end
%         red_binary(:,:,sub) = img;   
%        
%          %End of Red Puzzle FItting
%          
%          %Green Puzzle Fitting
%          
%            img = green_binary(:,:,sub);
%          CC = CC_green;
%          img_stats = green_img_stats;
%        for comp = 1:CC.NumObjects
%             
%        primary_region = CC.PixelIdxList{comp};
%       
%        Palate(primary_region) = 1;
%        stats = img_stats(comp);
%       
%        left = floor(stats.BoundingBox(1));
%        if left == 0
%            left = 1;
%        end
%        right = left + stats.BoundingBox(3)+1;
%        if right > col
%            right = col;
%        end
%        top = floor(stats.BoundingBox(2));
%        if top == 0
%            top=1;
%        end
%        bottom = top + stats.BoundingBox(4)+1;
%        if bottom > row
%            bottom = row;
%        end
%        
%        Palate(top:bottom,left:right) = MyEdge(Palate(top:bottom,left:right));      %Speed Up adjustment
%        
%        if fitting_ratio(Palate(top:bottom,left:right),edge_image(top:bottom,left:right))<fitting_factor
%            
%            img(primary_region) = 0;
%        end
%        
%        Palate(primary_region) = 0;
%             
%       end
%          green_binary(:,:,sub) = img;
%          
%          %End of Green Puzzle Fitting
%          
%          %Blue Puzzle Fitting
%          
%           img = blue_binary(:,:,sub);
%          CC = CC_blue;
%          img_stats = blue_img_stats;
%        for comp = 1:CC.NumObjects
%             
%        primary_region = CC.PixelIdxList{comp};
%       
%        Palate(primary_region) = 1;
%        stats = img_stats(comp);
%       
%        left = floor(stats.BoundingBox(1));
%        if left <1
%            left = 1;
%        end
%        right = left + stats.BoundingBox(3)+1;
%        if right >col
%            right = col;
%        end
%        top = floor(stats.BoundingBox(2));
%        if top < 1
%            top=1;
%        end
%        bottom = top + stats.BoundingBox(4)+1;
%        if bottom > row
%            bottom = row;
%        end
%        
%        Palate(top:bottom,left:right) = MyEdge(Palate(top:bottom,left:right));      %Speed Up adjustment
%        
%        if fitting_ratio(Palate(top:bottom,left:right),edge_image(top:bottom,left:right))<fitting_factor
%            
%            img(primary_region) = 0;
%          %  img(top:bottom,left:right) = Palate(top:bottom,left:right);
%        end
%        
%        Palate(primary_region) = 0;
%             
%       end
%          blue_binary(:,:,sub) = img;
%          
%          %End of Blue Puzzle Fitting
%          
%          
%      end
%   
% 
% %Puzzle Fitting Edge Detection
% 
%   image_component_map = zeros(128,300);
%   Label_quanta = zeros(row,col,128);
%   for i = 1:128
%      CC_quanta(i) = bwconncomp(smeared(:,:,i));
%      Stats_quanta(i,1:CC_quanta(i).NumObjects) = regionprops(CC_quanta(i));
%      Label_quanta(:,:,i) = bwlabel(smeared(:,:,i));
%      image_component_map(i,1:CC_quanta(i).NumObjects) = 1;
%   end
%   
%  edge_image = edge(rgb2gray(image),'Canny');
%  
%  components = zeros(128,50);   % Stores the componenents overlapping with a particular region
%  
%  fitting_map = zeros(128,2);  % Stores the fitting ratios of each sub_image scanned(for that particular region)
%  
%  Fitted_img = zeros(row,col);
%  
%  Palate = zeros(row,col);
%  
% for sub = 1:127
%   
%     CC = CC_quanta(sub);
%    % img_stats = Stats_quanta(sub);                    % Speed Up Code
%   % Label = Label_quanta(:,:,sub);
%     for comp = 1:CC.NumObjects
%         
%         if image_component_map(sub,comp) == 0
%             continue;
%         end
%        components(:,:) = 0;
%        fitting_map(:,:) = 0;
%        
%        primary_region = CC.PixelIdxList{comp};
%        
%        %Fill palate with the primary comp,find fitting ratio
%        components(sub,1) = comp; 
%        Palate(primary_region) = 1;
%        
%        stats = Stats_quanta(sub,comp);                       %Speed Up Code
%        left = floor(stats.BoundingBox(1));
%        if left == 0
%            left = 1;
%        end
%        right = left + stats.BoundingBox(3);
%        if right == col+1
%            right = col;
%        end
%        top = floor(stats.BoundingBox(2));
%        if top == 0
%            top=1;
%        end
%        bottom = top + stats.BoundingBox(4);
%        if bottom == row+1
%            bottom = row;
%        end
%        Palate(top:bottom,left:right) = MyEdge(Palate(top:bottom,left:right));      %Speed Up adjustment
%        
%        fitting_map(sub,:) = fitting_ratio(Palate(top:bottom,left:right),edge_image(top:bottom,left:right));  %Speed Up adjustment
%        
%        Palate(primary_region) = 0;
%        
%        for check_img = (sub+1):128
%            CC_check = CC_quanta(check_img);
%            Label = Label_quanta(:,:,check_img);
%            
%            %img_stats = Stats_quanta(check_img); %speed up code
%            left = -1;
%            right = -1;
%            top = -1;
%            bottom = -1;
%            
%            components(check_img,:) = findLabels(Label(primary_region));
%            if components(check_img,1) == 0
%                continue;
%            end
%            
%            %Fill palate with components,find the fitting ratio
%            for i = 1:50
%                
%               if components(check_img,i) == 0
%                   break;
%               end
%                  stats = Stats_quanta(check_img,components(check_img,i));         %Speed Up COde
%                    if left == -1 
%                          left = floor(stats.BoundingBox(1));
%                          if left == 0
%                             left = 1;
%                          end
%                          right = left + stats.BoundingBox(3);
%                          if right == col+1
%                            right = col;
%                          end
%                        top = floor(stats.BoundingBox(2));
%                        if top == 0
%                          top=1;
%                        end
%                       bottom = top + stats.BoundingBox(4);
%                      if bottom == row+1
%                       bottom = row;
%                      end
%                     
%                    else
%                         left = min(left,floor(stats.BoundingBox(1)));
%                          if left == 0
%                           left = 1;
%                          end
%                        right = max(right,floor(stats.BoundingBox(1)) + stats.BoundingBox(3));
%                         if right == col+1
%                             right = col;
%                         end
%                         top = min(top,floor(stats.BoundingBox(2)));
%                         if top == 0
%                           top=1;
%                         end
%                         bottom = max(bottom,floor(stats.BoundingBox(2)) + stats.BoundingBox(4));
%                         if bottom == row+1
%                            bottom = row;
%                         end
%                         
%                    end
%                    
%                Palate(CC_check.PixelIdxList{components(check_img,i)}) = 1;
%                
%                
%            end
%            Palate(top:bottom,left:right) = MyEdge(Palate(top:bottom,left:right));    %Speed Up adjustment
%            fitting_map(check_img,:) = fitting_ratio(Palate(top:bottom,left:right),edge_image(top:bottom,left:right));
%            Palate(top:bottom,left:right) = 0;
%            
%            
%        end
%        
%        
%        %Finding Largest Fitting ratio or the largest component for same
%        %fitting ratio
%        
%        largest  = sub;
%        
%        for i = (sub+1):128
%            
%           if fitting_map(largest,1)<0.5 && fitting_map(i,1)>0.5                                                          %fitting_map(i,1)>1.25*fitting_map(largest,1)
%               largest = i;
%           
%           else
%           if fitting_map(i,2) > fitting_map(largest,2)
% %                  if fitting_map(i,2)> fitting_map(largest,2)
% %                       largest = i;
% %                  end
%               largest = i;
%           end
%           end          
%        end
%         
%        %Delete all regions except the one with largest fitting ratio
%         for del = sub:128
%            
%             if del == largest
%                continue;
%             end
%            
%           
%          %  img = smeared(:,:,del);
%           % CC_del = CC_quanta(del);
%            
%            for j = 1:50
%                
%               if components(del,j) == 0
%                   break;
%               end
%               c = components(del,j);
%               [sub comp del c]
%               image_component_map(del,c) = 0;
% %               region = CC_del.PixelIdxList{c};
% %               img(region) = 0;
%            end
%            
%            %  smeared(:,:,del) = img;
%              
%         end
%     end
% end
% 
% for i = 1:128
%     
%    for comp = 1:CC_quanta(i).NumObjects
%       if image_component_map(i,comp) == 0
%           continue;
%       end
%       
%       Fitted_img(CC_quanta(i).PixelIdxList{comp}) = 1; 
%    end
% end

% %Alignment Analysis with density Calculation
% palate = zeros(row,col);
%  aligned = zeros(row,col,64);
%   non_aligned = zeros(row,col,64);
%   img_comp_map = zeros(300,1);
% 
%   for sub = 1:64
%      
%       CC = bwconncomp(smeared(:,:,sub));
%       
%      if CC.NumObjects < 1
%          continue;
%      end
%  
%      
%      img = smeared(:,:,sub);
%       img_comp_map(:,:) = 0;
%      img_comp_map(1:CC.NumObjects,1) = 1;
%      
%      img_stats = regionprops(CC);
%      img_a = aligned(:,:,sub);
%      img_na = non_aligned(:,:,sub);
%      
%      for comp = 1:CC.NumObjects
%         
%          
%          if img_comp_map(comp,1) == 0
%              continue;
%          end
%          
%          aligned_map(:,:) = 0;
%          aligns=0;
%          
%          
%          stats = img_stats(comp);
%          height = stats.BoundingBox(4);
%          y_cord = stats.BoundingBox(1)+stats.BoundingBox(3);
%          
%          upper_top_margin = stats.BoundingBox(2)+height*0.25;
%          lower_top_margin = stats.BoundingBox(2)-height*0.25;
%          
%          upper_bottom_margin = stats.BoundingBox(2)+height+height*0.25;
%          lower_bottom_margin = stats.BoundingBox(2)+height -height*0.25;
%          
%          for check_comp = 1:CC.NumObjects
%              
%             if check_comp == comp || img_comp_map(check_comp,1) == 0
%                 continue;
%             end
%             
%            
%             
%             stats = img_stats(check_comp);
%             
%             if abs(stats.BoundingBox(1)-y_cord)>height*0.25
%                 continue;
%             end
%             
%             
%             height = stats.BoundingBox(4);
%             
%             top_margin = stats.BoundingBox(2);
%             bottom_margin = top_margin + height;
%             
%             if top_margin>lower_top_margin && top_margin<upper_top_margin && bottom_margin>lower_bottom_margin && bottom_margin<upper_bottom_margin
%                
%                 if aligns == 0
%                     aligns = aligns+1;
%                    img_comp_map(comp,1) = 0;
%                    aligned_map(aligns,1) = comp;
%                 end
%                 
%                 y_cord = stats.BoundingBox(1)+stats.BoundingBox(3); % Possible Error if the next comp is not immediate next
%                 
%                 aligns = aligns+1;
%                 
%                 img_comp_map(check_comp,1) =0;
%                 aligned_map(aligns,1)=check_comp;
%                 
%             end
%             
%          end
%           
%          if aligns == 0
%                %Check Density to eliminate Heavy Non_aligns
%                 stats = img_stats(comp);
%                 left = floor(stats.BoundingBox(1));
%                 if left == 0
%                     left = 1;
%                 end
%                 right = left+stats.BoundingBox(3);
%                 
%                 top = floor(stats.BoundingBox(2));
%                 if top == 0
%                     top = 1;
%                 end
%                 bottom = top + stats.BoundingBox(4);
%                 palate(CC.PixelIdxList{comp}) = 1;
%                 img_matrix = palate(top:bottom,left:right);
%                 palate(CC.PixelIdxList{comp}) = 0;
%                 if density_check(img_matrix)<0.75 && form_factor(img_matrix)<4
%                     img_na(CC.PixelIdxList{comp}) = comp;
%                 end
%                
%                %End 
%              %img_na(CC.PixelIdxList{comp}) = comp;   
%          end
%          
%          if aligns>0
%              temp = aligns;
%            
%             total_density=0;
%             total_ff = 0;
%            while temp>0
%              stats = img_stats(aligned_map(temp,1));
%                 left = floor(stats.BoundingBox(1));
%                 if left == 0
%                     left = 1;
%                 end
%                 right = left+stats.BoundingBox(3);
%                 
%                 top = floor(stats.BoundingBox(2));
%                 if top == 0
%                     top = 1;
%                 end
%                 bottom = top + stats.BoundingBox(4);
%                 palate(CC.PixelIdxList{aligned_map(temp,1)}) = 1;
%                 img_matrix = palate(top:bottom,left:right);
%                 palate(CC.PixelIdxList{aligned_map(temp,1)}) = 0;
%                 total_density = total_density + density_check(img_matrix);
%                 total_ff = total_ff + form_factor(img_matrix);
%                 temp = temp-1;
%            end
%            
%              
%          end
%             if aligns>0 && (total_density/aligns)<0.88 && (total_ff/aligns)<4.5
%               while aligns>0 
%                  
%                
%                  img_a(CC.PixelIdxList{aligned_map(aligns,1)}) =comp;
%                 
%                  aligns = aligns-1;
%              
%               end
%             end
%          
%          
%          
%      end
%      aligned(:,:,sub) = img_a;
%      non_aligned(:,:,sub) = img_na;
%      
%      
%       
%   end
%   
%     %Combining Aligned Images
%      final_img = zeros(row,col);
%       for al = 1:64
%     
%            final_img = final_img + aligned(:,:,al);
%       end
%     %

%Alignment Analysis Code Original
  
%   aligned = zeros(row,col,64);
%   non_aligned = zeros(row,col,64);
%   img_comp_map = zeros(300,1);
%   for sub = 1:64
%      
%       CC = bwconncomp(smeared(:,:,sub));
%       
%      if CC.NumObjects == 0
%          continue;
%      end
%      
%      img_comp_map(1:CC.NumObjects,1) = 1;
%      
%      img_stats = regionprops(CC);
%      img_a = aligned(:,:,sub);
%      img_na = non_aligned(:,:,sub);
%      
%      for comp = 1:CC.NumObjects
%         
%          [sub comp]
%          if img_comp_map(comp,1) == 0
%              continue;
%          end
%          
%          aligned_map = zeros(100,1);
%          aligns=0;
%          
%          
%          stats = img_stats(comp);
%          height = stats.BoundingBox(4);
%          
%          upper_top_margin = stats.BoundingBox(2)+height*0.25;
%          lower_top_margin = stats.BoundingBox(2)-height*0.25;
%          
%          upper_bottom_margin = stats.BoundingBox(2)+height+height*0.25;
%          lower_bottom_margin = stats.BoundingBox(2)+height -height*0.25;
%          
%          for check_comp = 1:CC.NumObjects
%              
%             if check_comp == comp
%                 continue;
%             end
%             
%             stats = img_stats(check_comp);
%             
%             height = stats.BoundingBox(4);
%             
%             top_margin = stats.BoundingBox(2);
%             bottom_margin = top_margin + height;
%             
%             if top_margin>lower_top_margin && top_margin<upper_top_margin && bottom_margin>lower_bottom_margin && bottom_margin<upper_bottom_margin
%                
%                 if aligns == 0
%                     aligns = aligns+1;
%                    img_comp_map(comp,1) = 0;
%                    aligned_map(aligns,1) = comp;
%                 end
%                 
%                 aligns = aligns+1;
%                 
%                 img_comp_map(check_comp,1) =0;
%                 aligned_map(aligns,1)=check_comp;
%                 
%             end
%             
%          end
%          
%          if aligns == 0
%             
%           img_na(CC.PixelIdxList{comp}) = 1;
%          end
%             
%              while aligns>0
%                  
%                  
%                  img_a(CC.PixelIdxList{aligned_map(aligns,1)}) =1;
%                  aligns = aligns-1;
%              
%              end
%          
%          
%      end
%      
%      aligned(:,:,sub) = img_a;
%      non_aligned(:,:,sub) = img_na;
%       
%   end
  


%End of Alignment analysis code

% reduced_imgs = zeros(row,col,64);
% NumImages = 0;
% 
% for scan = 1:64
%    
%     scan_img = smeared(:,:,scan);
%     scan_CC = bwconncomp(scan_img);
%    
%     FinalNo = scan_CC.NumObjects;
%    
%    if scan_CC.NumObjects>0
%     for comp = 1:scan_CC.NumObjects
%        check_area = scan_CC.PixelIdxList{comp};
%        
%        for check = 1:64
%           if check == scan
%               continue;
%           end
%           
%            check_img = smeared(:,:,check);
%            if isSubsetOf(scan_img(check_area),check_img(check_area))==1
%               
%                scan_img(check_area) = 0;
%                FinalNo = FinalNo-1;
%                break;
%                
%            end
%            
%        end
%         
%         
%     end
%     
%    end
%     
%     smeared(:,:,scan) = scan_img;
%     
%     if FinalNo>0
%         NumImages = NumImages+1;
%         reduced_imgs(:,:,NumImages)=scan_img;
%     end
%     
%     
% end
% 







% for sub = 1:64
%     
%       CC = bwconncomp(smeared(:,:,sub));
%    
%    if CC.NumObjects>0
%        
%       isDisjoint = 1;
%       
%       for check_sub = 1:64
%           
%           if check_sub == sub
%               continue;
%           end
%           
%          if isSubsetOf(smeared(:,:,sub),smeared(:,:,check_sub))
%           
%             isDisjoint = 0;
%          end
%       end
%       
%       if isDisjoint == 1
%          
%      
%       
%       NumImages = NumImages+1;
%       
%       quanta(:,:,NumImages) = smeared(:,:,sub);
%       
%       CC_quanta(NumImages) = CC;
%       
%       BW_quanta(:,:,NumImages) = bwlabel(quanta(:,:,NumImages));
%       
%       end 
%       
%       NumImages
%        
%    end
%    
%     
% end
% 
% 
% 
% reduced_imgs = zeros(row,col,NumImages);
% reduced = 1;
% 
% for img=1:(NumImages)
%     
%     if img == NumImages
%         
%        reduced = reduced+1;
%        reduced_imgs(:,:,reduced) = quanta(:,:,img);
%       break;  
%     end
%     
%   
%    hasComponents = 0;
%    for comp = 1:(CC_quanta(img).NumObjects+1)
%     
%        if comp == (CC_quanta(img).NumObjects+1)
%            
%           if hasComponents ==1
%            reduced = reduced+1;
%           end
%            break;
%        end
%       
%        
%       selected = img;
%       selected_comp = CC_quanta(img).PixelIdxList{comp};
%       selected_img = quanta(:,:,img);
%       selectedBW_img = BW_quanta(:,:,img);
%       components = findLabels(selectedBW_img(selected_comp));
%       
%       if components(1,1) ==0
%           continue;
%       end
%       hasComponents =1;
%        
%       
%       for scan = (img+1):NumImages
%          
%           [reduced img comp scan]
%           
%           
%           scan_img = quanta(:,:,scan);
%           scanBW_img = BW_quanta(:,:,scan);
%           components = findLabels(scanBW_img(selected_comp));
%           if components(1,1) ==0
%               continue;
%           end
%           
%           scan_comp = CC_quanta(scan).PixelIdxList{components(1,1)};
%           
%           
%           for c_i = 2:10
%              
%               if components(1,c_i) ==0
%                   break;
%               end
%               
%               temp = vertcat(CC_quanta(scan).PixelIdxList{components(1,c_i)},scan_comp);
%               scan_comp = temp;
%           end
%           
%            if numel(scan_comp) <= numel(selected_comp)
%               if isSubsetOf(logical(scan_img(selected_comp)),logical(selected_img(selected_comp))) == 1
%                  scan_img(selected_comp)=0;
%                  scan_img(scan_comp)= 0;
%                  quanta(:,:,scan) = scan_img;
%                  scanBW_img(selected_comp) = 0;
%                  scanBW_img(scan_comp) = 0;
%                  BW_quanta(:,:,scan) = scanBW_img; 
%                   
%               end
%           end
%           
%           
%           if numel(scan_comp)>numel(selected_comp)
%               if isSubsetOf(logical(selected_img(scan_comp)),logical(scan_img(scan_comp))) == 1
%                  selected_img(scan_comp)=0;
%                  selected_img(selected_comp) = 0;
%                  quanta(:,:,selected) = selected_img;
%                  selectedBW_img(scan_comp) = 0;
%                  selectedBW_img(selected_comp) = 0;
%                  BW_quanta(:,:,selected) = selectedBW_img;
%                  
%                  selected = scan;
%                  selected_img = scan_img;
%                  selected_comp = scan_comp;
%                  selectedBW_img = scanBW_img;
%                 
%               end
%               
%           end
%           
%          
%           
%       end
%       
%    
%       reduced_temp = reduced_imgs(:,:,reduced);
%       
%       reduced_temp(selected_comp) = 1;
%       
%       selected_img(selected_comp) = 0;
%       quanta(:,:,selected) = selected_img;
%       
%       selectedBW_img(selected_comp) = 0;
%       BW_quanta(:,:,selected) = selectedBW_img;
%       
%       reduced_imgs(:,:,reduced) = reduced_temp;
%    
%       
%        
%    end
%     
% end



% BW_Label = bwlabel(smeared(:,:,21));
% BW_Conn = bwconncomp(smeared(:,:,21));
% component_matrix = BW_Conn.PixelIdxList{1};
% label = BW_Label(component_matrix(1));
% label

        
   
%  final_img = zeros(row,col);
%  final_imgs = zeros(row,col,NumImages);
%  check = zeros(row,col,NumImages,NumImages);
%  
%  for img = 1:(NumImages)
%     
%      img
%      primary_img = quanta(:,:,img);
%      
%      if img==NumImages
%          final_img =final_img+primary_img;
%          
%          final_imgs(:,:,img) = final_img;
%      break;
%      end
%      
%      for comp = 1:CC_quanta(img).NumObjects
%         comp
%          primary_region = CC_quanta(img).PixelIdxList{comp};
%          
%          comp_matrix = zeros(NumImages,10);
%          
%          img_region_strength = zeros(NumImages,1);
%          img_region_strength(img,1) = 1;
%          for scan = (img+1):NumImages
%             scan
%              temp = quanta(:,:,scan);
%              
%              
%              
%              if isSubsetOf(temp(primary_region),primary_img(primary_region))==1
%                 
%                  img_region_strength(img,1) = img_region_strength(img,1)+1;
%                  
%              end
%              
%          end
%          
%          comp_matrix(img,1)=comp;
%          for competition = img+1:NumImages
%             competition
%              temp = BW_quanta(:,:,competition);
%              comp_matrix(competition,:) = findLabels(temp(primary_region));
%              
%              if comp_matrix(competition,1)==0
%                  continue;
%              end
%              
%              full_area = CC_quanta(competition).PixelIdxList{comp_matrix(competition,1)};
%              
%              for cm_i = 2:10
%                 
%                  if comp_matrix(competition,cm_i) == 0
%                      break;
%                  end
%                  
%                 full_area = vertcat(CC_quanta(competition).PixelIdxList{comp_matrix(competition,cm_i)},full_area); 
%                  
%                  
%              end
%              
%              for scan = img+1:NumImages
%                 
%                  if scan==competition
%                      
%                     img_region_strength(competition,1) = img_region_strength(competition,1)+1; 
%                     continue;
%                  end
%                  
%                  temp = quanta(:,:,scan);
%                  tempB = quanta(:,:,competition);
%                  
%                  if isSubsetOf(temp(full_area),tempB(full_area))==1
%                     
%                      img_region_strength(competition,1)=img_region_strength(competition,1)+1;
%                  end
%                  
%              end
%              
%              
%          end
%          
%          priority_img =img;
%          
%          for i=img:NumImages
%             
%              if img_region_strength(i,1) > img_region_strength(priority_img,1)
%                 
%                  priority_img = i;
%              end
%              
%          end
%          
%          for p_i = 1:10
%             
%              if comp_matrix(priority_img,p_i)==0
%                 break; 
%              end
%              
%              final_img(CC_quanta(priority_img).PixelIdxList{comp_matrix(priority_img,p_i)}) = 1;
%              
%              
%              
%          end
%          
%         
%          for del = img:NumImages
%              
%              if comp_matrix(del,1)==0
%                  continue;
%              end
%              
%              del_area = CC_quanta(del).PixelIdxList{comp_matrix(del,1)};
%              
%              for c_i = 2:10
%                 
%                  if comp_matrix(del,c_i)==0
%                     break; 
%                  end
%                  
%                  del_area = vertcat(CC_quanta(del).PixelIdxList{comp_matrix(del,c_i)},del_area);
%                  
%               
%                  
%              end
%                 temp = quanta(:,:,del);
%                 temp(del_area) = 0;
%                 
%                 quanta(:,:,del) = temp;   
%              
%          end
%          
%      end
%      
%      check(:,:,:,img) = quanta(:,:,1:NumImages);
%      final_imgs(:,:,img) = final_img;
     







   
   