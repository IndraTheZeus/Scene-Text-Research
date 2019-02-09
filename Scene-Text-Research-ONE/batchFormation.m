%%%%%%   batchFormation()

function batchFormation(dir_in, dir_results, file_ext,out_ext,StabilityPredictor)
disp('WAIT! Execution begining...');

% list of files in the directory name with the input file extension
listing = dir(strcat(dir_in,'*.',file_ext));
file_names = {listing.name};

% number of pages in the directory with this file extension
num_pages = length(file_names);

%display(num_pages);
fprintf('Total number of pages = %d\n', num_pages);

% process all pages in the directory
for i = 1:num_pages  %%CONVERT TO 1:1 
  %if((i>=120)&&(i<125))  
 
%    fprintf('Processing page No: %d\n', i);  %%Commented out,reading done by load data  
%     
%    %% load the image from the directory
%  
%     
    img = imread(strcat(dir_in,file_names{i}));   %% Commented out reading
%                                                     %% as reading Done by LoadData
%  
    
    %[row,col,layer] = size(img);
    % call the text line extraction code
    %[outputImg] = test5icdar2(img);
    %[img,mask,inpainted_img,normalised3] = main_function(img);
 %   [finalA,NumImages] = Algo2001_3(img,1);
   
 [finalA,NumImages,~,~] = Algo2001_3(img,2,StabilityPredictor); 
 close all
 scaled_final_img = zeros(size(finalA,1),size(finalA,2));
 %added_img = false(size(scaled_final_img));
 for sc = NumImages:-1:1
     fprintf("\nScaling Components in Bin No. %d",sc);
     
     if(finalA(:,:,sc) == 0)
         continue;
     end
     f_neighbors = conv2(finalA(:,:,sc),[1,1,1;1,0,1;1,1,1],'same')>0;
     label = max(scaled_final_img(f_neighbors)) + 1
    
    scaled_final_img(finalA(:,:,sc)) = sc;
   % added_img = logical(added_img + finalA(:,:,sc));
 end
 
 max_map = scaled_final_img > 0;
 min_label = min(min(scaled_final_img(max_map)))
 max_label = max(max(scaled_final_img(max_map)))
 scaled_final_img(max_map) = scaled_final_img(max_map) - min_label;
%  figure
%  imagesc(scaled_final_img)
 %The display img is the one displayed
 %figure
 %imshow(added_img)
 %SaveFile = strcat("BinCombined_",strrep(file_names{i},strcat('.',file_ext),''),'.jpg');
% imwrite(scaled_final_img,SaveFile,'jpg');
 figure
image(scaled_final_img)
figure
imagesc(scaled_final_img)
savefig(strcat(dir_results,"ColorRegionsFigure_",file_names{i},".fig"))
show = mat2gray(scaled_final_img);
figure
imshow(show)
%  figure
%  imshow(display_img)
 savefig(strcat(dir_results,"RegionsFigure_",file_names{i},".fig"))
  display_img = finalA;

%  [finalA,NumImages] = LoadFeatureMatrix(dir_in,file_ext);
 
 
%    finalA = findInterestRegions(img);
%    NumImages = 1;
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


   for j=(1:NumImages)
       F_img = display_img(:,:,j);
    name = strrep(file_names{i},strcat('.',file_ext),'');
    %name1=strcat(name,'_1img');
    %name2=strcat(name,'_2mask');
    name3=strcat(name,'_');
    name3 = strcat(name3, int2str(j));
    %name4=strcat(name,'_4normalised');
    
    % create a directory with the file name with the extension    
    %saveFile1=strcat(dir_results,name1,'.bmp');
    %saveFile2=strcat(dir_results,name2,'.bmp');
    saveFile3=strcat(dir_results,name3,'.jpg');
    %saveFile4=strcat(dir_results,name4,'.bmp');
    
    % save output images
    %imwrite(img,saveFile1,'bmp');    
    %imwrite(mask,saveFile2,'bmp');
    imwrite(F_img,saveFile3,'jpg');
    %imwrite(normalised3,saveFile4,'bmp');
   end
    
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
    
%      F_img = final;
%      name = strrep(file_names{i},strcat('.',file_ext),'');
%     name3=strcat(name,'_img');
%     name3 = strcat(name3, int2str(65));
%     saveFile3=strcat(dir_results,name3,'.jpg');
%     imwrite(F_img,saveFile3,'jpg');

end
disp('\nWOW! Successful Execution...');