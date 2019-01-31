function truth = CheckColorStability(l,u,matrix,bf_factor,nf_factor,bf_tolerance,w,h,n)
 
  truth = 0;
   [row,col] = size(matrix);
   map_matrix = false(row,col);
   
   for x = 1:row
      for y = 1:col 
       
          if matrix(x,y)>=l && matrix(x,y)<=u
              
             map_matrix(x,y) = 1; 
              
          end
          
      end
   end

   CC = bwconncomp(map_matrix);
   max = 0;
   comp = 0;
   
   for c = 1:CC.NumObjects
      if numel(CC.PixelIdxList{c})>max
       max = numel(CC.PixelIdxList{c});
       comp = c;
      end
   end

   img_stats = regionprops(CC);
   
   stats = img_stats(comp);
   
   if (stats.BoundingBox(3)/w)>=(1/bf_factor) && (stats.BoundingBox(3)/w) <=bf_factor && (stats.BoundingBox(4)/h)>=(1/bf_factor) && (stats.BoundingBox(4)/h) <=bf_factor
      if abs(stats.BoundingBox(3)-w)<=bf_tolerance && abs(stats.BoundingBox(4)-h)<=bf_tolerance && (numel(CC.PixelIdxList{comp})/n) >=(1/nf_factor) && (numel(CC.PixelIdxList{comp})/n)<=nf_factor
          truth = 1;
      end
       
   end

end