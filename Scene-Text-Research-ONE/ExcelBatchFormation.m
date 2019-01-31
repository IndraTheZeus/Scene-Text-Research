%%%%%%   batchFormation()

function ExcelBatchFormation(dir_in, dir_results, file_ext,excel_file_ext)
disp('WAIT! Execution begining...');

append_mode = true;
output_filename = "D:\Indra-scene-text-research-one\Scene-Text-Research-ONE\test_output\Reduced_StabilityFeatures(0.2,0.25).xlsx";

% list of files in the directory name with the input file extension
listing = dir(strcat(dir_in,'*.',file_ext));
excel_listing = dir(strcat(dir_in,'*.',excel_file_ext));
file_names = {listing.name};
excel_file_names = {excel_listing.name};
% number of pages in the directory with this file extension
num_pages = length(file_names);

%display(num_pages);
fprintf('\nTotal number of pages = %d\n', num_pages);

     
     training_entry = 1;
     FeatureLabel = false(1,1);
 f_init = false;
% process all pages in the directory
for i = 1:num_pages
  %if((i>=120)&&(i<125))  
    fprintf('\nProcessing page No: %d\n', i);    
    
    % load the image from the directory
    img = imread(strcat(dir_in,file_names{i}));
    excel_file_names
  
    if numel(excel_file_names)~= 0 
        filename = strcat(dir_in,strcat("/",excel_file_names{i}));
       X = xlsread(filename);
       
%        imshow(img)
       for r = 1:size(X,1)
          BB = ceil(X(r,1:4));
          [FeaturesX,Labelsy,~,~] = LoadFeatureMatrix(img(max(0,BB(2)-5):min(BB(2)+BB(4)+5,size(img,1)),max(0,BB(1)-5):min(BB(1)+BB(3)+5,size(img,2)),:));
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
    end
end

     
    %%Writing Data to File
   
     if append_mode && isfile(output_filename)
        fprintf("\nAppending To Data To Existing File....\n");
        Prev = xlsread(output_filename);
%         Prev
        Data = [FeatureLabel FeatureSet];
        Primary = Data(:,1:15);
        Data = Data(~all(Primary==0,2),:);
%         Data

        if size(Prev,2) ~= size(Data,2)
          fprintf("\nData Dimension mismatch with previous data,Writing New File..");
          Prev_size = size(Prev)
          Data_size = size(Data)
           xlswrite(strcat(output_filename,"_"),Data);
        else
             xlswrite(output_filename,[Prev;Data]);
        end
       
     else
        fprintf("\nWriting New Data....\n");
        Data = [FeatureLabel FeatureSet]; 
        Primary = Data(:,1:15);
        Data = Data(~all(Primary==0,2),:);
%         Data
        xlswrite(output_filename,Data); 

    end

disp('WOW! Successful Execution...');
end