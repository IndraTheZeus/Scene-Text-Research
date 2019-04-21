function [out_img] =  BackGroundEliminate(images)

 out_img = false(size(images));
 [row,col,~] = size(images);
   for i = 1:size(images,3)
       img = images(:,:,i);
       
       Border_Sum = sum(sum(img(1,:))) + sum(sum(img(row,:))) + sum(sum(img(:,1))) + sum(sum(img(:,col)));
       
       if Border_Sum < 0.1*(row+col)
           out_img(:,:,i) = img;
       end
       
       
       
   end

end