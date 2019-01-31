function smeared = MySmear(matrix)

    
 [row,~] = size(matrix);
 
    filled = imfill(matrix, 'holes');
    holes = filled & ~matrix;
    
    bigholes = bwareaopen(holes,10);
    
    smallholes = holes & ~bigholes;
    
    matrix = matrix | smallholes;
    
    smeared = matrix;
    
   
%    smeared = logical(matrix);
%    matrix = double(matrix);
%    smear_volume_threshold = 0;
%    max_smear_threshold = 0.1;
%    min_smear_threshold = 0.05;
%   
%    %size_threshold = 10;
%    
%   % CC_original = bwconncomp(matrix);
% 
% [row,col] = size(matrix);
% 
% % Connecting inter-stroke Gap
% 
%    %Row wise covering
%    
%       for x = 1:row
%           flag = 0;
%           start = -1;
%          for y = 1:col
%              
%             if matrix(x,y) == 1 && flag == 1 
%                matrix(x,start:y-1) = 2;
%                flag = 0;
%                continue;
%             end
%             
%             if matrix(x,y) == 1 && flag~=1
%                 start = y;
%                 continue;
%             end
%             
%             if matrix(x,y) == 0 && flag~=1 && start~=-1
%               flag = 1;
%               start = y;
%             end
%          end
%           
%       end
%       
%       for y = 1:col
%           flag = 0;
%           start = -1;
%          for x = 1:row
%              
%             if matrix(x,y) == 1 && flag == 1 
%                matrix(start:x-1,y) = 2;
%                flag = 0;
%                continue;
%             end
%             
%             if matrix(x,y) == 1 && flag~=1
%                 start = x;
%                 continue;
%             end
%             
%             if matrix(x,y) == 0 && flag~=1 && start~=-1
%               flag = 1;
%               start = x;
%             end
%          end
%           
%       end
%       
%       cells = 0;
%       for x = 1:row
%          for y = 1:col 
%           
%              if matrix(x,y) == 0           
%                  continue;
%              end
%              cells = cells+1;
%              matrix(x,y) = matrix(x,y) - 1;
%          end
%       end
%       
%       CC_cover = bwconncomp(matrix);
%       img_stats = regionprops(CC_cover);
%       
%      for comp = 1:CC_cover.NumObjects
%          stats = img_stats(comp);
%        %  density = (numel(CC_cover.PixelIdxList{comp}))/(stats.BoundingBox(3)*stats.BoundingBox(4));    
%         if numel(CC_cover.PixelIdxList{comp}) > smear_volume_threshold*row*row && (max(stats.BoundingBox(4),stats.BoundingBox(3)) > max_smear_threshold*row && min(stats.BoundingBox(3),stats.BoundingBox(4))>min_smear_threshold*row)  %|| (stats.BoundingBox(3) > 10 && stats.BoundingBox(4)>10)
%            matrix(CC_cover.PixelIdxList{comp}) = 0; 
%         end
%          
%      end
%      
%      smeared = smeared +logical(matrix);
   
end