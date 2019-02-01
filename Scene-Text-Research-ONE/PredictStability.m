function [isStable] = PredictStability(FeatureValues)

    X = FeatureValues;
    
     X =[X X(:,1).*X(:,9) X(:,2).*X(:,9) X(:,3)./X(:,10) X(:,3)./X(:,9) X(:,1)./X(:,10) X(:,2)./X(:,10) ];
     
     y = EnsembleBest.predictFcn(X);
     
     if y==1
         isStable = true;
     else
         isStable = false;
     end

end