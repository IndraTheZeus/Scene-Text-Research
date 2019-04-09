function [X,y] = extractStabilityValuesNonText(region,BinImages,NUM_BIN_IMAGES,BinSizes,MAX_DISTANCE,StabilityCheckMatrix,BinMatrix)

    global scan_imgs upper_range_check_imgs lower_range_check_imgs upper_range_bwimages lower_range_bwimages
    
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
    
    % 13. SVT
    % 14. SVT difference lower range
    % 15. SVT difference higher range
    % 16. eHOG
    % 17. eHOH difference lower range
    % 18. eHOG difference higher range
    
    %Secondary Features
    % 13. 1. * 9.
    % 14. 2. * 9.
    % 15. 3. / 10.
    % 16. 3. / 9.
    % 17. 1. /10.
    % 18. 2. / 10.
    
           % BinImages = Uniquize_2Level(BinImages,BinSizes,BinSizes,MAX_DISTANCE);
  
  y = false(1,1);
  X = zeros(1,18);
  training_entry = 0; 
 
   
  
%   NumImages = NUM_BIN_IMAGES;
 
[row,col,~] = size(BinImages);
error_figure = false(row,col);
 palate = zeros(row,col);

show_img = false(row,col);
    %Creating labelled images beforehand to speed up process
%     BWImages = zeros(size(BinImages));
%     
%     for bw_c = 1:NUM_BIN_IMAGES  
%         BWImages(:,:,bw_c) = bwlabel(BinImages(:,:,bw_c));
%     end
    


 
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
          scan_img = scan_imgs(:,:,img_no);
  
       
        CC_scan_img = bwconncomp(scan_img);
       
        
       lower_range_check_img = lower_range_check_imgs(:,:,img_no);
   
      lower_range_check_CC = bwconncomp(lower_range_check_img);
      
        upper_range_check_img_no_1= StabilityCheckMatrix(img_no,6);
        upper_range_check_img_no_2= StabilityCheckMatrix(img_no,7);

      upper_range_check_img = upper_range_check_imgs(:,:,img_no);
      upper_range_check_CC = bwconncomp(upper_range_check_img);
      
      lower_range_bwimage = lower_range_bwimages(:,:,img_no);
      upper_range_bwimage =  upper_range_bwimages(:,:,img_no);
      
       stats = regionprops(CC_scan_img,'EulerNumber','Solidity');
        lower_check_stats = regionprops(lower_range_check_CC,'EulerNumber','Solidity');
       upper_check_stats = regionprops(upper_range_check_CC,'EulerNumber','Solidity');
       
      
    for overlap_comp_no = 1:CC_scan_img.NumObjects

           if(sum(sum(region(CC_scan_img.PixelIdxList{overlap_comp_no}))) ~= 0)
              continue;
          end
        
           lower_range_overlap_comp = findLabels(lower_range_bwimage(CC_scan_img.PixelIdxList{overlap_comp_no}),1); %Make to 1 for speed
           upper_range_overlap_comp = findLabels(upper_range_bwimage(CC_scan_img.PixelIdxList{overlap_comp_no}),1);
      
        if lower_range_overlap_comp(1,1) == 0 %lower_range_overlap_comp(1,2) ~= 0 || 
           fprintf("\n Wrong Calculation in LOWER Range Check Image");
           figure('Name','ERROR:No Overlap Component !! K-means Component being scanned');
           error_figure(CC_scan_img.PixelIdxList{overlap_comp_no}) = 1;
           imshow(error_figure);
           figure('Name','ERROR:Overlap Component !! The Lower Range Overlap Image');
           error_figure(:,:) = 0;
           imshow(lower_range_check_img);
           continue;
        end
        
        if  upper_range_overlap_comp(1,1) == 0 %upper_range_overlap_comp(1,2) ~= 0 ||   
           fprintf("\n Wrong Calculation in LOWER Range Check Image");
           figure('Name','ERROR:No Overlap Component!! K-means Component being scanned');
           error_figure(CC_scan_img.PixelIdxList{overlap_comp_no}) = 1;
           imshow(error_figure);
           figure('Name','ERROR:No Overlap Component!! The Upper Range Overlap Image');
           error_figure(:,:) = 0;
           imshow(upper_range_check_img);
           continue;
        end
        
        comp_num_of_pixels = numel(CC_scan_img.PixelIdxList{overlap_comp_no});
        
        upper_range_comp_no_pixels = numel(upper_range_check_CC.PixelIdxList{upper_range_overlap_comp(1,1)});
        lower_range_comp_no_pixels = numel(lower_range_check_CC.PixelIdxList{lower_range_overlap_comp(1,1)});
        
        if comp_num_of_pixels > lower_range_comp_no_pixels          
           fprintf("\nError in Finding Correct LOWER Range Component: Size of Overlap reduced ");
           figure('Name','ERROR: Size Reduction!! K-means Component being scanned');
           error_figure(CC_scan_img.PixelIdxList{overlap_comp_no}) = 1;
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
           error_figure(CC_scan_img.PixelIdxList{overlap_comp_no}) = 1;
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
            
       
            y(training_entry,1) = 0;

 
              
             X(training_entry,9) = numel(CC_scan_img.PixelIdxList{overlap_comp_no});
               
             X(training_entry,10) = BinSizes(i);
             
       if img_no~=(q_offset+main_offset) && img_no~=(q_offset+1)         
           X(training_entry,11) = 2*k;
       else       
           X(training_entry,11) = k;
       end
       
  

          
       X(training_entry,3) = stats(overlap_comp_no).EulerNumber;

      X(training_entry,6) = stats(overlap_comp_no).Solidity;  
   
       %Getting values from lower range image
           
        X(training_entry,1) = (abs(numel(lower_range_check_CC.PixelIdxList{lower_range_overlap_comp(1,1)}) - numel(CC_scan_img.PixelIdxList{overlap_comp_no})))/numel(CC_scan_img.PixelIdxList{overlap_comp_no});        
        X(training_entry,4) = lower_check_stats(lower_range_overlap_comp(1,1)).EulerNumber - stats(overlap_comp_no).EulerNumber;       
        X(training_entry,7) = (abs(lower_check_stats(lower_range_overlap_comp(1,1)).Solidity - stats(overlap_comp_no).Solidity))/ stats(overlap_comp_no).Solidity;
        
           X(training_entry,12) = max(BinMatrix(upper_range_check_img_no_1,4),BinMatrix(upper_range_check_img_no_2,4))-min(BinMatrix(upper_range_check_img_no_1,3),BinMatrix(upper_range_check_img_no_2,3)); 
          
       
       
          %Adding the Higher Range Bins

          
        X(training_entry,2) = (abs(numel(upper_range_check_CC.PixelIdxList{upper_range_overlap_comp(1,1)}) - numel(CC_scan_img.PixelIdxList{overlap_comp_no})))/numel(CC_scan_img.PixelIdxList{overlap_comp_no});        
        X(training_entry,5) = upper_check_stats(upper_range_overlap_comp(1,1)).EulerNumber - stats(overlap_comp_no).EulerNumber;       
        X(training_entry,8) = (abs(upper_check_stats(upper_range_overlap_comp(1,1)).Solidity - stats(overlap_comp_no).Solidity))/ stats(overlap_comp_no).Solidity;
        
        %Text Features Added
        palate(:,:) = 0;
        palate(CC_scan_img.PixelIdxList{overlap_comp_no}) = 1; 
        X(training_entry,13) = SWT(palate);
        X(training_entry,16) = eHOG(palate);
        
        palate(:,:) = 0;
        palate(lower_range_check_CC.PixelIdxList{lower_range_overlap_comp(1,1)}) = 1;
        X(training_entry,14) = SWT(palate) - X(training_entry,13) ;
        X(training_entry,17) = eHOG(palate) - X(training_entry,16);
        
        palate(:,:) = 0;
        palate(upper_range_check_CC.PixelIdxList{upper_range_overlap_comp(1,1)}) = 1;
        X(training_entry,15) = SWT(palate) - X(training_entry,13) ;
        X(training_entry,18) = eHOG(palate) - X(training_entry,16);
        
    end
   
  
        end
  
   
   % For 2nd Level Bins
     for img_no = (q_offset+main_offset+1):(q_offset+2*main_offset-1) 
          scan_img = scan_imgs(:,:,img_no);    
        CC_scan_img = bwconncomp(scan_img);
       
       lower_range_check_img = lower_range_check_imgs(:,:,img_no);
   
      lower_range_check_CC = bwconncomp(lower_range_check_img);
      
        upper_range_check_img_no_1= StabilityCheckMatrix(img_no,6);
        upper_range_check_img_no_2= StabilityCheckMatrix(img_no,7);

      upper_range_check_img = upper_range_check_imgs(:,:,img_no);
      upper_range_check_CC = bwconncomp(upper_range_check_img);
      
      lower_range_bwimage = lower_range_bwimages(:,:,img_no);
      upper_range_bwimage =  upper_range_bwimages(:,:,img_no);
      
       stats = regionprops(CC_scan_img,'EulerNumber','Solidity');
        lower_check_stats = regionprops(lower_range_check_CC,'EulerNumber','Solidity');
       upper_check_stats = regionprops(upper_range_check_CC,'EulerNumber','Solidity');
    for overlap_comp_no = 1:CC_scan_img.NumObjects
           

           if(sum(sum(region(CC_scan_img.PixelIdxList{overlap_comp_no}))) ~= 0)
              continue;
          end
        
           lower_range_overlap_comp = findLabels(lower_range_bwimage(CC_scan_img.PixelIdxList{overlap_comp_no}),1); %Make to 1 for speed
           upper_range_overlap_comp = findLabels(upper_range_bwimage(CC_scan_img.PixelIdxList{overlap_comp_no}),1);
      
         if lower_range_overlap_comp(1,1) == 0 %|| lower_range_overlap_comp(1,2) ~= 0 ||    
           fprintf("\n Wrong Calculation in LOWER Range Check Image");
           figure('Name','ERROR:No Overlap Component !! K-means Component being scanned');
           error_figure(CC_scan_img.PixelIdxList{overlap_comp_no}) = 1;
           imshow(error_figure);
           figure('Name','ERROR:Overlap Component !! The Lower Range Overlap Image');
           error_figure(:,:) = 0;
           imshow(lower_range_check_img);
           continue;
        end
        
        if  upper_range_overlap_comp(1,1) == 0 %upper_range_overlap_comp(1,2) ~= 0 ||   
           fprintf("\n Wrong Calculation in LOWER Range Check Image");
           figure('Name','ERROR:No Overlap Component!! K-means Component being scanned');
           error_figure(CC_scan_img.PixelIdxList{overlap_comp_no}) = 1;
           imshow(error_figure);
           figure('Name','ERROR:No Overlap Component!! The Upper Range Overlap Image');
           error_figure(:,:) = 0;
           imshow(upper_range_check_img);
           continue;
        end
        
        comp_num_of_pixels = numel(CC_scan_img.PixelIdxList{overlap_comp_no});
        
        upper_range_comp_no_pixels = numel(upper_range_check_CC.PixelIdxList{upper_range_overlap_comp(1,1)});
        lower_range_comp_no_pixels = numel(lower_range_check_CC.PixelIdxList{lower_range_overlap_comp(1,1)});
        
        if comp_num_of_pixels > lower_range_comp_no_pixels          
           fprintf("\nError in Finding Correct LOWER Range Component: Size of Overlap reduced ");
           figure('Name','ERROR: Size Reduction!! K-means Component being scanned');
           error_figure(CC_scan_img.PixelIdxList{overlap_comp_no}) = 1;
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
           error_figure(CC_scan_img.PixelIdxList{overlap_comp_no}) = 1;
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
            
              y(training_entry,1) = 0;

             X(training_entry,9) = numel(CC_scan_img.PixelIdxList{overlap_comp_no});

           X(training_entry,10) = BinSizes(i);

           X(training_entry,11) = 2*k;
      
       X(training_entry,3) = stats(overlap_comp_no).EulerNumber;
       X(training_entry,6) = stats(overlap_comp_no).Solidity;  
     
          
        X(training_entry,1) = (abs(numel(lower_range_check_CC.PixelIdxList{lower_range_overlap_comp(1,1)}) - numel(CC_scan_img.PixelIdxList{overlap_comp_no})))/numel(CC_scan_img.PixelIdxList{overlap_comp_no});        
        X(training_entry,4) = lower_check_stats(lower_range_overlap_comp(1,1)).EulerNumber - stats(overlap_comp_no).EulerNumber;       
        X(training_entry,7) = (abs(lower_check_stats(lower_range_overlap_comp(1,1)).Solidity - stats(overlap_comp_no).Solidity))/ stats(overlap_comp_no).Solidity;
        
            X(training_entry,12) = max(BinMatrix(upper_range_check_img_no_1,4),BinMatrix(upper_range_check_img_no_2,4))-min(BinMatrix(upper_range_check_img_no_1,3),BinMatrix(upper_range_check_img_no_2,3)); 
          
       
       
          %Adding the Higher Range Bins
            
        X(training_entry,2) = (abs(numel(upper_range_check_CC.PixelIdxList{upper_range_overlap_comp(1,1)}) - numel(CC_scan_img.PixelIdxList{overlap_comp_no})))/numel(CC_scan_img.PixelIdxList{overlap_comp_no});        
        X(training_entry,5) = upper_check_stats(upper_range_overlap_comp(1,1)).EulerNumber - stats(overlap_comp_no).EulerNumber;       
        X(training_entry,8) = (abs(upper_check_stats(upper_range_overlap_comp(1,1)).Solidity - stats(overlap_comp_no).Solidity))/ stats(overlap_comp_no).Solidity;
        
       
        % Text Features
        palate(:,:) = 0;
        palate(CC_scan_img.PixelIdxList{overlap_comp_no}) = 1; 
        X(training_entry,13) = SWT(palate);
        X(training_entry,16) = eHOG(palate);
        
        palate(:,:) = 0;
        palate(lower_range_check_CC.PixelIdxList{lower_range_overlap_comp(1,1)}) = 1;
        X(training_entry,14) = SWT(palate) - X(training_entry,13) ;
        X(training_entry,17) = eHOG(palate) - X(training_entry,16);
        
        palate(:,:) = 0;
        palate(upper_range_check_CC.PixelIdxList{upper_range_overlap_comp(1,1)}) = 1;
        X(training_entry,15) = SWT(palate) - X(training_entry,13) ;
        X(training_entry,18) = eHOG(palate) - X(training_entry,16);
        
          
        
        
    end
        
   
    end
   
   q_offset = q_offset+2*main_offset-1;
        end  
   
   
  
   
 end

  
