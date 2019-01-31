function [PosTrainingData,NegTrainingData] = SplitTrainingIntoLabels(TrainingData)

  positive_rows = (TrainingData(:,1) == 1);

  PosTrainingData = TrainingData(positive_rows,:);
  NegTrainingData = TrainingData((~positive_rows),:);

end