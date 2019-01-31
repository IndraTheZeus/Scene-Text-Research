function ratio = fitting_ratio(matrix,puzzle)

  pixels =0;
  cells = 0;
  
  [row,col] = size(matrix);
  
   for x = 1:row
      for y = 1:col
         if matrix(x,y) == 0
             continue;
         end
         
     %    cells = cells+3;
          cells = cells + 1;
          
         if puzzle(x,y) > 0  
             pixels = pixels+1;
             continue;
         end
         
     
%         if (x-1>0 && puzzle(x-1,y) == 3) || (x+1<row && puzzle(x+1,y) == 3  )
%              
%              pixels = pixels+2;
%              continue;
%          else 
%          if (y-1>0 && puzzle(x,y-1) == 3)  || (y+1<col && puzzle(x,y+1) == 3 )
%              
%              pixels = pixels+2;
%              continue;
%          end
%         end
        
         if (x-1>0 && puzzle(x-1,y) >0) || (x+1<row && puzzle(x+1,y) >0 )
             
             pixels = pixels+1;
             continue;
         else 
         if (y-1>0 && puzzle(x,y-1) >0)  || (y+1<col && puzzle(x,y+1) >0)
             
             pixels = pixels+1;
             continue;
         end
         
         end
  
  
        if (x-2>0 && puzzle(x-2,y) >0) || (x+2<row && puzzle(x+2,y) >0 )
             
             pixels = pixels+1;
             continue;
         else 
         if (y-2>0 && puzzle(x,y-2) >0)  || (y+2<col && puzzle(x,y+2) >0)
             
             pixels = pixels+1;
             continue;
         end
         
         end
          
        
          
      end
   end
 ratio = pixels/cells;
end