function [isStable] = PredictStability(FeatureValues,StabilityPredictor)
 global Matrix labels
  load('F.mat')
  F = table2array(F);
    X = FeatureValues;
    
     X =[X X(:,1).*X(:,9) X(:,2).*X(:,9) X(:,3)./X(:,10) X(:,3)./X(:,9) X(:,1)./X(:,10) X(:,2)./X(:,10)];
     
     found = false;
     for se = 1:size(Matrix,1)
         if X == Matrix(se,:)
             found = true;
             break;
         end
     end
     
     if found == false
         X
         FeatureValues
        error("Mismatch"); 
     end
     Table = table(X(1,1),X(1,2),X(1,3),X(1,4),X(1,5),X(1,6),X(1,7),X(1,8),X(1,9),X(1,10),X(1,11),X(1,12),X(1,13),X(1,14),X(1,15),X(1,16),X(1,17),X(1,18),X(1,19),X(1,20),X(1,21),X(1,22),X(1,23),X(1,24),'VariableNames',{'VarName2','VarName3','VarName4','VarName5','VarName6','VarName7','VarName8','VarName9','VarName10','VarName11','VarName12','VarName13','VarName14','VarName15','VarName16','VarName17','VarName18','VarName19','VarName20','VarName21','VarName22','VarName23','VarName24','VarName25'});
    
     y = StabilityPredictor.predictFcn(Table);
     pos = categorical(1);
     if y(1,1) == pos
         isStable = true;
     else
         isStable = false;
     end

end