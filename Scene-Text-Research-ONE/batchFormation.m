%%%%%%   batchFormation()

function batchFormation(dir_in, dir_results, file_ext,out_ext,StabilityPredictor)
disp('WAIT! Execution begining...');

TPs = 0;
PredictedPositives = 0;
ActualPositives = 0;

%ground_truth_dir = 'E:\ResearchFiles\DATA\DATASET-FOR-SCENE-TEXT-TRAINING\Benchmarking_word_image_datasets\Benchmarking_word_image_datasets\ICDAR03\ICDAR03\icdar03_ground_truth\';
ground_truth_dir = 'E:\ResearchFiles\DATA\DATASET-FOR-SCENE-TEXT-TRAINING\Benchmarking_word_image_datasets\Benchmarking_word_image_datasets\SVT10\SVT10\svt10_ground_truth\';


% list of files in the directory name with the input file extension
listing = dir(strcat(dir_in,'*.',file_ext));

gt_listing = dir(strcat(ground_truth_dir,'*.','tif'));

file_names = {listing.name};
gt_file_names  = {gt_listing.name};

% number of pages in the directory with this file extension
num_pages = length(file_names);

%display(num_pages);
fprintf('Total number of pages = %d\n', num_pages);

% process all pages in the directory
for i = 1:num_pages  %%CONVERT TO 1:1
    %if((i>=120)&&(i<125))
    
    fprintf('Processing Image No: %d\n', i);  %%Commented out,reading done by load data
    img = imread(strcat(dir_in,file_names{i}));   %% Commented out reading
    
    if ~exist(strcat(dir_results,"BinningMatObjects\","BinnedImages",strrep(file_names{i},strcat('.',file_ext),''),".mat"),'file')
        [finalA,~,BinSizes,MAX_DISTANCE] = Algo2001_3(img,2,StabilityPredictor);
        save(strcat(dir_results,"BinningMatObjects\","BinnedImages",strrep(file_names{i},strcat('.',file_ext),''),".mat"),'finalA');
        finalA = BackGroundEliminate(finalA);
    else
        MAX_DISTANCE = 442;
        BinSizes = generateBins(MAX_DISTANCE);
        load(strcat(dir_results,"BinningMatObjects\","BinnedImages",strrep(file_names{i},strcat('.',file_ext),''),".mat"),'finalA');
       % finalA = BackGroundEliminate(finalA);
    end
    
    close all
    
    
    
    %  AddToEvaluationSheet(finalA, wolf(rgb2gray(img),size(img),0.3),strcat(dir_results,"Evaluate.xlsx"));  %CHANGE THE REGION EXTRACTIOMN FUNCION IF NEEDED
    
    
    added_img =  zeros(size(finalA,1),size(finalA,2));
    q_offset = 0;
    fprintf("\nCombining Bins....");
    for bin_no = 1:ceil(numel(BinSizes)/2)
        %fprintf("Combining Bin %d\n",bin_no);
        main_offset = ceil(MAX_DISTANCE/BinSizes(bin_no));
        
        
        %      if bin_no == 1
        %          weight = 0;
        %      else
        weight =i;
        %      end
        
        
        for img_no = (q_offset+1):(q_offset+2*main_offset-1)
            
            added_img = added_img + (double(finalA(:,:,img_no)).*weight);
        end
        q_offset = q_offset + 2*main_offset - 1;
    end
    
    for bin_no = (ceil(numel(BinSizes)/2)+1):numel(BinSizes)
        %        fprintf("Combining Bin %d\n",bin_no);
        main_offset = ceil(MAX_DISTANCE/BinSizes(bin_no));
        weight = (numel(BinSizes)+1-i);
        for img_no = (q_offset+1):(q_offset+2*main_offset-1)
            
            added_img = added_img + (double(finalA(:,:,img_no)).*weight);
        end
        q_offset = q_offset + 2*main_offset - 1;
    end
    
    
    
    
    
    
    
    %  for sc = 1:ceil(NumImages/2)
    %      fprintf("\nScaling Components in Bin No. %d",sc);
    %
    % %      if(finalA(:,:,sc) == 0)
    % %          continue;
    % %      end
    % %      f_neighbors = conv2(finalA(:,:,sc),[1,1,1;1,0,1;1,1,1],'same')>0;
    % %      label = max(scaled_final_img(f_neighbors)) + 1;
    % %
    % %     scaled_final_img(finalA(:,:,sc)) = sc;
    %     added_img = added_img + (double(finalA(:,:,sc)).*sc);
    %  end
    %
    %  for sc = (ceil(NumImages/2)+1):NumImages
    %       added_img = added_img + (double(finalA(:,:,sc)).*(NumImages+1-sc));
    %  end
    close all
    C = unique(added_img);
    GT = logical(imread(strcat(ground_truth_dir,gt_file_names{i})));
    figure('Name','GroundTruth');
    imshow(GT)
    figure('Name','Added Image');
    imagesc(added_img)
    %  figure('Name','Added Image')
    %  imshow(logical(added_img))
    % save('Added_Image.mat','added_img')
    %  T = adaptthresh(added_img,0.8);
    %binarized_img = imbinarize(added_img,T);
    binarized_img = added_img > (0.5*median(C(C>0)));
    figure('Name','Binarized Image')
    imshow(binarized_img)
    
    name = strrep(file_names{i},strcat('.',file_ext),'');
    
    name = strcat(name,'_Binarized');
    
    saveFile3=strcat(dir_results,name,strcat('.',out_ext));
    
    imwrite(binarized_img,saveFile3,out_ext);
    
    mask = double(GT) + double(binarized_img);
    
    if sum(sum(mask == 2)) == 0
        curr_precision =0;
        curr_recall =0;
    else
        curr_precision = sum(sum(mask == 2))/(sum(sum(binarized_img)));
        curr_recall = sum(sum(mask == 2))/(sum(sum(GT)));
    end
    
    
    fprintf("\nOn Current Image:: Precison: %f , Recall: %f",curr_precision,curr_recall);
    
    TPs = TPs +  sum(sum(mask == 2));
    PredictedPositives = (sum(sum(binarized_img))) +  PredictedPositives;
    ActualPositives = ActualPositives + (sum(sum(GT)));
    
    
    fprintf("\nOVERALL :: Precison: %f ,Recall: %f\n",(TPs/PredictedPositives),(TPs/ActualPositives));
    
    
%     continue;
    
    
    
    for j=(1:size(finalA,3))
        F_img = finalA(:,:,j);
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
disp('\nWOW! Successful Execution...');