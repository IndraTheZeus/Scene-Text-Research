function res =  AccuracyFromTable(X)
    
    dev_value = 0.2;
    deviation = (X(:,1) - X(:,2))./X(:,1);
    
    y = (deviation < dev_value);
    
    Unions = sum(X(:,3));
    Intersects = sum(X(:,4));
    
    IOU = Intersects/Unions;
    
    if numel(y) == 0
       warning("NAN EXPECTED"); 
    end
    acc = sum(y)/numel(y);
    
    if isnan(acc)
       warning("NAN expected");
        X
       
    end
    
    fprintf("\n  =======  ACCURACY WITH DEVIATION OF %f: %d percent    IOU = %d   =======\n",dev_value,(acc*100),IOU);
    res = [dev_value (acc*100) IOU]; 

end