<<<<<<< HEAD
% ExcelBatchFormation('D:\Indra-scene-text-research-one\DATA\test_input\','D:D:\Indra-scene-text-research-one\DATA\test_output\','jpg','xlsx')
load('DensityRemovedEnsemble.mat')
load('Features12_1.mat')
load('Features12_2.mat')
load('Removed369_1.mat')
load('Removed369_2.mat')
load('Removed369.mat')
load('DensityPixelsRemovedEnsemble.mat')

batchFormation('D:\Indra-scene-text-research-one\DATA\test_input\','D:\Indra-scene-text-research-one\DATA\test_output\C1\','jpg','bmp',DensityRemoved)
batchFormation('D:\Indra-scene-text-research-one\DATA\test_input\','D:\Indra-scene-text-research-one\DATA\test_output\C2\','jpg','bmp',DensityPixelsRemoved)
%batchFormation('D:\Indra-scene-text-research-one\DATA\test_input\','D:\Indra-scene-text-research-one\DATA\test_output\C3\','jpg','bmp',Features12_1)
batchFormation('D:\Indra-scene-text-research-one\DATA\test_input\','D:\Indra-scene-text-research-one\DATA\test_output\C4\','jpg','bmp',Features12_2)
%batchFormation('D:\Indra-scene-text-research-one\DATA\test_input\','D:\Indra-scene-text-research-one\DATA\test_output\C5\','jpg','bmp',removed369)
%batchFormation('D:\Indra-scene-text-research-one\DATA\test_input\','D:\Indra-scene-text-research-one\DATA\test_output\C6\','jpg','bmp',Removed369_1)
batchFormation('D:\Indra-scene-text-research-one\DATA\test_input\','D:\Indra-scene-text-research-one\DATA\test_output\C7\','jpg','bmp',removed369_2)
=======
 ExcelBatchFormation('E:\ResearchFiles\DATA\test_input\','E:\ResearchFiles\DATA\test_output\','png','xls',false)
% load('DensityRemovedEnsemble.mat')
% load('DensityPixelsRemovedEnsemble.mat')
% batchFormation('E:\ResearchFiles\DATA\test_input\','E:\ResearchFiles\DATA\test_output\','jpg','bmp',DensityRemoved)
%batchFormation('D:\Indra-scene-text-research-one\DATA\test_input\','D:\Indra-scene-text-research-one\DATA\test_output\DensityPixelsRemoved\','jpg','bmp',DensityPixelsRemoved)
>>>>>>> 5f5b9b72587584c15ffae5c622f56d40837bee92
