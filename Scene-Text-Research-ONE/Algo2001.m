image = imread('icon.png');
[row,col,layer] = size(image);
unf_binary = zeros(row,col,27);
f_binary = zeros(row,col,27);

for r = 1:row
     for c = 1:col
         %  decimalToBinaryVector(image(r,c,1));
         
   
         
             
         
         value = image(r,c,1);                                         
         if value>=192
             msb2_r =[1 1];
         else
             if value>=64
                 msb2_r=[1 0];
             else
                 msb2_r=[0 0];
             end
         end
         
         
         

          %bits = size(msb2_r);
%         if bits(2)==8
%             msb2_r = msb2_r(1,1:2);
%         else
%             if bits(2)==7
%                 msb2_r = [0 msb2_r(1,1)];
%             else
%                 msb2_r =[0 0];
%             end
%         end
        
        
        
        value = image(r,c,2);                                         
         if value>=192
             msb2_g =[1 1];
         else
             if value>=64
                 msb2_g=[1 0];
             else
                 msb2_g=[0 0];
             end
         end
        
      value = image(r,c,3);                                         
         if value>=192
             msb2_b =[1 1];
         else
             if value>=64
                 msb2_b=[1 0];
             else
                 msb2_b=[0 0];
             end
         end
         
        
        
        
%         if msb2_r == [0 1]
%             msb2_r = [1 0];
%         end
%         
%           if msb2_g == [0 1]
%             msb2_g = [1 0];
%           end
%         
%           if msb2_b == [0 1]
%             msb2_b = [1 0];
%           end
           
    if msb2_r == [0 0]
        type_r=1;
    else
        if msb2_r == [1 0]
            type_r=2;
        else
            if msb2_r == [1 1]
                type_r=3;
            end
        end
    end
    
        
      if msb2_g == [0 0]
        type_g=1;
    else
        if msb2_g == [1 0]
            type_g=2;
        else
            if msb2_g == [1 1]
                type_g=3;
            end
        end
      end
      
      
      if msb2_b == [0 0]
        type_b=1;
    else
        if msb2_b == [1 0]
            type_b=2;
        else
            if msb2_b == [1 1]
                type_b=3;
            end
        end
     end
             
          type = type_r*type_g*type_b;
          
          unf_binary(r,c,type)=1;
          
         
              
          
       
     end
     r
end


          