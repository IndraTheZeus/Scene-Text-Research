function StableLayers = findStableLayers(q,red_matrix,green_matrix,blue_matrix)


 StableLayers = zeros(3,2);
 
insert = 0;
 
 for i = 1:3
    if i == 1
        matrix = red_matrix;
    end

    if i == 2
        matrix = green_matrix;
    end
    
    if i == 3
        matrix = blue_matrix;
    end
    
     for data = 1:numel(matrix)
         
        matrix(data) = floor(matrix(data)/ q) + 1;
         
     end
     
     len = numel(matrix);
     flag = 0;
     
     
     while numel(matrix)~= 0
        
         if sum(matrix == matrix(1)) >0.975*len
            insert = insert +1;  
             StableLayers(insert,:) = [i matrix(1)];
             flag = 1;
            break; 
         end
         matrix = matrix(matrix~=matrix(1));
     end
     
     
     if flag == 1
         continue;
     end
     
    if i == 1
        matrix = red_matrix;
    end

    if i == 2
        matrix = green_matrix;
    end
    
    if i == 3
        matrix = blue_matrix;
    end
     
   k = ceil((q/2)) -1;
   main_offset = ceil(256/q);
   
      for data = 1:numel(matrix)
        if matrix(data)>k && matrix(data) < 255-k
           matrix(data) = ceil((matrix(data)-k)/q);
        else
           matrix(data) = 0;
        end
      end
     
      while numel(matrix)~= 0
        
         if sum(matrix == matrix(1)) >0.975*len && (matrix(1)~=0)
             insert = insert+1;
             StableLayers(insert,:) = [ i (main_offset + matrix(1)) ];
            break; 
         end
         matrix = matrix(matrix~=matrix(1));
     end
     
 end
   


end