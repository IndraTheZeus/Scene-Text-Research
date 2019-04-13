%%%%%%   batchFormation()

function ExcelBatchFormation(dir_in,GT_dir, dir_results, file_ext,excel_file_ext,extractFromSheet)
disp('WAIT! Execution begining...');

append_mode = false;
output_filename = strcat(dir_results,"StabilityFeatures(0.5,0.5)_IC03.xlsx");

% list of files in the directory name with the input file extension
listing = dir(strcat(dir_in,'*.',file_ext));
GT_listing = dir(strcat(GT_dir,'*.','tif'));

if extractFromSheet
    excel_listing = dir(strcat(dir_in,'*.',excel_file_ext));
    excel_file_names = {excel_listing.name};
end
file_names = {listing.name};
GT_file_names = {GT_listing.name};
% number of pages in the directory with this file extension
num_pages = length(file_names);

%display(num_pages);
fprintf('\nTotal number of pages = %d\n', num_pages);

     
     training_entry = 1;
     FeatureLabel = false(1,1);
 f_init = false;
% process all pages in the directory
for i = 1:2:num_pages
  %if((i>=120)&&(i<125))  
    fprintf('\nProcessing page No: %d\n', i);    
    
    % load the image from the directory
    img = imread(strcat(dir_in,file_names{i}));
    if extractFromSheet
        excel_file_names{i}
    end
  
    if ~extractFromSheet || numel(excel_file_names)~= 0 
       
        
     if extractFromSheet   
        filename = strcat(dir_in,strcat("/",excel_file_names{i}));
       X = xlsread(filename);
      
       for r = 1:size(X,1)
          BB = ceil(X(r,1:4));
          [FeaturesX,Labelsy,~,~] = LoadFeatureMatrix(img(max(1,BB(2)-5):min(BB(2)+BB(4)+5,size(img,1)),max(1,BB(1)-5):min(BB(1)+BB(3)+5,size(img,2)),:));
          [rM,~] = size(FeaturesX);
          if ~f_init
             f_init = true;
             FeatureSet = zeros(1,size(FeaturesX,2));
          end
         FeatureSet(training_entry:(training_entry+rM-1),:) = FeaturesX;
         FeatureLabel(training_entry:(training_entry+rM-1),:) = Labelsy;
         training_entry = training_entry+rM;
          %imshow(finalA)

       end
     else
        [FeaturesX,Labelsy,~,~] = LoadFeatureMatrix(img,GT_dir,GT_file_names{i});
          [rM,~] = size(FeaturesX);
          if ~f_init
             f_init = true;
             FeatureSet = zeros(1,size(FeaturesX,2));
          end
         FeatureSet(training_entry:(training_entry+rM-1),:) = FeaturesX;
         FeatureLabel(training_entry:(training_entry+rM-1),:) = Labelsy;
         training_entry = training_entry+rM;
         
         if mod((i-1)/2,10) == 0
              fprintf("\nWriting Records till: %d ,total training entries: %d....\n",i,training_entry);
              Data = [FeatureLabel FeatureSet];
              xlswrite(output_filename,Data);   
         end
     end
      
    end
    
    
end

     
    %%Writing Data to File
   
     if append_mode && isfile(output_filename)
        fprintf("\nAppending To Data To Existing File....\n");
        Prev = xlsread(output_filename);
%         Prev
        Data = [FeatureLabel FeatureSet];
%         Data

        if size(Prev,2) ~= size(Data,2)
          fprintf("\nData Dimension mismatch with previous data,Writing New File..");
          Prev_size = size(Prev)
          Data_size = size(Data)
           xlswrite(strcat("S_",output_filename),Data);
        else
             xlswrite(output_filename,[Prev;Data]);
        end
       
     else
        fprintf("\nWriting ALL Records till: %d ,total training entries: %d....\n",i,training_entry);
        Data = [FeatureLabel FeatureSet];
%         Data
        xlswrite(output_filename,Data); 

    end

disp('WOW! Successful Execution...');
end