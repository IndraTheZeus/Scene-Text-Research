function out = MapFeatures(X,max_power)


  [m,n] = size(X);
  out = zeros(m,(1+max_power)^n);


  indicies = generateIndicies(n,max_power);
  
  out_term = ones(m,1);
  for index_no = 1:size(indicies,1)
     for term = 1:n
       out_term = out_term.*(X(:,term).^indicies(index_no,term));
     end
     out(:,index_no) = out_term;
     out_term(:,:) = 1;
  end
   
end