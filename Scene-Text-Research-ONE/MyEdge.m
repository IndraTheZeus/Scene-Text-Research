function image = MyEdge(matrix)

 [row,col] = size(matrix);
 image = zeros(row,col);
  for x = 1:row
     for y = 1:col
        
         if matrix(x,y) == 0
             continue;
         end
         
         if x==1 || x==row || y==1 || y==col
             image(x,y) = 1;
             continue;
         end
         
         if matrix(x-1,y-1) == 1 && matrix(x-1,y) == 1 && matrix(x-1,y+1) == 1 && matrix(x,y-1) == 1 && matrix(x,y+1) == 1 && matrix(x+1,y-1) == 1 && matrix(x+1,y) == 1 && matrix(x+1,y+1) == 1
           continue;
         end
         image(x,y) = 1;
         
%          if matrix(x-1,y-1) == 0 || matrix(x-1,y) == 0 || matrix(x-1,y+1) == 0
%              image(x,y) = 1;
%              continue;
%          end
%          
%          if matrix(x,y-1) == 0 || matrix(x,y+1) == 0
%              image(x,y) = 1;
%              continue;
%          end
%          
%          if matrix(x+1,y-1) == 0 || matrix(x+1,y) == 0 || matrix(x+1,y+1) == 0
%              image(x,y) = 1;
%              continue;
%          end
         
         %image(x,y) = 0;
     end  
  end


end