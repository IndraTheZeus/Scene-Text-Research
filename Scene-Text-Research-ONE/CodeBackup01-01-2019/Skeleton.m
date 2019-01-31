function skeleton = Skeleton(matrix)

 [row,col] = size(matrix);
skeleton = matrix;
 for x = 1:row
  for y = 1:col
       if matrix(x,y) == 0
           continue;
       end
         
   try
       if matrix(x-1,y) == 1 && matrix(x-1,y+1) == 1 && matrix(x-1,y-1) == 1 && matrix(x,y-1) == 1 && matrix(x,y+1) == 1 && matrix(x+1,y-1) == 1 && matrix(x+1,y) == 1 && matrix(x+1,y+1) == 1
           skeleton(x,y) = 0;
       end
   catch
       continue;
  end
  end

 CC = bwconncomp(skeleton);
 
 
 max = 0;
 sel = 0;
 for comp = 1:CC.NumObjects
    
     if numel(CC.PixelIdxList{comp}) > max
         max = numel(CC.PixelIdxList{comp});
         sel = comp;
     end
     
 end
 
  for comp = 1:CC.NumObjects
    if comp == sel
        continue;
    end
    
    skeleton(CC.PixelIdxList{comp}) = 0;
     
 end
 

end