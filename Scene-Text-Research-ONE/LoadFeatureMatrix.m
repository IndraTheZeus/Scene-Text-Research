
function [X,y,BinImages,NUM_BIN_IMAGES] = LoadFeatureMatrix(img)

%%FUNCTION TO EXTRACT FEATURES FROM EACH BOUNDING IMAGE AND CONNECTED
%%COMPONENT AND STORE IT IN EXCEL SHEET


show_results = false;


%% Create The Feature Matrix X

 %Features: 
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
    % 11.Lower Range Increment Check
    % 12. Higher Range Increment Check
    
    % 13. 1. * 9.
    % 14. 2. * 9.
    % 15. 3. / 10.
    % 16. 3. / 9.
    % 17. 1. /10.
    % 18. 2. / 10. 
   
     X = zeros(1,12);
     training_entry = 1;
     y = false(1,1);
  

     
%% Extract Features from each Image
        
    
    % load the image from the directory
    [row,col] = size(img);
    %region denotes the correct homogenous region
    region = findInterestRegions(img);
     CC = bwconncomp(region);
     
     %Creating the Bin Images to extract features
     fprintf("\n  -- Creating the Bin Images  -- \n");
   [BinImages,NUM_BIN_IMAGES,BinSizes,MAX_DISTANCE] = Algo2001_3(img,1);
   
   StabilityCheckMatrix = testDriverGURI(); % CHANGE FUNCTION IF DISTANCE CALCULATION CHANGES
%     StabilityCheckMatrix
    BinMatrix = printBinAllocations(BinSizes,MAX_DISTANCE,NUM_BIN_IMAGES);
%     BinMatrix
    
    
    %Iterate through each component and extract features
    test_figures = false(size(region));
     for comp_no = 1:CC.NumObjects
        
       curr_obj_region = CC.PixelIdxList{comp_no};

       if show_results
         test_figures(curr_obj_region) = 1;
            figure('Name','           The K-Means Text Region');
            imshow(test_figures)
         test_figures(:,:) = 0;
       end
         
        fprintf("\nExtracting Features for Component No: %d",comp_no);
       [rX,rY] = extractStabilityValues(img,region,curr_obj_region,BinImages,NUM_BIN_IMAGES,BinSizes,MAX_DISTANCE,StabilityCheckMatrix,BinMatrix);
       [rM,~] = size(rX);
       
      %Put extracted feature values into X and y
         X(training_entry:(training_entry+rM-1),:) = rX;
         y(training_entry:(training_entry+rM-1),:) = rY;
         training_entry = training_entry+rM;
       
          close all
        
%          fprintf('\n    ---The Features Values for Comp---\n ');
%            [rY,rX]
     end
    
%      if show_results
%         fprintf("\nExtracted Data: \n");
%         [y X]
%      end

%Creating Secondary Features
    % 13. 1. * 9.
    % 14. 2. * 9.
    % 15. 3. / 10.
    % 16. 3. / 9.
    % 17. 1. /10.
    % 18. 2. / 10. 
   % X =[X X(:,1).*X(:,9) X(:,2).*X(:,9) X(:,3)./X(:,10) X(:,3)./X(:,9) X(:,1)./X(:,10) X(:,2)./X(:,10) ];
     
%     %%Writing Data to File
%    
%      if append_mode && isfile("StabilityFeatures(0.2,0.25).xlsx")
%         fprintf("\nAppending To Data To Existing File....\n");
%         Prev = xlsread(filename);
%         Prev
%         Data = [y X]; 
%         Data
%         xlswrite(filename,[Prev;Data]);
%      else
%         fprintf("\nWriting New Data....\n");
%         Data = [y X];    
%         Data
%         xlswrite(filename,Data); 
% 
%     end
   
   
     
    
   
    
    

end












%%OLD CODE
% function [BinImages,NUM_BIN_IMAGES] = LoadFeatureMatrix(dir_in, file_ext)
% 
% %%FUNCTION TO EXTRACT FEATURES FROM EACH BOUNDING IMAGE AND CONNECTED
% %%COMPONENT AND STORE IT IN EXCEL SHEET
% 
% filename = "StabilityFeatures(0.2,0.25).xlsx";
% append_mode = true;
% 
% show_results = true;
% 
%  fprintf('\n                        ------------------LOADING FEATURE MATRIX----------------          \n  ');
% 
% % list of files in the directory name with the input file extension
% listing = dir(strcat(dir_in,'*.',file_ext));
% file_names = {listing.name};
% 
% % number of pages in the directory with this file extension
% num_pages = length(file_names);
% 
% %display(num_pages);
% fprintf('Total number of Data Images = %d\n', num_pages);
% 
% %% Create The Feature Matrix X
% 
%  %Features: 
%     % 1. Del(No. of Pixels Bin i - Bin i + SubBin(i-1,i+1))/Total No. of Pixels
%     % 2. Del(No. of Pixels Bin i - Bin(i,i+1,i-1))/Total No. of Pixels
%     % 3. No. of Holes
%     % 4. Del(No. of Holes Bin i - Bin i + SubBin(i-1,i+1))
%     % 5. Del(No. of Holes Bin i - Bin i + Bin(i-1,i+1))
%     % 6. Density 
%     % 7. Del(Change of Density of Bin i - Bin i + SubBin(i-1,i+1))/Density
%     % 8. Del(Change of Density of Bin i - Bin i + Bin(i,i-1,i+1))/Density
%     % 9. Number of Pixels
%     % 10. BinSize
%     % 11.Lower Range Increment Check
%     % 12. Higher Range Increment Check
%    
%      X = zeros(1,12);
%      training_entry = 1;
%      y = false(1,1);
%   
% 
%      
% %% Extract Features from each Image
%     for i = 1:num_pages 
%   
%     fprintf(' \n ===== Extracting Features from Data Image No: %d =====\n', i);    
%     
%     % load the image from the directory
%     img = imread(strcat(dir_in,file_names{i}));
%     [row,col] = size(img);
%     %region denotes the correct homogenous region
%     region = findInterestRegions(img);
%      CC = bwconncomp(region);
%      
%      %Creating the Bin Images to extract features
%      fprintf("\n  -- Creating the Bin Images  -- \n");
%    [BinImages,NUM_BIN_IMAGES,BinSizes,MAX_DISTANCE] = Algo2001_3(img,1);
%    
%    StabilityCheckMatrix = testDriverGURI(); % CHANGE FUNCTION IF DISTANCE CALCULATION CHANGES
% %     StabilityCheckMatrix
%     BinMatrix = printBinAllocations(BinSizes,MAX_DISTANCE,NUM_BIN_IMAGES);
% %     BinMatrix
%     
%     
%     %Iterate through each component and extract features
%     test_figures = false(size(region));
%      for comp_no = 1:CC.NumObjects
%         
%        curr_obj_region = CC.PixelIdxList{comp_no};
% 
%        if show_results
%          test_figures(curr_obj_region) = 1;
%             figure('Name','           The K-Means Text Region');
%             imshow(test_figures)
%          test_figures(:,:) = 0;
%        end
%          
%         fprintf("Extracting Features for Component No: %d",comp_no);
%        [rX,rY] = extractStabilityValues(img,region,curr_obj_region,BinImages,NUM_BIN_IMAGES,BinSizes,MAX_DISTANCE,StabilityCheckMatrix,BinMatrix);
%        [rM,~] = size(rX);
%        
%       %Put extracted feature values into X and y
%          X(training_entry:(training_entry+rM-1),:) = rX;
%          y(training_entry:(training_entry+rM-1),:) = rY;
%          training_entry = training_entry+rM;
%           close all
%          fprintf('\n    ---The Features Values for Comp---\n ');
%            [rY,rX]
%      end
%     
%      fprintf("\nExtracted Data: \n");
% %      [y X]
%     %%Writing Data to File
%    
%      if append_mode && isfile("StabilityFeatures(0.2,0.25).xlsx")
%         fprintf("\nAppending To Data To Existing File....\n");
%         Prev = xlsread(filename);
%         Prev
%         Data = [y X]; 
%         Data
%         xlswrite(filename,[Prev;Data]);
%      else
%         fprintf("\nWriting New Data....\n");
%         Data = [y X];    
%         Data
%         xlswrite(filename,Data); 
% 
%     end
%    
%    
% 
%     
% %    BWImages = double(row,col,NumImages);
% %    %Creating labelled images beforehand to speed up process
% %     for bw_c = 1:NumImages  
% %         BWImages(:,:,bw_c) = bwlabel(finalA(:,:,bw_c));
% %     end
% %     
% %     
% %     
% %     CC = bwconncomp(region);
% %     dev_set = 0;
% %     
% %     % Find the minimum deviation in pixels from the region image with the
% %     % edge bin images, then put features for each component in X
% %     for obj_no =  1:CC.NumObjects
% %         curr_obj_region = CC.PixelIdxList{obj_no};
% %      for scan_img_no = 1:NumImages   
% %        
% %         scan_img = finalA(:,:,scan_img_no);
% %         label_scan_img = BWImages(:,:,scan_img_no);
% %         CC_scan_img = bwconncomp(scan_img);
% %        
% %         %Take upto 20 component that overlap with the correct region
% %         overlap_comps = findLabels(label_scan_img(curr_obj_region),20);
% %         
% %         for overlap_comp_no = 1:20
% %             if(overlap_comps(1,overlap_comp_no) == 0)
% %                break; 
% %             end
% %             
% %          if dev_set == 0
% %            min_deviation = abs(numel(CC_scan_img.PixelIdxList{overlap_comps(1,1)}) - numel(CC_scan_img.PixelIdxList{overlap_comps(1,1)}));
% %            dev_set = 1;
% %          else
% %              deviation = abs(numel(CC_scan_img.PixelIdxList{overlap_comps(1,1)}) - numel(CC_scan_img.PixelIdxList{overlap_comps(1,1)}));
% %                 if deviation < min_deviation 
% %                     min_deviation = deviation;
% %                 end
% %          end
% %         end
% %         
% %      end
% %     
% %     
% %     %The Min Deviation has been calculated ,now extract features and label
% %     %the min deviation components as 1
% % 
% %       for scan_img_no = 1:NumImages   
% %        
% %         scan_img = finalA(:,:,scan_img_no);
% %         label_scan_img = BWImages(:,:,scan_img_no);
% %         CC_scan_img = bwconncomp(scan_img);
% %        
% %         %Take upto 20 component that overlap with the correct region
% %         overlap_comps = findLabels(label_scan_img(curr_obj_region),20);
% %         
% %         for overlap_comp_no = 1:20
% %             if(overlap_comps(1,overlap_comp_no) == 0)
% %                break; 
% %             end
% %             
% %              deviation = abs(numel(CC_scan_img.PixelIdxList{overlap_comps(1,1)}) - numel(CC_scan_img.PixelIdxList{overlap_comps(1,1)}));
% %              if(deviation == min_deviation)
% %                  y(training_entry,1) = 1;         
% %              end
% %              
% %              min_upper = finalA(:,:,scan_img_no) + 
% %              X(training_data,:) = ExtractCustomFeatures(scan_img,
% %              
% %         end
% %         
% %      end
% %     
% %   
% %   
% % 
% % %     
% % 
%      end
%    
%     
%     
% disp('WOW! Successful Execution...');
% 
% end