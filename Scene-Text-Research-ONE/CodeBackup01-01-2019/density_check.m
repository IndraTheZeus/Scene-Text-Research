function density = density_check(matrix)



[row,col] = size(matrix);
matrix = double(matrix);
% Connecting inter-stroke Gap

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


 cells = 0;
 pixels = 0;
 for x = 1:row
    for y = 1:col
       if matrix(x,y) == 0
           continue;
       end
       
       cells = cells+1;
       
       if matrix(x,y) == 1
           pixels = pixels+1;
       else
           matrix(x,y) = 0;
       end
       
        
    end
 end
 
 density = pixels/cells;
%  if simple_density>0.75
%      value = 7;
%  else
%      value = 1;
%  end

%  density = value;

 
 
 
 
 
 
     %Left Diagonal wise covering
%      for init_x = row:-1:1
%          
%         x = init_x;
%         y = 1;
%         flag = 0;
%         start = -1;
%         while x<=row && y<=col
%            
%             if matrix(x,y) == 1 && flag == 1 
%                a = start;
%                b = (start-init_x)+1;
%                while a<x
%                    
%                   matrix(a,b) = 2;
%                   a = a+1;
%                   b = b+1;
%                end
%                flag = 0;
%                x =x+1;
%                y = y+1;
%                continue;
%             end
%             
%             if matrix(x,y) == 1 && flag~=1
%                 start = x;
%                  x =x+1;
%                y = y+1;
%                 continue;
%             end
%             
%             if matrix(x,y) == 0 && flag~=1 && start~=-1
%               flag = 1;
%               start = x;
%               
%             end
%             x = x+1;
%             y = y+1;
%             
%         end
%      end
%      
%      for init_y = 2:col
%          
%         y = init_y;
%         x = 1;
%         flag = 0;
%         start = -1;
%         while x<=row && y<=col
%            
%             if matrix(x,y) == 1 && flag == 1 
%                a = (start-init_y)+1;
%                b = start;
%                while b<y
%                    
%                   matrix(a,b) = 2;
%                   a = a+1;
%                   b = b+1;
%                end
%                flag = 0;
%                x =x+1;
%                y = y+1;
%                continue;
%             end
%             
%             if matrix(x,y) == 1 && flag~=1
%                 start = y;
%                  x =x+1;
%                y = y+1;
%                 continue;
%             end
%             
%             if matrix(x,y) == 0 && flag~=1 && start~=-1
%               flag = 1;
%               start = y;
%         
%             end
%                    x =x+1;
%                y = y+1;
%         end
%      end
%      
%      
%      %Right Diagonal wise covering
%      
%       for init_x = row:-1:1
%          
%         x = init_x;
%         y = 1;
%         flag = 0;
%         start = -1;
%         while x<=row && y<=col
%            
%             if matrix(x,col+1-y) == 1 && flag == 1 
%                a = start;
%                b = (start-init_x)+1;
%                while a<x
%                    
%                   matrix(a,col+1-b) = 2;
%                   a = a+1;
%                   b = b+1;
%                end
%                flag = 0;
%                x =x+1;
%                y = y+1;
%                continue;
%             end
%             
%             if matrix(x,col+1-y) == 1 && flag~=1
%                 start = x;
%                  x =x+1;
%                y = y+1;
%                 continue;
%             end
%             
%             if matrix(x,col+1-y) == 0 && flag~=1 && start~=-1
%               flag = 1;
%               start = x;
%               
%             end
%             x = x+1;
%             y = y+1;
%             
%         end
%      end
%      
%      for init_y = 2:col
%          
%         y = init_y;
%         x = 1;
%         flag = 0;
%         start = -1;
%         while x<=row && y<=col
%            
%             if matrix(x,col+1-y) == 1 && flag == 1 
%                a = (start-init_y)+1;
%                b = start;
%                while b<y
%                    
%                   matrix(a,col+1-b) = 2;
%                   a = a+1;
%                   b = b+1;
%                end
%                flag = 0;
%                x =x+1;
%                y = y+1;
%                continue;
%             end
%             
%             if matrix(x,col+1-y) == 1 && flag~=1
%                 start = y;
%                  x =x+1;
%                y = y+1;
%                 continue;
%             end
%             
%             if matrix(x,col+1-y) == 0 && flag~=1 && start~=-1
%               flag = 1;
%               start = y;
%         
%             end
%                x =x+1;
%                y = y+1;
%         end
%      end
   %End 
% End of Connecting inter-stroke gap

%  density = pixels/(row*col);
  
%   total_cells = row*col;
%   
%   for x=row:-1:1
%      
%       y = 1;
%       min_y = min(col,row+1-x);
%       for cells = 1:min_y
%           
%          if matrix(x+cells-1,y) == 1
%             break;
%          end
%          
%          
%          if y == min_y
%              y_new=1;
%              for cell = 1:min_y
%                 matrix(x+cell-1,y_new) = -1;
%                 y_new = y_new+1;
%              end
%              
%          end 
%          
%          y = y+1;
%       end
%       
%    end
%          
%   
% % 
%   for y=col:-1:2
%      
%       x = 1;
%       min_x = min(row,col+1-y);
%       for cells = 1:min_x
%           
%          if matrix(x,y+cells-1) == 1
%             break;
%          end
%          
%          
%          if x == min_x
%              x_new=1;
%              for cell = 1:min_x
%                 matrix(x_new,y+cell-1) = -1;
%                 x_new = x_new+1;
%              end
%              
%          end
%          
%          x = x+1;
%       end
%       
%   end
%   
%   %Right Diagonal
%    
%   for x=row:-1:1
%      
%       y = 1;
%       min_y = min(col,row+1-x);
%       for cells = 1:min_y
%           
%          if matrix(x+cells-1,col-y+1) == 1
%             break;
%          end
%          
%          
%          if y == min_y
%              y_new=1;
%              for cell = 1:min_y
%                 matrix(x+cell-1,col-y_new+1) = -1;
%                 y_new = y_new+1;
%              end
%              
%          end 
%          
%          y = y+1;
%       end
%       
%   end
%    
%    for y=col:-1:2
%      
%       x = 1;
%       min_x = min(row,col+1-y);
%       for cells = 1:min_x
%           
%          if matrix(x,col-y-cells+2) == 1
%             break;
%          end
%          
%          
%          if x == min_x
%              x_new=1;
%              for cell = 1:min_x
%                 matrix(x_new,col-y-cell+2) = -1;
%                 x_new = x_new+1;
%              end
%              
%          end
%          
%          x = x+1;
%       end
%       
%    end
%    pixels = 0;
%    cells = 0;
%  
%   % Simple Density Check
%     
%      for x = 1:row
%         
%          for y = 1:col
%              
%             if matrix(x,y) == -1
%                 continue;
%             end
%             
%             cells = cells+1;
%             
%             if matrix(x,y) == 1
%                 pixels = pixels+1;
%             end
%          end
%          
%      end
%   
%   simple_density = pixels/cells;
%   %End of Simple Density Check
%   
%   %strict density Checker
%   
%   for x = 1:row
%      
%       for y = 1:col
%           if matrix(x,y) == 1
%               break;
%           end
%          if matrix(x,y) == -1
%              continue;
%          end
%          cells = cells-1;
%          matrix(x,y) = -1;
%       end 
%       
%        for y = col:-1:1
%           if matrix(x,y) == 1
%               break;
%           end
%          if matrix(x,y) == -1
%              continue;
%          end
%          cells = cells-1;
%          matrix(x,y) = -1;
%       end
%   end
%   
%   for y = 1:col
%      
%       for x = 1:row
%           if matrix(x,y) == 1
%               break;
%           end
%          if matrix(x,y) == -1
%              continue;
%          end
%          cells = cells-1;
%          matrix(x,y) = -1;
%       end 
%       
%        for x = row:-1:1
%           if matrix(x,y) == 1
%               break;
%           end
%          if matrix(x,y) == -1
%              continue;
%          end
%          cells = cells-1;
%          matrix(x,y) = -1;
%       end
%   end
%   
%   
%   strict_density = pixels/cells;
%   %End of strict density checker
%   
%     %Uniformity Checker
%     %Row wise scan
%     breaks=0;
%     for x= 2:row
%         errors = 0;
%         for y = 1:col
%             
%             if matrix(x,y) ~=matrix(x-1,y)
%                 errors = errors+1;
%             end
%             
%         end
%         
%         if errors>0.2*col
%             
%             breaks = breaks+1;
%         end
%         
%     end
%     
%     breaks_x = breaks;
%     
%     %Column wise scan
%       
%         breaks=0;
%     for y= 2:col
%         errors = 0;
%         for x = 1:row
%             
%             if matrix(x,y) ~=matrix(x,y-1)
%                 errors = errors+1;
%             end
%             
%         end
%         
%         if errors>0.2*row
%             
%             breaks = breaks+1;
%         end
%         
%     end
%     breaks_y = breaks;
%     %End of Uniformity Checker
%     
%     if simple_density>0.8
%         value = 5;
%     else
%       if min(breaks_x,breaks_y) == 0 || min(breaks_x,breaks_y)>11
%           value = 6;
%           
%       else
%           if min(breaks_x,breaks_y) <4
%              value = 2;
%           else
%               if strict_density>0.95
%                   value = 7;
%               else
%                   if simple_density<0.25
%                       value = 1;
%                   else
%                       if strict_density<0.75
%                           value = 3;
%                       else
%                           value = 4;
%                       end
%                   end
%               end
%           end
%       end
%       
%       
%     end
%         
%         
%    density = value;     
   %density = [value simple_density strict_density breaks_x breaks_y];   
  
  %Gap Density
   
     %Row wise Mass
%      mass = 0;
%       for x = 1:row
%           flag = 0;
%           row_sum = 0;
%           multiplier = 0;
%           product =0;
%          for y = 1:col
%               if matrix(x,y)== -1
%                   continue;
%               end
%               
%               if matrix(x,y) == 1
%                  if flag == 0
%                   flag = 1;
%                  else
%                     if product>0
%                      row_sum = row_sum+product;
%                      product = 0;
%                      multiplier=0;
%                      flag=0;
%                     end
%                  end
%               else
%                if flag==1 
%                 if product == 0
%                     product = 1;
%                 end
%                   multiplier = multiplier+1;
%                   product = product*multiplier;
%               end
%               end
%               
%          end
%          
%          mass = mass+row_sum;
%          
%       end
%       
%       %Row_wise Volume
%       volume=0;
%       for x = 1:row
%            row_sum = 0;
%            multiplier = 0;
%            flag = 0;
%           for y = 1:col
%              
%               if matrix(x,y) == -1 && flag == 1
%                   break;
%               end
%               
%               if matrix(x,y) == -1 && flag ~=1
%                   
%                  continue; 
%               end
%                   flag = 1;
%                   
%                   if row_sum==0
%                       row_sum=row_sum+1;
%                   end
%                   
%                   multiplier = multiplier+1;
%                   row_sum = row_sum*multiplier;
%           end
%           volume = volume + row_sum;
%       end
%      row_density = 1-(mass/volume);
%      %End 
%      
%      
%       %Column wise Mass
%      mass = 0;
%       for y = 1:col
%           flag = 0;
%           row_sum = 0;
%           multiplier = 0;
%           product =0;
%          for x = 1:row
%               if matrix(x,y)== -1
%                   continue;
%               end
%               
%               if matrix(x,y) == 1
%                  if flag == 0
%                   flag = 1;
%                  else
%                     if product>0
%                      row_sum = row_sum+product;
%                      product = 0;
%                      multiplier=0;
%                      flag=0;
%                     end
%                  end
%               else
%             if flag==1 
%                 if multiplier == 0
%                     product = product+1;
%                 end
%              multiplier = multiplier+1;
%              product = product*multiplier;
%             end
%               end
%          end
%          
%          mass = mass+row_sum;
%          
%       end
%       
%       %Column_wise Volume
%       volume=0;
%       for y = 1:col
%            row_sum = 0;
%            multiplier = 0;
%            flag = 0;
%           for x = 1:row
%              
%               if matrix(x,y) == -1 && flag == 1
%                   break;
%               end
%               
%               if matrix(x,y) == -1 && flag ~=1
%                   
%                  continue; 
%               end
%                   flag = 1;
%                   
%                   if row_sum==0
%                       row_sum=row_sum+1;
%                   end
%                   
%                   multiplier = multiplier+1;
%                   row_sum = row_sum*multiplier;
%           end
%           volume = volume + row_sum;
%       end
%      column_density = 1-(mass/volume);
%      
%      %End
%      
%      gap_density = [row_density column_density];
%   
%   %End of Gap Density
%   
%   if simple_density<0.25
%       value = 1;
%   else
%       if min(gap_density(1),gap_density(2))<0.8
%           value = 2;
%       else
%           value = 3;
%       end
%   end
%   
%   density =[value simple_density row_density column_density];
  %density = value;
  %density = matrix;
  
%   
%   left_density = pixels/total_cells;
%   
%   
%   for x = row:-1:1
%      
%       y = col;
%       
%       for cells = 1:(row+1-x)
%           
%           
%       end
%   end

%volume = row*factorial(col);
% volume = row*col;
% %hollow = 2*factorial(col) + 2*factorial(row)+(2*(col-2)+2*(row-2));
% 
% %upper_ratio = pure_solid/hollow;
% mass = 0;
% 
% for x = 1:row
%    %multiplier = 1;
%    row_sum = 0;
%    %partial_sum = 0;
%     for y = 1:col
%        
% %         if matrix(x,y) == 1 && partial_sum == 0
% %             
% %            partial_sum = 1;
% %            continue;
% %         end
%         if matrix(x,y) == 1
%           %  multiplier = multiplier+1;            
%           %  partial_sum = partial_sum*multiplier;
%           row_sum = row_sum+1;  
%  
%         end
% %        if matrix(x,y) == 0
% %          row_sum = row_sum+partial_sum;
% %          partial_sum = 0;
% %          multiplier = 1;
% %          
% %        end
%     end
%     row_density = row_sum/col; %+ partial_sum;
%     mass = mass + row_density;
%     
% end
% 
% row_density = mass/row;
% mass = 0;
% %volume = col*factorial(row);
% 
% 
% for y = 1:col
%    %multiplier = 1;
%    row_sum = 0;
%    %partial_sum = 0;
%     for x = 1:row
% %        
% %         if matrix(x,y) == 1 && partial_sum == 0
% %             
% %            partial_sum = 1;
% %            continue;
% %         end
%         if matrix(x,y) == 1
%            % multiplier = multiplier+1;            
%             row_sum = row_sum+1;
%  
%         end
% %        if matrix(x,y) == 0
% %          row_sum = row_sum+partial_sum;
% %          partial_sum = 0;
% %          multiplier = 1;
% %        end
%     end
%     row_density = row_sum/row;
%     mass = mass+row_density;
% end
% 
% col_density = mass/col;
% 
%   density = min(row_density,col_density);
%   %density = density*10^6;
end