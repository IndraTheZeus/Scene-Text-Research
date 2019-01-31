function Cover =  Covers(list)

  count = 0;
  cover_threshold = 0.95;
   for i = 1:numel(list)
      if list(i) == 1
       count = count+1;
      end  
   end
 
   if (count/numel(list)) > cover_threshold
       Cover = 1;
   else
       Cover = 0;
   end

end