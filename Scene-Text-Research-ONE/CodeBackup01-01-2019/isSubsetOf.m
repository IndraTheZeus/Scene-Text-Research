
function result = isSubsetOf(matrixA,matrixB)
 
  flag = 0;
% total = numel(matrixA);
 % count = total;
   for i = 1:numel(matrixA)
       
     
      if matrixA(i) == 1 && matrixB(i)~=1
           flag =1;
          result = 0; 
 %          count = count-1;
         break; 
        
      end
      
       
   end
   
%   ratio = count/total;
%    
%    if ratio>0.95
%        result=1;
%    else
%        result = 0;
%    end
  
  
   
   if flag==0
    result = 1;
   end

end