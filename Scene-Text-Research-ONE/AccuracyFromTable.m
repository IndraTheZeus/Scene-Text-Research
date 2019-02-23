function AccuracyFromTable(X)
    
    dev_value = 0.2;
    deviation = (X(:,1) - X(:,2))./X(:,1);
    
    y = deviation < dev_value;
    
    Unions = sum(X(:,3));
    Intersects = sum(X(:,4));
    
    IOU = Intersects/Unions;
    acc = sum(y)/numel(y);
    fprintf("\n  =======  ACCURACY WITH DEVIATION OF %f: %d percent    IOU = %d   =======\n",dev_value,(acc*100),IOU);


end