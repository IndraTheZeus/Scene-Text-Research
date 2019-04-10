% 
 input_dir = 'D:\Indra-scene-text-research-one\DATASET-FOR-SCENE-TEXT-TRAINING\Benchmarking_word_image_datasets\Benchmarking_word_image_datasets\SVT10\SVT10\svt10_test_words\';
 GT_dir = 'D:\Indra-scene-text-research-one\DATASET-FOR-SCENE-TEXT-TRAINING\Benchmarking_word_image_datasets\Benchmarking_word_image_datasets\SVT10\SVT10\svt10_ground_truth\';
 output_dir = 'D:\Indra-scene-text-research-one\DATA\EXCEL_FILES_WITH_FEATURES\';

 ExcelBatchFormation(input_dir,GT_dir,output_dir,'jpg','',false)
% % % load('C1.mat')
%   load('C2.mat')
% % load('C3.mat')
% % load('C4.mat')
% % load('C5.mat')
% % load('C6.mat')
% % load('C7.mat')
% % load('C8.mat')
% %  load('C9.mat')
% % load('C10.mat')
% % load('C11.mat')
%  load('C12.mat')
% % load('C13.mat')
% % load('C14.mat')

% load('F1.mat')
% %input_dir = 'E:\ResearchFiles\DATA\DATASET-FOR-SCENE-TEXT-TRAINING\Benchmarking_word_image_datasets\Benchmarking_word_image_datasets\ICDAR03\ICDAR03\icdar03_test_words\';
% input_dir ='D:\Indra-scene-text-research-one\DATASET-FOR-SCENE-TEXT-TRAINING\Benchmarking_word_image_datasets\Benchmarking_word_image_datasets\SVT10\SVT10\svt10_test_words\';
% output_dir = 'D:\Indra-scene-text-research-one\DATA\test_output\';
% % % load('DensityPixelsRemovedEnsemble.mat')
% 
% batchFormation(input_dir,strcat(output_dir,'F1\'),'jpg','png',F1)
% % % batchFormation('E:\ResearchFiles\DATA\test_input\','E:\ResearchFiles\DATA\test_output\C1\','png','png',AllFeatures_1) 
% batchFormation(input_dir,strcat(output_dir,'C2\'),'jpg','png',AllFeatures_2)
% % batchFormation('E:\ResearchFiles\DATA\test_input\','E:\ResearchFiles\DATA\test_output\C3\','png','png',Removed3_1)
% % batchFormation('E:\ResearchFiles\DATA\test_input\','E:\ResearchFiles\DATA\test_output\C4\','png','png',Removed3_2)
% % batchFormation('E:\ResearchFiles\DATA\test_input\','E:\ResearchFiles\DATA\test_output\C5\','png','png',Removed6_1)
% % batchFormation('E:\ResearchFiles\DATA\test_input\','E:\ResearchFiles\DATA\test_output\C6\','png','png',Removed6_2)
% % batchFormation('E:\ResearchFiles\DATA\test_input\','E:\ResearchFiles\DATA\test_output\C7\','png','png',Removed9_1)
% % batchFormation('E:\ResearchFiles\DATA\test_input\','E:\ResearchFiles\DATA\test_output\C8\','png','png',Removed9_2)
% %batchFormation(input_dir,strcat(output_dir,'C9\'),'jpg','png',Removed63_1)
% % batchFormation('E:\ResearchFiles\DATA\test_input\','E:\ResearchFiles\DATA\test_output\C10\','png','png',Removed63_2)
% % batchFormation('E:\ResearchFiles\DATA\test_input\','E:\ResearchFiles\DATA\test_output\C11\','png','png',Removed369_1)
%  batchFormation(input_dir,strcat(output_dir,'C12\'),'jpg','png',Removed369_2)
% 
% i = 1;
% 
% for Classifier = [ AllFeatures_1 ] %AllFeatures_2] %Removed9_1, Removed9_2, Removed6_1, Removed6_2, Removed3_1, Removed3_2, Removed63_1, Removed63_2, Removed369_1, Removed369_2 ]
%     fprintf("\n\nTARGETING CLASSIFIER = %d\n",i);
%     target = strcat('D:\Indra-scene-text-research-one\DATA\test_output\C',int2str(i),'\');
%     
%   %  batchFormation('D:\Indra-scene-text-research-one\DATA\test_input\',target,'png','bmp',Classifier) %TARGET CHANGED
%   for lang = ["English" ]%, "Korean", "Mixed" ]
%      for type =["Digital_Camera" ]%,"Mobile_Phone"]
%         dir_in = char(strcat("D:\STANDARD_IMAGE_DATASETS\KAIST_all\KAIST\",lang,"\",type,"\"));
%          KaistDatasetEval(dir_in,strcat(pwd,'\'),target,strcat('C',int2str(i),'_KaistEval.xlsx'),'jpg',Classifier);
%      end
%   end
%   
%   for j = 1:i
%       fprintf("========================== RESULTS =======================");
%     Eval = xlsread(strcat(strcat(pwd,'\'),strcat('C',int2str(j),'_KaistEval.xlsx'))); 
%     AccuracyFromTable(Eval);
%   end
%     fprintf("\nFINISHED WITH CLASSIFIER = %d\n",(i));
%      i = i+1;
% end
%  ExcelBatchFormation('D:\Indra-scene-text-research-one\DATA\test_input\','D:\Indra-scene-text-research-one\DATA\test_output\','png','xls',false)
% load('DensityRemovedEnsemble.mat')
% load('DensityPixelsRemovedEnsemble.mat')
% batchFormation('E:\ResearchFiles\DATA\test_input\','E:\ResearchFiles\DATA\test_output\','jpg','bmp',DensityRemoved)
%batchFormation('D:\Indra-scene-text-research-one\DATA\test_input\','D:\Indra-scene-text-research-one\DATA\test_output\DensityPixelsRemoved\','jpg','bmp',DensityPixelsRemoved)

