function [X,y] = extractStabilityValues(img,region,curr_obj_region,BinImages,NUM_BIN_IMAGES,BinSizes,MAX_DISTANCE,StabilityCheckMatrix,BinMatrix)

%%Params for Feature Extraction
    max_growth = 0.2; %The Maximum growth allowed on increase in Bin Size
    max_positive_label_deviation = 0.25; %The Max deviation from k-means image that can also be labelled positive
    %TODO:: NEED TO LABEL CORRECT POSITIVE REGIONS
    
    
    show_results = false;
    
    
    %%OLD CODE BACKUP
    
   %Primary Features: 
    % 1. Del(No. of Pixels Bin i - Bin i + SubBin(i-1,i+1))/Total No. of Pixels
    % 2. Del(No. of Pixels Bin i - Bin(i,i+1,i-1))/Total No. of Pixels
    % 3. No. of Holes                   
    % 4. Del(No. of Holes Bin i - Bin i + SubBin(i-1,i+1))
    % 5. Del(No. of Holes Bin i - Bin i + Bin(i-1,i+1))
    % 6. Density 
    % 7. Del(Change of Density of Bin i - Bin i + SubBin(i-1,i+1))/Density
    % 8. Del(Change of Density of Bin i - Bin i + Bin(i,i-1,i+1))/Density
    % 9. Number of Pixels
    % 10. BinSize
    % 11.Lower Range Increment Check  (Eliminate)
    % 12. Higher Range Increment Check (Eliminate)
    
    %Secondary Features
    % 13. 1. * 9.
    % 14. 2. * 9.
    % 15. 3. / 10.
    % 16. 3. / 9.
    % 17. 1. /10.
    % 18. 2. / 10.
    
           % BinImages = Uniquize_2Level(BinImages,BinSizes,BinSizes,MAX_DISTANCE);
  
  y = false(1,1);
  X = zeros(1,12);
  training_entry = 0; 
 
   
  
%   NumImages = NUM_BIN_IMAGES;
 
[row,col,~] = size(BinImages);
error_figure = false(row,col);

show_img = false(row,col);
    %Creating labelled images beforehand to speed up process
%     BWImages = zeros(size(BinImages));
%     
%     for bw_c = 1:NUM_BIN_IMAGES  
%         BWImages(:,:,bw_c) = bwlabel(BinImages(:,:,bw_c));
%     end
    

%% We First find a Bin Image Component closest to the region,store the deviation in min_deviation

    
    min_deviation_set = 0;
    
    q_offset = 0;
 
     
    
     
%    for i = 1:8   %Must change Loop for change of Bins    
%          main_offset = ceil(MAX_DISTANCE/BinSizes(i));
%          
%     %For 1st Level Bins
%        for img_no = (q_offset+1):(q_offset+main_offset)
% 
%         if img_no ~= (q_offset+main_offset)
%           scan_img = logical(BinImages(:,:,img_no)+BinImages(:,:,(img_no+main_offset)));
%         else
%            scan_img = logical(BinImages(:,:,img_no));
%         end
%         label_scan_img = bwlabel(scan_img);
%         CC_scan_img = bwconncomp(scan_img);
%        
%         %Take upto 20 component that overlap with the correct region
%         overlap_comps = findLabels(label_scan_img(curr_obj_region),20);
%         if overlap_comps(1,1) == 0
%             continue;
%         end
%         
%         lower_overlap_bin_no = img_no + main_offset-1;
%         upper_overlap_bin_no = img_no+main_offset;
%          if((img_no > NUM_BIN_IMAGES) || (lower_overlap_bin_no> NUM_BIN_IMAGES))              
%               fprintf("CALC:: \nLoop Error,img_value >134;printing loop at Bin Index: %d main_offset = %d ,q_offset = %d\n" ,main_offset,q_offset);            
%          end
%         %The Smaller range against which to check stability
%  
%       if img_no > q_offset+1 && img_no<(q_offset+main_offset)
%          lower_range_check_img = logical(BinImages(:,:,img_no)+BinImages(:,:,lower_overlap_bin_no) + BinImages(:,:,upper_overlap_bin_no));
%       else
%          if img_no == q_offset+main_offset
%            lower_range_check_img = logical(BinImages(:,:,img_no)+ BinImages(:,:,lower_overlap_bin_no)); 
%            upper_overlap_bin_no = 0;
%          else
%           lower_range_check_img = logical(BinImages(:,:,img_no)+BinImages(:,:,upper_overlap_bin_no));
%           lower_overlap_bin_no = 0;
%          end
%       end
%       
%       lower_range_check_CC = bwconncomp(lower_range_check_img);
%       %The Larger Range against which to check stability
%       
% %         lower_bin_limit = (img_no-q_offset-1)*BinSizes(1,i);
% %         k = ceil((BinSizes(1,i)/2)) -1;
% %         upper_bin_limit = min(440,k+(img_no-q_offset)*BinSizes(1,i));
%         upper_range_check_img_no_1= StabilityCheckMatrix(img_no,6);
%         upper_range_check_img_no_2= StabilityCheckMatrix(img_no,7);
%         
%       upper_range_check_img = logical(BinImages(:,:,upper_range_check_img_no_1)+BinImages(:,:,upper_range_check_img_no_2));
%       upper_range_check_CC = bwconncomp(upper_range_check_img);
%       
%       lower_range_bwimage = bwlabel(lower_range_check_img);
%       upper_range_bwimage = bwlabel(upper_range_check_img);
%     for overlap_comp_no = 1:20
%         if overlap_comps(1,overlap_comp_no) == 0
%             break;
%         end
%            lower_range_overlap_comp = findLabels(lower_range_bwimage(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}),2); %Make to 1 for speed
%            upper_range_overlap_comp = findLabels(upper_range_bwimage(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}),2);
%       
%        if img_no ~= (q_offset+main_offset)
%           main_comp_bin_1 = img_no;
%           main_comp_bin_2 = img_no+main_offset;
%          else
%           main_comp_bin_1 = img_no;
%           main_comp_bin_2 = img_no;
%        end
%         
%         if lower_range_overlap_comp(1,2) ~= 0 || lower_range_overlap_comp(1,1) == 0 
% 
%            fprintf("\n CALC(Main offset Loop)::Wrong Calculation in LOWER Range Check Image,Main component from Bins::%d & %d  Lower Range Bins:: %d & %d & %d ",main_comp_bin_1,main_comp_bin_2,img_no,lower_overlap_bin_no,upper_overlap_bin_no);
%            figure('Name','ERROR:No Overlap Component !! Main Component being scanned');
%            error_figure(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) = 1;
%            imshow(error_figure);
%            figure('Name','ERROR:Overlap Component !! The Lower Range Overlap Image');
%            error_figure(:,:) = 0;
%            imshow(lower_range_check_img);
%            continue;
%         end
%         
%         if upper_range_overlap_comp(1,2) ~= 0 || upper_range_overlap_comp(1,1) == 0    
%            fprintf("\n CALC(Main Loop)::Wrong Calculation in Upper Range Check Image,upper_overlap_comp(1,1) = %d & upper_overlap_comp(1,2) = %d ,Main component from Bins::%d & %d  Upper Range Bins:: %d & %d ", upper_range_overlap_comp(1,1), upper_range_overlap_comp(1,2),main_comp_bin_1,main_comp_bin_2,upper_range_check_img_no_1,upper_range_check_img_no_2);
%            figure('Name','ERROR:No Overlap Component!! K-means Component being scanned');
%            error_figure(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) = 1;
%            imshow(error_figure);
%            figure('Name','ERROR:No Overlap Component!! The Upper Range Overlap Image');
%            error_figure(:,:) = 0;
%            imshow(upper_range_check_img);
%            continue;
%         end
%         
%         comp_num_of_pixels = numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)});
%         
%         upper_range_comp_no_pixels = numel(upper_range_check_CC.PixelIdxList{upper_range_overlap_comp(1,1)});
%         lower_range_comp_no_pixels = numel(lower_range_check_CC.PixelIdxList{lower_range_overlap_comp(1,1)});
%         
%         if comp_num_of_pixels > lower_range_comp_no_pixels          
%           fprintf("\n CALC::Wrong Calculation in LOWER Range Check Image,Main component from Bins::%d & %d  Lower Range Bins:: %d & %d & %d ",main_comp_bin_1,main_comp_bin_2,img_no,lower_overlap_bin_no,upper_overlap_bin_no);
%            figure('Name','ERROR: Size Reduction!! K-means Component being scanned');
%            error_figure(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) = 1;
%            imshow(error_figure);
%            figure('Name','ERROR:Size Reduction!! The Lower Range Overlap Image');
%            error_figure(:,:) = 0;
%            imshow(lower_range_check_img);
%            figure('Name','ERROR:Size Redution!! The Lower Range Overlap Component');
%            error_figure(lower_range_check_CC.PixelIdxList{lower_range_overlap_comp(1,1)}) = 1;
%            imshow(error_figure);
%            error_figure(:,:) = 0;
%            continue;
%         end
% 
%         if comp_num_of_pixels > upper_range_comp_no_pixels          
%           fprintf("\n CALC::(Size Reduction)Wrong Calculation in Upper Range Check Image,Main component from Bins::%d & %d  Upper Range Bins:: %d & %d ",main_comp_bin_1,main_comp_bin_2,upper_range_check_img_no_1,upper_range_check_img_no_2);
%             figure('Name','ERROR: Size Reduction!! K-means Component being scanned');
%            error_figure(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) = 1;
%            imshow(error_figure);
%            figure('Name','ERROR:Size Reduction!! The Upper Range Overlap Image');
%            error_figure(:,:) = 0;
%            imshow(upper_range_check_img);
%            figure('Name','ERROR:Size Redution!! The Upper Range Overlap Component');
%            error_figure(upper_range_check_CC.PixelIdxList{upper_range_overlap_comp(1,1)}) = 1;
%            imshow(error_figure);
%            error_figure(:,:) = 0;
%            continue;
%         end
%         
%         %deviation <= ((max_positive_label_deviation)*comp_num_of_pixels)
%         %&& Add the Lines for RESTRICTED SET OF MIN DEVIATION COMPONENTS
%         
%         deviation = abs(comp_num_of_pixels - numel(curr_obj_region));
%         if  min_deviation_set == 0 && lower_range_comp_no_pixels <= ((1+max_growth)*comp_num_of_pixels) && upper_range_comp_no_pixels <= ((1+max_growth)*comp_num_of_pixels)          
%                  min_deviation = abs(comp_num_of_pixels - numel(curr_obj_region));
%                  min_deviation_set = 1;
%         else
%             if min_deviation_set ~= 0 && lower_range_comp_no_pixels <= ((1+max_growth)*comp_num_of_pixels) && upper_range_comp_no_pixels <= ((1+max_growth)*comp_num_of_pixels)
%                 if deviation < min_deviation 
%                     min_deviation = deviation;                     
%                 end
%                 
%             end
%          end
%         
%         
%         
%     end
%    
%        end
%         
%         
%      %End of  img_no for 1st Level
%    
%    
%    %For 2nd Level Bins
%        for img_no = (q_offset+main_offset+1):(q_offset+2*main_offset-1) 
%   
%          scan_img = logical(BinImages(:,:,img_no)+BinImages(:,:,(img_no-main_offset+1)));
%         main_comp_bin_1 = img_no;
%         main_comp_bin_2 = img_no-main_offset+1;
%       
%         label_scan_img = bwlabel(scan_img);
%         CC_scan_img = bwconncomp(scan_img);
%        
%         %Take upto 20 component that overlap with the correct region
%         overlap_comps = findLabels(label_scan_img(curr_obj_region),20);
%         if overlap_comps(1,1) == 0
%             continue;
%         end
%         
%         %The Smaller range against which to check stability
%         lower_overlap_bin_no = img_no-main_offset;
%         upper_overlap_bin_no = img_no-main_offset+1;
%          if((img_no > NUM_BIN_IMAGES) || (lower_overlap_bin_no> NUM_BIN_IMAGES))              
%               fprintf("CALC(offset loop)::\nLoop Error,img_value >134;printing loop at Bin Index: %d main_offset = %d ,q_offset = %d\n" ,main_offset,q_offset);            
%          end
%         lower_range_check_img = logical(BinImages(:,:,img_no)+BinImages(:,:,lower_overlap_bin_no) + BinImages(:,:,upper_overlap_bin_no));
% 
%       lower_range_check_CC = bwconncomp(lower_range_check_img);
%       %The Larger Range against which to check stability
%      
%   %         lower_bin_limit = (img_no-q_offset-1)*BinSizes(1,i);
% %         k = ceil((BinSizes(1,i)/2)) -1;
% %         upper_bin_limit = min(440,k+(img_no-q_offset)*BinSizes(1,i));
%         upper_range_check_img_no_1= StabilityCheckMatrix(img_no,6);
%         upper_range_check_img_no_2= StabilityCheckMatrix(img_no,7);
% 
%       upper_range_check_img = logical(BinImages(:,:,upper_range_check_img_no_1)+BinImages(:,:,upper_range_check_img_no_2));
%       upper_range_check_CC = bwconncomp(upper_range_check_img);
%       
%       lower_range_bwimage = bwlabel(lower_range_check_img);
%       upper_range_bwimage = bwlabel(upper_range_check_img);
%     for overlap_comp_no = 1:20
%         if overlap_comps(1,overlap_comp_no) == 0
%             break;
%         end
%            lower_range_overlap_comp = findLabels(lower_range_bwimage(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}),2); %Make to 1 for speed
%            upper_range_overlap_comp = findLabels(upper_range_bwimage(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}),2);
%       
%         if lower_range_overlap_comp(1,2) ~= 0 || lower_range_overlap_comp(1,1) == 0    
%          fprintf("\n CALC(offset loop)::Wrong Calculation in LOWER Range Check Image,Main component from Bins::%d & %d  Lower Range Bins:: %d & %d & %d ",main_comp_bin_1,main_comp_bin_2,img_no,lower_overlap_bin_no,upper_overlap_bin_no);
%              figure('Name','ERROR:No Overlap Component !! K-means Component being scanned');
%            error_figure(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) = 1;
%            imshow(error_figure);
%            figure('Name','ERROR:Overlap Component !! The Lower Range Overlap Image');
%            error_figure(:,:) = 0;
%            imshow(lower_range_check_img);
%            continue;
%         end
%         
%         %ERROR HAPPENING HERE!!!!!!!!!!!!!!!!
%         
%         if upper_range_overlap_comp(1,2) ~= 0 || upper_range_overlap_comp(1,1) == 0    
%      fprintf("\n CALC(Offset Loop)::Wrong Calculation in Upper Range Check Image,upper_overlap_comp(1,1) = %d & upper_overlap_comp(1,2) = %d ,Main component from Bins::%d & %d  Upper Range Bins:: %d & %d ", upper_range_overlap_comp(1,1), upper_range_overlap_comp(1,2),main_comp_bin_1,main_comp_bin_2,upper_range_check_img_no_1,upper_range_check_img_no_2);
%            figure('Name','ERROR:No Overlap Component!! K-means Component being scanned');
%            error_figure(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) = 1;
%            imshow(error_figure);
%            figure('Name','ERROR:No Overlap Component!! The Upper Range Overlap Image');
%            error_figure(:,:) = 0;
%            imshow(upper_range_check_img);
%            continue;
%         end
%         
%         comp_num_of_pixels = numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)});
%         
%         upper_range_comp_no_pixels = numel(upper_range_check_CC.PixelIdxList{upper_range_overlap_comp(1,1)});
%         lower_range_comp_no_pixels = numel(lower_range_check_CC.PixelIdxList{lower_range_overlap_comp(1,1)});
%         
%         if comp_num_of_pixels > lower_range_comp_no_pixels          
%         fprintf("\nCALC(offset loop)::Wrong Calculation in LOWER Range Check Image,Main component from Bins::%d & %d  Lower Range Bins:: %d & %d & %d ",main_comp_bin_1,main_comp_bin_2,img_no,lower_overlap_bin_no,upper_overlap_bin_no);
%              figure('Name','ERROR: Size Reduction!! K-means Component being scanned');
%            error_figure(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) = 1;
%            imshow(error_figure);
%            figure('Name','ERROR:Size Reduction!! The Lower Range Overlap Image');
%            error_figure(:,:) = 0;
%            imshow(lower_range_check_img);
%            figure('Name','ERROR:Size Redution!! The Lower Range Overlap Component');
%            error_figure(lower_range_check_CC.PixelIdxList{lower_range_overlap_comp(1,1)}) = 1;
%            imshow(error_figure);
%            error_figure(:,:) = 0;
%            continue;
%         end
% 
%         if comp_num_of_pixels > upper_range_comp_no_pixels          
%           fprintf("\n CALC(Offset Loop)::(Size Reduction)Wrong Calculation in Upper Range Check Image,upper_overlap_comp(1,1) = %d & upper_overlap_comp(1,2) = %d ,Main component from Bins::%d & %d  Upper Range Bins:: %d & %d ", upper_range_overlap_comp(1,1), upper_range_overlap_comp(1,2),main_comp_bin_1,main_comp_bin_2,upper_range_check_img_no_1,upper_range_check_img_no_2);
%              figure('Name','ERROR: Size Reduction!! K-means Component being scanned');
%            error_figure(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) = 1;
%            imshow(error_figure);
%            figure('Name','ERROR:Size Redution!! The Original Component');
%            error_figure(CC_scan_img.PixelIdxList{overlap_comps(1,1)}) = 1;
%            imshow(error_figure);
%            error_figure(:,:) = 0;
%            figure('Name','ERROR:Size Reduction!! The Upper Range Overlap Image');
%            error_figure(:,:) = 0;
%            imshow(upper_range_check_img);
%            figure('Name','ERROR:Size Redution!! The Upper Range Overlap Component');
%            error_figure(upper_range_check_CC.PixelIdxList{upper_range_overlap_comp(1,1)}) = 1;
%            imshow(error_figure);
%            error_figure(:,:) = 0;
%            continue;
%         end
%         
%         %&& deviation <=
%         %((max_positive_label_deviation)*comp_num_of_pixels)  Add This Line
%         %to the If Statements Below to make min deviation for RESTRICTED
%         %SET OF COMPONENTS
%         deviation = abs(comp_num_of_pixels - numel(curr_obj_region));
%         if min_deviation_set == 0  && lower_range_comp_no_pixels <= ((1+max_growth)*comp_num_of_pixels) && upper_range_comp_no_pixels <= ((1+max_growth)*comp_num_of_pixels)            
%                  min_deviation = abs(comp_num_of_pixels - numel(curr_obj_region));
%                  min_deviation_set = 1;
%         else
%             if min_deviation_set ~= 0  && lower_range_comp_no_pixels <= ((1+max_growth)*comp_num_of_pixels) && upper_range_comp_no_pixels <= ((1+max_growth)*comp_num_of_pixels)
%                 if deviation < min_deviation 
%                     min_deviation = deviation;                     
%                 end
%                 
%             end
%         end       
%     end
%     
%    
%        end %End of  img_no for 2nd Level
%   
%    
%  % End of i = BinSizes
%      q_offset = q_offset+(2*main_offset-1);    
%    end
%      

%% Next we extract the Values for each Bin. Correct Components those with pixels within min Variance In Component Size

min_deviation_set = 1; %Since 1st half not used

q_offset = 0;  
         for i = 1:8 %Must change Loop for change in Bin
             if min_deviation_set == 0
                fprintf("\nNo SUITABLE Component found\n");
                break;
             end
        main_offset = ceil(MAX_DISTANCE/BinSizes(i));
       k = ceil((BinSizes(i)/2)) -1;
   
    %For 1st Level Bins
       for img_no = (q_offset+1):(q_offset+main_offset) 
        if img_no ~= (q_offset+main_offset)
          scan_img = logical(BinImages(:,:,img_no)+BinImages(:,:,(img_no+main_offset)));
        else
           scan_img = logical(BinImages(:,:,img_no));
        end
        label_scan_img = bwlabel(scan_img);
        CC_scan_img = bwconncomp(scan_img);
       
        %Take upto 20 component that overlap with the correct region
        overlap_comps = findLabels(label_scan_img(curr_obj_region),20);
        if overlap_comps(1,1) == 0
            continue;
        end
        
        lower_overlap_bin_no = img_no + main_offset-1;
        upper_overlap_bin_no = img_no+main_offset;
           if((img_no > NUM_BIN_IMAGES) || ((img_no+main_offset)> NUM_BIN_IMAGES && img_no~=q_offset+main_offset))
               
              fprintf("\nLoop Error,img_value >134;printing loop at Bin Index: %d main_offset = %d ,q_offset = %d\n" ,main_offset,q_offset);
               
           end
        %The Smaller range against which to check stability
      if img_no > q_offset+1 && img_no<(q_offset+main_offset)
         lower_range_check_img = logical(BinImages(:,:,img_no)+BinImages(:,:,lower_overlap_bin_no) + BinImages(:,:,upper_overlap_bin_no));
      else
         if img_no == q_offset+main_offset
           lower_range_check_img = logical(BinImages(:,:,img_no)+ BinImages(:,:,lower_overlap_bin_no)); 
         else
          lower_range_check_img = logical(BinImages(:,:,img_no)+BinImages(:,:,upper_overlap_bin_no));
         end
      end
      lower_range_check_CC = bwconncomp(lower_range_check_img);
      
      %The Larger Range against which to check stability     
   %         lower_bin_limit = (img_no-q_offset-1)*BinSizes(1,i);
%         k = ceil((BinSizes(1,i)/2)) -1;
%         upper_bin_limit = min(440,k+(img_no-q_offset)*BinSizes(1,i));
        upper_range_check_img_no_1= StabilityCheckMatrix(img_no,6);
        upper_range_check_img_no_2= StabilityCheckMatrix(img_no,7);


      upper_range_check_img = logical(BinImages(:,:,upper_range_check_img_no_1)+BinImages(:,:,upper_range_check_img_no_2));
      upper_range_check_CC = bwconncomp(upper_range_check_img);
      
      lower_range_bwimage = bwlabel(lower_range_check_img);
      upper_range_bwimage = bwlabel(upper_range_check_img);
      
       stats = regionprops(CC_scan_img,'EulerNumber','Solidity');
        lower_check_stats = regionprops(lower_range_check_img,'EulerNumber','Solidity');
       upper_check_stats = regionprops(upper_range_check_img,'EulerNumber','Solidity');
    for overlap_comp_no = 1:20
        if overlap_comps(1,overlap_comp_no) == 0
            break;
        end
           lower_range_overlap_comp = findLabels(lower_range_bwimage(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}),2); %Make to 1 for speed
           upper_range_overlap_comp = findLabels(upper_range_bwimage(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}),2);
      
        if lower_range_overlap_comp(1,2) ~= 0 || lower_range_overlap_comp(1,1) == 0    
           fprintf("\n Wrong Calculation in LOWER Range Check Image");
           figure('Name','ERROR:No Overlap Component !! K-means Component being scanned');
           error_figure(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) = 1;
           imshow(error_figure);
           figure('Name','ERROR:Overlap Component !! The Lower Range Overlap Image');
           error_figure(:,:) = 0;
           imshow(lower_range_check_img);
           continue;
        end
        
        if upper_range_overlap_comp(1,2) ~= 0 || upper_range_overlap_comp(1,1) == 0    
           fprintf("\n Wrong Calculation in LOWER Range Check Image");
           figure('Name','ERROR:No Overlap Component!! K-means Component being scanned');
           error_figure(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) = 1;
           imshow(error_figure);
           figure('Name','ERROR:No Overlap Component!! The Upper Range Overlap Image');
           error_figure(:,:) = 0;
           imshow(upper_range_check_img);
           continue;
        end
        
        comp_num_of_pixels = numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)});
        
        upper_range_comp_no_pixels = numel(upper_range_check_CC.PixelIdxList{upper_range_overlap_comp(1,1)});
        lower_range_comp_no_pixels = numel(lower_range_check_CC.PixelIdxList{lower_range_overlap_comp(1,1)});
        
        if comp_num_of_pixels > lower_range_comp_no_pixels          
           fprintf("\nError in Finding Correct LOWER Range Component: Size of Overlap reduced ");
           figure('Name','ERROR: Size Reduction!! K-means Component being scanned');
           error_figure(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) = 1;
           imshow(error_figure);
           figure('Name','ERROR:Size Reduction!! The Lower Range Overlap Image');
           error_figure(:,:) = 0;
           imshow(lower_range_check_img);
           figure('Name','ERROR:Size Redution!! The Lower Range Overlap Component');
           error_figure(lower_range_check_CC.PixelIdxList{lower_range_overlap_comp(1,1)}) = 1;
           imshow(error_figure);
           error_figure(:,:) = 0;
           continue;
        end

        if comp_num_of_pixels > upper_range_comp_no_pixels          
          fprintf("\nError in Finding Correct UPPER Range Component: Size of Overlap reduced ");
           figure('Name','ERROR: Size Reduction!! K-means Component being scanned');
           error_figure(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) = 1;
           imshow(error_figure);
           figure('Name','ERROR:Size Reduction!! The Upper Range Overlap Image');
           error_figure(:,:) = 0;
           imshow(upper_range_check_img);
           figure('Name','ERROR:Size Redution!! The Upper Range Overlap Component');
           error_figure(upper_range_check_CC.PixelIdxList{upper_range_overlap_comp(1,1)}) = 1;
           imshow(error_figure);
           error_figure(:,:) = 0;
           continue;
        end
           training_entry = training_entry+1;
            
            %Label the closest component to the actual object region
             deviation = abs(comp_num_of_pixels - numel(curr_obj_region));
             if (deviation <= (max_positive_label_deviation)*comp_num_of_pixels) && lower_range_comp_no_pixels <= ((1+max_growth)*comp_num_of_pixels) && upper_range_comp_no_pixels <= ((1+max_growth)*comp_num_of_pixels)
                  y(training_entry,1) = 1;
                   if show_results
                     show_img(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) = 1;
                     figure('Name',strcat("       The Positive Example(Lower Range): ",int2str(img_no)));
                     imshow(show_img);
                     show_img(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) = 0;
                   end
                 
             else
                 %FOR COMPOENETS WHICH ARE CONFUSING DO NOT CONSIDER LABEL
%                  if (deviation <= (max_positive_label_deviation)*comp_num_of_pixels) || ((lower_range_comp_no_pixels <= ((1+max_growth)*comp_num_of_pixels)) && (upper_range_comp_no_pixels <= ((1+max_growth)*comp_num_of_pixels)))
%                     training_entry = training_entry - 1;
%                     continue;
%                  end

                    if false %deviation == min_deviation && lower_range_comp_no_pixels <= ((1+max_growth)*comp_num_of_pixels) && upper_range_comp_no_pixels <= ((1+max_growth)*comp_num_of_pixels)
                        y(training_entry,1) = 1;
                 
%                        show_img(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) = 1;
%                       figure('Name',strcat("       EXCEPTIONAL::The Positive Example(Lower Range): ",int2str(img_no)));
%                       imshow(show_img);
%                       show_img(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) = 0;      
                    else
                         y(training_entry,1) = 0;
                    end
                   
             end
              
             X(training_entry,9) = numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)});
               
             X(training_entry,10) = BinSizes(i);
             
       if img_no~=(q_offset+main_offset) && img_no~=(q_offset+1)         
           X(training_entry,11) = 2*k;
       else       
           X(training_entry,11) = k;
       end
       
  

          
       X(training_entry,3) = stats(overlap_comps(1,overlap_comp_no)).EulerNumber;

      X(training_entry,6) = stats(overlap_comps(1,overlap_comp_no)).Solidity;  
   
       %Getting values from lower range image
               if y(training_entry,1) == 1
                   if show_results
                     show_img(lower_range_check_CC.PixelIdxList{lower_range_overlap_comp(1,1)}) = 1;
                     figure('Name',strcat('    Lower Range Bins Added :: ',strcat(int2str(X(training_entry,10)),strcat(' & ',int2str(X(training_entry,11))))));
                    imshow(show_img);
                     show_img(lower_range_check_CC.PixelIdxList{lower_range_overlap_comp(1,1)}) = 1;
                   end
               end
           
        
          
        X(training_entry,1) = (abs(numel(lower_range_check_CC.PixelIdxList{lower_range_overlap_comp(1,1)}) - numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)})))/numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)});        
        X(training_entry,4) = lower_check_stats(lower_range_overlap_comp(1,1)).EulerNumber - stats(overlap_comps(1,overlap_comp_no)).EulerNumber;       
        X(training_entry,7) = (abs(lower_check_stats(lower_range_overlap_comp(1,1)).Solidity - stats(overlap_comps(1,overlap_comp_no)).Solidity))/ stats(overlap_comps(1,overlap_comp_no)).Solidity;
        

        
        
     
           X(training_entry,12) = max(BinMatrix(upper_range_check_img_no_1,4),BinMatrix(upper_range_check_img_no_2,4))-min(BinMatrix(upper_range_check_img_no_1,3),BinMatrix(upper_range_check_img_no_2,3)); 
          
       
       
          %Adding the Higher Range Bins
         
              if y(training_entry,1) == 1
                   if show_results
                     show_img(upper_range_check_CC.PixelIdxList{upper_range_overlap_comp(1,1)}) = 1;
                     figure('Name',strcat('    Higher Range Bins Added :: ',strcat(int2str(X(training_entry,10)),strcat(' & ',int2str(X(training_entry,11))))));
                     imshow(show_img);
                     show_img(upper_range_check_CC.PixelIdxList{upper_range_overlap_comp(1,1)}) = 1;
                   end
              end
               
               
     
          
        X(training_entry,2) = (abs(numel(upper_range_check_CC.PixelIdxList{upper_range_overlap_comp(1,1)}) - numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)})))/numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)});        
        X(training_entry,5) = upper_check_stats(upper_range_overlap_comp(1,1)).EulerNumber - stats(overlap_comps(1,overlap_comp_no)).EulerNumber;       
        X(training_entry,8) = (abs(upper_check_stats(upper_range_overlap_comp(1,1)).Solidity - stats(overlap_comps(1,overlap_comp_no)).Solidity))/ stats(overlap_comps(1,overlap_comp_no)).Solidity;
        

        
        
    end
   
  
        end
  
   
   % For 2nd Level Bins
     for img_no = (q_offset+main_offset+1):(q_offset+2*main_offset-1) 
        scan_img = logical(BinImages(:,:,img_no)+BinImages(:,:,(img_no-main_offset+1)));
        
      
        label_scan_img = bwlabel(scan_img);
        CC_scan_img = bwconncomp(scan_img);
       
        %Take upto 20 component that overlap with the correct region
        overlap_comps = findLabels(label_scan_img(curr_obj_region),20);
        if overlap_comps(1,1) == 0
            continue;
        end
        
        %The Smaller range against which to check stability
  
            lower_overlap_bin_no = img_no -main_offset;
        upper_overlap_bin_no = img_no-main_offset+1;
         if((img_no > NUM_BIN_IMAGES) || (lower_overlap_bin_no> NUM_BIN_IMAGES))              
              fprintf("\nLoop Error,img_value >134;printing loop at Bin Index: %d main_offset = %d ,q_offset = %d\n" ,main_offset,q_offset);            
         end
        lower_range_check_img = logical(BinImages(:,:,img_no)+BinImages(:,:,lower_overlap_bin_no) + BinImages(:,:,upper_overlap_bin_no));

      lower_range_check_CC = bwconncomp(lower_range_check_img);
      %The Larger Range against which to check stability
     
   %         lower_bin_limit = (img_no-q_offset-1)*BinSizes(1,i);
%         k = ceil((BinSizes(1,i)/2)) -1;
%         upper_bin_limit = min(440,k+(img_no-q_offset)*BinSizes(1,i));
        upper_range_check_img_no_1= StabilityCheckMatrix(img_no,6);
        upper_range_check_img_no_2= StabilityCheckMatrix(img_no,7);


      upper_range_check_img = logical(BinImages(:,:,upper_range_check_img_no_1)+BinImages(:,:,upper_range_check_img_no_2));
      upper_range_check_CC = bwconncomp(upper_range_check_img);
      
      lower_range_bwimage = bwlabel(lower_range_check_img);
      upper_range_bwimage = bwlabel(upper_range_check_img);
      
       stats = regionprops(CC_scan_img,'EulerNumber','Solidity');
        lower_check_stats = regionprops(lower_range_check_img,'EulerNumber','Solidity');
       upper_check_stats = regionprops(upper_range_check_img,'EulerNumber','Solidity');
    for overlap_comp_no = 1:20
        if overlap_comps(1,overlap_comp_no) == 0
            break;
        end
           lower_range_overlap_comp = findLabels(lower_range_bwimage(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}),2); %Make to 1 for speed
           upper_range_overlap_comp = findLabels(upper_range_bwimage(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}),2);
      
         if lower_range_overlap_comp(1,2) ~= 0 || lower_range_overlap_comp(1,1) == 0    
           fprintf("\n Wrong Calculation in LOWER Range Check Image");
           figure('Name','ERROR:No Overlap Component !! K-means Component being scanned');
           error_figure(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) = 1;
           imshow(error_figure);
           figure('Name','ERROR:Overlap Component !! The Lower Range Overlap Image');
           error_figure(:,:) = 0;
           imshow(lower_range_check_img);
           continue;
        end
        
        if upper_range_overlap_comp(1,2) ~= 0 || upper_range_overlap_comp(1,1) == 0    
           fprintf("\n Wrong Calculation in LOWER Range Check Image");
           figure('Name','ERROR:No Overlap Component!! K-means Component being scanned');
           error_figure(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) = 1;
           imshow(error_figure);
           figure('Name','ERROR:No Overlap Component!! The Upper Range Overlap Image');
           error_figure(:,:) = 0;
           imshow(upper_range_check_img);
           continue;
        end
        
        comp_num_of_pixels = numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)});
        
        upper_range_comp_no_pixels = numel(upper_range_check_CC.PixelIdxList{upper_range_overlap_comp(1,1)});
        lower_range_comp_no_pixels = numel(lower_range_check_CC.PixelIdxList{lower_range_overlap_comp(1,1)});
        
        if comp_num_of_pixels > lower_range_comp_no_pixels          
           fprintf("\nError in Finding Correct LOWER Range Component: Size of Overlap reduced ");
           figure('Name','ERROR: Size Reduction!! K-means Component being scanned');
           error_figure(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) = 1;
           imshow(error_figure);
           figure('Name','ERROR:Size Reduction!! The Lower Range Overlap Image');
           error_figure(:,:) = 0;
           imshow(lower_range_check_img);
           figure('Name','ERROR:Size Redution!! The Lower Range Overlap Component');
           error_figure(lower_range_check_CC.PixelIdxList{lower_range_overlap_comp(1,1)}) = 1;
           imshow(error_figure);
           error_figure(:,:) = 0;
           continue;
        end

        if comp_num_of_pixels > upper_range_comp_no_pixels          
          fprintf("\nError in Finding Correct UPPER Range Component: Size of Overlap reduced ");
           figure('Name','ERROR: Size Reduction!! K-means Component being scanned');
           error_figure(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) = 1;
           imshow(error_figure);
           figure('Name','ERROR:Size Reduction!! The Upper Range Overlap Image');
           error_figure(:,:) = 0;
           imshow(upper_range_check_img);
           figure('Name','ERROR:Size Redution!! The Upper Range Overlap Component');
           error_figure(upper_range_check_CC.PixelIdxList{upper_range_overlap_comp(1,1)}) = 1;
           imshow(error_figure);
           error_figure(:,:) = 0;
           continue;
        end
        
              training_entry = training_entry+1;
            
            %Label the closest component to the actual object region
             deviation = abs(comp_num_of_pixels - numel(curr_obj_region));
             if (deviation <= (max_positive_label_deviation)*comp_num_of_pixels) && lower_range_comp_no_pixels <= ((1+max_growth)*comp_num_of_pixels) && upper_range_comp_no_pixels <= ((1+max_growth)*comp_num_of_pixels)
                  y(training_entry,1) = 1;
                  if show_results
                 show_img(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) = 1;
                 figure('Name',strcat("       The Positive Example(Lower Range): ",int2str(img_no)));
                 imshow(show_img);
                 show_img(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) = 0;
                  end
%                  
             else
     
                    if false %deviation == min_deviation && lower_range_comp_no_pixels <= ((1+max_growth)*comp_num_of_pixels) && upper_range_comp_no_pixels <= ((1+max_growth)*comp_num_of_pixels)
                        y(training_entry,1) = 1;
                 
                       show_img(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) = 1;
                      figure('Name',strcat("       EXCEPTIONAL::The Positive Example(Lower Range): ",int2str(img_no)));
                      imshow(show_img);
                      show_img(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) = 0;      
                    else
                         y(training_entry,1) = 0;
                    end
                   
             end
              
             X(training_entry,9) = numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)});
               
          
           X(training_entry,10) = BinSizes(i);
       
       
        
           X(training_entry,11) = 2*k;
      

          
       X(training_entry,3) = stats(overlap_comps(1,overlap_comp_no)).EulerNumber;
       X(training_entry,6) = stats(overlap_comps(1,overlap_comp_no)).Solidity;  
   
             %Getting values from lower range image
               if y(training_entry,1) == 1
                   if show_results
                 show_img(lower_range_check_CC.PixelIdxList{lower_range_overlap_comp(1,1)}) = 1;
                 figure('Name',strcat('    Lower Range Bins Added :: ',strcat(int2str(X(training_entry,10)),strcat(' & ',int2str(X(training_entry,11))))));
                 imshow(show_img);
                  show_img(lower_range_check_CC.PixelIdxList{lower_range_overlap_comp(1,1)}) = 1;
                   end
               end
           
        
          
        X(training_entry,1) = (abs(numel(lower_range_check_CC.PixelIdxList{lower_range_overlap_comp(1,1)}) - numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)})))/numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)});        
        X(training_entry,4) = lower_check_stats(lower_range_overlap_comp(1,1)).EulerNumber - stats(overlap_comps(1,overlap_comp_no)).EulerNumber;       
        X(training_entry,7) = (abs(lower_check_stats(lower_range_overlap_comp(1,1)).Solidity - stats(overlap_comps(1,overlap_comp_no)).Solidity))/ stats(overlap_comps(1,overlap_comp_no)).Solidity;
        
            X(training_entry,12) = max(BinMatrix(upper_range_check_img_no_1,4),BinMatrix(upper_range_check_img_no_2,4))-min(BinMatrix(upper_range_check_img_no_1,3),BinMatrix(upper_range_check_img_no_2,3)); 
          
       
       
          %Adding the Higher Range Bins
         
              if y(training_entry,1) == 1
                  if show_results
                 show_img(upper_range_check_CC.PixelIdxList{upper_range_overlap_comp(1,1)}) = 1;
                 figure('Name',strcat('    Higher Range Bins Added :: ',strcat(int2str(X(training_entry,10)),strcat(' & ',int2str(X(training_entry,11))))));
                 imshow(show_img);
                  show_img(upper_range_check_CC.PixelIdxList{upper_range_overlap_comp(1,1)}) = 1;
                  end
              end
               
               
     
          
        X(training_entry,2) = (abs(numel(upper_range_check_CC.PixelIdxList{upper_range_overlap_comp(1,1)}) - numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)})))/numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)});        
        X(training_entry,5) = upper_check_stats(upper_range_overlap_comp(1,1)).EulerNumber - stats(overlap_comps(1,overlap_comp_no)).EulerNumber;       
        X(training_entry,8) = (abs(upper_check_stats(upper_range_overlap_comp(1,1)).Solidity - stats(overlap_comps(1,overlap_comp_no)).Solidity))/ stats(overlap_comps(1,overlap_comp_no)).Solidity;
        

        
          
        
        
    end
        
   
    end
   
   q_offset = q_offset+2*main_offset-1;
        end  
   
   
  
   
 end

  







    
    
    
    
    

 %% UNDEBUAGABLE CODE
%    %Features: 
%     % 1. Del(No. of Pixels Bin i - Bin i + SubBin(i-1,i+1))/Total No. of Pixels
%     % 2. Del(No. of Pixels Bin i - Bin(i,i+1,i-1))/Total No. of Pixels
%     % 3. No. of Holes
%     % 4. Del(No. of Holes Bin i - Bin i + SubBin(i-1,i+1))
%     % 5. Del(No. of Holes Bin i - Bin i + Bin(i-1,i+1))
%     % 6. Density 
%     % 7. Del(Change of Density of Bin i - Bin i + SubBin(i-1,i+1))/Density
%     % 8. Del(Change of Density of Bin i - Bin i + Bin(i,i-1,i+1))/Density
%     % 9. Number of Pixels
%     % 10. Height
%     % 11. Width
%     % 12. Bin Size
%     
%     
%            % BinImages = Uniquize_2Level(BinImages,BinSizes,BinSizes,MAX_DISTANCE);
%   
%   y = false(1,1);
%   X = zeros(1,16);
%   training_entry = 0; 
%  
%    
%   
%   NumImages = NUM_BIN_IMAGES;
%  
% [row,col,~] = size(BinImages);
% 
% show_img = false(row,col);
%     %Creating labelled images beforehand to speed up process
%     BWImages = zeros(size(BinImages));
%     
%     for bw_c = 1:NUM_BIN_IMAGES  
%         BWImages(:,:,bw_c) = bwlabel(BinImages(:,:,bw_c));
%     end
%     
%     
% %% We First find a Bin Image Component closest to the region,store the deviation in min_deviation
% 
%     
%     min_deviation_set = 0;
%     q_offset = 0;
%      check_top_img = false(row,col);
%      check_bottom_img = false(row,col);
%      
%      for i = 1:numel(BinSizes)   
%          main_offset = ceil(MAX_DISTANCE/BinSizes(i));
%          
%     %For 1st Level Bins
%    for img_no = (q_offset+1):(q_offset+main_offset) 
%        if img_no ~= (q_offset+main_offset)
%           scan_img = logical(BinImages(:,:,img_no)+BinImages(:,:,(img_no+main_offset)));
%        else
%           scan_img = logical(BinImages(:,:,img_no));
%        end
%         label_scan_img = bwlabel(scan_img);
%         CC_scan_img = bwconncomp(scan_img);
%        
%         %Take upto 20 component that overlap with the correct region
%         overlap_comps = findLabels(label_scan_img(curr_obj_region),20);
%         if overlap_comps(1,1) == 0
%             continue;
%         end
%         
%         if img_no ~= (q_offset+main_offset)
%             check_top_img = BinImages(:,:,(img_no+1));
%         else
%            check_top_img(:,:) = 0;
%         end
%         
%         if img_no ~= (q_offset+1)
%             check_bottom_img = BinImages(:,:,(img_no-1));
%         else
%            check_bottom_img(:,:) = 0;
%         end
%         
%         upward_thres_check_img = logical(scan_img + check_top_img + check_bottom_img);   %Must change scan_img to BinImages(:,:,img_no)
%         upward_label_img = bwlabel(upward_thres_check_img);
%         upward_CC_img = bwconncomp(upward_thres_check_img);
%         for overlap_comp_no = 1:20
%             if(overlap_comps(1,overlap_comp_no) == 0)
%                break; 
%             end
%             upward_overlap_comps = findLabels(upward_label_img(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}),2);  %% Reduce to 1 for speed
%             
%             if upward_overlap_comps(1,2) ~=0
%                fprintf("Wrong Assumption in upward threshold check"); 
%             end
%             
%          %   CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)};
%         %  upward_CC_img.PixelIdxList{upward_overlap_comps(1,1)};
%           
%        %   if (abs(numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) - numel(upward_CC_img.PixelIdxList{upward_overlap_comps(1,1)}))/numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)})) >= max_upward_dev
%        %     continue;
%        %   end
%               
%          if min_deviation_set == 0
%                  min_deviation = abs(numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) - numel(curr_obj_region));
%                  min_deviation_set = 1;
%          else
%              deviation = abs(numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) - numel(curr_obj_region));
%                 if deviation < min_deviation 
%                     min_deviation = deviation;
% %                     
% %                     %DEBUG
% %                     
% %                   show_img(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) = 1;
% %                   figure('Name',strcat('    Positive Example at Level 1::Bins ',strcat(int2str(img_no),int2str(img_no+main_offset))));
% %                   imshow(show_img);
% %                   show_img(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) = 0;
% %                    
% %                   show_img(upward_CC_img.PixelIdxList{upward_overlap_comps(1,1)}) = 1;
% %                   figure('Name',strcat('    On Adding the Two Bins on Sides::Bins ',strcat(int2str(img_no+1),int2str(img_no-1))));
% %                   imshow(show_img);
% %                   show_img(upward_CC_img.PixelIdxList{upward_overlap_comps(1,1)}) = 0;
% %                     
%                 end
%          end
%         end
%         
%    end  %End of  img_no for 1st Level
%    
%    
%    %For 2nd Level Bins
%    for img_no = (q_offset+main_offset+1):(q_offset+2*main_offset-1) 
%       
%           scan_img = logical(BinImages(:,:,img_no)+BinImages(:,:,(img_no-main_offset+1)));
%       
%         %  scan_img = logical(BinImages(:,:,img_no));
%       
%         label_scan_img = bwlabel(scan_img);
%         CC_scan_img = bwconncomp(scan_img);
%        
%         %Take upto 20 component that overlap with the correct region
%         overlap_comps = findLabels(label_scan_img(curr_obj_region),20);
%         if overlap_comps(1,1) == 0
%             continue;
%         end
%         
%         if img_no ~= (q_offset+2*main_offset-1)
%             check_top_img = BinImages(:,:,(img_no+1));
%         else
%            check_top_img = BinImages(:,:,(img_no-main_offset+1));
%         end
%         
%         if img_no ~= (q_offset+main_offset+1)
%             check_bottom_img = BinImages(:,:,(img_no-1));
%         else
%            check_bottom_img = BinImages(:,:,(img_no-main_offset));
%         end
%         
%         upward_thres_check_img = logical(scan_img + check_top_img + check_bottom_img);   %scan_img must be changed to BinImages(:,:,img_no)
%         upward_label_img = bwlabel(upward_thres_check_img);
%         upward_CC_img = bwconncomp(upward_thres_check_img);
%         for overlap_comp_no = 1:20
%             if(overlap_comps(1,overlap_comp_no) == 0)
%                break; 
%             end
%             upward_overlap_comps = findLabels(upward_label_img(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}),2);  %% Reduce to 1 for speed
%             
%             if upward_overlap_comps(1,2) ~=0
%                fprintf("\nWrong Assumption in upward threshold check"); 
%             end
%             
%             if upward_overlap_comps(1,1) == 0
%                     fprintf("\nUpward Overlap comps is wrong!!!");
%             end
%             
%      %     if (abs(numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) - numel(upward_CC_img.PixelIdxList{upward_overlap_comps(1,1)}))/numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)})) >= max_upward_dev
%      %       continue;
%       %    end
%               
%          if min_deviation_set == 0
%                  min_deviation = abs(numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) - numel(curr_obj_region));
%                  min_deviation_set = 1;
%          else
%                 deviation = abs(numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) - numel(curr_obj_region));
%                 if deviation < min_deviation 
%                     min_deviation = deviation;
% %                     
% %                     %DEBUG
% %                     
% %                   show_img(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) = 1;
% %                   figure('Name',strcat('    Positive Example at Level 2::Bins ',strcat(int2str(img_no),int2str(img_no-main_offset+1))));
% %                   imshow(show_img);
% %                   show_img(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) = 0;
% %                    
% %                   show_img(upward_CC_img.PixelIdxList{upward_overlap_comps(1,1)}) = 1;
% %                   figure('Name',strcat('    On Adding the Two Bins on Sides::Bins ',strcat(int2str(img_no+1),int2str(img_no-1))));
% %                   imshow(show_img);
% %                   show_img(upward_CC_img.PixelIdxList{upward_overlap_comps(1,1)}) = 0;
% %                     
%                     
%                 end
%          end
%         end
%         
%    end  %End of  img_no for 2nd Level
%    
%    q_offset = q_offset+2*main_offset-1;
%    
%      end  % End of i = BinSizes
%         
%      
% 
%  %% DEBUG CODE TO CHECK WHICH COMPONENTS ARE POSITIVELY LABELLED
%    
%     q_offset = 0;
%      check_top_img = false(row,col);
%      check_bottom_img = false(row,col);
%      
%      for i = 1:numel(BinSizes)   
%          main_offset = ceil(MAX_DISTANCE/BinSizes(i));
%          
%     %For 1st Level Bins
%    for img_no = (q_offset+1):(q_offset+main_offset) 
%        if img_no ~= (q_offset+main_offset)
%           scan_img = logical(BinImages(:,:,img_no)+BinImages(:,:,(img_no+main_offset)));
%        else
%           scan_img = logical(BinImages(:,:,img_no));
%        end
%         label_scan_img = bwlabel(scan_img);
%         CC_scan_img = bwconncomp(scan_img);
%        
%         %Take upto 20 component that overlap with the correct region
%         overlap_comps = findLabels(label_scan_img(curr_obj_region),20);
%         if overlap_comps(1,1) == 0
%             continue;
%         end
%         
%         if img_no ~= (q_offset+main_offset)
%             check_top_img = BinImages(:,:,(img_no+1));
%         else
%            check_top_img(:,:) = 0;
%         end
%         
%         if img_no ~= (q_offset+1)
%             check_bottom_img = BinImages(:,:,(img_no-1));
%         else
%            check_bottom_img(:,:) = 0;
%         end
%         
%         upward_thres_check_img = logical(scan_img + check_top_img + check_bottom_img);    %must change scan_img to BinImages(:,:,img_no)
%         upward_label_img = bwlabel(upward_thres_check_img);
%         upward_CC_img = bwconncomp(upward_thres_check_img);
%         for overlap_comp_no = 1:20
%             if(overlap_comps(1,overlap_comp_no) == 0)
%                break; 
%             end
%             upward_overlap_comps = findLabels(upward_label_img(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}),2);  %% Reduce to 1 for speed
%             
%             if upward_overlap_comps(1,2) ~=0
%                fprintf("Wrong Assumption in upward threshold check"); 
%             end
%                 
%       %    if (abs(numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) - numel(upward_CC_img.PixelIdxList{upward_overlap_comps(1,1)}))/numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)})) >= max_upward_dev
%       %      continue;
%       %    end
%               
%         
%         
%                
%          
%              deviation = abs(numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) - numel(curr_obj_region));
%                 if(deviation <= min_deviation) 
%                   show_img(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) = 1;
%                   figure('Name',strcat('    Positive Example at Level 1::Bins ',strcat(int2str(img_no),int2str(img_no+main_offset))));
%                   imshow(show_img);
%                   show_img(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) = 0;
%                    
%                   show_img(upward_CC_img.PixelIdxList{upward_overlap_comps(1,1)}) = 1;
%                   figure('Name',strcat('    On Adding the Two Bins on Sides::Bins ',strcat(int2str(img_no+1),int2str(img_no-1))));
%                   imshow(show_img);
%                   show_img(upward_CC_img.PixelIdxList{upward_overlap_comps(1,1)}) = 0;
%                   
%                 end
%          
%         end
%         
%    end  %End of  img_no for 1st Level
%    
%    
%    %For 2nd Level Bins
%    for img_no = (q_offset+main_offset+1):(q_offset+2*main_offset-1) 
%      
%         scan_img = logical(BinImages(:,:,img_no)+BinImages(:,:,(img_no-main_offset+1)));
% 
%         label_scan_img = bwlabel(scan_img);
%         CC_scan_img = bwconncomp(scan_img);
%        
%         %Take upto 20 component that overlap with the correct region
%         overlap_comps = findLabels(label_scan_img(curr_obj_region),20);
%         if overlap_comps(1,1) == 0
%             continue;
%         end
%         
%         if img_no ~= (q_offset+2*main_offset-1)
%             check_top_img = BinImages(:,:,(img_no+1));
%         else
%            check_top_img = BinImages(:,:,(img_no-main_offset+1));
%         end
%         
%         if img_no ~= (q_offset+main_offset+1)
%             check_bottom_img = BinImages(:,:,(img_no-1));
%         else
%            check_bottom_img = BinImages(:,:,(img_no-main_offset));
%         end
%         
%         upward_thres_check_img = logical(scan_img + check_top_img + check_bottom_img);    %must change scan_img to BinImages(:,:,img_no)
%         upward_label_img = bwlabel(upward_thres_check_img);
%         upward_CC_img = bwconncomp(upward_thres_check_img);
%         for overlap_comp_no = 1:20
%             if(overlap_comps(1,overlap_comp_no) == 0)
%                break; 
%             end
%             upward_overlap_comps = findLabels(upward_label_img(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}),2);  %% Reduce to 1 for speed
%             
%             if upward_overlap_comps(1,2) ~=0
%                fprintf("Wrong Assumption in upward threshold check"); 
%             end
%                 
% %           if (abs(numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) - numel(upward_CC_img.PixelIdxList{upward_overlap_comps(1,1)}))/numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)})) >= max_upward_dev
% %             continue;
% %           end
% %               
%          
%              deviation = abs(numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) - numel(curr_obj_region));
%                 if(deviation <= min_deviation)
%                   show_img(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) = 1;
%                   figure('Name',strcat('    Positive Example at Level 2::Bins ',strcat(int2str(img_no),int2str(img_no-main_offset+1))));
%                   imshow(show_img);
%                   show_img(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) = 0;
%                    
%                   show_img(upward_CC_img.PixelIdxList{upward_overlap_comps(1,1)}) = 1;
%                   figure('Name',strcat('    On Adding the Two Bins on Sides::Bins ',strcat(int2str(img_no+1),int2str(img_no-1))));
%                   imshow(show_img);
%                   show_img(upward_CC_img.PixelIdxList{upward_overlap_comps(1,1)}) = 0;
%                   
%                 end
%                 
%         end
%         
%    end  %End of  img_no for 2nd Level
%      end  % End of i = BinSizes
%         
%       
%     
%  
%      
     
 %% Next we extract the Values for each Bin. Correct Components those with pixels within minVarianceInComponent 
% 
% check_top_img = false(row,col);
% check_bottom_img = false(row,col);
% 
% q_offset = 0;  
%   for i = 1:numel(BinSizes)
%    main_offset = ceil(MAX_DISTANCE/BinSizes(i));
%   
%    
%    %For 1st Level Bins
%    for img_no = (q_offset+1):(q_offset+main_offset)
%         
%         scan_img = BinImages(:,:,img_no);
%         label_scan_img = BWImages(:,:,img_no);
%         CC_scan_img = bwconncomp(scan_img);
% 
%         %Take upto 20 component that overlap with the correct region
%         overlap_comps = findLabels(label_scan_img(curr_obj_region),20);
%         
%         %For every Component extract features,if component has min
%         %deviation from main region componenet,it is labelled 1 ,otherwise
%         %0
%     for overlap_comp_no = 1:20     
%             if(overlap_comps(1,overlap_comp_no) == 0)
%                break; 
%             end
%             
%             training_entry = training_entry+1;
%             
%             %Label the closest component to the actual object region
%              deviation = abs(numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) - numel(curr_obj_region));
%              if(deviation == min_deviation)
%                  y(training_entry,1) = 1;
%                  show_img(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) = 1;
%                  figure('Name',strcat("       The Positive Example: ",int2str(img_no)));
%                  imshow(show_img);
%                  show_img(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) = 0;
%                  
%              else
%                  y(training_entry,1) = 0;
%              end
%               
%              X(training_entry,9) = img_no;
%                
%        if img_no~=(q_offset+main_offset)
%            check_top_img = BinImages(:,:,(img_no+main_offset));
%            X(training_entry,10) = img_no+main_offset;
%        else
%            check_top_img(:,:) = 0;
%            X(training_entry,10) = img_no+main_offset-1;
%        end
%        
%        if img_no~=(q_offset+1)
%            check_bottom_img = BinImages(:,:,(img_no+main_offset-1));
%            X(training_entry,11) = img_no+main_offset-1;
%        else
%            check_bottom_img(:,:) = 0;
%            X(training_entry,11) = img_no+main_offset;
%        end
%        
%        %Add the current bin top sub-bin and bottom sub-bin
%        stability_check_img = logical(check_top_img + check_bottom_img + scan_img);
%        
%        
%        check_CCImage = bwconncomp(stability_check_img);  %CC for the Summed Up Images
%        check_LabelImage = bwlabel(stability_check_img);
%           
%         %label_matrix stores the component number for the Summed up Images
%         %of Bin i,SubBins i and SubBin i+1
%         
%            label_matrix = findLabels(check_LabelImage(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}),2);   %%Change to 1 for faster execution later
%                if y(training_entry,1) == 1
%                  show_img(check_CCImage.PixelIdxList{label_matrix(1,1)}) = 1;
%                  figure('Name',strcat('    SubBins Added to both sides',strcat(int2str(X(training_entry,10)),int2str(X(training_entry,11)))));
%                  imshow(show_img);
%                  show_img(check_CCImage.PixelIdxList{label_matrix(1,1)}) = 0;
%                end
%            
%            
%            if label_matrix(1,2)~=0
%                fprintf("\n!!!More than two componenets found!\n");
%            end
%            
%           if(numel(check_CCImage.PixelIdxList{label_matrix(1,1)}) < numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}))
%               fprintf("\n!!!ERROR IN ASSUMPTION!\n");
%               error = 1
%           end
%           
%         X(training_entry,1) = (abs(numel(check_CCImage.PixelIdxList{label_matrix(1,1)}) - numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)})))/numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)});
%         stats = regionprops(CC_scan_img,'EulerNumber','Solidity');
%         check_stats = regionprops(check_CCImage,'EulerNumber','Solidity');
%         
%         X(training_entry,3) = stats(overlap_comps(1,overlap_comp_no)).EulerNumber;
%         X(training_entry,4) = check_stats(label_matrix(1,1)).EulerNumber - stats(overlap_comps(1,overlap_comp_no)).EulerNumber;
%         X(training_entry,6) = stats(overlap_comps(1,overlap_comp_no)).Solidity;
%         X(training_entry,7) = (abs(check_stats(label_matrix(1,1)).Solidity - stats(overlap_comps(1,overlap_comp_no)).Solidity))/ stats(overlap_comps(1,overlap_comp_no)).Solidity;
%         
%         %%% Extract the features after adding the two Bins on two sides
%       if img_no~=(q_offset+main_offset)
%            check_top_img = BinImages(:,:,(img_no+1));
%            X(training_entry,12) = img_no+1;
%        else
%            check_top_img(:,:) = 0;
%            X(training_entry,12) = img_no-1;
%        end
%        
%        if img_no~=(q_offset+1)
%            check_bottom_img = BinImages(:,:,(img_no-1));
%            X(training_entry,13) = img_no-1;
%        else
%            check_bottom_img(:,:) = 0;
%            X(training_entry,13) = img_no+1;
%        end
%        
%        stability_check_img = logical(check_top_img + check_bottom_img + scan_img);
%        
%        check_CCImage = bwconncomp(stability_check_img);
%        check_LabelImage = bwlabel(stability_check_img);
%           
%            label_matrix = findLabels(check_LabelImage(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}),2);   %%Change to 1 for faster execution later
%            
%                if y(training_entry,1) == 1
%                  show_img(check_CCImage.PixelIdxList{label_matrix(1,1)}) = 1;
%                  figure('Name',strcat('    Bins Added to both sides',strcat(int2str(X(training_entry,12)),int2str(X(training_entry,13)))));
%                  imshow(show_img);
%                  show_img(check_CCImage.PixelIdxList{label_matrix(1,1)}) = 0;
%                end
%                
%                
%            if label_matrix(1,2)~=0
%                fprintf("\n!!!More than two componenets found!\n");
%            end
%            
%           if(numel(check_CCImage.PixelIdxList{label_matrix(1,1)}) < numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}))
%               fprintf("\n!!!ERROR IN ASSUMPTION!\n");
%               error = 1
%           end
%           
%         X(training_entry,2) = (abs(numel(check_CCImage.PixelIdxList{label_matrix(1,1)}) - numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)})))/numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)});
%         stats = regionprops(CC_scan_img,'EulerNumber','Solidity');
%         check_stats = regionprops(check_CCImage,'EulerNumber','Solidity');
%         
%         X(training_entry,5) = check_stats(label_matrix(1,1)).EulerNumber - stats(overlap_comps(1,overlap_comp_no)).EulerNumber;
%         X(training_entry,8) = (abs(check_stats(label_matrix(1,1)).Solidity - stats(overlap_comps(1,overlap_comp_no)).Solidity))/ stats(overlap_comps(1,overlap_comp_no)).Solidity;
%         
%    end
%    end
%        
%    
%    % For 2nd Level Bins
%   for img_no = (q_offset+main_offset+1):(q_offset+2*main_offset-1)
%        
%         scan_img = BinImages(:,:,img_no);
%         label_scan_img = BWImages(:,:,img_no);
%         CC_scan_img = bwconncomp(scan_img);
%         
%         %Take upto 20 component that overlap with the correct region
%         overlap_comps = findLabels(label_scan_img(curr_obj_region),20);
%         
%     for overlap_comp_no = 1:20
%           
%             if(overlap_comps(1,overlap_comp_no) == 0)
%                break; 
%             end
%              training_entry = training_entry+1;
%              
%              deviation = abs(numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) - numel(curr_obj_region));
%              if(deviation == min_deviation)
%                  y(training_entry,1) = 1;
%                  show_img(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) = 1;
%                  figure('Name',strcat("       The Positive Example(2nd Level): ",int2str(img_no)));
%                  imshow(show_img);
%                  show_img(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) = 0;
%                  
%              else
%                  y(training_entry,1) = 0;
%              end
%              
%              X(training_entry,9) = img_no;
%                  
%            check_top_img = BinImages(:,:,(img_no-main_offset+1));
%            check_bottom_img = BinImages(:,:,(img_no-main_offset));
%              
%             X(training_entry,10) = img_no-main_offset+1;
%             X(training_entry,11) = img_no-main_offset;
%             
%          
%        stability_check_img = logical(check_top_img + check_bottom_img + scan_img);
%        
% 
%        
%        check_CCImage = bwconncomp(stability_check_img);
%        check_LabelImage = bwlabel(stability_check_img);
%           
%            label_matrix = findLabels(check_LabelImage(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}),2);   %%Change to 1 for faster execution later
%           
%                if y(training_entry,1) == 1
%                  show_img(check_CCImage.PixelIdxList{label_matrix(1,1)}) = 1;
%                  figure('Name',strcat('    Bins Added to both sides',strcat(int2str(X(training_entry,10)),int2str(X(training_entry,11)))));
%                  imshow(show_img);
%                  show_img(check_CCImage.PixelIdxList{label_matrix(1,1)}) = 0;
%                end
%            
%            
%            if label_matrix(1,2)~=0
%                fprintf("\n!!!More than two componenets found!\n");
%            end
%            
%           if(numel(check_CCImage.PixelIdxList{label_matrix(1,1)}) < numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}))
%               fprintf("\n!!!ERROR IN ASSUMPTION!\n");
%               error = 1
%           end
%           
%         X(training_entry,1) = (abs(numel(check_CCImage.PixelIdxList{label_matrix(1,1)}) - numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)})))/numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)});
%         stats = regionprops(CC_scan_img,'EulerNumber','Solidity');
%         check_stats = regionprops(check_CCImage,'EulerNumber','Solidity');
%         
%         X(training_entry,3) = stats(overlap_comps(1,overlap_comp_no)).EulerNumber;
%         X(training_entry,4) = check_stats(label_matrix(1,1)).EulerNumber - stats(overlap_comps(1,overlap_comp_no)).EulerNumber;
%         X(training_entry,6) = stats(overlap_comps(1,overlap_comp_no)).Solidity;
%         X(training_entry,7) = (abs(check_stats(label_matrix(1,1)).Solidity - stats(overlap_comps(1,overlap_comp_no)).Solidity))/ stats(overlap_comps(1,overlap_comp_no)).Solidity;
%         
%         % Extract the features after adding the two Bins on two sides
%       if img_no~=(q_offset+2*main_offset-1)
%            check_top_img = BinImages(:,:,(img_no+1));
%            X(training_entry,12) = img_no+1;
%        else
%            check_top_img(:,:) = 0;
%            X(training_entry,12) = img_no-1;
%        end
%        
%        if img_no~=(q_offset+main_offset+1)
%            check_bottom_img = BinImages(:,:,(img_no-1));
%            X(training_entry,13) = img_no-1;
%        else
%            check_bottom_img(:,:) = 0;
%            X(training_entry,13) = img_no+1;
%        end
%        
%        stability_check_img = logical(check_top_img + check_bottom_img + scan_img);
%             
% 
%                
%        check_CCImage = bwconncomp(stability_check_img);
%        check_LabelImage = bwlabel(stability_check_img);
%           
%            label_matrix = findLabels(check_LabelImage(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}),2);   %%Change to 1 for faster execution later
%           
%                if y(training_entry,1) == 1
%                  show_img(check_CCImage.PixelIdxList{label_matrix(1,1)}) = 1;
%                  figure('Name',strcat('    SubBins Added to both sides',strcat(int2str(X(training_entry,12)),int2str(X(training_entry,13)))));
%                  imshow(show_img);
%                  show_img(check_CCImage.PixelIdxList{label_matrix(1,1)}) = 0;
%                end 
%            
%            
%            if label_matrix(1,2)~=0
%                fprintf("\n!!!More than two componenets found!\n");
%            end
%            
%           if(numel(check_CCImage.PixelIdxList{label_matrix(1,1)}) < numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}))
%               fprintf("\n!!!ERROR IN ASSUMPTION!\n");
%               error = 1
%           end
%           
%         X(training_entry,2) = (abs(numel(check_CCImage.PixelIdxList{label_matrix(1,1)}) - numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)})))/numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)});
%      %   stats = regionprops(CC_scan_img,'EulerNumber','Solidity');
%         check_stats = regionprops(check_CCImage,'EulerNumber','Solidity');
%         
%         X(training_entry,5) = check_stats(label_matrix(1,1)).EulerNumber - stats(overlap_comps(1,overlap_comp_no)).EulerNumber;
%         X(training_entry,8) = (abs(check_stats(label_matrix(1,1)).Solidity - stats(overlap_comps(1,overlap_comp_no)).Solidity))/ stats(overlap_comps(1,overlap_comp_no)).Solidity;
%         
%    end
%   end
%        
%    
%    
%   
%     q_offset = q_offset+2*main_offset-1;
%  end

  







%%OLD CODE BACKUP
%     
%    %Features: 
%     % 1. Del(No. of Pixels Bin i - Bin i + SubBin(i-1,i+1))/Total No. of Pixels
%     % 2. Del(No. of Pixels Bin i - Bin(i,i+1,i-1))/Total No. of Pixels
%     % 3. No. of Holes
%     % 4. Del(No. of Holes Bin i - Bin i + SubBin(i-1,i+1))
%     % 5. Del(No. of Holes Bin i - Bin i + Bin(i-1,i+1))
%     % 6. Density 
%     % 7. Del(Change of Density of Bin i - Bin i + SubBin(i-1,i+1))/Density
%     % 8. Del(Change of Density of Bin i - Bin i + Bin(i,i-1,i+1))/Density
%     % 9. Number of Pixels
%     % 10. Height
%     % 11. Width
%     
%     
%            % BinImages = Uniquize_2Level(BinImages,BinSizes,BinSizes,MAX_DISTANCE);
%   
%   y = false(1,1);
%   X = zeros(1,16);
%   training_entry = 0; 
%  
%    
%   
%   NumImages = NUM_BIN_IMAGES;
%  
% [row,col,~] = size(BinImages);
% 
% show_img = false(row,col);
%     %Creating labelled images beforehand to speed up process
%     BWImages = zeros(size(BinImages));
%     
%     for bw_c = 1:NUM_BIN_IMAGES  
%         BWImages(:,:,bw_c) = bwlabel(BinImages(:,:,bw_c));
%     end
%     
%     
% %% We First find a Bin Image Component closest to the region,store the deviation in min_deviation
% 
%     
%     min_deviation_set = 0;
%     
%      for scan_img_no = 1:NumImages   
%        
%         scan_img = BinImages(:,:,scan_img_no);
%         label_scan_img = BWImages(:,:,scan_img_no);
%         CC_scan_img = bwconncomp(scan_img);
%        
%         %Take upto 20 component that overlap with the correct region
%         overlap_comps = findLabels(label_scan_img(curr_obj_region),20);
%         
%         for overlap_comp_no = 1:20
%             if(overlap_comps(1,overlap_comp_no) == 0)
%                break; 
%             end
%             
%          if min_deviation_set == 0
%            min_deviation = abs(numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) - numel(curr_obj_region));
%            min_deviation_set = 1;
%          else
%              deviation = abs(numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) - numel(curr_obj_region));
%                 if deviation < min_deviation 
%                     min_deviation = deviation;
%                 end
%          end
%         end
%         
%      end
%         
%      
% 
% %% Next we extract the Values for each Bin. Correct Components those with pixels within minVarianceInComponent 
% 
% check_top_img = false(row,col);
% check_bottom_img = false(row,col);
% 
% q_offset = 0;  
%   for i = 1:numel(BinSizes)
%    main_offset = ceil(MAX_DISTANCE/BinSizes(i));
%   
%    
%     %For 1st Level Bins
%    for img_no = (q_offset+1):(q_offset+main_offset)
%        
%         scan_img = BinImages(:,:,img_no);
%         label_scan_img = BWImages(:,:,img_no);
%         CC_scan_img = bwconncomp(scan_img);
% 
%         %Take upto 20 component that overlap with the correct region
%         overlap_comps = findLabels(label_scan_img(curr_obj_region),20);
%         
%         %For every Component extract features,if component has min
%         %deviation from main region componenet,it is labelled 1 ,otherwise
%         %0
%     for overlap_comp_no = 1:20     
%             if(overlap_comps(1,overlap_comp_no) == 0)
%                break; 
%             end
%             
%             training_entry = training_entry+1;
%             
%             %Label the closest component to the actual object region
%              deviation = abs(numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) - numel(curr_obj_region));
%              if(deviation == min_deviation)
%                  y(training_entry,1) = 1;
%                  show_img(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) = 1;
%                  figure('Name',strcat("       The Positive Example: ",int2str(img_no)));
%                  imshow(show_img);
%                  show_img(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) = 0;
%                  
%              else
%                  y(training_entry,1) = 0;
%              end
%               
%              X(training_entry,9) = img_no;
%                
%        if img_no~=(q_offset+main_offset)
%            check_top_img = BinImages(:,:,(img_no+main_offset));
%            X(training_entry,10) = img_no+main_offset;
%        else
%            check_top_img(:,:) = 0;
%            X(training_entry,10) = img_no+main_offset-1;
%        end
%        
%        if img_no~=(q_offset+1)
%            check_bottom_img = BinImages(:,:,(img_no+main_offset-1));
%            X(training_entry,11) = img_no+main_offset-1;
%        else
%            check_bottom_img(:,:) = 0;
%            X(training_entry,11) = img_no+main_offset;
%        end
%        
%        %Add the current bin top sub-bin and bottom sub-bin
%        stability_check_img = logical(check_top_img + check_bottom_img + scan_img);
%        
%        
%        check_CCImage = bwconncomp(stability_check_img);  %CC for the Summed Up Images
%        check_LabelImage = bwlabel(stability_check_img);
%           
%         %label_matrix stores the component number for the Summed up Images
%         %of Bin i,SubBins i and SubBin i+1
%         
%            label_matrix = findLabels(check_LabelImage(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}),2);   %%Change to 1 for faster execution later
%                if y(training_entry,1) == 1
%                  show_img(check_CCImage.PixelIdxList{label_matrix(1,1)}) = 1;
%                  figure('Name',strcat('    SubBins Added to both sides',strcat(int2str(X(training_entry,10)),int2str(X(training_entry,11)))));
%                  imshow(show_img);
%                  show_img(check_CCImage.PixelIdxList{label_matrix(1,1)}) = 0;
%                end
%            
%            
%            if label_matrix(1,2)~=0
%                fprintf("\n!!!More than two componenets found!\n");
%            end
%            
%           if(numel(check_CCImage.PixelIdxList{label_matrix(1,1)}) < numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}))
%               fprintf("\n!!!ERROR IN ASSUMPTION!\n");
%               error = 1
%           end
%           
%         X(training_entry,1) = (abs(numel(check_CCImage.PixelIdxList{label_matrix(1,1)}) - numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)})))/numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)});
%         stats = regionprops(CC_scan_img,'EulerNumber','Solidity');
%         check_stats = regionprops(check_CCImage,'EulerNumber','Solidity');
%         
%         X(training_entry,3) = stats(overlap_comps(1,overlap_comp_no)).EulerNumber;
%         X(training_entry,4) = check_stats(label_matrix(1,1)).EulerNumber - stats(overlap_comps(1,overlap_comp_no)).EulerNumber;
%         X(training_entry,6) = stats(overlap_comps(1,overlap_comp_no)).Solidity;
%         X(training_entry,7) = (abs(check_stats(label_matrix(1,1)).Solidity - stats(overlap_comps(1,overlap_comp_no)).Solidity))/ stats(overlap_comps(1,overlap_comp_no)).Solidity;
%         
%         %%% Extract the features after adding the two Bins on two sides
%       if img_no~=(q_offset+main_offset)
%            check_top_img = BinImages(:,:,(img_no+1));
%            X(training_entry,12) = img_no+1;
%        else
%            check_top_img(:,:) = 0;
%            X(training_entry,12) = img_no-1;
%        end
%        
%        if img_no~=(q_offset+1)
%            check_bottom_img = BinImages(:,:,(img_no-1));
%            X(training_entry,13) = img_no-1;
%        else
%            check_bottom_img(:,:) = 0;
%            X(training_entry,13) = img_no+1;
%        end
%        
%        stability_check_img = logical(check_top_img + check_bottom_img + scan_img);
%        
%        check_CCImage = bwconncomp(stability_check_img);
%        check_LabelImage = bwlabel(stability_check_img);
%           
%            label_matrix = findLabels(check_LabelImage(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}),2);   %%Change to 1 for faster execution later
%            
%                if y(training_entry,1) == 1
%                  show_img(check_CCImage.PixelIdxList{label_matrix(1,1)}) = 1;
%                  figure('Name',strcat('    Bins Added to both sides',strcat(int2str(X(training_entry,12)),int2str(X(training_entry,13)))));
%                  imshow(show_img);
%                  show_img(check_CCImage.PixelIdxList{label_matrix(1,1)}) = 0;
%                end
%                
%                
%            if label_matrix(1,2)~=0
%                fprintf("\n!!!More than two componenets found!\n");
%            end
%            
%           if(numel(check_CCImage.PixelIdxList{label_matrix(1,1)}) < numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}))
%               fprintf("\n!!!ERROR IN ASSUMPTION!\n");
%               error = 1
%           end
%           
%         X(training_entry,2) = (abs(numel(check_CCImage.PixelIdxList{label_matrix(1,1)}) - numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)})))/numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)});
%         stats = regionprops(CC_scan_img,'EulerNumber','Solidity');
%         check_stats = regionprops(check_CCImage,'EulerNumber','Solidity');
%         
%         X(training_entry,5) = check_stats(label_matrix(1,1)).EulerNumber - stats(overlap_comps(1,overlap_comp_no)).EulerNumber;
%         X(training_entry,8) = (abs(check_stats(label_matrix(1,1)).Solidity - stats(overlap_comps(1,overlap_comp_no)).Solidity))/ stats(overlap_comps(1,overlap_comp_no)).Solidity;
%         
%    end
%    end
%        
%    
%    % For 2nd Level Bins
%   for img_no = (q_offset+main_offset+1):(q_offset+2*main_offset-1)
%        
%         scan_img = BinImages(:,:,img_no);
%         label_scan_img = BWImages(:,:,img_no);
%         CC_scan_img = bwconncomp(scan_img);
%         
%         %Take upto 20 component that overlap with the correct region
%         overlap_comps = findLabels(label_scan_img(curr_obj_region),20);
%         
%     for overlap_comp_no = 1:20
%           
%             if(overlap_comps(1,overlap_comp_no) == 0)
%                break; 
%             end
%              training_entry = training_entry+1;
%              
%              deviation = abs(numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) - numel(curr_obj_region));
%              if(deviation == min_deviation)
%                  y(training_entry,1) = 1;
%                  show_img(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) = 1;
%                  figure('Name',strcat("       The Positive Example(2nd Level): ",int2str(img_no)));
%                  imshow(show_img);
%                  show_img(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) = 0;
%                  
%              else
%                  y(training_entry,1) = 0;
%              end
%              
%              X(training_entry,9) = img_no;
%                  
%            check_top_img = BinImages(:,:,(img_no-main_offset+1));
%            check_bottom_img = BinImages(:,:,(img_no-main_offset));
%              
%             X(training_entry,10) = img_no-main_offset+1;
%             X(training_entry,11) = img_no-main_offset;
%             
%          
%        stability_check_img = logical(check_top_img + check_bottom_img + scan_img);
%        
% 
%        
%        check_CCImage = bwconncomp(stability_check_img);
%        check_LabelImage = bwlabel(stability_check_img);
%           
%            label_matrix = findLabels(check_LabelImage(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}),2);   %%Change to 1 for faster execution later
%           
%                if y(training_entry,1) == 1
%                  show_img(check_CCImage.PixelIdxList{label_matrix(1,1)}) = 1;
%                  figure('Name',strcat('    Bins Added to both sides',strcat(int2str(X(training_entry,10)),int2str(X(training_entry,11)))));
%                  imshow(show_img);
%                  show_img(check_CCImage.PixelIdxList{label_matrix(1,1)}) = 0;
%                end
%            
%            
%            if label_matrix(1,2)~=0
%                fprintf("\n!!!More than two componenets found!\n");
%            end
%            
%           if(numel(check_CCImage.PixelIdxList{label_matrix(1,1)}) < numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}))
%               fprintf("\n!!!ERROR IN ASSUMPTION!\n");
%               error = 1
%           end
%           
%         X(training_entry,1) = (abs(numel(check_CCImage.PixelIdxList{label_matrix(1,1)}) - numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)})))/numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)});
%         stats = regionprops(CC_scan_img,'EulerNumber','Solidity');
%         check_stats = regionprops(check_CCImage,'EulerNumber','Solidity');
%         
%         X(training_entry,3) = stats(overlap_comps(1,overlap_comp_no)).EulerNumber;
%         X(training_entry,4) = check_stats(label_matrix(1,1)).EulerNumber - stats(overlap_comps(1,overlap_comp_no)).EulerNumber;
%         X(training_entry,6) = stats(overlap_comps(1,overlap_comp_no)).Solidity;
%         X(training_entry,7) = (abs(check_stats(label_matrix(1,1)).Solidity - stats(overlap_comps(1,overlap_comp_no)).Solidity))/ stats(overlap_comps(1,overlap_comp_no)).Solidity;
%         
%         % Extract the features after adding the two Bins on two sides
%       if img_no~=(q_offset+2*main_offset-1)
%            check_top_img = BinImages(:,:,(img_no+1));
%            X(training_entry,12) = img_no+1;
%        else
%            check_top_img(:,:) = 0;
%            X(training_entry,12) = img_no-1;
%        end
%        
%        if img_no~=(q_offset+main_offset+1)
%            check_bottom_img = BinImages(:,:,(img_no-1));
%            X(training_entry,13) = img_no-1;
%        else
%            check_bottom_img(:,:) = 0;
%            X(training_entry,13) = img_no+1;
%        end
%        
%        stability_check_img = logical(check_top_img + check_bottom_img + scan_img);
%             
% 
%                
%        check_CCImage = bwconncomp(stability_check_img);
%        check_LabelImage = bwlabel(stability_check_img);
%           
%            label_matrix = findLabels(check_LabelImage(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}),2);   %%Change to 1 for faster execution later
%           
%                if y(training_entry,1) == 1
%                  show_img(check_CCImage.PixelIdxList{label_matrix(1,1)}) = 1;
%                  figure('Name',strcat('    SubBins Added to both sides',strcat(int2str(X(training_entry,12)),int2str(X(training_entry,13)))));
%                  imshow(show_img);
%                  show_img(check_CCImage.PixelIdxList{label_matrix(1,1)}) = 0;
%                end 
%            
%            
%            if label_matrix(1,2)~=0
%                fprintf("\n!!!More than two componenets found!\n");
%            end
%            
%           if(numel(check_CCImage.PixelIdxList{label_matrix(1,1)}) < numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}))
%               fprintf("\n!!!ERROR IN ASSUMPTION!\n");
%               error = 1
%           end
%           
%         X(training_entry,2) = (abs(numel(check_CCImage.PixelIdxList{label_matrix(1,1)}) - numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)})))/numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)});
%      %   stats = regionprops(CC_scan_img,'EulerNumber','Solidity');
%         check_stats = regionprops(check_CCImage,'EulerNumber','Solidity');
%         
%         X(training_entry,5) = check_stats(label_matrix(1,1)).EulerNumber - stats(overlap_comps(1,overlap_comp_no)).EulerNumber;
%         X(training_entry,8) = (abs(check_stats(label_matrix(1,1)).Solidity - stats(overlap_comps(1,overlap_comp_no)).Solidity))/ stats(overlap_comps(1,overlap_comp_no)).Solidity;
%         
%    end
%   end
%        
%    
%    
%   
%     q_offset = q_offset+2*main_offset-1;
%  end
% 
%   
% end
% 
% 
% 






%% BACKUP END






%  for img_no = (q_offset+main_offset+1):(q_offset+2*main_offset-1)
%        
% %        img = BinImages(:,:,img_no);
% %        CC_scan_img = bwconncomp(img);
% %        
% %      
% %       % Find Component with max area in the region         
% %        label_matrix = findLabels(LabelImg(interestRegion),10); 
% %      
% %        overlap_comp_no = label_matrix(1,1);
% %        if overlap_comp_no == 0
% %            continue;
% %        end
% %         
% %         if label_matrix(1,2)~=0
% %            check_comp = 2;
% %            while label_matrix(1,check_comp)~=0
% %               if numel(CC_scan_img.PixelIdxList{label_matrix(1,check_comp)}) > numel(CC_scan_img.PixelIdxList{overlap_comp_no})
% %                   overlap_comp_no = label_marix(1,check_comp);
% %               end
% %               check_comp = check_comp + 1;
% %            end
% %         end
% %        
% %         if abs(numel(CC_scan_img.PixelIdxList{overlap_comp_no}) - numel(interestRegion)) <= minVarianceInComponent
% %             y(img_no,1) = 1;
% %         else
% %             y(img_no,1) = 0;
% %         end
% 
%             if(overlap_comps(1,overlap_comp_no) == 0)
%                break; 
%             end
%             
%              deviation = abs(numel(CC_scan_img.PixelIdxList{overlap_comps(1,1)}) - numel(CC_scan_img.PixelIdxList{overlap_comps(1,1)}));
%              if(deviation == min_deviation)
%                  y(training_entry,1) = 1;         
%              end
%              
%           %Extract the Component after adding SubBins Images on both sides
%           %of current Bin
%                  
%      
%            check_top_img = BinImages(:,:,(img_no-main_offset+1));
%            check_bottom_img = BinImages(:,:,(img_no-main_offset));
% 
%        
%        stability_check_img = check_top_img | check_bottom_img | img;
%        
%        check_CCImage = bwconncomp(stability_check_img);
%        check_LabelImage = bwlabel(stability_check_img);
%           
%            label_matrix = findLabels(check_LabelImage(CC_scan_img.PixelIdxList{overlap_comp_no}),2);   %%Change to 1 for faster execution later
%            if label_matrix(1,2)~=0
%                fprintf("\n!!!More than two componenets found!\n");
%            end
%            
%           if(numel(check_CCImage.PixelIdxList{label_matrix(1,1)}) < numel(CC_scan_img.PixelIdxList{overlap_comp_no}))
%               fprintf("\n!!!ERROR IN ASSUMPTION!\n");
%               error = 1
%           end
%           
%         X(img_no,1) = (abs(numel(check_CCImage.PixelIdxList{label_matrix(1,1)}) - numel(CC_scan_img.PixelIdxList{overlap_comp_no})))/numel(CC_scan_img.PixelIdxList{overlap_comp_no});
%         stats = regionprops(CC_scan_img,'EulerNumber','Solidity');
%         check_stats = regionprops(check_CCImage,'EulerNumber','Solidity');
%         
%         X(img_no,3) = stats(overlap_comp_no).EulerNumber;
%         X(img_no,4) = check_stats(label_matrix(1,1)).EulerNumber - stats(overlap_comp_no).EulerNumber;
%         X(img_no,6) = stats(overlap_comp_no).Solidity;
%         X(img_no,7) = (abs(check_stats(label_matrix(1,1)).Solidity - stats(overlap_comp_no).Solidity))/ stats(overlap_comp_no).Solidity;
%         
%         % Extract the features after adding the two Bins on two sides
%       if img_no~=(q_offset+2*main_offset-1)
%            check_top_img = BinImages(:,:,(img_no+1));
%        else
%            check_top_img(:,:) = 0;
%        end
%        
%        if img_no~=(q_offset+main_offset+1)
%            check_bottom_img = BinImages(:,:,(img_no-1));
%        else
%            check_bottom_img(:,:) = 0;
%        end
%        
%        stability_check_img = check_top_img | check_bottom_img | img;
%        
%        check_CCImage = bwconncomp(stability_check_img);
%        check_LabelImage = bwlabel(stability_check_img);
%           
%            label_matrix = findLabels(check_LabelImage(CC_scan_img.PixelIdxList{overlap_comp_no}),2);   %%Change to 1 for faster execution later
%            if label_matrix(1,2)~=0
%                fprintf("\n!!!More than two componenets found!\n");
%            end
%            
%           if(numel(check_CCImage.PixelIdxList{label_matrix(1,1)}) < numel(CC_scan_img.PixelIdxList{overlap_comp_no}))
%               fprintf("\n!!!ERROR IN ASSUMPTION!\n");
%               error = 1
%           end
%           
%         X(img_no,2) = (abs(numel(check_CCImage.PixelIdxList{label_matrix(1,1)}) - numel(CC_scan_img.PixelIdxList{overlap_comp_no})))/numel(CC_scan_img.PixelIdxList{overlap_comp_no});
%         stats = regionprops(CC_scan_img,'EulerNumber','Solidity');
%         check_stats = regionprops(check_CCImage,'EulerNumber','Solidity');
%         
%         X(img_no,5) = check_stats(label_matrix(1,1)).EulerNumber - stats(overlap_comp_no).EulerNumber;
%         X(img_no,8) = (abs(check_stats(label_matrix(1,1)).Solidity - stats(overlap_comp_no).Solidity))/ stats(overlap_comp_no).Solidity;
%         
%    end
      
    