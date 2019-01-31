
function [POS_MUL,POS_ACCURACY,NEG_ACCURACY] = PlotMultiplierVsAccuracy(filename)

      TrainingData = xlsread(filename);
      

      [PosTrainingData,NegTrainingData] = SplitTrainingIntoLabels(TrainingData);
      range_of_plots = 1:150;
            
      POS_MUL = size(range_of_plots);
      POS_ACCURACY = size(range_of_plots);
      NEG_ACCURACY = size(range_of_plots);
      
   
      
      insert = 1;
      for mul = range_of_plots
          POS_MUL(insert) = mul;

          
          [POS_ACCURACY(insert),NEG_ACCURACY(insert),~,~] = trainOneClass(PosTrainingData,NegTrainingData,mul);         
          insert = insert+1;
      end
      
      FigureName = strcat(" Plot For File ",filename);
      figure("Name",FigureName);
      plot(range_of_plots,POS_ACCURACY,"+",range_of_plots,NEG_ACCURACY,"-");
      
      name = strcat(filename,strcat('.',"fig"));
      name3=strcat("Plot ",name);
 

     savefig(name3)
end