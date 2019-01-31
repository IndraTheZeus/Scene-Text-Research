%%%%%%   batchFormation()

function FINAL_batchFormation(dir_in, dir_results, file_ext)
disp('WAIT! Execution begining...');

% list of files in the directory name with the input file extension
listing = dir(strcat(dir_in,'*.',file_ext));
file_names = {listing.name};

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
    
    % call the text line extraction code
    %[outputImg] = test5icdar2(img);
    %[img,mask,inpainted_img,normalised3] = main_function(img);
    [norm] = Algo2001_3(img);
   
    % remove the file extension from the file name
    name = strrep(file_names{i},strcat('.',file_ext),'');
    name1=strcat(name,'_norm');
    %name2=strcat(name,'_bin');
    %name3=strcat(name,'_BKGND');
    %name4=strcat(name,'_4normalised');
    
    % create a directory with the file name with the extension    
    saveFile1=strcat(dir_results,name1,'.png');
    %saveFile2=strcat(dir_results,name2,'.png');
    %saveFile3=strcat(dir_results,name3,'.png');
    %saveFile4=strcat(dir_results,name4,'.bmp');
    
    % save output images
    imwrite(norm,saveFile1,'png');    
    %imwrite(bin,saveFile2,'png');
    %imwrite(bck,saveFile3,'png');
    %imwrite(normalised3,saveFile4,'bmp');
    %objective_evaluation(listfilename, outputfile, varargin) 

end
disp('WOW! Successful Execution...');