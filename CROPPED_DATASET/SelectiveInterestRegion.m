%%%%%%   batchFormation()

function SelectiveInterestRegion(dir_in, dir_results, file_ext,excel_file_ext)
disp('WAIT! Execution begining...');

% list of files in the directory name with the input file extension
listing = dir(strcat(dir_in,'*.',file_ext));
excel_listing = dir(strcat(dir_in,'*.',excel_file_ext));
file_names = {listing.name};
excel_file_names = {excel_listing.name};
% number of pages in the directory with this file extension
num_pages = length(file_names);

%display(num_pages);
fprintf('Total number of pages = %d\n', num_pages);

% process all pages in the directory
for i = 1:num_pages
  %if((i>=120)&&(i<125))  
    fprintf('Processing page No: %d\n', i);    
    
    % load the image from the directory
    img = imread(strcat(dir_in,file_names{i}));
    excel_file_names{i}
  
    if numel(excel_file_names)~= 0 
        filename = strcat(dir_in,"/",excel_file_names{i});
       X = xlsread(filename);
       out_img = false(size(img,1),size(img,2));
      % imshow(img)
       for r = 1:size(X,1)
          BB = ceil(X(r,1:4)); 
          scan_img = img(max(1,BB(2)-5):min(BB(2)+BB(4)+5,size(img,1)),max(1,BB(1)-5):min(BB(1)+BB(3)+5,size(img,2)),:);
          out   = wolf(rgb2gray(scan_img),size(scan_image),0.3);
           [row,col] = size(out);
           textClass = 1 - mode([out(row,:) out(1,:) out(2:row-1,1)' out(2:row-1,col)']);
   
      if textClass == 0
         out = ~out; 
      end
      out = ReduceToMainCCs(out);
      
      out_img(max(1,BB(2)-5):min(BB(2)+BB(4)+5,size(img,1)),max(1,BB(1)-5):min(BB(1)+BB(3)+5,size(img,2))) = out;
       end
    end
    
 
   


       F_img = out_img;
    name = strrep(file_names{i},strcat('.',file_ext),'');
    name3=strcat('TextRegions_',name);

    
    saveFile3=strcat(dir_results,name3,'.jpg');
 
    imwrite(F_img,saveFile3,'jpg');     


end
disp('WOW! Successful Execution...');