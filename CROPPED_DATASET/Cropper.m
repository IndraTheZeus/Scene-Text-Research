%%%%%%   batchFormation()

function Cropper(dir_in, dir_results, file_ext,excel_file_ext)
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
       
       imshow(img)
       for r = 1:size(X,1)
          BB = ceil(X(r,1:4)); 
          c_img = img(max(1,BB(2)-5):min(BB(2)+BB(4)+5,size(img,1)),max(1,BB(1)-5):min(BB(1)+BB(3)+5,size(img,2)),:);
%           imshow(finalA)
           name = strcat(strrep(file_names{i},strcat('.',file_ext),''),'_',int2str(r));
          
           saveFile3=strcat(dir_results,name,'.png');

           imwrite(c_img,saveFile3,'png');
       end
    end
    %[row,col,layer] = size(img);
    % call the text line extraction code
    %[outputImg] = test5icdar2(img);
    %[img,mask,inpainted_img,normalised3] = main_function(img);
    
    
    % remove the file extension from the file name
%     for j=(1:NumImages)
%         for k=(1:NumImages)
%        F_img = matrix(:,:,k,j);
%     name = strrep(file_names{i},strcat('.',file_ext),'');
    %name1=strcat(name,'_1img');
    %name2=strcat(name,'_2mask');
%     name3=strcat(name,'_img');
%     name3 = strcat(name3, strcat(int2str(k),'_pass_',int2str(j)));
    %name4=strcat(name,'_4normalised');
    
    % create a directory with the file name with the extension    
    %saveFile1=strcat(dir_results,name1,'.bmp');
    %saveFile2=strcat(dir_results,name2,'.bmp');
%     saveFile3=strcat(dir_results,name3,'.jpg');
    %saveFile4=strcat(dir_results,name4,'.bmp');
    
    % save output images
    %imwrite(img,saveFile1,'bmp');    
    %imwrite(mask,saveFile2,'bmp');
%     imwrite(F_img,saveFile3,'jpg');
    %imwrite(normalised3,saveFile4,'bmp');
%         end
%    end


%    for j=(1:NumImages)
%        F_img = finalA(:,:,j);
%     name = strrep(file_names{i},strcat('.',file_ext),'');
%     %name1=strcat(name,'_1img');
%     %name2=strcat(name,'_2mask');
%     name3=strcat(name,'_img');
%     name3 = strcat(name3, strcat('Blue_',int2str(j)));
%     %name4=strcat(name,'_4normalised');
%     
%     % create a directory with the file name with the extension    
%     %saveFile1=strcat(dir_results,name1,'.bmp');
%     %saveFile2=strcat(dir_results,name2,'.bmp');
%     saveFile3=strcat(dir_results,name3,'.jpg');
%     %saveFile4=strcat(dir_results,name4,'.bmp');
%     
%     % save output images
%     %imwrite(img,saveFile1,'bmp');    
%     %imwrite(mask,saveFile2,'bmp');
%     imwrite(F_img,saveFile3,'jpg');
%     %imwrite(normalised3,saveFile4,'bmp');
%    end
%     
%   for j=(1:NumImages)
%        F_img = finalB(:,:,j);
%     name = strrep(file_names{i},strcat('.',file_ext),'');
%     %name1=strcat(name,'_1img');
%     %name2=strcat(name,'_2mask');
%     name3=strcat(name,'_img');
%     name3 = strcat(name3, strcat('finalRed_',int2str(j)));
%     %name4=strcat(name,'_4normalised');
%     
%     % create a directory with the file name with the extension    
%     %saveFile1=strcat(dir_results,name1,'.bmp');
%     %saveFile2=strcat(dir_results,name2,'.bmp');
%     saveFile3=strcat(dir_results,name3,'.jpg');
%     %saveFile4=strcat(dir_results,name4,'.bmp');
%     
%     % save output images
%     %imwrite(img,saveFile1,'bmp');    
%     %imwrite(mask,saveFile2,'bmp');
%     imwrite(F_img,saveFile3,'jpg');
%     %imwrite(normalised3,saveFile4,'bmp');
%   end
%     
%    for j=(1:NumImages)
%        F_img = finalC(:,:,j);
%     name = strrep(file_names{i},strcat('.',file_ext),'');
%     %name1=strcat(name,'_1img');
%     %name2=strcat(name,'_2mask');
%     name3=strcat(name,'_img');
%     name3 = strcat(name3, strcat('finalGreen_',int2str(j)));
%     %name4=strcat(name,'_4normalised');
%     
%     % create a directory with the file name with the extension    
%     %saveFile1=strcat(dir_results,name1,'.bmp');
%     %saveFile2=strcat(dir_results,name2,'.bmp');
%     saveFile3=strcat(dir_results,name3,'.jpg');
%     %saveFile4=strcat(dir_results,name4,'.bmp');
%     
%     % save output images
%     %imwrite(img,saveFile1,'bmp');    
%     %imwrite(mask,saveFile2,'bmp');
%     imwrite(F_img,saveFile3,'jpg');
%     %imwrite(normalised3,saveFile4,'bmp');
%    end
%   
%    for j=(1:NumImages)
%        F_img = finalD(:,:,j);
%     name = strrep(file_names{i},strcat('.',file_ext),'');
%     %name1=strcat(name,'_1img');
%     %name2=strcat(name,'_2mask');
%     name3=strcat(name,'_img');
%     name3 = strcat(name3, strcat('finalBlue_',int2str(j)));
%     %name4=strcat(name,'_4normalised');
%     
%     % create a directory with the file name with the extension    
%     %saveFile1=strcat(dir_results,name1,'.bmp');
%     %saveFile2=strcat(dir_results,name2,'.bmp');
%     saveFile3=strcat(dir_results,name3,'.jpg');
%     %saveFile4=strcat(dir_results,name4,'.bmp');
%     
%     % save output images
%     %imwrite(img,saveFile1,'bmp');    
%     %imwrite(mask,saveFile2,'bmp');
%     imwrite(F_img,saveFile3,'jpg');
%     %imwrite(normalised3,saveFile4,'bmp');
%   end
%     
%     
%      F_img = final;
%      name = strrep(file_names{i},strcat('.',file_ext),'');
%     name3=strcat(name,'_img');
%     name3 = strcat(name3, int2str(65));
%     saveFile3=strcat(dir_results,name3,'.jpg');
%     imwrite(F_img,saveFile3,'jpg');

end
disp('WOW! Successful Execution...');