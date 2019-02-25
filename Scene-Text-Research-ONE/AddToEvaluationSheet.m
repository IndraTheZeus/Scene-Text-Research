function evalX = AddToEvaluationSheet(GeneratedImgs,CorrectImage)

    append_mode = true;
    if size(GeneratedImgs,1) ~= size(CorrectImage,1) ||  size(GeneratedImgs,2) ~= size(CorrectImage,2)
        
       error("Generated Images and Correct Image dimension mismatch"); 
    end
    
    
    
    BWImages = zeros(size(GeneratedImgs));
    
      [row,col] = size(CorrectImage);
           textClass = 1 - mode([CorrectImage(row,:) CorrectImage(1,:) CorrectImage(2:row-1,1)' CorrectImage(2:row-1,col)']);
   
       if textClass == 0
          CorrectImage = ~CorrectImage; 
       end
      CorrectImage = ReduceToMainCCs(CorrectImage);
    
    for bw = 1:size(GeneratedImgs,3)
        
        BWImages(:,:,bw) = bwlabel(GeneratedImgs(:,:,bw));
        CCStructs(bw) = bwconncomp(GeneratedImgs(:,:,bw));
    end

     CC_correct = bwconncomp(CorrectImage);
     evalX = zeros(CC_correct.NumObjects,7);
      for comp = 1:CC_correct.NumObjects
          min_deviation_set = false;
          max_IOU_set = false;
         
          region = CC_correct.PixelIdxList{comp};
          
          for scan_img = 1:size(GeneratedImgs,3)
              
             bwImage = BWImages(:,:,scan_img);
             ccStruct = CCStructs(scan_img);
             overlap_label_nos = findLabels(bwImage(region),10);
             
             for overlaps = 1:numel(overlap_label_nos)
                 if overlap_label_nos(1,overlaps) == 0
                     break
                 end
                 
                 
                 if ~min_deviation_set
                    min_deviation_region = ccStruct.PixelIdxList{overlap_label_nos(1,overlaps)};
                 
                   min_deviation_set = true;
                 else
                  
                     if abs(numel(min_deviation_region) - numel(region)) > abs(numel(ccStruct.PixelIdxList{overlap_label_nos(1,overlaps)}) - numel(region))%IOU > IOU_max
                            min_deviation_region = ccStruct.PixelIdxList{overlap_label_nos(1,overlaps)};
                     end
                 end
                
                if ~max_IOU_set
                    max_IOU_region = ccStruct.PixelIdxList{overlap_label_nos(1,overlaps)};
                    IOU_max = numel(intersect(region,ccStruct.PixelIdxList{overlap_label_nos(1,overlaps)}))/numel(union(region,ccStruct.PixelIdxList{overlap_label_nos(1,overlaps)}));
            
                    max_IOU_set = true;
                 else
                     IOU = numel(intersect(region,ccStruct.PixelIdxList{overlap_label_nos(1,overlaps)}))/numel(union(region,ccStruct.PixelIdxList{overlap_label_nos(1,overlaps)}));
                     if IOU > IOU_max
                            max_IOU_region = ccStruct.PixelIdxList{overlap_label_nos(1,overlaps)};
                            IOU_max = IOU; 
                     end
                end
                 
             end
              
          end
          
          if ~min_deviation_set
             evalX(comp,:) = [numel(region) 0 numel(region) 0 0 numel(region) 0];
          else
             evalX(comp,:) = [numel(region) numel(min_deviation_region) numel(union(region,min_deviation_region)) numel(intersect(region,min_deviation_region)) numel(max_IOU_region) numel(union(region,max_IOU_region)) numel(intersect(region,max_IOU_region)) ];
          end
          
          
          
      end
      
     % AccuracyFromTable(evalX);
      
%       if append_mode && isfile(ExcelFilenameWithPath)
%         Prev = xlsread(ExcelFilenameWithPath);
%          xlswrite(ExcelFilenameWithPath,[Prev;evalX]);
%       else
%          xlswrite(ExcelFilenameWithPath,evalX); 
%       end
      
     
end