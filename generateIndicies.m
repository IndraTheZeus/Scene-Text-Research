function indicies = generateIndicies(no_of_terms,max_power)


indicies = zeros((max_power+1)^no_of_terms,no_of_terms);




for col = 1:no_of_terms
   gap = (max_power+1)^(col-1);
   elem_of_interest = 0;
   for r = 1:size(indicies,1) 
      indicies(r,col) = elem_of_interest;
      gap = gap - 1;
      if gap == 0
        gap = (max_power+1)^(col-1);
        elem_of_interest = elem_of_interest+1;
        if elem_of_interest>max_power
           elem_of_interest = 0; 
        end
      end
   end
end

end