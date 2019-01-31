function factor = uniformity_factor(matrix)
 
     disorder = 0;
     
     [row,col] = size(matrix);
     matrix = double(matrix);
       %Row wise covering
   
      for x = 1:row
          flag = 0;
          start = -1;
         for y = 1:col
             
            if matrix(x,y) == 1 && flag == 1 
               matrix(x,start:y-1) = 2;
               flag = 0;
               continue;
            end
            
            if matrix(x,y) == 1 && flag~=1
                start = y;
                continue;
            end
            
            if matrix(x,y) == 0 && flag~=1 && start~=-1
              flag = 1;
              start = y;
            end
         end
          
      end
      
      for y = 1:col
          flag = 0;
          start = -1;
         for x = 1:row
             
            if matrix(x,y) == 1 && flag == 1 
               matrix(start:x-1,y) = 2;
               flag = 0;
               continue;
            end
            
            if matrix(x,y) == 1 && flag~=1
                start = x;
                continue;
            end
            
            if matrix(x,y) == 0 && flag~=1 && start~=-1
              flag = 1;
              start = x;
            end
         end
          
      end
     
     
     
     break_array = zeros(1,col);
     
     for y = 1:col
        for x = 2:row
             if matrix(x,y) == 2 && matrix(x-1,y) == 1
                break_array(1,y) = break_array(1,y) + 1;
             end
        end
     end
     
     stack = zeros(30,1);
     head = 0;
     
     for i = 1:col
         
         if head == 0
             head = head + 1;
             stack(head,1) = break_array(1,i);
             continue;
         end
         if break_array(1,i) == stack(head,1)
             continue;
         end
         
         
         if break_array(1,i)>stack(head,1)
             head = head + 1;
             stack(head,1) = break_array(1,i);
             continue;
         end
         
         head = head - 1;
         
         while head>0 && stack(head,1) > break_array(1,i) 
            head = head - 1; 
            disorder = disorder+ 1; 
         end
         
         if head>0 && stack(head,1) ~= break_array(1,i)
            disorder = disorder + 1; 
            head = head + 1;
            stack(head,1) = break_array(1,i);
         end
         
      if head == 0
          head = head + 1;
          stack(head,1) = break_array(1,i);
      end
      
     end
     
     
     disorder_y = disorder;
     disorder = 0;
     
         break_array = zeros(1,row);
     
     for x = 1:row
        for y = 2:col
             if matrix(x,y) == 2 && matrix(x,y-1) == 1
                break_array(1,x) = break_array(1,x) + 1;
             end
        end
     end
     
     stack = zeros(30,1);
     head = 0;
     
     for i = 1:row
         
         if head == 0
             head = head + 1;
             stack(head,1) = break_array(1,i);
             continue;
         end
         if break_array(1,i) == stack(head,1)
             continue;
         end
         
         
         if break_array(1,i)>stack(head,1)
             head = head + 1;
             stack(head,1) = break_array(1,i);
             continue;
         end
         
         head = head - 1;
         
         while head>0 && stack(head,1) > break_array(1,i) 
            head = head - 1; 
            disorder = disorder+ 1; 
         end
         
         if head>0 && stack(head,1) ~= break_array(1,i)
            disorder = disorder + 1; 
            head = head + 1;
            stack(head,1) = break_array(1,i);
         end
         
      if head == 0
          head = head + 1;
          stack(head,1) = break_array(1,i);
      end
      
     end
     
     disorder_x = disorder;
     
     factor = max(disorder_y/col,disorder_x/row);
    
%    [row,col] = size(matrix);  
%    matrix = double(matrix);
%      for x = 1:row
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
%       for x = 1:row
%          for y = 1:col 
%           
%              if matrix(x,y) == 0
%                  continue;
%              end
%              matrix(x,y) = matrix(x,y) - 1;
%          end
%       end
%       
%       CC = bwconncomp(matrix);
%       factor = CC.NumObjects;
%       %Parameters
%        distortion_threshold = 0.4;
%       
%       breaks=0;
%   
%       x_rows = 0;
%       y_rows = 0;
%     for x= 2:row
%         errors = 0;
%         cells = 0;
%        flag = 0;
%         for y = 1:col
%  
%             if matrix(x,y) == 0 
%                 continue;
%             end
%           
%           cells = cells + 1;
%             if flag == 0
%               x_rows = x_rows+1;
%               flag = 1;
%             end
% 
%             if matrix(x,y) ~=matrix(x-1,y)
%                 errors = errors+1;
%             end
%             
%         end
%     
%         if errors>distortion_threshold*cells
%            if cells>0
%                 %[errors/cells]
%             breaks = breaks+1;%errors/cells);
%            end
%         end
%         
%     end
%     
%     breaks_x = breaks;
%     
%     %Column wise scan
%        %stage = 2
%         breaks=0;
%     for y= 2:col
%         errors = 0;
%         cells = 0;
%         flag = 0;
%         for x = 1:row
% 
%            if matrix(x,y) == 0 
%                 continue;
%            end
%          cells = cells + 1;
% %             
%            if flag == 0
%               y_rows = y_rows+1;
%               flag = 1;
%            end
% 
%             
%             if matrix(x,y) ~=matrix(x,y-1)
%                 errors = errors+1;
%             end
%             
%         end
%        
%       
%         if errors>distortion_threshold*cells
%            
%           if cells>0
%      %        [errors/cells]
%             breaks = breaks +1;%(errors/cells);
%           end
%         end
%         
%     end
%     breaks_y = breaks;
%   
%      factor = max(breaks_y/y_rows,breaks_x/x_rows);
end