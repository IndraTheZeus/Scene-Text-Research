function [out_img] =  BackGroundEliminate(images)

 out_img = false(size(images));
 [row,col,~] = size(images);
   for i = 1:size(images,3)
       img = images(:,:,i);
       
       if sum(img(1,:)) == 0 && sum(img(row,:)) == 0 && sum(img(:,1)) == 0 && sum(img(:,col)) == 0
           out_img(:,:,i) = img;
       end
       
       
       
   end

end