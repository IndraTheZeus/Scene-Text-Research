function region = findInterestRegions(image)

   %Visualize the e
   
   [row,col,~] = size(image);
   region = false(row,col);
  
   X = image(:,:,1);
   Y = image(:,:,2);
   Z = image(:,:,3);
    V1 = X(:);
    V2 = Y(:);
    V3 = Z(:);
   
    M = [V1,V2,V3];
    M = double(M);
   
    [idx] = kmeans(M,2);
   
    
    get = 1;
    for y = 1:col
       for x = 1:row
          region(x,y) =  idx(get,1)-1;
          get = get+1;
       end
    end
    
   % textClass = 1 - mode([region(1,1) region(1,ceil(col/2)) region(1,col) region(ceil(row/2),1) region(ceil(row/2),col) region(row,1) region(row,ceil(col/2)) region(row,ceil(col/2)) region(row,col) ]);
   
   textClass = 1 - mode([region(row,:) region(1,:) region(2:row-1,1)' region(2:row-1,col)']);
   
      if textClass == 0
         region = ~region; 
      end
      region = ReduceToMainCCs(region);
      imshow(region)
    %  imshow(binImage);
 % scatter3(V1,V2,V3,'*');
end