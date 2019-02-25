%%%%%%   batchFormation()

function KaistDatasetEval(dir_in, eval_dir ,dir_results,evalFileName, file_ext,StabilityPredictor)

append_mode = false
disp('\nWAIT! Execution begining...\n');



% list of files in the directory name with the input file extension
listing = dir(strcat(dir_in,'*.',file_ext));
xml_listing = dir(strcat(dir_in,'*.','xml'));
bin_listing = dir(strcat(dir_in,'*.','bmp'));




file_names = {listing.name};
xml_names = {xml_listing.name};
bin_names = {bin_listing.name};

    f_n = numel(file_names);
    x_n = numel(xml_names);
    b_n = numel(bin_names);
if numel(file_names) ~= numel(xml_names) || numel(file_names) ~= numel(bin_names)
    f_n
    x_n
    b_n
   fprintf("\nAll Files not present\n"); 
end
% number of pages in the directory with this file extension
num_pages = length(file_names);

%display(num_pages);
fprintf('Total number of pages = %d\n', num_pages);

% process all pages in the directory
X_created = false;

xml_i = 1;
for i = 1:num_pages  
      
   
    if i > f_n || i > b_n || xml_i > x_n
       fprintf("\n%d Not Processed due to missing files\n",i);
       continue; 
    end
    [~, FileName, ~] = fileparts(file_names{i});
    [~, ExcelFileName, ~] = fileparts(xml_names{i});
    [~, BinFileName, ~] = fileparts(bin_names{i});
    if (convertCharsToStrings(FileName) ~= convertCharsToStrings(ExcelFileName)) || (convertCharsToStrings(FileName) ~= convertCharsToStrings(BinFileName))
        file_names{i}
        xml_names{i}
        bin_names{i}
       fprintf("\nFILE DATA MISMATCH,%d not processed\n",i); 
       continue;
    end
     fprintf("Processing image: %d (%s) , Bin: %d(%s) , XML: %d (%s)",i,file_names{i},i,bin_names{i},xml_i,xml_names{xml_i});
    img = imread(strcat(dir_in,file_names{i}));  
  
    t = logical(imread(strcat(dir_in,bin_names{i})));
    bin_img = t(:,:,1) | t(:,:,2) | t(:,:,3);
    
    try
    xmlS = xml2struct(strcat(dir_in,xml_names{xml_i}));
    test =  numel(xmlS.images.image.words.word);
    catch
       fprintf("XML FILE HAS WRONG FORMAT,IGNORING....");
        xml_i = xml_i +1;
       continue;
    end
 
    
    
    [row,col] = size(img);
    for word_no = 1: numel(xmlS.images.image.words.word)
       
        if numel(xmlS.images.image.words.word) > 1
           BB = xmlS.images.image.words.word{word_no}.Attributes; 
        else
            BB = xmlS.images.image.words.word.Attributes;
        end
        
        x1 = max(1,str2double(BB.x) - 5);
        x2 = min(col,x1 + str2double(BB.width) + 5);
        y1 = max(1,str2double(BB.y) - 5);
        y2 = min(row,y1 +str2double(BB.height) + 5);
        
        scan_img = img(y1:y2,x1:x2);
      %  imshow(scan_img); %%Comment out for speed
        
        [finalA,NumImages,~,~] = Algo2001_3(scan_img,2,StabilityPredictor); 
         close all
        correct_img = bin_img(y1:y2,x1:x2);
     %   imshow(correct_img);  %%Comment out for speed
        EX =  AddToEvaluationSheet(finalA,correct_img);
        if EX(1,1) == 0
           continue; 
        end
        AccuracyFromTable(EX);
        if ~X_created
            X_created = true;
            X = EX;
        else
            X = [X;EX];
        end
    end
   
        
    xml_i = xml_i + 1;

 
 
  %CHANGE THE REGION EXTRACTIOMN FUNCION IF NEEDED
 continue;
 
 
 scaled_final_img = zeros(size(finalA,1),size(finalA,2));
 %added_img = false(size(scaled_final_img));
 for sc = NumImages:-1:1
     fprintf("\nScaling Components in Bin No. %d",sc);
     
     if(finalA(:,:,sc) == 0)
         continue;
     end
     f_neighbors = conv2(finalA(:,:,sc),[1,1,1;1,0,1;1,1,1],'same')>0;
     label = max(scaled_final_img(f_neighbors)) + 1;
    
    scaled_final_img(finalA(:,:,sc)) = sc;
   % added_img = logical(added_img + finalA(:,:,sc));
 end
 
 max_map = scaled_final_img > 0;
 min_label = min(min(scaled_final_img(max_map)));
 max_label = max(max(scaled_final_img(max_map)));
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
    
    imwrite(F_img,saveFile3,'jpg');

end


     if X_created
      if append_mode && isfile(evalFileName)
        Prev = xlsread(strcat(eval_dir,evalFileName));
         xlswrite(strcat(eval_dir,evalFileName),[Prev;X]);
      else
         xlswrite(strcat(eval_dir,evalFileName),X); 
      end
     end

disp('\nWOW! Successful Execution...');