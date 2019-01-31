function region = findInterestRegions(image)

   %Visualize the Image
   
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
   
    textClass = 3 - idx(1,1);
    get = 1;
    for y = 1:col
       for x = 1:row
          region(x,y) =  (idx(get,1) == textClass);
          get = get+1;
       end
    end
    
    
    %  imshow(binImage);
 % scatter3(V1,V2,V3,'*');
end