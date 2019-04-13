 function [rgb_StableImages,NUM_BIN_IMAGES,BinSizes,MAX_DISTANCE] = Algo2001_3( image,end_stage,StabilityPredictor )
  %reduced = 186;
 

 image = histeq(image);

 MAX_DISTANCE = 441;
 BinSizes = generateBins(MAX_DISTANCE);
 NUM_BIN_IMAGES = calculateNumBins_2Level(BinSizes,MAX_DISTANCE);
 [row,col,~] = size(image);
 
  BinMatrix = printBinAllocations(BinSizes,MAX_DISTANCE,NUM_BIN_IMAGES);
  StabilityCheckMatrix = testDriverGURI(MAX_DISTANCE); % CHANGE FUNCTION IF DISTANCE CALCULATION CHANGES
 rgb_BinImages = false(row,col,NUM_BIN_IMAGES);
 
 
 
 q_offset = 0;
 DistanceMatrix = zeros(row,col);
 %fprintf("\nMapping Image Pixels to Distance Matrix");
 for r = 1:row
     for c = 1:col
        if size(image,3) == 1
            DistanceMatrix(r,c) = floor(rgbDistance(image(r,c,1),image(r,c,1),image(r,c,1)));
            if DistanceMatrix(r,c) > MAX_DISTANCE
               error("MAx Distance Incorrect"); 
            end
        else
            DistanceMatrix(r,c) = image(r,c)*1.7;
            if DistanceMatrix(r,c) > MAX_DISTANCE
               error("MAx Distance Incorrect"); 
            end
        end
        
     end
 end
 
 fprintf("\nMapping Image to Bins");
 for i = 1:numel(BinSizes)
   main_offset = ceil(MAX_DISTANCE/BinSizes(i));
   k = ceil((BinSizes(i)/2)) -1;
  
   for r = 1:row
        for c = 1:col
     
       value = DistanceMatrix(r,c);
         x = q_offset+floor(value/BinSizes(i))+1;
          rgb_BinImages(r,c,x) = 1;
          if BinMatrix(x,3) > value || BinMatrix(x,4) < value
              BinMatrix
              [value,x]
              error("VALUES ARE NOT MAPPING TO BIN_MATRIX"); 
          end

         if value>k && value<(((main_offset-1)*BinSizes(i))+k)        %%CHANGES IN MAX DISTANCE MADE
            y = q_offset+main_offset+ceil((value-k)/BinSizes(i));
            rgb_BinImages(r,c,y) = 1;
          if BinMatrix(y,3) > value || BinMatrix(y,4) < value
              BinMatrix
              [value,x]
              error("VALUES ARE NOT MAPPING TO BIN_MATRIX");  
          end
         end
           
        end   
   end
    
    q_offset = q_offset+2*main_offset-1;
 end

 % rgb_BinImages = false(row,col,1);
% entry = 1;
% DIS = DistanceMatrix(:);
% 
% idxes = zeros(size(DIS));
% for i = 1:numel(BinSizes)
%     [idxes] = Binning(DIS,idxes,BinSizes(1,i));
%     
%     
%     divs = unique(idxes);
%     
%     for n = 1:numel(divs)
%         new_map = false(row,col);
%         p = 1;
%         for c = 1:col
%             for r = 1:row
%                 if idxes(p) == divs(n)
%                     new_map(r,c) = 1;
%                 end
%                 p = p+1;
%             end
%         end
%         rgb_BinImages(:,:,entry) = new_map;
%         entry = entry +1;
%     end
% end
% %  figure('Name','Stage One')
% %  imshow(image)

stage = 2;
 if stage>end_stage
    rgb_StableImages = rgb_BinImages;
 else
  
     fprintf("\nStabilizing Images....");
     rgb_StableImages = removeUnstableComponents(rgb_BinImages,MAX_DISTANCE,BinSizes,StabilityCheckMatrix,BinMatrix,18,StabilityPredictor); %CHANGE FOR CHANGE IN PRIMARY FEATURES
   
%      figure('Name','Stage Two')
%      imshow(image)
 end

 end

 
 function [final_indexes] = Binning(Arr,idxes,BinSize)
 
     if (max(Arr) - min(Arr)) <= BinSize
         final_indexes = idxes;
         return
     end
     
     [idxes] = kmeans(Arr,2);
    
     [idxes1] = Binning(Arr(idxes == 1),idxes(idxes == 1),BinSize);
     
     [idxes2] = Binning(Arr(idxes == 2),idxes(idxes == 2),BinSize);
     
     idxes2 = idxes2 + max(idxes1); 
     
    
     final_indexes(idxes == 1) = idxes1;

 
     final_indexes(idxes == 2) = idxes2;

      
%      final_indexes = idxes;
 
 end
 
%  cal_set = [1 2 3 4];        %Enter the processing layers in cal set and the the layers to print in print_set
% % print_set =[1 2 3 4];
%  
%  
%  %Manually enter image Numbers here
%  gray_set = [];
%  red_set = [];
%  green_set =[];
%  blue_set = [];
%  
%  apply_box =[];          %Set 1 to apply bounding boxes on original image
%  
%  
% % image = imread('multiscript.jpg');
% 
% image = imresize(image,0.5);
%  
% gray_image = rgb2gray(image);
% 
% gray_binary = false(row,col,186);
% red_binary = false(row,col,186);
% green_binary = false(row,col,186);
%  blue_binary = false(row,col,186);
% %  temp_binary = false(row,col,186);
%  
%   blue_final_imgs = false(row,col,186);
%   gray_final_imgs = false(row,col,186);
%   red_final_imgs = false(row,col,186);
%   green_final_imgs = false(row,col,186);
%  % temp_final_imgs = false(row,col,186);
%   
% %     gray_binary = false(row,col,186);
% %    redBB_final_imgs = false(row,col,186);
% %    green_binary = false(row,col,186);
%    blueBB_final_imgs = false(row,col,186);
% %   temp_binary = false(row,col,186);
%   
%  % BW_imgs = zeros(row,col,4);
% 
%   output_image = false(row,col);
%   % checker = false(row,col,4);
%  
% Image_Index = zeros(93,4);
% isSuper = false(93,ceil((row*col)/100));
% flag_array = false(ceil((row*col)/100),1);
% 
% 
%   aligned_map = zeros(100,1);
%   img_comp_map = zeros(ceil((row*col)/100),1); 
%     
%   final_img = false(row,col);  
%       BB_final_img = false(row,col);
%  %all_final_imgs = false(row,col,(186*4));
%  
% 
%   stage = 1
%   q = [16 32 47 61 75 89 103 115 127];
%  
%  
% 
% 
% 
% %  stage = 14
% %  q_offset = 0;
% %  
% %  for i = 1:numel(q)
% %     main_offset = ceil(256/q(i));
% %     for img = (q_offset+1):(q_offset+main_offset)
% %      
% %      check_img = blue_binary(:,:,img);
% %      CC = bwconncomp(check_img);
% %      
% %      no = img - q_offset;
% %      lower = no-1;
% %      upper = no;
% %      if lower>0
% %          lower_img = blue_binary(:,:,(lower+q_offset+main_offset));
% %      end
% %      
% %      if upper<main_offset
% %          
% %         upper_img = blue_binary(:,:,(upper+q_offset+main_offset)); 
% %      end
% %      
% %      for comp = 1:CC.NumObjects
% %          if lower>0
% %             if lower_img(CC.PixelIdxList{comp}) == 1 
% %                check_img(CC.PixelIdxList{comp}) = 0; 
% %                continue;
% %             end
% %          end
% %          
% %          if upper<main_offset
% %             if upper_img(CC.PixelIdxList{comp}) == 1
% %                check_img(CC.PixelIdxList{comp}) = 0; 
% %             end
% %          end
% %          
% %      end
% %      blue_binary(:,:,img) = check_img;
% %     end
% %     
% %     q_offset = q_offset+2*main_offset-1;
% %  end
% %  
% %  
%  
%  
%  stage=2
% 
% % %Invert Images
%     
%    for sub = 1:93
%        gray_binary(:,:,(sub+93)) = not(gray_binary(:,:,sub));
%        red_binary(:,:,(sub+93)) = not(red_binary(:,:,sub));
%        green_binary(:,:,(sub+93)) = not(green_binary(:,:,sub));
%        blue_binary(:,:,(sub+93)) = not(blue_binary(:,:,sub));
%    end
%    
%  
%    temp_binary = blue_binary;
%     %%Parameters
%  
%   min_size = 5;
%   max_size_factor = 0.25; 
%   
%   aligned_distance_factor = 2;
%   base_line_factor = aligned_distance_factor*0.706;          %%changed
%   aligned_upper_height_factor = 4;
%   aligned_lower_height_factor = 0.25;
% 
%  
% 
%    
%   a_solidity_factor = 0.8;  
%   na_solidity_factor = 0.65;
% 
%    a_eccent_factor = 0.98; 
%    na_eccent_factor =0.99;
%    
%    a_lower_extent = 0.2;
%    a_upper_extent = 0.9;
%    
%    na_lower_extent = 0.2;
%    na_upper_extent = 0.9;
%    
%    na_sw_factor = 0.25;
%    a_sw_factor = 0.25;
%    
%    na_hog_factor = 0.3;
%    a_hog_factor = 0.3;
% 
%   %Frequency factors
%   
%   bf_factor = 1.5;   % Tolerance for Bounding Box stats  %Original... 1.5,1.5,5
%   nf_factor = 1.75;   % Tolerance for total pixel number 
%   bf_tolerance = 3;
%   
%   
%   
%   
% %%End of Parameters 
%    
%    
%    
%      palate = false(row,col);
% 
%   
% 
%  
%    stage = 3 % remove large & small objects,smear components 
%   
% %[58 67 71 67 74 77 152 160 (68+93) (71+93) (72+93) (74+93) (75+93) (77+93)(78+93)]   for Hare ram hare krishna wall
% 
% %[52 55 59 60 61 62 64 67 68 70 71 72]  for Hotel Image
% 
% %i = 1;
% 
% for layer = cal_set
%    
%     if  layer == 1
%         blue_binary = gray_binary;
%     end
%     
%     if  layer == 2
%         blue_binary = red_binary;
%     end
%     
%     if  layer == 3
%         blue_binary = green_binary;
%     end
%     
%     if  layer == 4
%         blue_binary = temp_binary;
%     end
%     
%     
%     
%     
%     
%  for sub = 1:186                                                
%  img = blue_binary(:,:,sub);
% 
%  palate(:,:) = 0;
%  CC = bwconncomp(img);
%  img_stats = regionprops(CC);
%    
%   
%      for obj = 1:CC.NumObjects
%          
%         stats = img_stats(obj);
%        
%        if max(stats.BoundingBox(3),stats.BoundingBox(4))<min_size || numel(CC.PixelIdxList{obj})< min_size || stats.BoundingBox(3)>max_size_factor*col || stats.BoundingBox(4)>max_size_factor*row 
%           img(CC.PixelIdxList{obj})= 0;
%           continue;
%        end
% 
% %                 palate(CC.PixelIdxList{obj}) = 1;
% %        
% %                 left = ceil(stats.BoundingBox(1));
% %                 if left <1
% %                     left = 1;
% %                 end
% %                 right = left+stats.BoundingBox(3)-1;
% %                 if right >col
% %                     right = col;
% %                 end
% %                 
% %                 top = ceil(stats.BoundingBox(2));
% %                 if top <1
% %                     top = 1;
% %                 end
% %                 bottom = top + stats.BoundingBox(4)-1;
% %                 if bottom >row
% %                     bottom = row;
% %                 end
% %                 
% %           img(top:bottom,left:right) = logical(MySmear(palate(top:bottom,left:right))+img(top:bottom,left:right));
% %         
% %           palate(top:bottom,left:right) = 0;
%      end
% 
%      img = logical(MySmear(img));
%     blue_binary(:,:,sub) = img;
% %      checker(:,:,i) = img;
% %     i = i+4;
% 
%  end
% 
%     if  layer == 1
%        gray_binary = blue_binary;
%     end
%     
%     if  layer == 2
%         red_binary = blue_binary;
%     end
%     
%     if  layer == 3
%         green_binary = blue_binary;
%     end
%     
%     if  layer == 4
%         temp_binary = blue_binary;
%     end   
%     
%     
% end
% 
% 
%  
% stage = 4
% 
%  q_offset = 0;
%    for i  = 1:(numel(q)-1)
%       main_offset = ceil(256/q(i));
%       for img_no = (q_offset+1):(q_offset+main_offset)
%          lower_value = (img_no-q_offset - 1)*q(i);
%          upper_value = (img_no-q_offset)*q(i)-1;
%          
%          lower_main = q_offset + 2*main_offset -1 + floor(lower_value/q(i+1)) + 1;
%          upper_main = q_offset + 2*main_offset - 1 + floor(upper_value/q(i+1)) + 1;
%     
%          k = ceil(q(i+1)/2) - 1;
% 
%         if upper_value < (k+1) || lower_value>=(255-k)
%           lower_offset = lower_main;
%           upper_offset = upper_main;
%         else
%           if lower_value < (k+1)
%             lower_offset = q_offset + 2*main_offset -1 +ceil(256/q(i+1)) + ceil((1)/q(i+1));
%             upper_offset = q_offset + 2*main_offset - 1 + ceil(256/q(i+1)) +ceil((upper_value-k)/q(i+1)) ;
%          else
%           if upper_value >= (255-k)
%            lower_offset = q_offset + 2*main_offset -1 +ceil(256/q(i+1)) + ceil((lower_value-k)/q(i+1));
%             upper_offset = q_offset + 2*main_offset - 1 + ceil(256/q(i+1)) +ceil((255-k-1-k)/q(i+1)) ;
%           else
%             lower_offset = q_offset + 2*main_offset -1 +ceil(256/q(i+1)) + ceil((lower_value-k)/q(i+1));
%             upper_offset = q_offset + 2*main_offset - 1 + ceil(256/q(i+1)) +ceil((upper_value-k)/q(i+1)) ;
%           end
%          end    
%         end
%   
%      
%         Image_Index(img_no,:) = [lower_main upper_main lower_offset upper_offset];
%         
%       end
%    
%       for img_no = (q_offset+main_offset+1):(q_offset+2*main_offset-1)
%          k = ceil(256/q(i));
%          lower_value = (img_no-q_offset-main_offset - 1)*q(i)+k;
%          upper_value = (img_no-q_offset-main_offset)*q(i)-1+k;
%          
%          lower_main = q_offset + 2*main_offset -1 + floor(lower_value/q(i+1)) + 1;
%          upper_main = q_offset + 2*main_offset - 1 + floor(upper_value/q(i+1)) + 1;
%     
%          k = ceil(q(i+1)/2) - 1;
%         if upper_value < (k+1) || lower_value>=(255-k)
%           lower_offset = lower_main;
%           upper_offset = upper_main;
%         else
%           if lower_value < (k+1)
%             lower_offset = q_offset + 2*main_offset -1 +ceil(256/q(i+1)) + ceil((1)/q(i+1));
%             upper_offset = q_offset + 2*main_offset - 1 + ceil(256/q(i+1)) +ceil((upper_value-k)/q(i+1)) ;
%          else
%           if upper_value >= (255-k)
%            lower_offset = q_offset + 2*main_offset -1 +ceil(256/q(i+1)) + ceil((lower_value-k)/q(i+1));
%             upper_offset = q_offset + 2*main_offset - 1 + ceil(256/q(i+1)) +ceil((255-k-1-k)/q(i+1)) ;
%           else
%             lower_offset = q_offset + 2*main_offset -1 +ceil(256/q(i+1)) + ceil((lower_value-k)/q(i+1));
%             upper_offset = q_offset + 2*main_offset - 1 + ceil(256/q(i+1)) +ceil((upper_value-k)/q(i+1)) ;
%           end
%          end    
%         end
%   
%      
%  
%         Image_Index(img_no,:) = [lower_main upper_main lower_offset upper_offset];
%       end   
%    q_offset = q_offset + 2*main_offset - 1;
%    end
%    
% 
% for layer = cal_set
%      if  layer == 1
%         blue_binary = gray_binary;
%     end
%     
%     if  layer == 2
%         blue_binary = red_binary;
%     end
%     
%     if  layer == 3
%         blue_binary = green_binary;
%     end
%     
%     if  layer == 4
%         blue_binary = temp_binary;
%     end
%     
%   
%  
%  %1st Half
%   isSuper(:,:) = 0;  
%  flag_array(:,:) = 0;
%  
%  for Img = 1:88
%      
%     img = blue_binary(:,:,Img); 
%     CC = bwconncomp(img);
%     if CC.NumObjects<1
%        continue; 
%     end
%     img_stats = regionprops(CC);
%     flag_array(:,:) = 0;
%     flag_array(1:CC.NumObjects,1) = 1;
%     
% 
%      top_check_img = blue_binary(:,:,Image_Index(Img,1));
%      bottom_check_img = blue_binary(:,:,Image_Index(Img,2));
%    
%      sum_check_img = logical(blue_binary(:,:,Image_Index(Img,1))+ blue_binary(:,:,Image_Index(Img,2)));
%      
%      
%     top_check_CC  = bwconncomp(top_check_img);  
%     top_check_img_stats = regionprops(top_check_CC);
%     top_check_BW = bwlabel(top_check_img);
%      
%     bottom_check_CC  = bwconncomp(bottom_check_img);  
%     bottom_check_img_stats = regionprops(bottom_check_CC);
%     bottom_check_BW = bwlabel(bottom_check_img);
%      
%      
%     sum_check_CC  = bwconncomp(sum_check_img);  
%     sum_check_img_stats = regionprops(sum_check_CC);
%     sum_check_BW = bwlabel(sum_check_img);
%      
%      for comp = 1:CC.NumObjects
%          
%          if isSuper(Img,comp) == 1
%              continue;
%          end
%          
%         stats = img_stats(comp);
%        
%         top_label_matrix = findLabels(top_check_BW(CC.PixelIdxList{comp}));
%         bottom_label_matrix = findLabels(bottom_check_BW(CC.PixelIdxList{comp}));
%         sum_label_matrix = findLabels(sum_check_BW(CC.PixelIdxList{comp}));
%         
%         if top_label_matrix(1,1) ~= 0 && top_label_matrix(1,2)== 0
%             top_check_stats = top_check_img_stats(top_label_matrix(1,1));
%                 if numel(top_check_CC.PixelIdxList{top_label_matrix(1,1)}) >= numel(CC.PixelIdxList{comp})
%                     
%                   if (top_check_stats.BoundingBox(3)<bf_factor*stats.BoundingBox(3) && abs(top_check_stats.BoundingBox(3)-stats.BoundingBox(3)) < bf_tolerance )&& (top_check_stats.BoundingBox(4)<bf_factor*stats.BoundingBox(4) && abs(top_check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
%                      
%                      if numel(top_check_CC.PixelIdxList{top_label_matrix(1,1)}) < nf_factor* numel(CC.PixelIdxList{comp})
%                                 if Covers(top_check_img(CC.PixelIdxList{comp})) ==1
%                                    isSuper(Image_Index(Img,1),top_label_matrix(1,1)) = 1;
%                                   continue; 
%                                end
%                       end
%                   end
%                   
% %                 else
% %                   if (stats.BoundingBox(3)<bf_factor*top_check_stats.BoundingBox(3) && abs(top_check_stats.BoundingBox(3)-stats.BoundingBox(3)) < bf_tolerance )&& (stats.BoundingBox(4)<bf_factor*top_check_stats.BoundingBox(4) && abs(top_check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
% %                      
% %                      if numel(CC.PixelIdxList{comp}) < nf_factor* numel(top_check_CC.PixelIdxList{top_label_matrix(1,1)})
% %                                 if Covers(img(top_check_CC.PixelIdxList{top_label_matrix(1,1)})) ==1
% %                                    isSuper(Image_Index(Img,1),top_label_matrix(1,1)) = 1;
% %                                   continue; 
% %                                end
% %                       end
% %                   end
% %                     
% %                   
%                 end
%         end
%         
%         if bottom_label_matrix(1,1) ~= 0 && bottom_label_matrix(1,2)== 0
%             bottom_check_stats = bottom_check_img_stats(bottom_label_matrix(1,1));
%             if numel(bottom_check_CC.PixelIdxList{bottom_label_matrix(1,1)}) >= numel(CC.PixelIdxList{comp})
%                   if (bottom_check_stats.BoundingBox(3)<bf_factor*stats.BoundingBox(3) && abs(bottom_check_stats.BoundingBox(3)-stats.BoundingBox(3)) < bf_tolerance )&& (bottom_check_stats.BoundingBox(4)<bf_factor*stats.BoundingBox(4) && abs(bottom_check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
%                      
%                      if numel(bottom_check_CC.PixelIdxList{bottom_label_matrix(1,1)}) < nf_factor* numel(CC.PixelIdxList{comp})
%                                 if Covers(bottom_check_img(CC.PixelIdxList{comp})) ==1
%                                     isSuper(Image_Index(Img,2),bottom_label_matrix(1,1)) = 1;
%                                   continue; 
%                                end
%                       end
%                   end
%                   
% %              else
% %                   if (stats.BoundingBox(3)<bf_factor*bottom_check_stats.BoundingBox(3) && abs(bottom_check_stats.BoundingBox(3)-stats.BoundingBox(3)) < bf_tolerance )&& (stats.BoundingBox(4)<bf_factor*bottom_check_stats.BoundingBox(4) && abs(bottom_check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
% %                      
% %                      if numel(CC.PixelIdxList{comp}) < nf_factor*numel(bottom_check_CC.PixelIdxList{bottom_label_matrix(1,1)})
% %                                 if Covers(img(bottom_check_CC.PixelIdxList{bottom_label_matrix(1,1)})) ==1
% %                                    isSuper(Image_Index(Img,2),bottom_label_matrix(1,1)) = 1;
% %                                   continue; 
% %                                end
% %                       end
% %                   end
% %                     
% %                   
%             end
%             
%         end
%         
%                 
%         if sum_label_matrix(1,1) ~= 0 && sum_label_matrix(1,2)== 0
%             sum_check_stats = sum_check_img_stats(sum_label_matrix(1,1));
%             if numel(sum_check_CC.PixelIdxList{sum_label_matrix(1,1)}) >= numel(CC.PixelIdxList{comp})
%                   if (sum_check_stats.BoundingBox(3)<bf_factor*stats.BoundingBox(3) && abs(sum_check_stats.BoundingBox(3)-stats.BoundingBox(3)) < bf_tolerance )&& (sum_check_stats.BoundingBox(4)<bf_factor*stats.BoundingBox(4) && abs(sum_check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
%                      
%                     if numel(sum_check_CC.PixelIdxList{sum_label_matrix(1,1)}) < nf_factor* numel(CC.PixelIdxList{comp})
%                                 if Covers(sum_check_img(CC.PixelIdxList{comp})) ==1
%                                   continue; 
%                                end
%                      end
%                   end
%                   
% %             else
% %                   if (stats.BoundingBox(3)<bf_factor*sum_check_stats.BoundingBox(3) && abs(sum_check_stats.BoundingBox(3)-stats.BoundingBox(3)) < bf_tolerance )&& (stats.BoundingBox(4)<bf_factor*sum_check_stats.BoundingBox(4) && abs(sum_check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
% %                      
% %                      if numel(CC.PixelIdxList{comp}) < nf_factor* numel(sum_check_CC.PixelIdxList{sum_label_matrix(1,1)})
% %                                 if Covers(img(sum_check_CC.PixelIdxList{sum_label_matrix(1,1)})) ==1
% %                                   continue; 
% %                                end
% %                       end
% %                   end
% %                     
%                   
%              end
%         end
%         
%         
%         flag_array(comp,1) = 0;
%        
%          
%      end
%      
% 
%      top_check_img = blue_binary(:,:,Image_Index(Img,3));
%      bottom_check_img = blue_binary(:,:,Image_Index(Img,4));
%      sum_check_img = logical(blue_binary(:,:,Image_Index(Img,3))+ blue_binary(:,:,Image_Index(Img,4)));
%      
%      
%     top_check_CC  = bwconncomp(top_check_img);  
%     top_check_img_stats = regionprops(top_check_CC);
%     top_check_BW = bwlabel(top_check_img);
%      
%     bottom_check_CC  = bwconncomp(bottom_check_img);  
%     bottom_check_img_stats = regionprops(bottom_check_CC);
%     bottom_check_BW = bwlabel(bottom_check_img);
%      
%      
%     sum_check_CC  = bwconncomp(sum_check_img);  
%     sum_check_img_stats = regionprops(sum_check_CC);
%     sum_check_BW = bwlabel(sum_check_img);
%      
%      for comp = 1:CC.NumObjects
%          if flag_array(comp,1) == 1
%              continue;
%          end
%          
%         stats = img_stats(comp);
%        
%         top_label_matrix = findLabels(top_check_BW(CC.PixelIdxList{comp}));
%         bottom_label_matrix = findLabels(bottom_check_BW(CC.PixelIdxList{comp}));
%         sum_label_matrix = findLabels(sum_check_BW(CC.PixelIdxList{comp}));
%         
%     if top_label_matrix(1,1) ~= 0 && top_label_matrix(1,2)== 0
%                  top_check_stats = top_check_img_stats(top_label_matrix(1,1));
%                 if numel(top_check_CC.PixelIdxList{top_label_matrix(1,1)}) >= numel(CC.PixelIdxList{comp})
%                     
%                   if (top_check_stats.BoundingBox(3)<bf_factor*stats.BoundingBox(3) && abs(top_check_stats.BoundingBox(3)-stats.BoundingBox(3)) < bf_tolerance )&& (top_check_stats.BoundingBox(4)<bf_factor*stats.BoundingBox(4) && abs(top_check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
%                      
%                      if numel(top_check_CC.PixelIdxList{top_label_matrix(1,1)}) < nf_factor* numel(CC.PixelIdxList{comp})
%                                 if Covers(top_check_img(CC.PixelIdxList{comp})) ==1
%                                    isSuper(Image_Index(Img,3),top_label_matrix(1,1)) = 1;
%                                   continue; 
%                                end
%                       end
%                   end
%                   
% %               else
% %                   if (stats.BoundingBox(3)<bf_factor*top_check_stats.BoundingBox(3) && abs(top_check_stats.BoundingBox(3)-stats.BoundingBox(3)) < bf_tolerance )&& (stats.BoundingBox(4)<bf_factor*top_check_stats.BoundingBox(4) && abs(top_check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
% %                      
% %                      if numel(CC.PixelIdxList{comp}) < nf_factor* numel(top_check_CC.PixelIdxList{top_label_matrix(1,1)})
% %                                 if Covers(img(top_check_CC.PixelIdxList{top_label_matrix(1,1)})) ==1
% %                                    isSuper(Image_Index(Img,3),top_label_matrix(1,1)) = 1;
% %                                   continue; 
% %                                end
% %                       end
% %                   end
% %                     
%                   
%                 end
%     end
%         
%         if bottom_label_matrix(1,1) ~= 0 && bottom_label_matrix(1,2)== 0
%             bottom_check_stats = bottom_check_img_stats(bottom_label_matrix(1,1));
%             if numel(bottom_check_CC.PixelIdxList{bottom_label_matrix(1,1)}) >= numel(CC.PixelIdxList{comp})
%                   if (bottom_check_stats.BoundingBox(3)<bf_factor*stats.BoundingBox(3) && abs(bottom_check_stats.BoundingBox(3)-stats.BoundingBox(3)) < bf_tolerance )&& (bottom_check_stats.BoundingBox(4)<bf_factor*stats.BoundingBox(4) && abs(bottom_check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
%                      
%                      if numel(bottom_check_CC.PixelIdxList{bottom_label_matrix(1,1)}) < nf_factor* numel(CC.PixelIdxList{comp})
%                                 if Covers(bottom_check_img(CC.PixelIdxList{comp})) ==1
%                                     isSuper(Image_Index(Img,4),bottom_label_matrix(1,1)) = 1;
%                                   continue; 
%                                end
%                       end
%                   end
% %                   
% %              else
% %                   if (stats.BoundingBox(3)<bf_factor*bottom_check_stats.BoundingBox(3) && abs(bottom_check_stats.BoundingBox(3)-stats.BoundingBox(3)) < bf_tolerance )&& (stats.BoundingBox(4)<bf_factor*bottom_check_stats.BoundingBox(4) && abs(bottom_check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
% %                      
% %                      if numel(CC.PixelIdxList{comp}) < nf_factor*numel(bottom_check_CC.PixelIdxList{bottom_label_matrix(1,1)})
% %                                 if Covers(img(bottom_check_CC.PixelIdxList{bottom_label_matrix(1,1)})) ==1
% %                                    isSuper(Image_Index(Img,4),bottom_label_matrix(1,1)) = 1;
% %                                   continue; 
% %                                end
% %                       end
% %                   end
% %                     
%                   
%             end
%             
%         end
%         
%                 
%         if sum_label_matrix(1,1) ~= 0 && sum_label_matrix(1,2)== 0
%             sum_check_stats = sum_check_img_stats(sum_label_matrix(1,1));
%             if numel(sum_check_CC.PixelIdxList{sum_label_matrix(1,1)}) >= numel(CC.PixelIdxList{comp})
%                   if (sum_check_stats.BoundingBox(3)<bf_factor*stats.BoundingBox(3) && abs(sum_check_stats.BoundingBox(3)-stats.BoundingBox(3)) < bf_tolerance )&& (sum_check_stats.BoundingBox(4)<bf_factor*stats.BoundingBox(4) && abs(sum_check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
%                      
%                     if numel(sum_check_CC.PixelIdxList{sum_label_matrix(1,1)}) < nf_factor* numel(CC.PixelIdxList{comp})
%                                 if Covers(sum_check_img(CC.PixelIdxList{comp})) ==1
%                                   continue; 
%                                end
%                      end
%                   end
%                   
% %             else
% %                   if (stats.BoundingBox(3)<bf_factor*sum_check_stats.BoundingBox(3) && abs(sum_check_stats.BoundingBox(3)-stats.BoundingBox(3)) < bf_tolerance )&& (stats.BoundingBox(4)<bf_factor*sum_check_stats.BoundingBox(4) && abs(sum_check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
% %                      
% %                      if numel(CC.PixelIdxList{comp}) < nf_factor* numel(sum_check_CC.PixelIdxList{sum_label_matrix(1,1)})
% %                                 if Covers(img(sum_check_CC.PixelIdxList{sum_label_matrix(1,1)})) ==1
% %                                   continue; 
% %                                end
% %                       end
% %                   end
% %                     
% %                   
%              end
%         end
%         
%         img(CC.PixelIdxList{comp}) = 0; 
%          
%      end
%      
%      Img
%      blue_binary(:,:,Img) = img;
% %     checker(:,:,i) = img;
% %     i = i+4;
%  end
%   
% 
% %Removing non supersets from last q
%  for Img = 89:93
%     img = blue_binary(:,:,Img);
%     CC = bwconncomp(img);
%     if CC.NumObjects<1
%         continue;
%     end
%     
%     for comp = 1:CC.NumObjects
%        if isSuper(Img,comp) ~=1
%           
%            img(CC.PixelIdxList{comp}) = 0;
%        end
%         
%     end
%     (Img)
%     blue_binary(:,:,Img) = img;
% end
% 
% %2nd Half
% 
% 
%  isSuper(:,:) = 0;  
%  flag_array(:,:) = 0;
% for Img = 1:88
%      
%     img = blue_binary(:,:,(Img+93)); 
%     CC = bwconncomp(img);
%     if CC.NumObjects<1
%        continue; 
%     end
%     img_stats = regionprops(CC);
%     flag_array(:,:) = 0;
%     flag_array(1:CC.NumObjects,1) = 1;
%     
% 
%      top_check_img = blue_binary(:,:,(Image_Index(Img,1)+93));
%      bottom_check_img = blue_binary(:,:,(93+Image_Index(Img,2)));
%      sum_check_img = logical(blue_binary(:,:,(93+Image_Index(Img,1)))+ blue_binary(:,:,(93+Image_Index(Img,2))));
%      
%      
%     top_check_CC  = bwconncomp(top_check_img);  
%     top_check_img_stats = regionprops(top_check_CC);
%     top_check_BW = bwlabel(top_check_img);
%      
%     bottom_check_CC  = bwconncomp(bottom_check_img);  
%     bottom_check_img_stats = regionprops(bottom_check_CC);
%     bottom_check_BW = bwlabel(bottom_check_img);
%      
%      
%     sum_check_CC  = bwconncomp(sum_check_img);  
%     sum_check_img_stats = regionprops(sum_check_CC);
%     sum_check_BW = bwlabel(sum_check_img);
%      
%      for comp = 1:CC.NumObjects
% 
%          
%          if isSuper(Img,comp) == 1
%              continue;
%          end
%          
%         stats = img_stats(comp);
%        
%         top_label_matrix = findLabels(top_check_BW(CC.PixelIdxList{comp}));
%         bottom_label_matrix = findLabels(bottom_check_BW(CC.PixelIdxList{comp}));
%         sum_label_matrix = findLabels(sum_check_BW(CC.PixelIdxList{comp}));
%         
%     if top_label_matrix(1,1) ~= 0 && top_label_matrix(1,2)== 0
%                  top_check_stats = top_check_img_stats(top_label_matrix(1,1));
%                 if numel(top_check_CC.PixelIdxList{top_label_matrix(1,1)}) > numel(CC.PixelIdxList{comp})
%                     
%                   if (top_check_stats.BoundingBox(3)<bf_factor*stats.BoundingBox(3) && abs(top_check_stats.BoundingBox(3)-stats.BoundingBox(3)) < bf_tolerance )&& (top_check_stats.BoundingBox(4)<bf_factor*stats.BoundingBox(4) && abs(top_check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
%                      
%                      if numel(top_check_CC.PixelIdxList{top_label_matrix(1,1)}) < nf_factor* numel(CC.PixelIdxList{comp})
%                                 if Covers(top_check_img(CC.PixelIdxList{comp})) ==1
%                                    isSuper(Image_Index(Img,1),top_label_matrix(1,1)) = 1;
%                                   continue; 
%                                end
%                       end
%                   end
%                   
%               else
%                   if (stats.BoundingBox(3)<bf_factor*top_check_stats.BoundingBox(3) && abs(top_check_stats.BoundingBox(3)-stats.BoundingBox(3)) < bf_tolerance )&& (stats.BoundingBox(4)<bf_factor*top_check_stats.BoundingBox(4) && abs(top_check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
%                      
%                      if numel(CC.PixelIdxList{comp}) < nf_factor* numel(top_check_CC.PixelIdxList{top_label_matrix(1,1)})
%                                 if Covers(img(top_check_CC.PixelIdxList{top_label_matrix(1,1)})) ==1
%                                    isSuper(Image_Index(Img,1),top_label_matrix(1,1)) = 1;
%                                   continue; 
%                                end
%                       end
%                   end
%                     
%                   
%                 end
%     end
%         
%         if bottom_label_matrix(1,1) ~= 0 && bottom_label_matrix(1,2)== 0
%             bottom_check_stats = bottom_check_img_stats(bottom_label_matrix(1,1));
%             if numel(bottom_check_CC.PixelIdxList{bottom_label_matrix(1,1)}) > numel(CC.PixelIdxList{comp})
%                   if (bottom_check_stats.BoundingBox(3)<bf_factor*stats.BoundingBox(3) && abs(bottom_check_stats.BoundingBox(3)-stats.BoundingBox(3)) < bf_tolerance )&& (bottom_check_stats.BoundingBox(4)<bf_factor*stats.BoundingBox(4) && abs(bottom_check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
%                      
%                      if numel(bottom_check_CC.PixelIdxList{bottom_label_matrix(1,1)}) < nf_factor* numel(CC.PixelIdxList{comp})
%                                 if Covers(bottom_check_img(CC.PixelIdxList{comp})) ==1
%                                     isSuper(Image_Index(Img,2),bottom_label_matrix(1,1)) = 1;
%                                   continue; 
%                                end
%                       end
%                   end
%                   
%              else
%                   if (stats.BoundingBox(3)<bf_factor*bottom_check_stats.BoundingBox(3) && abs(bottom_check_stats.BoundingBox(3)-stats.BoundingBox(3)) < bf_tolerance )&& (stats.BoundingBox(4)<bf_factor*bottom_check_stats.BoundingBox(4) && abs(bottom_check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
%                      
%                      if numel(CC.PixelIdxList{comp}) < nf_factor*numel(bottom_check_CC.PixelIdxList{bottom_label_matrix(1,1)})
%                                 if Covers(img(bottom_check_CC.PixelIdxList{bottom_label_matrix(1,1)})) ==1
%                                    isSuper(Image_Index(Img,2),bottom_label_matrix(1,1)) = 1;
%                                   continue; 
%                                end
%                       end
%                   end
%                     
%                   
%             end
%             
%         end
%         
%                 
%         if sum_label_matrix(1,1) ~= 0 && sum_label_matrix(1,2)== 0
%             sum_check_stats = sum_check_img_stats(sum_label_matrix(1,1));
%             if numel(sum_check_CC.PixelIdxList{sum_label_matrix(1,1)}) > numel(CC.PixelIdxList{comp})
%                   if (sum_check_stats.BoundingBox(3)<bf_factor*stats.BoundingBox(3) && abs(sum_check_stats.BoundingBox(3)-stats.BoundingBox(3)) < bf_tolerance )&& (sum_check_stats.BoundingBox(4)<bf_factor*stats.BoundingBox(4) && abs(sum_check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
%                      
%                     if numel(sum_check_CC.PixelIdxList{sum_label_matrix(1,1)}) < nf_factor* numel(CC.PixelIdxList{comp})
%                                 if Covers(sum_check_img(CC.PixelIdxList{comp})) ==1
%                                   continue; 
%                                end
%                      end
%                   end
%                   
%             else
%                   if (stats.BoundingBox(3)<bf_factor*sum_check_stats.BoundingBox(3) && abs(sum_check_stats.BoundingBox(3)-stats.BoundingBox(3)) < bf_tolerance )&& (stats.BoundingBox(4)<bf_factor*sum_check_stats.BoundingBox(4) && abs(sum_check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
%                      
%                      if numel(CC.PixelIdxList{comp}) < nf_factor* numel(sum_check_CC.PixelIdxList{sum_label_matrix(1,1)})
%                                 if Covers(img(sum_check_CC.PixelIdxList{sum_label_matrix(1,1)})) ==1
%                                   continue; 
%                                end
%                       end
%                   end
%                     
%                   
%              end
%         end
%         flag_array(comp,1) = 0;
%         
% 
%      
%      
%   
%      end
%      
% 
%      top_check_img = blue_binary(:,:,(93+Image_Index(Img,3)));
%      bottom_check_img = blue_binary(:,:,(93+Image_Index(Img,4)));
%      sum_check_img = logical(blue_binary(:,:,(93+Image_Index(Img,3)))+ blue_binary(:,:,(93+Image_Index(Img,4))));
%      
%      
%     top_check_CC  = bwconncomp(top_check_img);  
%     top_check_img_stats = regionprops(top_check_CC);
%     top_check_BW = bwlabel(top_check_img);
%      
%     bottom_check_CC  = bwconncomp(bottom_check_img);  
%     bottom_check_img_stats = regionprops(bottom_check_CC);
%     bottom_check_BW = bwlabel(bottom_check_img);
%      
%      
%     sum_check_CC  = bwconncomp(sum_check_img);  
%     sum_check_img_stats = regionprops(sum_check_CC);
%     sum_check_BW = bwlabel(sum_check_img);
%      
%      for comp = 1:CC.NumObjects
%          if flag_array(comp,1) == 1
%              continue;
%          end
%          
%         stats = img_stats(comp);
%        
%         top_label_matrix = findLabels(top_check_BW(CC.PixelIdxList{comp}));
%         bottom_label_matrix = findLabels(bottom_check_BW(CC.PixelIdxList{comp}));
%         sum_label_matrix = findLabels(sum_check_BW(CC.PixelIdxList{comp}));
%         
%     if top_label_matrix(1,1) ~= 0 && top_label_matrix(1,2)== 0
%                  top_check_stats = top_check_img_stats(top_label_matrix(1,1));
%                 if numel(top_check_CC.PixelIdxList{top_label_matrix(1,1)}) > numel(CC.PixelIdxList{comp})
%                     
%                   if (top_check_stats.BoundingBox(3)<bf_factor*stats.BoundingBox(3) && abs(top_check_stats.BoundingBox(3)-stats.BoundingBox(3)) < bf_tolerance )&& (top_check_stats.BoundingBox(4)<bf_factor*stats.BoundingBox(4) && abs(top_check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
%                      
%                      if numel(top_check_CC.PixelIdxList{top_label_matrix(1,1)}) < nf_factor* numel(CC.PixelIdxList{comp})
%                                 if Covers(top_check_img(CC.PixelIdxList{comp})) ==1
%                                    isSuper(Image_Index(Img,3),top_label_matrix(1,1)) = 1;
%                                   continue; 
%                                end
%                       end
%                   end
%                   
%               else
%                   if (stats.BoundingBox(3)<bf_factor*top_check_stats.BoundingBox(3) && abs(top_check_stats.BoundingBox(3)-stats.BoundingBox(3)) < bf_tolerance )&& (stats.BoundingBox(4)<bf_factor*top_check_stats.BoundingBox(4) && abs(top_check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
%                      
%                      if numel(CC.PixelIdxList{comp}) < nf_factor* numel(top_check_CC.PixelIdxList{top_label_matrix(1,1)})
%                                 if Covers(img(top_check_CC.PixelIdxList{top_label_matrix(1,1)})) ==1
%                                    isSuper(Image_Index(Img,3),top_label_matrix(1,1)) = 1;
%                                   continue; 
%                                end
%                       end
%                   end
%                     
%                   
%                 end
%     end
%         
%         if bottom_label_matrix(1,1) ~= 0 && bottom_label_matrix(1,2)== 0
%             bottom_check_stats = bottom_check_img_stats(bottom_label_matrix(1,1));
%             if numel(bottom_check_CC.PixelIdxList{bottom_label_matrix(1,1)}) > numel(CC.PixelIdxList{comp})
%                   if (bottom_check_stats.BoundingBox(3)<bf_factor*stats.BoundingBox(3) && abs(bottom_check_stats.BoundingBox(3)-stats.BoundingBox(3)) < bf_tolerance )&& (bottom_check_stats.BoundingBox(4)<bf_factor*stats.BoundingBox(4) && abs(bottom_check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
%                      
%                      if numel(bottom_check_CC.PixelIdxList{bottom_label_matrix(1,1)}) < nf_factor* numel(CC.PixelIdxList{comp})
%                                 if Covers(bottom_check_img(CC.PixelIdxList{comp})) ==1
%                                     isSuper(Image_Index(Img,4),bottom_label_matrix(1,1)) = 1;
%                                   continue; 
%                                end
%                       end
%                   end
%                   
%              else
%                   if (stats.BoundingBox(3)<bf_factor*bottom_check_stats.BoundingBox(3) && abs(bottom_check_stats.BoundingBox(3)-stats.BoundingBox(3)) < bf_tolerance )&& (stats.BoundingBox(4)<bf_factor*bottom_check_stats.BoundingBox(4) && abs(bottom_check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
%                      
%                      if numel(CC.PixelIdxList{comp}) < nf_factor*numel(bottom_check_CC.PixelIdxList{bottom_label_matrix(1,1)})
%                                 if Covers(img(bottom_check_CC.PixelIdxList{bottom_label_matrix(1,1)})) ==1
%                                    isSuper(Image_Index(Img,4),bottom_label_matrix(1,1)) = 1;
%                                   continue; 
%                                end
%                       end
%                   end
%                     
%                   
%             end
%             
%         end
%         
%                 
%         if sum_label_matrix(1,1) ~= 0 && sum_label_matrix(1,2)== 0
%             sum_check_stats = sum_check_img_stats(sum_label_matrix(1,1));
%             if numel(sum_check_CC.PixelIdxList{sum_label_matrix(1,1)}) > numel(CC.PixelIdxList{comp})
%                   if (sum_check_stats.BoundingBox(3)<bf_factor*stats.BoundingBox(3) && abs(sum_check_stats.BoundingBox(3)-stats.BoundingBox(3)) < bf_tolerance )&& (sum_check_stats.BoundingBox(4)<bf_factor*stats.BoundingBox(4) && abs(sum_check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
%                      
%                     if numel(sum_check_CC.PixelIdxList{sum_label_matrix(1,1)}) < nf_factor* numel(CC.PixelIdxList{comp})
%                                 if Covers(sum_check_img(CC.PixelIdxList{comp})) ==1
%                                   continue; 
%                                end
%                      end
%                   end
%                   
%             else
%                   if (stats.BoundingBox(3)<bf_factor*sum_check_stats.BoundingBox(3) && abs(sum_check_stats.BoundingBox(3)-stats.BoundingBox(3)) < bf_tolerance )&& (stats.BoundingBox(4)<bf_factor*sum_check_stats.BoundingBox(4) && abs(sum_check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
%                      
%                      if numel(CC.PixelIdxList{comp}) < nf_factor* numel(sum_check_CC.PixelIdxList{sum_label_matrix(1,1)})
%                                 if Covers(img(sum_check_CC.PixelIdxList{sum_label_matrix(1,1)})) ==1
%                                   continue; 
%                                end
%                       end
%                   end
%                     
%                   
%              end
%         end
%         
%         img(CC.PixelIdxList{comp}) = 0; 
%          
%      end
%      
%      (93+Img)
%      blue_binary(:,:,(93+Img)) = img;
% %          blue_final_imgs(:,:,i) = img;
% %     i = i+3;
% end
% 
% 
% % Removing non supersets from final q
% 
% for Img = 89:93
%     img = blue_binary(:,:,(93+Img));
%     CC = bwconncomp(img);
%     if CC.NumObjects<1
%         continue;
%     end
%     
%     for comp = 1:CC.NumObjects
%        if isSuper(Img,comp) ~=1
%           
%            img(CC.PixelIdxList{comp}) = 0;
%        end
%         
%     end
%     (93+Img)
%     blue_binary(:,:,(93+Img)) = img;
% end
% 
%   
%     if  layer == 1
%        gray_binary = blue_binary;
%     end
%     
%     if  layer == 2
%         red_binary = blue_binary;
%     end
%     
%     if  layer == 3
%         green_binary = blue_binary;
%     end
%     
%     if  layer == 4
%         temp_binary = blue_binary;
%     end    
%     
%     
% end
% 
%  
% 
% 
%      
%    stage = 5 
%  
% 
%    
% 
%    
%  
% for layer = cal_set
%      if  layer == 1
%         blue_binary = gray_binary;
%     end
%     
%     if  layer == 2
%         blue_binary = red_binary;
%     end
%     
%     if  layer == 3
%         blue_binary = green_binary;
%     end
%     
%     if  layer == 4
%         blue_binary = temp_binary;
%     end    
%     
% for sub = 1:186                                                   
%  img = blue_binary(:,:,sub);
%  final_img(:,:) = 0;
%  BB_final_img(:,:) = 0;
%     %Alignment Analysis 
% 
%    aligned_map(:,:) = 0;
%   img_comp_map(:,:) = 0;
%  
%     
%      palate(:,:) = 0;
%      
%       CC = bwconncomp(img);
%       
%    
%      img_comp_map(1:CC.NumObjects,1) = 1;     
%      img_stats = regionprops(CC,'Eccentricity','BoundingBox','Solidity','Extent');
% 
%     for comp = 1:CC.NumObjects
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
%          
%          
%          
%          total_eccent = stats.Eccentricity;
%          avg_eccent = total_eccent;
%          
%          
%          
%          total_solidity = stats.Solidity;
%          avg_solidity = total_solidity;
%          
%          total_extent = stats.Extent;
%          avg_extent = total_extent;
%          
% 
%          
%   
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
%                 
%                 
%       total_sw = SWT(img_matrix);
%       avg_sw = total_sw;
%       
%       total_hog = eHOG(img_matrix);
%       avg_hog = total_hog;
%                 
%          
%          height = stats.BoundingBox(4);
%          y_cord = floor(stats.BoundingBox(1))+stats.BoundingBox(3);
%          
% 
%          
%          upper_bottom_margin = stats.BoundingBox(2)+height+height*base_line_factor;
%          lower_bottom_margin = stats.BoundingBox(2)+height -height*base_line_factor;
%          
% %          density_array(:,:) = 0;
%          
%          for check_comp = comp:CC.NumObjects
%              
%             if check_comp == comp || img_comp_map(check_comp,1) == 0
%                 continue;
%             end
%                    
%             stats = img_stats(check_comp);
%             
%              if abs(stats.BoundingBox(1)-y_cord)>2*aligned_distance_factor*height
%                 break;
%              end               
% 
%             if stats.BoundingBox(4)>aligned_upper_height_factor*height || stats.BoundingBox(4)<aligned_lower_height_factor*height || abs(stats.BoundingBox(1)-y_cord)>aligned_distance_factor*height
%                continue;
%             end
% 
% 
% %             
%             
%             top_margin = stats.BoundingBox(2);
%             bottom_margin = top_margin + stats.BoundingBox(4);
%              
%             if bottom_margin>lower_bottom_margin && bottom_margin<upper_bottom_margin %&& (uff-avg_uff) < aligned_uff_tolerance
%                
%                 if aligns == 0
%                     aligns = aligns+1;
%                    img_comp_map(comp,1) = 0;
%                    aligned_map(aligns,1) = comp;
%                   % density_array(aligns,1) = avg_density;
%                 end
%                 
% 
%  
%                 height = max(height,stats.BoundingBox(4));
%                 upper_bottom_margin = stats.BoundingBox(2)+stats.BoundingBox(4)+height*base_line_factor;
%                 lower_bottom_margin = stats.BoundingBox(2)+stats.BoundingBox(4) -height*base_line_factor;
%     
%                  y_cord = floor(stats.BoundingBox(1)) +stats.BoundingBox(3);
%                  
%                 aligns = aligns+1;
%                 
%                 img_comp_map(check_comp,1) =0;
%                 aligned_map(aligns,1)=check_comp;
%                 
%                 total_eccent = total_eccent + stats.Eccentricity;
%                 total_solidity = total_solidity + stats.Solidity;
%                 total_extent = total_extent + stats.Extent;
%                 
%                 avg_eccent = total_eccent/aligns;
%                 avg_solidity = total_solidity/aligns;
%                 avg_extent = total_extent/aligns;
%                 
%                 
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
%                 palate(CC.PixelIdxList{check_comp}) = 1;
%                 img_matrix = palate(top:bottom,left:right);
%                 palate(CC.PixelIdxList{check_comp}) = 0;
%                 
%                 total_sw = total_sw + SWT(img_matrix);
%                 avg_sw = total_sw/aligns;
%                 
%                 total_hog = total_hog + eHOG(img_matrix);
%                 avg_hog = total_hog/aligns;
%                 
%                 
% 
%                 
% 
%             end
%             
%          end
%           
%          if aligns == 0
%               stats = img_stats(comp);
%                 if ~(avg_eccent>na_eccent_factor || avg_solidity>na_solidity_factor || avg_extent < na_lower_extent || avg_extent > na_upper_extent || max(stats.BoundingBox(3),stats.BoundingBox(4)) < 10)%(avg_ff >na_form_factor || avg_density >na_density_factor   || avg_uff>na_uniformity_factor) %|| avg_cf <=na_curve_factor )
%                    
%                    if avg_sw<na_sw_factor && avg_hog < na_hog_factor
%                     final_img(CC.PixelIdxList{comp}) = 1;
%                     
%                  stats = img_stats(comp);
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
%                  
%                 final_img(top,left:right) = 1;
%                 final_img(bottom,left:right) = 1;
%                 final_img(top:bottom,left) = 1;
%                 final_img(top:bottom,right) = 1;
%                 
%                BB_final_img(top:bottom,left:right) = 1;
%        
%                    end 
%                 end
%           end
% 
%          
%         
%             if aligns>0 && ~(avg_eccent>a_eccent_factor || avg_solidity>a_solidity_factor|| avg_extent < a_lower_extent || avg_extent > a_upper_extent)%((avg_ff>a_form_factor || avg_density>a_density_factor || avg_uff>a_uniformity_factor ))
%            
%             if avg_sw< a_sw_factor && avg_hog < a_hog_factor
%                 
%                 stats = img_stats(comp);
%                 left_m = floor(stats.BoundingBox(1));
%                 if left_m == 0
%                     left_m = 1;
%                 end
%                 right_m = left_m+stats.BoundingBox(3)+1;
%                 if right_m >col
%                     right_m = col;
%                 end
%                 
%                 top_m = floor(stats.BoundingBox(2));
%                 if top_m == 0
%                     top_m = 1;
%                 end
%                 bottom_m = top_m + stats.BoundingBox(4)+1;
%                 if bottom_m >row
%                     bottom_m = row;
%                 end
%                 
%                 
%                 
%              while aligns>0 
%                  
%                  stats = img_stats(aligned_map(aligns,1));
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
%                 
%                 left_m = min(left,left_m);
%                 right_m = max(right,right_m);
%                 top_m = min(top,top_m);
%                 bottom_m = max(bottom,bottom_m);
%                  
%                  final_img(CC.PixelIdxList{aligned_map(aligns,1)}) =1;
%                  aligns = aligns -1;
%              end
%                  final_img(top_m,left_m:right_m) = 1;
%                 final_img(bottom_m,left_m:right_m) = 1;
%                 final_img(top_m:bottom_m,left_m) = 1;
%                 final_img(top_m:bottom_m,right_m) = 1;
%                 
%              BB_final_img(top_m:bottom_m,left_m:right_m) = 1;
%             end
%                    
%             end 
%         
%          
%    
%          
%          
%     end
%      
%     sub
%     blue_final_imgs(:,:,sub) = final_img(:,:);
%     blueBB_final_imgs(:,:,sub) = BB_final_img(:,:);
% %     checker(:,:,i) = final_img;
% %     i = i+4;
% 
% 
% end
% 
% 
%     if  layer == 1
%        gray_final_imgs = blue_final_imgs;
%        gray_binary = blueBB_final_imgs;
%     end
%     
%     if  layer == 2
%         red_final_imgs = blue_final_imgs;
%         red_binary = blueBB_final_imgs;
%     end
%     
%     if  layer == 3
%         green_final_imgs = blue_final_imgs;
%         green_binary = blueBB_final_imgs;
%     end
%     
%     if  layer == 4
%         temp_final_imgs = blue_final_imgs;
%         temp_binary = blueBB_final_imgs;
%     end    
%     
% end
% 
%  
% 
% 
%  
%  
%  stage = 6
%  
% for layer = cal_set 
%     
%     if  layer == 1
%         blue_final_imgs = gray_binary;
%         ch_final_imgs = gray_final_imgs;
%     end
%     
%     if  layer == 2
%         blue_final_imgs = red_binary;
%         ch_final_imgs = red_final_imgs;
%     end
%     
%     if  layer == 3
%         blue_final_imgs = green_binary;
%         ch_final_imgs = green_final_imgs;
%     end
%     
%     if  layer == 4
%         blue_final_imgs = temp_binary;
%         ch_final_imgs = temp_final_imgs;
%     end 
%     
% 
%   %1st Half
%  isSuper(:,:) = 0;  
%  flag_array(:,:) = 0;
%  for Img =1:88 
%      
%     img = blue_final_imgs(:,:,Img); 
%     ch_img = ch_final_imgs(:,:,Img);
%     
%     CC = bwconncomp(img);
%     if CC.NumObjects<1
%        continue; 
%     end
%     img_stats = regionprops(CC);
%     flag_array(:,:) = 0;
%     flag_array(1:CC.NumObjects,1) = 1;
%     
% 
%      top_check_img = blue_final_imgs(:,:,Image_Index(Img,1));
%      bottom_check_img = blue_final_imgs(:,:,Image_Index(Img,2));
%    
%      sum_check_img = logical(blue_final_imgs(:,:,Image_Index(Img,1))+ blue_final_imgs(:,:,Image_Index(Img,2)));
%      
%      
%     top_check_CC  = bwconncomp(top_check_img);  
%     top_check_img_stats = regionprops(top_check_CC);
%     top_check_BW = bwlabel(top_check_img);
%      
%     bottom_check_CC  = bwconncomp(bottom_check_img);  
%     bottom_check_img_stats = regionprops(bottom_check_CC);
%     bottom_check_BW = bwlabel(bottom_check_img);
%      
%      
%     sum_check_CC  = bwconncomp(sum_check_img);  
%     sum_check_img_stats = regionprops(sum_check_CC);
%     sum_check_BW = bwlabel(sum_check_img);
%      
%      for comp = 1:CC.NumObjects
%          
%          if isSuper(Img,comp) == 1
%              continue;
%          end
%          
%         stats = img_stats(comp);
%        
%         top_label_matrix = findLabels(top_check_BW(CC.PixelIdxList{comp}));
%         bottom_label_matrix = findLabels(bottom_check_BW(CC.PixelIdxList{comp}));
%         sum_label_matrix = findLabels(sum_check_BW(CC.PixelIdxList{comp}));
%         
%         if top_label_matrix(1,1) ~= 0 && top_label_matrix(1,2)== 0
%             top_check_stats = top_check_img_stats(top_label_matrix(1,1));
%                 if numel(top_check_CC.PixelIdxList{top_label_matrix(1,1)}) >= numel(CC.PixelIdxList{comp})
%                     
%                   if (top_check_stats.BoundingBox(3)<bf_factor*stats.BoundingBox(3) && abs(top_check_stats.BoundingBox(3)-stats.BoundingBox(3)) < bf_tolerance )&& (top_check_stats.BoundingBox(4)<bf_factor*stats.BoundingBox(4) && abs(top_check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
%                      
%                      if numel(top_check_CC.PixelIdxList{top_label_matrix(1,1)}) < nf_factor* numel(CC.PixelIdxList{comp})
%                                 if Covers(top_check_img(CC.PixelIdxList{comp})) ==1
%                                    isSuper(Image_Index(Img,1),top_label_matrix(1,1)) = 1;
%                                   continue; 
%                                end
%                       end
%                   end
%                   
% %                 else
% %                   if (stats.BoundingBox(3)<bf_factor*top_check_stats.BoundingBox(3) && abs(top_check_stats.BoundingBox(3)-stats.BoundingBox(3)) < bf_tolerance )&& (stats.BoundingBox(4)<bf_factor*top_check_stats.BoundingBox(4) && abs(top_check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
% %                      
% %                      if numel(CC.PixelIdxList{comp}) < nf_factor* numel(top_check_CC.PixelIdxList{top_label_matrix(1,1)})
% %                                 if Covers(img(top_check_CC.PixelIdxList{top_label_matrix(1,1)})) ==1
% %                                    isSuper(Image_Index(Img,1),top_label_matrix(1,1)) = 1;
% %                                   continue; 
% %                                end
% %                       end
% %                   end
%                     
%                   
%                 end
%         end
%         
%         if bottom_label_matrix(1,1) ~= 0 && bottom_label_matrix(1,2)== 0
%             bottom_check_stats = bottom_check_img_stats(bottom_label_matrix(1,1));
%             if numel(bottom_check_CC.PixelIdxList{bottom_label_matrix(1,1)}) >= numel(CC.PixelIdxList{comp})
%                   if (bottom_check_stats.BoundingBox(3)<bf_factor*stats.BoundingBox(3) && abs(bottom_check_stats.BoundingBox(3)-stats.BoundingBox(3)) < bf_tolerance )&& (bottom_check_stats.BoundingBox(4)<bf_factor*stats.BoundingBox(4) && abs(bottom_check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
%                      
%                      if numel(bottom_check_CC.PixelIdxList{bottom_label_matrix(1,1)}) < nf_factor* numel(CC.PixelIdxList{comp})
%                                 if Covers(bottom_check_img(CC.PixelIdxList{comp})) ==1
%                                     isSuper(Image_Index(Img,2),bottom_label_matrix(1,1)) = 1;
%                                   continue; 
%                                end
%                       end
%                   end
%                   
% %              else
% %                   if (stats.BoundingBox(3)<bf_factor*bottom_check_stats.BoundingBox(3) && abs(bottom_check_stats.BoundingBox(3)-stats.BoundingBox(3)) < bf_tolerance )&& (stats.BoundingBox(4)<bf_factor*bottom_check_stats.BoundingBox(4) && abs(bottom_check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
% %                      
% %                      if numel(CC.PixelIdxList{comp}) < nf_factor*numel(bottom_check_CC.PixelIdxList{bottom_label_matrix(1,1)})
% %                                 if Covers(img(bottom_check_CC.PixelIdxList{bottom_label_matrix(1,1)})) ==1
% %                                    isSuper(Image_Index(Img,2),bottom_label_matrix(1,1)) = 1;
% %                                   continue; 
% %                                end
% %                       end
% %                   end
%                     
%                   
%             end
%             
%         end
%         
%                 
%         if sum_label_matrix(1,1) ~= 0 && sum_label_matrix(1,2)== 0
%             sum_check_stats = sum_check_img_stats(sum_label_matrix(1,1));
%             if numel(sum_check_CC.PixelIdxList{sum_label_matrix(1,1)}) >= numel(CC.PixelIdxList{comp})
%                   if (sum_check_stats.BoundingBox(3)<bf_factor*stats.BoundingBox(3) && abs(sum_check_stats.BoundingBox(3)-stats.BoundingBox(3)) < bf_tolerance )&& (sum_check_stats.BoundingBox(4)<bf_factor*stats.BoundingBox(4) && abs(sum_check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
%                      
%                     if numel(sum_check_CC.PixelIdxList{sum_label_matrix(1,1)}) < nf_factor* numel(CC.PixelIdxList{comp})
%                                 if Covers(sum_check_img(CC.PixelIdxList{comp})) ==1
%                                   continue; 
%                                end
%                      end
%                   end
%                   
% %             else
% %                   if (stats.BoundingBox(3)<bf_factor*sum_check_stats.BoundingBox(3) && abs(sum_check_stats.BoundingBox(3)-stats.BoundingBox(3)) < bf_tolerance )&& (stats.BoundingBox(4)<bf_factor*sum_check_stats.BoundingBox(4) && abs(sum_check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
% %                      
% %                      if numel(CC.PixelIdxList{comp}) < nf_factor* numel(sum_check_CC.PixelIdxList{sum_label_matrix(1,1)})
% %                                 if Covers(img(sum_check_CC.PixelIdxList{sum_label_matrix(1,1)})) ==1
% %                                   continue; 
% %                                end
% %                       end
% %                   end
%                     
%                   
%              end
%         end
%         
%         
%         flag_array(comp,1) = 0;
%        
%          
%      end
%      
% 
%      top_check_img = blue_final_imgs(:,:,Image_Index(Img,3));
%      bottom_check_img = blue_final_imgs(:,:,Image_Index(Img,4));
%      sum_check_img = logical(blue_final_imgs(:,:,Image_Index(Img,3))+ blue_final_imgs(:,:,Image_Index(Img,4)));
%      
%      
%     top_check_CC  = bwconncomp(top_check_img);  
%     top_check_img_stats = regionprops(top_check_CC);
%     top_check_BW = bwlabel(top_check_img);
%      
%     bottom_check_CC  = bwconncomp(bottom_check_img);  
%     bottom_check_img_stats = regionprops(bottom_check_CC);
%     bottom_check_BW = bwlabel(bottom_check_img);
%      
%      
%     sum_check_CC  = bwconncomp(sum_check_img);  
%     sum_check_img_stats = regionprops(sum_check_CC);
%     sum_check_BW = bwlabel(sum_check_img);
%      
%      for comp = 1:CC.NumObjects
%          if flag_array(comp,1) == 1
%              continue;
%          end
%          
%         stats = img_stats(comp);
%        
%         top_label_matrix = findLabels(top_check_BW(CC.PixelIdxList{comp}));
%         bottom_label_matrix = findLabels(bottom_check_BW(CC.PixelIdxList{comp}));
%         sum_label_matrix = findLabels(sum_check_BW(CC.PixelIdxList{comp}));
%         
%     if top_label_matrix(1,1) ~= 0 && top_label_matrix(1,2)== 0
%                  top_check_stats = top_check_img_stats(top_label_matrix(1,1));
%                 if numel(top_check_CC.PixelIdxList{top_label_matrix(1,1)}) >= numel(CC.PixelIdxList{comp})
%                     
%                   if (top_check_stats.BoundingBox(3)<bf_factor*stats.BoundingBox(3) && abs(top_check_stats.BoundingBox(3)-stats.BoundingBox(3)) < bf_tolerance )&& (top_check_stats.BoundingBox(4)<bf_factor*stats.BoundingBox(4) && abs(top_check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
%                      
%                      if numel(top_check_CC.PixelIdxList{top_label_matrix(1,1)}) < nf_factor* numel(CC.PixelIdxList{comp})
%                                 if Covers(top_check_img(CC.PixelIdxList{comp})) ==1
%                                    isSuper(Image_Index(Img,3),top_label_matrix(1,1)) = 1;
%                                   continue; 
%                                end
%                       end
%                   end
%                   
% %               else
% %                   if (stats.BoundingBox(3)<bf_factor*top_check_stats.BoundingBox(3) && abs(top_check_stats.BoundingBox(3)-stats.BoundingBox(3)) < bf_tolerance )&& (stats.BoundingBox(4)<bf_factor*top_check_stats.BoundingBox(4) && abs(top_check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
% %                      
% %                      if numel(CC.PixelIdxList{comp}) < nf_factor* numel(top_check_CC.PixelIdxList{top_label_matrix(1,1)})
% %                                 if Covers(img(top_check_CC.PixelIdxList{top_label_matrix(1,1)})) ==1
% %                                    isSuper(Image_Index(Img,3),top_label_matrix(1,1)) = 1;
% %                                   continue; 
% %                                end
% %                       end
% %                   end
%                     
%                   
%                 end
%     end
%         
%         if bottom_label_matrix(1,1) ~= 0 && bottom_label_matrix(1,2)== 0
%             bottom_check_stats = bottom_check_img_stats(bottom_label_matrix(1,1));
%             if numel(bottom_check_CC.PixelIdxList{bottom_label_matrix(1,1)}) >= numel(CC.PixelIdxList{comp})
%                   if (bottom_check_stats.BoundingBox(3)<bf_factor*stats.BoundingBox(3) && abs(bottom_check_stats.BoundingBox(3)-stats.BoundingBox(3)) < bf_tolerance )&& (bottom_check_stats.BoundingBox(4)<bf_factor*stats.BoundingBox(4) && abs(bottom_check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
%                      
%                      if numel(bottom_check_CC.PixelIdxList{bottom_label_matrix(1,1)}) < nf_factor* numel(CC.PixelIdxList{comp})
%                                 if Covers(bottom_check_img(CC.PixelIdxList{comp})) ==1
%                                     isSuper(Image_Index(Img,4),bottom_label_matrix(1,1)) = 1;
%                                   continue; 
%                                end
%                       end
%                   end
%                   
% %              else
% %                   if (stats.BoundingBox(3)<bf_factor*bottom_check_stats.BoundingBox(3) && abs(bottom_check_stats.BoundingBox(3)-stats.BoundingBox(3)) < bf_tolerance )&& (stats.BoundingBox(4)<bf_factor*bottom_check_stats.BoundingBox(4) && abs(bottom_check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
% %                      
% %                      if numel(CC.PixelIdxList{comp}) < nf_factor*numel(bottom_check_CC.PixelIdxList{bottom_label_matrix(1,1)})
% %                                 if Covers(img(bottom_check_CC.PixelIdxList{bottom_label_matrix(1,1)})) ==1
% %                                    isSuper(Image_Index(Img,4),bottom_label_matrix(1,1)) = 1;
% %                                   continue; 
% %                                end
% %                       end
% %                   end
% %                     
%                   
%             end
%             
%         end
%         
%                 
%         if sum_label_matrix(1,1) ~= 0 && sum_label_matrix(1,2)== 0
%             sum_check_stats = sum_check_img_stats(sum_label_matrix(1,1));
%             if numel(sum_check_CC.PixelIdxList{sum_label_matrix(1,1)}) >= numel(CC.PixelIdxList{comp})
%                   if (sum_check_stats.BoundingBox(3)<bf_factor*stats.BoundingBox(3) && abs(sum_check_stats.BoundingBox(3)-stats.BoundingBox(3)) < bf_tolerance )&& (sum_check_stats.BoundingBox(4)<bf_factor*stats.BoundingBox(4) && abs(sum_check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
%                      
%                     if numel(sum_check_CC.PixelIdxList{sum_label_matrix(1,1)}) < nf_factor* numel(CC.PixelIdxList{comp})
%                                 if Covers(sum_check_img(CC.PixelIdxList{comp})) ==1
%                                   continue; 
%                                end
%                      end
%                   end
%                   
% %             else
% %                   if (stats.BoundingBox(3)<bf_factor*sum_check_stats.BoundingBox(3) && abs(sum_check_stats.BoundingBox(3)-stats.BoundingBox(3)) < bf_tolerance )&& (stats.BoundingBox(4)<bf_factor*sum_check_stats.BoundingBox(4) && abs(sum_check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
% %                      
% %                      if numel(CC.PixelIdxList{comp}) < nf_factor* numel(sum_check_CC.PixelIdxList{sum_label_matrix(1,1)})
% %                                 if Covers(img(sum_check_CC.PixelIdxList{sum_label_matrix(1,1)})) ==1
% %                                   continue; 
% %                                end
% %                       end
% %                   end
% %                     
%                   
%              end
%         end
%         
%         img(CC.PixelIdxList{comp}) = 0; 
%         ch_img(CC.PixelIdxList{comp}) = 0; 
%      end
%      
%      Img
%      blue_final_imgs(:,:,Img) = img;
%      ch_final_imgs(:,:,Img) = ch_img;
% %      checker(:,:,i) = img;
% %      i = i+4;
% 
%  end
%   
% 
% %2nd Half
% 
%  isSuper(:,:) = 0;  
%  flag_array(:,:) = 0;
% for Img = 1:88
%      
%     img = blue_final_imgs(:,:,(Img+93)); 
%     ch_img = ch_final_imgs(:,:,(Img+93));
%     
%     CC = bwconncomp(img);
%     if CC.NumObjects<1
%        continue; 
%     end
%     img_stats = regionprops(CC);
%     flag_array(:,:) = 0;
%     flag_array(1:CC.NumObjects,1) = 1;
%     
% 
%      top_check_img = blue_final_imgs(:,:,(Image_Index(Img,1)+93));
%      bottom_check_img = blue_final_imgs(:,:,(93+Image_Index(Img,2)));
%      sum_check_img = logical(blue_final_imgs(:,:,(93+Image_Index(Img,1)))+ blue_final_imgs(:,:,(93+Image_Index(Img,2))));
%      
%      
%     top_check_CC  = bwconncomp(top_check_img);  
%     top_check_img_stats = regionprops(top_check_CC);
%     top_check_BW = bwlabel(top_check_img);
%      
%     bottom_check_CC  = bwconncomp(bottom_check_img);  
%     bottom_check_img_stats = regionprops(bottom_check_CC);
%     bottom_check_BW = bwlabel(bottom_check_img);
%      
%      
%     sum_check_CC  = bwconncomp(sum_check_img);  
%     sum_check_img_stats = regionprops(sum_check_CC);
%     sum_check_BW = bwlabel(sum_check_img);
%      
%      for comp = 1:CC.NumObjects
% 
%          
%          if isSuper(Img,comp) == 1
%              continue;
%          end
%          
%         stats = img_stats(comp);
%        
%         top_label_matrix = findLabels(top_check_BW(CC.PixelIdxList{comp}));
%         bottom_label_matrix = findLabels(bottom_check_BW(CC.PixelIdxList{comp}));
%         sum_label_matrix = findLabels(sum_check_BW(CC.PixelIdxList{comp}));
%         
%     if top_label_matrix(1,1) ~= 0 && top_label_matrix(1,2)== 0
%                  top_check_stats = top_check_img_stats(top_label_matrix(1,1));
%                 if numel(top_check_CC.PixelIdxList{top_label_matrix(1,1)}) > numel(CC.PixelIdxList{comp})
%                     
%                   if (top_check_stats.BoundingBox(3)<bf_factor*stats.BoundingBox(3) && abs(top_check_stats.BoundingBox(3)-stats.BoundingBox(3)) < bf_tolerance )&& (top_check_stats.BoundingBox(4)<bf_factor*stats.BoundingBox(4) && abs(top_check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
%                      
%                      if numel(top_check_CC.PixelIdxList{top_label_matrix(1,1)}) < nf_factor* numel(CC.PixelIdxList{comp})
%                                 if Covers(top_check_img(CC.PixelIdxList{comp})) ==1
%                                    isSuper(Image_Index(Img,1),top_label_matrix(1,1)) = 1;
%                                   continue; 
%                                end
%                       end
%                   end
%                   
%               else
%                   if (stats.BoundingBox(3)<bf_factor*top_check_stats.BoundingBox(3) && abs(top_check_stats.BoundingBox(3)-stats.BoundingBox(3)) < bf_tolerance )&& (stats.BoundingBox(4)<bf_factor*top_check_stats.BoundingBox(4) && abs(top_check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
%                      
%                      if numel(CC.PixelIdxList{comp}) < nf_factor* numel(top_check_CC.PixelIdxList{top_label_matrix(1,1)})
%                                 if Covers(img(top_check_CC.PixelIdxList{top_label_matrix(1,1)})) ==1
%                                    isSuper(Image_Index(Img,1),top_label_matrix(1,1)) = 1;
%                                   continue; 
%                                end
%                       end
%                   end
%                     
%                   
%                 end
%     end
%         
%         if bottom_label_matrix(1,1) ~= 0 && bottom_label_matrix(1,2)== 0
%             bottom_check_stats = bottom_check_img_stats(bottom_label_matrix(1,1));
%             if numel(bottom_check_CC.PixelIdxList{bottom_label_matrix(1,1)}) > numel(CC.PixelIdxList{comp})
%                   if (bottom_check_stats.BoundingBox(3)<bf_factor*stats.BoundingBox(3) && abs(bottom_check_stats.BoundingBox(3)-stats.BoundingBox(3)) < bf_tolerance )&& (bottom_check_stats.BoundingBox(4)<bf_factor*stats.BoundingBox(4) && abs(bottom_check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
%                      
%                      if numel(bottom_check_CC.PixelIdxList{bottom_label_matrix(1,1)}) < nf_factor* numel(CC.PixelIdxList{comp})
%                                 if Covers(bottom_check_img(CC.PixelIdxList{comp})) ==1
%                                     isSuper(Image_Index(Img,2),bottom_label_matrix(1,1)) = 1;
%                                   continue; 
%                                end
%                       end
%                   end
%                   
%              else
%                   if (stats.BoundingBox(3)<bf_factor*bottom_check_stats.BoundingBox(3) && abs(bottom_check_stats.BoundingBox(3)-stats.BoundingBox(3)) < bf_tolerance )&& (stats.BoundingBox(4)<bf_factor*bottom_check_stats.BoundingBox(4) && abs(bottom_check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
%                      
%                      if numel(CC.PixelIdxList{comp}) < nf_factor*numel(bottom_check_CC.PixelIdxList{bottom_label_matrix(1,1)})
%                                 if Covers(img(bottom_check_CC.PixelIdxList{bottom_label_matrix(1,1)})) ==1
%                                    isSuper(Image_Index(Img,2),bottom_label_matrix(1,1)) = 1;
%                                   continue; 
%                                end
%                       end
%                   end
%                     
%                   
%             end
%             
%         end
%         
%                 
%         if sum_label_matrix(1,1) ~= 0 && sum_label_matrix(1,2)== 0
%             sum_check_stats = sum_check_img_stats(sum_label_matrix(1,1));
%             if numel(sum_check_CC.PixelIdxList{sum_label_matrix(1,1)}) > numel(CC.PixelIdxList{comp})
%                   if (sum_check_stats.BoundingBox(3)<bf_factor*stats.BoundingBox(3) && abs(sum_check_stats.BoundingBox(3)-stats.BoundingBox(3)) < bf_tolerance )&& (sum_check_stats.BoundingBox(4)<bf_factor*stats.BoundingBox(4) && abs(sum_check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
%                      
%                     if numel(sum_check_CC.PixelIdxList{sum_label_matrix(1,1)}) < nf_factor* numel(CC.PixelIdxList{comp})
%                                 if Covers(sum_check_img(CC.PixelIdxList{comp})) ==1
%                                   continue; 
%                                end
%                      end
%                   end
%                   
%             else
%                   if (stats.BoundingBox(3)<bf_factor*sum_check_stats.BoundingBox(3) && abs(sum_check_stats.BoundingBox(3)-stats.BoundingBox(3)) < bf_tolerance )&& (stats.BoundingBox(4)<bf_factor*sum_check_stats.BoundingBox(4) && abs(sum_check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
%                      
%                      if numel(CC.PixelIdxList{comp}) < nf_factor* numel(sum_check_CC.PixelIdxList{sum_label_matrix(1,1)})
%                                 if Covers(img(sum_check_CC.PixelIdxList{sum_label_matrix(1,1)})) ==1
%                                   continue; 
%                                end
%                       end
%                   end
%                     
%                   
%              end
%         end
%         flag_array(comp,1) = 0;
%         
% 
%      
%      
%   
%      end
%      
% 
%      top_check_img = blue_final_imgs(:,:,(93+Image_Index(Img,3)));
%      bottom_check_img = blue_final_imgs(:,:,(93+Image_Index(Img,4)));
%      sum_check_img = logical(blue_final_imgs(:,:,(93+Image_Index(Img,3)))+ blue_final_imgs(:,:,(93+Image_Index(Img,4))));
%      
%      
%     top_check_CC  = bwconncomp(top_check_img);  
%     top_check_img_stats = regionprops(top_check_CC);
%     top_check_BW = bwlabel(top_check_img);
%      
%     bottom_check_CC  = bwconncomp(bottom_check_img);  
%     bottom_check_img_stats = regionprops(bottom_check_CC);
%     bottom_check_BW = bwlabel(bottom_check_img);
%      
%      
%     sum_check_CC  = bwconncomp(sum_check_img);  
%     sum_check_img_stats = regionprops(sum_check_CC);
%     sum_check_BW = bwlabel(sum_check_img);
%      
%      for comp = 1:CC.NumObjects
%          if flag_array(comp,1) == 1
%              continue;
%          end
%          
%         stats = img_stats(comp);
%        
%         top_label_matrix = findLabels(top_check_BW(CC.PixelIdxList{comp}));
%         bottom_label_matrix = findLabels(bottom_check_BW(CC.PixelIdxList{comp}));
%         sum_label_matrix = findLabels(sum_check_BW(CC.PixelIdxList{comp}));
%         
%     if top_label_matrix(1,1) ~= 0 && top_label_matrix(1,2)== 0
%                  top_check_stats = top_check_img_stats(top_label_matrix(1,1));
%                 if numel(top_check_CC.PixelIdxList{top_label_matrix(1,1)}) > numel(CC.PixelIdxList{comp})
%                     
%                   if (top_check_stats.BoundingBox(3)<bf_factor*stats.BoundingBox(3) && abs(top_check_stats.BoundingBox(3)-stats.BoundingBox(3)) < bf_tolerance )&& (top_check_stats.BoundingBox(4)<bf_factor*stats.BoundingBox(4) && abs(top_check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
%                      
%                      if numel(top_check_CC.PixelIdxList{top_label_matrix(1,1)}) < nf_factor* numel(CC.PixelIdxList{comp})
%                                 if Covers(top_check_img(CC.PixelIdxList{comp})) ==1
%                                    isSuper(Image_Index(Img,3),top_label_matrix(1,1)) = 1;
%                                   continue; 
%                                end
%                       end
%                   end
%                   
%               else
%                   if (stats.BoundingBox(3)<bf_factor*top_check_stats.BoundingBox(3) && abs(top_check_stats.BoundingBox(3)-stats.BoundingBox(3)) < bf_tolerance )&& (stats.BoundingBox(4)<bf_factor*top_check_stats.BoundingBox(4) && abs(top_check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
%                      
%                      if numel(CC.PixelIdxList{comp}) < nf_factor* numel(top_check_CC.PixelIdxList{top_label_matrix(1,1)})
%                                 if Covers(img(top_check_CC.PixelIdxList{top_label_matrix(1,1)})) ==1
%                                    isSuper(Image_Index(Img,3),top_label_matrix(1,1)) = 1;
%                                   continue; 
%                                end
%                       end
%                   end
%                     
%                   
%                 end
%     end
%         
%         if bottom_label_matrix(1,1) ~= 0 && bottom_label_matrix(1,2)== 0
%             bottom_check_stats = bottom_check_img_stats(bottom_label_matrix(1,1));
%             if numel(bottom_check_CC.PixelIdxList{bottom_label_matrix(1,1)}) > numel(CC.PixelIdxList{comp})
%                   if (bottom_check_stats.BoundingBox(3)<bf_factor*stats.BoundingBox(3) && abs(bottom_check_stats.BoundingBox(3)-stats.BoundingBox(3)) < bf_tolerance )&& (bottom_check_stats.BoundingBox(4)<bf_factor*stats.BoundingBox(4) && abs(bottom_check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
%                      
%                      if numel(bottom_check_CC.PixelIdxList{bottom_label_matrix(1,1)}) < nf_factor* numel(CC.PixelIdxList{comp})
%                                 if Covers(bottom_check_img(CC.PixelIdxList{comp})) ==1
%                                     isSuper(Image_Index(Img,4),bottom_label_matrix(1,1)) = 1;
%                                   continue; 
%                                end
%                       end
%                   end
%                   
%              else
%                   if (stats.BoundingBox(3)<bf_factor*bottom_check_stats.BoundingBox(3) && abs(bottom_check_stats.BoundingBox(3)-stats.BoundingBox(3)) < bf_tolerance )&& (stats.BoundingBox(4)<bf_factor*bottom_check_stats.BoundingBox(4) && abs(bottom_check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
%                      
%                      if numel(CC.PixelIdxList{comp}) < nf_factor*numel(bottom_check_CC.PixelIdxList{bottom_label_matrix(1,1)})
%                                 if Covers(img(bottom_check_CC.PixelIdxList{bottom_label_matrix(1,1)})) ==1
%                                    isSuper(Image_Index(Img,4),bottom_label_matrix(1,1)) = 1;
%                                   continue; 
%                                end
%                       end
%                   end
%                     
%                   
%             end
%             
%         end
%         
%                 
%         if sum_label_matrix(1,1) ~= 0 && sum_label_matrix(1,2)== 0
%             sum_check_stats = sum_check_img_stats(sum_label_matrix(1,1));
%             if numel(sum_check_CC.PixelIdxList{sum_label_matrix(1,1)}) > numel(CC.PixelIdxList{comp})
%                   if (sum_check_stats.BoundingBox(3)<bf_factor*stats.BoundingBox(3) && abs(sum_check_stats.BoundingBox(3)-stats.BoundingBox(3)) < bf_tolerance )&& (sum_check_stats.BoundingBox(4)<bf_factor*stats.BoundingBox(4) && abs(sum_check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
%                      
%                     if numel(sum_check_CC.PixelIdxList{sum_label_matrix(1,1)}) < nf_factor* numel(CC.PixelIdxList{comp})
%                                 if Covers(sum_check_img(CC.PixelIdxList{comp})) ==1
%                                   continue; 
%                                end
%                      end
%                   end
%                   
%             else
%                   if (stats.BoundingBox(3)<bf_factor*sum_check_stats.BoundingBox(3) && abs(sum_check_stats.BoundingBox(3)-stats.BoundingBox(3)) < bf_tolerance )&& (stats.BoundingBox(4)<bf_factor*sum_check_stats.BoundingBox(4) && abs(sum_check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
%                      
%                      if numel(CC.PixelIdxList{comp}) < nf_factor* numel(sum_check_CC.PixelIdxList{sum_label_matrix(1,1)})
%                                 if Covers(img(sum_check_CC.PixelIdxList{sum_label_matrix(1,1)})) ==1
%                                   continue; 
%                                end
%                       end
%                   end
%                     
%                   
%              end
%         end
%         
%         img(CC.PixelIdxList{comp}) = 0; 
%         ch_img(CC.PixelIdxList{comp}) = 0;
%      end
%      
%      (93+Img)
%      blue_final_imgs(:,:,(93+Img)) = img;
%      ch_final_imgs(:,:,(93+Img)) = ch_img;
% %          blue_final_imgs(:,:,i) = img;
% %     i = i+3;
% end
% 
% 
% 
% %Removing non supersets from last q
%  for Img = 89:93
%     img = blue_final_imgs(:,:,Img);
%     CC = bwconncomp(img);
%     if CC.NumObjects<1
%         continue;
%     end
%     
%     for comp = 1:CC.NumObjects
%        if isSuper(Img,comp) ~=1
%           
%            img(CC.PixelIdxList{comp}) = 0;
%        end
%         
%     end
%     (Img)
%     blue_final_imgs(:,:,Img) = img;
% end
% 
% 
% % Removing non supersets from final q
% 
% for Img = 89:93
%     img = blue_final_imgs(:,:,(93+Img));
%     CC = bwconncomp(img);
%     if CC.NumObjects<1
%         continue;
%     end
%     
%     for comp = 1:CC.NumObjects
%        if isSuper(Img,comp) ~=1
%           
%            img(CC.PixelIdxList{comp}) = 0;
%        end
%         
%     end
%     (93+Img)
%     blue_final_imgs(:,:,(93+Img)) = img;
% end
% 
% 
%      if  layer == 1
%        gray_binary = blue_final_imgs;
%        gray_final_imgs = ch_final_imgs;
%     end
%     
%     if  layer == 2
%         red_binary = blue_final_imgs;
%         red_final_imgs = ch_final_imgs;
%     end
%     
%     if  layer == 3
%         green_binary = blue_final_imgs;
%         green_final_imgs = ch_final_imgs;
%     end
%     
%     if  layer == 4
%         temp_binary = blue_final_imgs;
%         temp_final_imgs = ch_final_imgs;
%     end    
%       
%     
%     
%     
% end
% 
% 
% 
% %For Printing Everything
% 
%  
%  st = 1;
%  
%  for layer = []
%      
%     if layer == 1
%         
%         all_final_imgs(:,:,st:(st+185)) = gray_final_imgs;
%         st = st+186;
%     end
%     
%     if layer == 2
%         
%         all_final_imgs(:,:,st:(st+185)) = red_final_imgs;
%         st = st+186;
%     end  
%     
%     if layer == 3
%         
%         all_final_imgs(:,:,st:(st+185)) = green_final_imgs;
%         st = st+186;
%     end
%     
%    if layer == 4
%         
%         all_final_imgs(:,:,st:(st+185)) = blue_final_imgs;
%         st = st+186;
%     end
%      
%      
%  end
% %For Printing STuff
% 
% %Gray
% for sub = gray_set
%     
%     
%    output_image = output_image  + gray_binary(:,:,sub);
%     
% end
% 
% %Red
% 
% for sub = red_set
%     
%     
%    output_image = output_image  + red_binary(:,:,sub);
%     
% end
% 
% %Green
% 
% for sub = green_set
%     
%     
%    output_image = output_image  + green_binary(:,:,sub);
%     
% end
% 
% 
% %Blue
% 
% for sub = blue_set
%     
%     
%    output_image = output_image  + temp_binary(:,:,sub);
%     
% end
% 
% 
% 
% for layer = apply_box
%    
%     CC = bwconncomp(output_image);
%     img_stats = regionprops(CC);
%     for comp = 1:CC.NumObjects
%         stats = img_stats(comp);
%         
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
% 
%                 image(top:bottom,left,1) = 255;  
%                 image(top:bottom,right,1) = 255;
%                 image(top,left:right,1) = 255;
%                 image(bottom,left:right,1) = 255;
% %        
%         
%         
%     end
% 
%     
%     
% end
% 
% imshow(image);
%  
% 
% 
% 
% % for sub = 1:1                                                 
% %  img = output_image;
% %  final_img(:,:) = 0;
% % 
% %     %Alignment Analysis 
% % 
% %    aligned_map(:,:) = 0;
% %   img_comp_map(:,:) = 0;
% %  
% %     
% %      palate(:,:) = 0;
% %      
% %       CC = bwconncomp(img);
% %       
% %    
% %      img_comp_map(1:CC.NumObjects,1) = 1;     
% %      img_stats = regionprops(CC);
% % 
% %     for comp = 1:CC.NumObjects
% %         
% %          
% %          if img_comp_map(comp,1) == 0
% %              continue;
% %          end
% %          
% %          aligned_map(:,:) = 0;
% %          aligns=0;
% %          
% %          
% %          stats = img_stats(comp);
% %          
% %          
% %      
% %          
% % 
% %          
% %   
% %  
% % 
% %                 
% %          
% %          height = stats.BoundingBox(4);
% %          y_cord = floor(stats.BoundingBox(1))+stats.BoundingBox(3);
% %          
% % 
% %          
% %          upper_bottom_margin = stats.BoundingBox(2)+height+height*base_line_factor;
% %          lower_bottom_margin = stats.BoundingBox(2)+height -height*base_line_factor;
% %          
% % %          density_array(:,:) = 0;
% %          
% %          for check_comp = comp:CC.NumObjects
% %              
% %             if check_comp == comp || img_comp_map(check_comp,1) == 0
% %                 continue;
% %             end
% %                    
% %             stats = img_stats(check_comp);
% %             
% %              if abs(stats.BoundingBox(1)-y_cord)>2*aligned_distance_factor*height
% %                 break;
% %              end               
% % 
% %             if stats.BoundingBox(4)>aligned_upper_height_factor*height || stats.BoundingBox(4)<aligned_lower_height_factor*height || abs(stats.BoundingBox(1)-y_cord)>aligned_distance_factor*height
% %                continue;
% %             end
% % 
% % 
% % %             
% %             
% %             top_margin = stats.BoundingBox(2);
% %             bottom_margin = top_margin + stats.BoundingBox(4);
% %              
% %             if bottom_margin>lower_bottom_margin && bottom_margin<upper_bottom_margin %&& (uff-avg_uff) < aligned_uff_tolerance
% %                
% %                 if aligns == 0
% %                     aligns = aligns+1;
% %                    img_comp_map(comp,1) = 0;
% %                    aligned_map(aligns,1) = comp;
% %                   % density_array(aligns,1) = avg_density;
% %                 end
% %                 
% % 
% %  
% %                 height = max(height,stats.BoundingBox(4));
% %                 upper_bottom_margin = stats.BoundingBox(2)+stats.BoundingBox(4)+height*base_line_factor;
% %                 lower_bottom_margin = stats.BoundingBox(2)+stats.BoundingBox(4) -height*base_line_factor;
% %     
% %                  y_cord = floor(stats.BoundingBox(1)) +stats.BoundingBox(3);
% %                  
% %                 aligns = aligns+1;
%                 
%                 img_comp_map(check_comp,1) =0;
%                 aligned_map(aligns,1)=check_comp;
%               
%                 
%  
%                 
%                 
% 
%                 
% 
%             end
%             
%          end
%           
%          if aligns == 0
%               
%                  stats = img_stats(comp);
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
% 
%                 image(top:bottom,left,1) = 255;  
%                 image(top:bottom,right,1) = 255;
%                 image(top,left:right,1) = 255;
%                 image(bottom,left:right,1) = 255;
%        
%                 
%           end
% 
%          
%         
%             if aligns>0
%                 stats = img_stats(comp);
%                 left_m = floor(stats.BoundingBox(1));
%                 if left_m == 0
%                     left_m = 1;
%                 end
%                 right_m = left_m+stats.BoundingBox(3)+1;
%                 if right_m >col
%                     right_m = col;
%                 end
%                 
%                 top_m = floor(stats.BoundingBox(2));
%                 if top_m == 0
%                     top_m = 1;
%                 end
%                 bottom_m = top_m + stats.BoundingBox(4)+1;
%                 if bottom_m >row
%                     bottom_m = row;
%                 end
%             
%              while aligns>0 
%                  stats = img_stats(aligned_map(aligns,1));
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
%              
%                 left_m = min(left_m,left);
%                 right_m = max(right_m,right);
%                 top_m = min(top_m,top);
%                 bottom_m = max(bottom_m,bottom);
%                  
%                aligns = aligns - 1;
%              end
%             
%                  image(top_m:bottom_m,left_m,1) = 255;  
%                 image(top_m:bottom_m,right_m,1) = 255;
%                 image(top_m,left_m:right_m,1) = 255;
%                 image(bottom_m,left_m:right_m,1) = 255;
%                    
%             end 
%         
%          
%    
%          
%          
%     end
%      
%   
% %     checker(:,:,i) = final_img;
% %     i = i+4;
% 
% 
% end

% stage = 7
% 
% %Algorithm :: Look for Dominant (98%) Bin across any image plane.Return a
% %matrix 
% layered_imgs = false(row,col,186,4);
% 
% layered_imgs(:,:,:,1) = gray_final_imgs;
% layered_imgs(:,:,:,2) = red_final_imgs;
% layered_imgs(:,:,:,3) = green_final_imgs;
% layered_imgs(:,:,:,4) = temp_final_imgs;
% 
% for sub = 1:186
%     
%    gray_CC(sub) = bwconncomp(gray_final_imgs(:,:,sub)); 
%    red_CC(sub) = bwconncomp(red_final_imgs(:,:,sub));
%    green_CC(sub) = bwconncomp(green_final_imgs(:,:,sub));
%    blue_CC(sub) = bwconncomp(temp_final_imgs(:,:,sub));
%    
% 
%     
% end
% 
% 
% 
% 
% for layer = 1:4
% 
%   layer_imgs = layered_imgs(:,:,:,layer);
% 
%   if layer  == 1
%       first_layer = layered_imgs(:,:,:,2);
%       first_CC = red_CC;
%   %    first_img_stats = red_img_stats;
%   else
%       first_layer = layered_imgs(:,:,:,1);
%       first_CC = gray_CC;
%  %    first_img_stats = gray_img_stats;
%   end
%   
%   if layer  == 2
%       second_layer = layered_imgs(:,:,:,3);
%       second_CC = green_CC;
%   %    second_img_stats = green_img_stats;
%   else
%       second_layer = layered_imgs(:,:,:,2);
%       second_CC = red_CC;
%   %    second_img_stats = red_img_stats;
%   end
%   
%   if layer  == 3
%       third_layer = layered_imgs(:,:,:,4);
%       third_CC = blue_CC;
%   %    third_img_stats = blue_img_stats;
%   else
%       third_layer = layered_imgs(:,:,:,3);
%       third_CC = green_CC;
%   %    third_img_stats = green_img_stats;
%   end
%   
%   
%     
%    q_offset = 0;
%    for i = 1:numel(q)
%      main_offset = ceil(256/q(i));
%      
%      for sub = (q_offset+1):(q_offset+2*main_offset-1)
%          img = layer_imgs(:,:,sub);
%          CC = bwconncomp(img);
%          img_stats = regionprops(CC);
%          for comp = 1:CC.NumObjects
%              stats = img_stats(comp);
%             for check_sub = (q_offset+1):(q_offset+2*main_offset-1)
%                
%                %1st
%                  check_img = first_layer(:,:,check_sub);
%                  check_CC = first_CC(check_sub);
%                  check_img_stats = regionprops(check_CC);
%                  BW_img = bwlabel(check_img);
%                  
%                  label_matrix = findLabels(BW_img(CC.PixelIdxList{comp}));
%                  
%                  if label_matrix(1,1)~=0 && label_matrix(1,2) == 0
%                     check_stats = check_img_stats(label_matrix(1,1));
%                  if numel(check_CC.PixelIdxList{label_matrix(1,1)}) >= numel(CC.PixelIdxList{comp}) 
%                   if (check_stats.BoundingBox(3)<bf_factor*stats.BoundingBox(3) && abs(check_stats.BoundingBox(3)-stats.BoundingBox(3)) < bf_tolerance )&& (check_stats.BoundingBox(4)<bf_factor*stats.BoundingBox(4) && abs(check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
%                      
%                      if numel(check_CC.PixelIdxList{label_matrix(1,1)}) < nf_factor* numel(CC.PixelIdxList{comp})
%                                 if Covers(check_img(CC.PixelIdxList{comp})) ==1
%                                    output_image(CC.PixelIdxList{comp}) = 1;
%                                end
%                       end
%                   end
%                  else    
%                   if (stats.BoundingBox(3)<bf_factor*check_stats.BoundingBox(3) && abs(stats.BoundingBox(3)-check_stats.BoundingBox(3)) < bf_tolerance )&& (stats.BoundingBox(4)<bf_factor*check_stats.BoundingBox(4) && abs(check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
%                      
%                      if numel(CC.PixelIdxList{comp}) < nf_factor* numel(check_CC.PixelIdxList{label_matrix(1,1)})
%                                 if Covers(img(check_CC.PixelIdxList{label_matrix(1,1)})) ==1
%                                    output_image(CC.PixelIdxList{comp}) = 1;
%                                   continue; 
%                                end
%                       end
%                   end
%        
%                  end
%                      
%                  end
%                  
%                
%                %2nd
%                  check_img = second_layer(:,:,check_sub);
%                  check_CC = second_CC(check_sub);
%                  check_img_stats = regionprops(check_CC);
%                  BW_img = bwlabel(check_img);
%                  
%                  label_matrix = findLabels(BW_img(CC.PixelIdxList{comp}));
%                  
%                  if label_matrix(1,1)~=0 && label_matrix(1,2) == 0
%                     check_stats = check_img_stats(label_matrix(1,1));
%                  if numel(check_CC.PixelIdxList{label_matrix(1,1)}) >= numel(CC.PixelIdxList{comp}) 
%                   if (check_stats.BoundingBox(3)<bf_factor*stats.BoundingBox(3) && abs(check_stats.BoundingBox(3)-stats.BoundingBox(3)) < bf_tolerance )&& (check_stats.BoundingBox(4)<bf_factor*stats.BoundingBox(4) && abs(check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
%                      
%                      if numel(check_CC.PixelIdxList{label_matrix(1,1)}) < nf_factor* numel(CC.PixelIdxList{comp})
%                                 if Covers(check_img(CC.PixelIdxList{comp})) ==1
%                                    output_image(CC.PixelIdxList{comp}) = 1;
%                                end
%                       end
%                   end
%                  else
%                        
%                   if (stats.BoundingBox(3)<bf_factor*check_stats.BoundingBox(3) && abs(stats.BoundingBox(3)-check_stats.BoundingBox(3)) < bf_tolerance )&& (stats.BoundingBox(4)<bf_factor*check_stats.BoundingBox(4) && abs(check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
%                      
%                      if numel(CC.PixelIdxList{comp}) < nf_factor* numel(check_CC.PixelIdxList{label_matrix(1,1)})
%                                 if Covers(img(check_CC.PixelIdxList{label_matrix(1,1)})) ==1
%                                    output_image(CC.PixelIdxList{comp}) = 1;
%                                   continue; 
%                                end
%                       end
%                   end
%                   
%                   
%                   
%                  end
%                      
%                  end
%                  
%                
% 
% 
%                
%                
%                %3rd
%                  check_img = third_layer(:,:,check_sub);
%                  check_CC = third_CC(check_sub);
%                  check_img_stats = regionprops(check_CC);
%                  BW_img = bwlabel(check_img);
%                  
%                  label_matrix = findLabels(BW_img(CC.PixelIdxList{comp}));
%                  
%                  if label_matrix(1,1)~=0 && label_matrix(1,2) == 0
%                     check_stats = check_img_stats(label_matrix(1,1));
%                  if numel(check_CC.PixelIdxList{label_matrix(1,1)}) >= numel(CC.PixelIdxList{comp}) 
%                   if (check_stats.BoundingBox(3)<bf_factor*stats.BoundingBox(3) && abs(check_stats.BoundingBox(3)-stats.BoundingBox(3)) < bf_tolerance )&& (check_stats.BoundingBox(4)<bf_factor*stats.BoundingBox(4) && abs(check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
%                      
%                      if numel(check_CC.PixelIdxList{label_matrix(1,1)}) < nf_factor* numel(CC.PixelIdxList{comp})
%                                 if Covers(check_img(CC.PixelIdxList{comp})) ==1
%                                    output_image(CC.PixelIdxList{comp}) = 1;
%                                end
%                       end
%                   end
%                  else
%                        
%                   if (stats.BoundingBox(3)<bf_factor*check_stats.BoundingBox(3) && abs(stats.BoundingBox(3)-check_stats.BoundingBox(3)) < bf_tolerance )&& (stats.BoundingBox(4)<bf_factor*check_stats.BoundingBox(4) && abs(check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
%                      
%                      if numel(CC.PixelIdxList{comp}) < nf_factor* numel(check_CC.PixelIdxList{label_matrix(1,1)})
%                                 if Covers(img(check_CC.PixelIdxList{label_matrix(1,1)})) ==1
%                                    output_image(CC.PixelIdxList{comp}) = 1;
%                                   continue; 
%                                end
%                       end
%                   end
%                   
%                   
%                   
%                  end
%                      
%                  end
%                  
%                
%                 
%                 
%             end
%              
%          end
%          
%          
%      end
%        
%      q_offset = q_offset + 2*main_offset -1;  
%    end
%     
%  
% end
% 

% stage = 7
% 
% 
% for sub = 1:186                                                
%  img = temp_final_imgs(:,:,sub);
% 
% % palate(:,:) = 0;
%  CC = bwconncomp(img);
%  img_stats = regionprops(CC);
%    
%   
%      for obj = 1:CC.NumObjects
%          
%         stats = img_stats(obj);
%        
%        if max(stats.BoundingBox(3),stats.BoundingBox(4))<5 || numel(CC.PixelIdxList{obj})< 5 
%           img(CC.PixelIdxList{obj})= 0;
%           continue;
%        end
% 
%          
%      end
% 
%          
%     temp_final_imgs(:,:,sub) = img(:,:);
% %      checker(:,:,i) = img;
% %     i = i+4;
% 
%  end



% for layer = 1:4
%     
%      if  layer == 1
%         blue_final_imgs = gray_final_imgs;
%     end
%     
%     if  layer == 2
%         blue_final_imgs = red_final_imgs;
%     end
%     
%     if  layer == 3
%         blue_final_imgs = green_final_imgs;
%     end
%     
%     if  layer == 4
%         blue_final_imgs = temp_final_imgs;
%     end 
%     
%   for sub = 32:181
%       
%       
%      checker(:,:,layer) = checker(:,:,layer) + blue_final_imgs(:,:,sub); 
%       
%   end
%     
%     
%     
% end


% stage = 8






% stage = 7
% for layer = 1:4
%     
%      if  layer == 1
%         blue_final_imgs = gray_final_imgs;
%     end
%     
%     if  layer == 2
%         blue_final_imgs = red_final_imgs;
%     end
%     
%     if  layer == 3
%         blue_final_imgs = green_final_imgs;
%     end
%     
%     if  layer == 4
%         blue_final_imgs = temp_final_imgs;
%     end 
%     
%    q_offset = 31;
%  for i = 2:numel(q(i))
%      
%      main_offset = ceil(256/q(i));
%      
%      for sub = (q_offset +1):(q_offset + 2*main_offset -1)
%           
%        img = blue_final_imgs(:,:,sub);
%        CC = bwconncomp(img);
%       
%        for comp = 1:CC.NumObjects
%            flag = 0;
%        for check_layer = 1:4
%            
%           if layer == check_layer
%               continue;
%           end
%           
%           
%        for check_sub = (q_offset +1):(q_offset + 2*main_offset -1) 
%            check_img = blue_final_imgs(:,:,check_sub); 
%            if Covers(check_img(CC.PixelIdxList{comp})) == 1
%                
%               output_image(CC.PixelIdxList{comp}) = 1;
%               break;
%                
%            end
%        end
%           
%            
%        end
%          
%            
%        end
%       
%      end
%     
%      q_offset = q_offset + 2*main_offset - 1;
%      
%  end
%     
%     
% end
% 
% 
% 
% 
% 
% 
% 
% stage = 8
% 
% 
% 
% for ch = 1:4
%     BW_imgs(:,:,ch) = bwlabel(checker(:,:,ch));
% %     CC_imgs(ch) = bwconncomp(checker(:,:,ch));
% end
% 
% 
% 
%  bl = image(:,:,3);
% for layer = 1:4
%     
%     img = checker(:,:,layer);
%     CC = bwconncomp(img);
%    img_stats = regionprops(CC);
%    for comp = 1:CC.NumObjects
%       stats = img_stats(comp);
%        for check_layer = 1:4
%            
%           if check_layer == layer
%              continue; 
%           end
% 
%           BW_img = BW_imgs(:,:,check_layer);
%           
%           label_matrix = findLabels(BW_img(CC.PixelIdxList{comp}));
%           
%           if label_matrix(1,1) == 0 || label_matrix(1,2)~=0
%               continue;
%           end
%           
%           check_img = checker(:,:,check_layer);
%           check_CC = bwconncomp(checker(:,:,check_layer));
%           check_img_stats = regionprops(check_CC);
%           check_stats = check_img_stats(label_matrix(1,1));
%  
%   
%       
%            
%                 if numel(check_CC.PixelIdxList{label_matrix(1,1)}) > numel(CC.PixelIdxList{comp})
%                     
%                   if (check_stats.BoundingBox(3)<bf_factor*stats.BoundingBox(3) && abs(check_stats.BoundingBox(3)-stats.BoundingBox(3)) < bf_tolerance )&& (check_stats.BoundingBox(4)<bf_factor*stats.BoundingBox(4) && abs(check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
%                      
%                      if numel(check_CC.PixelIdxList{label_matrix(1,1)}) < nf_factor* numel(CC.PixelIdxList{comp})
%                                 if Covers(check_img(CC.PixelIdxList{comp})) ==1
%                                     output_image(check_CC.PixelIdxList{label_matrix(1,1)}) = 1;
%                                     bl(check_CC.PixelIdxList{label_matrix(1,1)}) = 255;
%                                     
% %                                    check_img(check_CC.PixelIdxList{label_matrix(1,1)}) = 0;
% %                                    checker(:,:,check_layer) = check_img;
% %                                    img(CC.PixelIdxList{comp}) = 0;
%                                   break; 
%                                end
%                       end
%                   end
%                   
%                 else
%                   if (stats.BoundingBox(3)<bf_factor*check_stats.BoundingBox(3) && abs(check_stats.BoundingBox(3)-stats.BoundingBox(3)) < bf_tolerance )&& (stats.BoundingBox(4)<bf_factor*check_stats.BoundingBox(4) && abs(check_stats.BoundingBox(4)-stats.BoundingBox(4)) < bf_tolerance)
%                      
%                      if numel(CC.PixelIdxList{comp}) < nf_factor* numel(check_CC.PixelIdxList{label_matrix(1,1)})
%                                 if Covers(img(check_CC.PixelIdxList{label_matrix(1,1)})) ==1
%                                    output_image(CC.PixelIdxList{comp}) = 1;
%                                    bl(CC.PixelIdxList{comp}) = 255;
% %                                    check_img(check_CC.PixelIdxList{label_matrix(1,1)}) = 0;
% %                                    checker(:,:,check_layer) = check_img;
% %                                    img(CC.PixelIdxList{comp}) = 0;
%                                    break;
%                                end
%                       end
%                   end
%                     
%                   
%                 end
%        
%                   
%           
%            
%        end
%        
%    end
%     
%     
% end
%  
% image(:,:,3) = bl;
% imshow(image);
%  
 

     
 






   
   