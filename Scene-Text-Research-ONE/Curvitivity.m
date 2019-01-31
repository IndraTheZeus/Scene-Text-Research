function count = Curvitivity(list,thres)


curve_threshold = thres;
count = 0;

dir_array = zeros(1,8);
max = 0;

  for i = 1:numel(list)
      
     dir_array(1,(list(i)+1)) = dir_array(1,(list(i)+1))+ 1;
     
     if dir_array(1,(list(i)+1))>max
         max = dir_array(1,(list(i)+1));
     end
       
  end
  
  
  for i = 1:8
      
     if dir_array(1,i) > curve_threshold*max
        count = count+1; 
     end
      
  end
  


end