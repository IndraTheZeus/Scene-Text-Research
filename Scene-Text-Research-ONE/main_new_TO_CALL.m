% ExcelBatchFormation('D:\Indra-scene-text-research-one\DATA\test_input\','D:D:\Indra-scene-text-research-one\DATA\test_output\','jpg','xlsx')
 load('C1.mat')
load('C2.mat')
load('C3.mat')
load('C4.mat')
load('C5.mat')
load('C6.mat')
load('C7.mat')
load('C8.mat')
load('C9.mat')
load('C10.mat')
load('C11.mat')
load('C12.mat')
load('C13.mat')
load('C14.mat')
% load('DensityPixelsRemovedEnsemble.mat')
% 
% batchFormation('D:\Indra-scene-text-research-one\DATA\test_input\','D:\Indra-scene-text-research-one\DATA\test_output\C1\','jpg','bmp',AllFeatures_1)
% batchFormation('D:\Indra-scene-text-research-one\DATA\test_input\','D:\Indra-scene-text-research-one\DATA\test_output\C2\','jpg','bmp',AllFeaures_2)
% %batchFormation('D:\Indra-scene-text-research-one\DATA\test_input\','D:\Indra-scene-text-research-one\DATA\test_output\C3\','jpg','bmp',Features12_1)
% batchFormation('D:\Indra-scene-text-research-one\DATA\test_input\','D:\Indra-scene-text-research-one\DATA\test_output\C4\','jpg','bmp',Features12_2)
% %batchFormation('D:\Indra-scene-text-research-one\DATA\test_input\','D:\Indra-scene-text-research-one\DATA\test_output\C5\','jpg','bmp',removed369)
% %batchFormation('D:\Indra-scene-text-research-one\DATA\test_input\','D:\Indra-scene-text-research-one\DATA\test_output\C6\','jpg','bmp',Removed369_1)
% batchFormation('D:\Indra-scene-text-research-one\DATA\test_input\','D:\Indra-scene-text-research-one\DATA\test_output\C7\','jpg','bmp',removed369_2)
i = 1;
for Classifier = [ AllFeatures_1, AllFeatures_2]%Removed9_1, Removed9_2, Removed6_1, Removed6_2, Removed3_1, Removed3_2, Removed63_1, Removed63_2, Removed369_1, Removed369_2 ]
    fprintf("\n\nTARGETING CLASSIFIER = %d\n",i);
    target = strcat('D:\Indra-scene-text-research-one\DATA\test_output\C',int2str(i),'\');
    i = i+1;
    batchFormation('D:\Indra-scene-text-research-one\DATA\test_input\',target,'png','bmp',Classifier) %TARGET CHANGED
    
    
    Eval = xlsread(strcat(target,"Evaluate.xlsx")); 
    AccuracyFromTable(Eval);
    
    fprintf("\nFINISHED WITH CLASSIFIER = %d\n",(i-1));
    
end
%  ExcelBatchFormation('D:\Indra-scene-text-research-one\DATA\test_input\','D:\Indra-scene-text-research-one\DATA\test_output\','png','xls',false)
% load('DensityRemovedEnsemble.mat')
% load('DensityPixelsRemovedEnsemble.mat')
% batchFormation('E:\ResearchFiles\DATA\test_input\','E:\ResearchFiles\DATA\test_output\','jpg','bmp',DensityRemoved)
%batchFormation('D:\Indra-scene-text-research-one\DATA\test_input\','D:\Indra-scene-text-research-one\DATA\test_output\DensityPixelsRemoved\','jpg','bmp',DensityPixelsRemoved)

