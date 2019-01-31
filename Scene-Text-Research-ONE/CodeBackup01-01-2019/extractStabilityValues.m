function [X,y] = extractStabilityValues(img,region,curr_obj_region,BinImages,NUM_BIN_IMAGES,BinSizes,MAX_DISTANCE)

%%Params for Feature Extraction
    deviation_thres = 0; % The Deviation from the Min deviation to be positively labelled as well
    max_upward_dev = 5; % The Upper Limit of increase in pixels on adding bins
    
    
    %%OLD CODE BACKUP
    
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
    % 10. Height
    % 11. Width
    
    
           % BinImages = Uniquize_2Level(BinImages,BinSizes,BinSizes,MAX_DISTANCE);
  
  y = false(1,1);
  X = zeros(1,16);
  training_entry = 0; 
 
   
  
  NumImages = NUM_BIN_IMAGES;
 
[row,col,~] = size(BinImages);

show_img = false(row,col);
    %Creating labelled images beforehand to speed up process
    BWImages = zeros(size(BinImages));
    
    for bw_c = 1:NUM_BIN_IMAGES  
        BWImages(:,:,bw_c) = bwlabel(BinImages(:,:,bw_c));
    end
    
    
%% We First find a Bin Image Component closest to the region,store the deviation in min_deviation

    
    min_deviation_set = 0;
    
    q_offset = 0;
     check_top_img = false(row,col);
     check_bottom_img = false(row,col);
     
     for i = 1:numel(BinSizes)   
         main_offset = ceil(MAX_DISTANCE/BinSizes(i));
         
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
        
        if img_no ~= (q_offset+main_offset)
            check_top_img = BinImages(:,:,(img_no+1));
        else
           check_top_img(:,:) = 0;
        end
        
        if img_no ~= (q_offset+1)
            check_bottom_img = BinImages(:,:,(img_no-1));
        else
           check_bottom_img(:,:) = 0;
        end
        
        upward_thres_check_img = logical(scan_img + check_top_img + check_bottom_img);   %Must change scan_img to BinImages(:,:,img_no)
        upward_label_img = bwlabel(upward_thres_check_img);
        upward_CC_img = bwconncomp(upward_thres_check_img);
        for overlap_comp_no = 1:20
            if(overlap_comps(1,overlap_comp_no) == 0)
               break; 
            end
            upward_overlap_comps = findLabels(upward_label_img(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}),2);  %% Reduce to 1 for speed
            
            if upward_overlap_comps(1,2) ~=0
               fprintf("Wrong Assumption in upward threshold check"); 
            end
            
         %   CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)};
        %  upward_CC_img.PixelIdxList{upward_overlap_comps(1,1)};
          
       %   if (abs(numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) - numel(upward_CC_img.PixelIdxList{upward_overlap_comps(1,1)}))/numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)})) >= max_upward_dev
       %     continue;
       %   end
              
         if min_deviation_set == 0
                 min_deviation = abs(numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) - numel(curr_obj_region));
                 min_deviation_set = 1;
         else
             deviation = abs(numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) - numel(curr_obj_region));
                if deviation < min_deviation 
                    min_deviation = deviation;
%                     
%                     %DEBUG
%                     
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
                end
         end
        end
        
   end  %End of  img_no for 1st Level
   
   
   %For 2nd Level Bins
   for img_no = (q_offset+main_offset+1):(q_offset+2*main_offset-1) 
      
          scan_img = logical(BinImages(:,:,img_no)+BinImages(:,:,(img_no-main_offset+1)));
      
        %  scan_img = logical(BinImages(:,:,img_no));
      
        label_scan_img = bwlabel(scan_img);
        CC_scan_img = bwconncomp(scan_img);
       
        %Take upto 20 component that overlap with the correct region
        overlap_comps = findLabels(label_scan_img(curr_obj_region),20);
        if overlap_comps(1,1) == 0
            continue;
        end
        
        if img_no ~= (q_offset+2*main_offset-1)
            check_top_img = BinImages(:,:,(img_no+1));
        else
           check_top_img = BinImages(:,:,(img_no-main_offset+1));
        end
        
        if img_no ~= (q_offset+main_offset+1)
            check_bottom_img = BinImages(:,:,(img_no-1));
        else
           check_bottom_img = BinImages(:,:,(img_no-main_offset));
        end
        
        upward_thres_check_img = logical(scan_img + check_top_img + check_bottom_img);   %scan_img must be changed to BinImages(:,:,img_no)
        upward_label_img = bwlabel(upward_thres_check_img);
        upward_CC_img = bwconncomp(upward_thres_check_img);
        for overlap_comp_no = 1:20
            if(overlap_comps(1,overlap_comp_no) == 0)
               break; 
            end
            upward_overlap_comps = findLabels(upward_label_img(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}),2);  %% Reduce to 1 for speed
            
            if upward_overlap_comps(1,2) ~=0
               fprintf("\nWrong Assumption in upward threshold check"); 
            end
            
            if upward_overlap_comps(1,1) == 0
                    fprintf("\nUpward Overlap comps is wrong!!!");
            end
            
     %     if (abs(numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) - numel(upward_CC_img.PixelIdxList{upward_overlap_comps(1,1)}))/numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)})) >= max_upward_dev
     %       continue;
      %    end
              
         if min_deviation_set == 0
                 min_deviation = abs(numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) - numel(curr_obj_region));
                 min_deviation_set = 1;
         else
                deviation = abs(numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) - numel(curr_obj_region));
                if deviation < min_deviation 
                    min_deviation = deviation;
%                     
%                     %DEBUG
%                     
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
                    
                end
         end
        end
        
   end  %End of  img_no for 2nd Level
   
   q_offset = q_offset+2*main_offset-1;
   
     end  % End of i = BinSizes
        
        
     

%% Next we extract the Values for each Bin. Correct Components those with pixels within minVarianceInComponent 

check_top_img = false(row,col);
check_bottom_img = false(row,col);

q_offset = 0;  
  for i = 1:numel(BinSizes)
   main_offset = ceil(MAX_DISTANCE/BinSizes(i));
  
   
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
        
        %For every Component extract features,if component has min
        %deviation from main region componenet,it is labelled 1 ,otherwise
        %0
        
       if img_no~=(q_offset+main_offset)
           check_top_img = BinImages(:,:,(img_no+main_offset));
     
       else
           check_top_img(:,:) = 0;
      
       end
       
       if img_no~=(q_offset+1)
           check_bottom_img = BinImages(:,:,(img_no+main_offset-1));
          
       else
           check_bottom_img(:,:) = 0;
         
       end
       
       %Adding Level 2 Bins(Lower)
       lower_stability_check_img = logical(check_top_img + check_bottom_img + scan_img);
       
       
       lower_check_CCImage = bwconncomp(lower_stability_check_img);  %CC for the Summed Up Images
       lower_check_LabelImage = bwlabel(lower_stability_check_img);
       
       
               %%% Adding Level 1 Bins(Higher)
      if img_no~=(q_offset+main_offset)
           check_top_img = BinImages(:,:,(img_no+1));
       else
           check_top_img(:,:) = 0;
       end
       
       if img_no~=(q_offset+1)
           check_bottom_img = BinImages(:,:,(img_no-1));
       else
           check_bottom_img(:,:) = 0;
       end
       
       higher_stability_check_img = logical(check_top_img + check_bottom_img + scan_img);
       
       higher_check_CCImage = bwconncomp(higher_stability_check_img);
       higher_check_LabelImage = bwlabel(higher_stability_check_img);
        
        
        
    for overlap_comp_no = 1:20     
            if(overlap_comps(1,overlap_comp_no) == 0)
               break; 
            end
            
            training_entry = training_entry+1;
            
            %Label the closest component to the actual object region
             deviation = abs(numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) - numel(curr_obj_region));
             if(deviation == min_deviation)
                 y(training_entry,1) = 1;
                 show_img(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) = 1;
                 figure('Name',strcat("       The Positive Example(Level 1): ",int2str(img_no)));
                 imshow(show_img);
                 show_img(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) = 0;
                 
             else
                 y(training_entry,1) = 0;
             end
              
             X(training_entry,9) = img_no;
               
       if img_no~=(q_offset+main_offset)          
           X(training_entry,10) = img_no+main_offset;
       else       
           X(training_entry,10) = img_no+main_offset-1;
       end
       
       if img_no~=(q_offset+1)         
           X(training_entry,11) = img_no+main_offset-1;
       else         
           X(training_entry,11) = img_no+main_offset;
       end

          
        %Adding the Level 2 Bins(Lower)
        
   
           label_matrix = findLabels(lower_check_LabelImage(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}),2);   %%Change to 1 for faster execution later          %Finding components in the stability checking image(Level 2) Bins added to Level 1) that overlap with the component in Level 1
               if y(training_entry,1) == 1
                 show_img(lower_check_CCImage.PixelIdxList{label_matrix(1,1)}) = 1;
                 figure('Name',strcat('    Level 2 Bins Added :: ',strcat(int2str(X(training_entry,10)),strcat(' & ',int2str(X(training_entry,11))))));
                 imshow(show_img);
                 show_img(lower_check_CCImage.PixelIdxList{label_matrix(1,1)}) = 0;
               end
           
           
           if label_matrix(1,2)~=0
               fprintf("\n!!!More than two componenets found!\n");
           end
           
          if(numel(lower_check_CCImage.PixelIdxList{label_matrix(1,1)}) < numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}))
              fprintf("\n!!!ERROR IN ASSUMPTION!\n");
              error = 1
          end
          
        X(training_entry,1) = (abs(numel(lower_check_CCImage.PixelIdxList{label_matrix(1,1)}) - numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)})))/numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)});
        stats = regionprops(CC_scan_img,'EulerNumber','Solidity');
        check_stats = regionprops(lower_check_CCImage,'EulerNumber','Solidity');
        
        X(training_entry,3) = stats(overlap_comps(1,overlap_comp_no)).EulerNumber;
        X(training_entry,4) = check_stats(label_matrix(1,1)).EulerNumber - stats(overlap_comps(1,overlap_comp_no)).EulerNumber;
        X(training_entry,6) = stats(overlap_comps(1,overlap_comp_no)).Solidity;
        X(training_entry,7) = (abs(check_stats(label_matrix(1,1)).Solidity - stats(overlap_comps(1,overlap_comp_no)).Solidity))/ stats(overlap_comps(1,overlap_comp_no)).Solidity;
        

        
        
       if img_no~=(q_offset+main_offset)
           X(training_entry,12) = img_no+1;
       else
           X(training_entry,12) = img_no-1;
       end
       
       if img_no~=(q_offset+1)
           X(training_entry,13) = img_no-1;
       else
           X(training_entry,13) = img_no+1;
       end
       
          %Adding the Level 1 Bins now(higher)
           label_matrix = findLabels(higher_check_LabelImage(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}),2);   %%Change to 1 for faster execution later
           
               if y(training_entry,1) == 1
                 show_img(higher_check_CCImage.PixelIdxList{label_matrix(1,1)}) = 1;
                 figure('Name',strcat('    Level 1 Bins :: ',strcat(int2str(X(training_entry,12)),strcat(' & ',int2str(X(training_entry,13))))));
                 imshow(show_img);
                 show_img(higher_check_CCImage.PixelIdxList{label_matrix(1,1)}) = 0;
               end
               
               
           if label_matrix(1,2)~=0
               fprintf("\n!!!More than two componenets found!\n");
           end
           
          if(numel(higher_check_CCImage.PixelIdxList{label_matrix(1,1)}) < numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}))
              fprintf("\n!!!ERROR IN ASSUMPTION!\n");
              error = 1
          end
          
        X(training_entry,2) = (abs(numel(higher_check_CCImage.PixelIdxList{label_matrix(1,1)}) - numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)})))/numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)});
        stats = regionprops(CC_scan_img,'EulerNumber','Solidity');
        check_stats = regionprops(higher_check_CCImage,'EulerNumber','Solidity');
        
        X(training_entry,5) = check_stats(label_matrix(1,1)).EulerNumber - stats(overlap_comps(1,overlap_comp_no)).EulerNumber;
        X(training_entry,8) = (abs(check_stats(label_matrix(1,1)).Solidity - stats(overlap_comps(1,overlap_comp_no)).Solidity))/ stats(overlap_comps(1,overlap_comp_no)).Solidity;
        
   end
   end
       
   
   % For 2nd Level Bins
  for img_no = (q_offset+main_offset+1):(q_offset+2*main_offset-1)
       
          scan_img = logical(BinImages(:,:,img_no)+BinImages(:,:,(img_no-main_offset+1)));
        label_scan_img = bwlabel(scan_img);
        CC_scan_img = bwconncomp(scan_img);
        
        %Take upto 20 component that overlap with the correct region
        overlap_comps = findLabels(label_scan_img(curr_obj_region),20);
        
        %Adding Level 1 Bins(lower)
           check_top_img = BinImages(:,:,(img_no-main_offset+1));
           check_bottom_img = BinImages(:,:,(img_no-main_offset));
           
        lower_stability_check_img = logical(check_top_img + check_bottom_img + scan_img);
        lower_check_CCImage = bwconncomp(lower_stability_check_img);
        lower_check_LabelImage = bwlabel(lower_stability_check_img);
        
               % Adding Level 2 Bins(higher)
      if img_no~=(q_offset+2*main_offset-1)
           check_top_img = BinImages(:,:,(img_no+1));
       else
           check_top_img(:,:) = 0;
       end
       
       if img_no~=(q_offset+main_offset+1)
           check_bottom_img = BinImages(:,:,(img_no-1));
       else
           check_bottom_img(:,:) = 0;
       end
       
       higher_stability_check_img = logical(check_top_img + check_bottom_img + scan_img);
            

               
       higher_check_CCImage = bwconncomp(higher_stability_check_img);
       higher_check_LabelImage = bwlabel(higher_stability_check_img);
        
    for overlap_comp_no = 1:20
          
            if(overlap_comps(1,overlap_comp_no) == 0)
               break; 
            end
             training_entry = training_entry+1;
             
             deviation = abs(numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) - numel(curr_obj_region));
             if(deviation == min_deviation)
                 y(training_entry,1) = 1;
                 show_img(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) = 1;
                 figure('Name',strcat("       The Positive Example(2nd Level): ",int2str(img_no)));
                 imshow(show_img);
                 show_img(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}) = 0;
                 
             else
                 y(training_entry,1) = 0;
             end
             
             X(training_entry,9) = img_no;
                 

             
            X(training_entry,10) = img_no-main_offset+1;
            X(training_entry,11) = img_no-main_offset;
            
         
 
          
           label_matrix = findLabels(lower_check_LabelImage(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}),2);   %%Change to 1 for faster execution later
          
               if y(training_entry,1) == 1
                 show_img(lower_check_CCImage.PixelIdxList{label_matrix(1,1)}) = 1;
                 figure('Name',strcat('    Level 1 Bins Added :: ',strcat(int2str(X(training_entry,10)),strcat(' & ',int2str(X(training_entry,11))))));
                 imshow(show_img);
                 show_img(lower_check_CCImage.PixelIdxList{label_matrix(1,1)}) = 0;
               end
           
           
           if label_matrix(1,2)~=0
               fprintf("\n!!!More than two componenets found!\n");
           end
           
          if(numel(lower_check_CCImage.PixelIdxList{label_matrix(1,1)}) < numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}))
              fprintf("\n!!!ERROR IN ASSUMPTION!\n");
              error = 1
          end
          
        X(training_entry,1) = (abs(numel(lower_check_CCImage.PixelIdxList{label_matrix(1,1)}) - numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)})))/numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)});
        stats = regionprops(CC_scan_img,'EulerNumber','Solidity');
        check_stats = regionprops(lower_check_CCImage,'EulerNumber','Solidity');
        
        X(training_entry,3) = stats(overlap_comps(1,overlap_comp_no)).EulerNumber;
        X(training_entry,4) = check_stats(label_matrix(1,1)).EulerNumber - stats(overlap_comps(1,overlap_comp_no)).EulerNumber;
        X(training_entry,6) = stats(overlap_comps(1,overlap_comp_no)).Solidity;
        X(training_entry,7) = (abs(check_stats(label_matrix(1,1)).Solidity - stats(overlap_comps(1,overlap_comp_no)).Solidity))/ stats(overlap_comps(1,overlap_comp_no)).Solidity;
        
 
          %Adding Bins of Level 2 
           label_matrix = findLabels(higher_check_LabelImage(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}),2);   %%Change to 1 for faster execution later
          
               if y(training_entry,1) == 1
                 show_img(higher_check_CCImage.PixelIdxList{label_matrix(1,1)}) = 1;
                 figure('Name',strcat('    Level 2 Bins Added :: ',strcat(int2str(X(training_entry,12)),strcat(' & ',int2str(X(training_entry,13))))));
                 imshow(show_img);
                 show_img(higher_check_CCImage.PixelIdxList{label_matrix(1,1)}) = 0;
               end 
           
           
           if label_matrix(1,2)~=0
               fprintf("\n!!!More than two componenets found!\n");
           end
           
          if(numel(higher_check_CCImage.PixelIdxList{label_matrix(1,1)}) < numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)}))
              fprintf("\n!!!ERROR IN ASSUMPTION!\n");
              error = 1
          end
          
        X(training_entry,2) = (abs(numel(higher_check_CCImage.PixelIdxList{label_matrix(1,1)}) - numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)})))/numel(CC_scan_img.PixelIdxList{overlap_comps(1,overlap_comp_no)});
     %   stats = regionprops(CC_scan_img,'EulerNumber','Solidity');
        check_stats = regionprops(higher_check_CCImage,'EulerNumber','Solidity');
        
        X(training_entry,5) = check_stats(label_matrix(1,1)).EulerNumber - stats(overlap_comps(1,overlap_comp_no)).EulerNumber;
        X(training_entry,8) = (abs(check_stats(label_matrix(1,1)).Solidity - stats(overlap_comps(1,overlap_comp_no)).Solidity))/ stats(overlap_comps(1,overlap_comp_no)).Solidity;
        
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
      
    