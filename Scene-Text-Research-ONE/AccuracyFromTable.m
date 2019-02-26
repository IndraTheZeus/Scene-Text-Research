function res =  AccuracyFromTable(X)
    
    dev_value = 0.25;
    iou_dev = 0.6;
    
    deviation = (X(:,1) - X(:,5))./X(:,1);
    overlap = X(:,7)./X(:,6);
    y = (deviation <= dev_value);
    y_2 = (overlap >= iou_dev );
    
    y_3 = y & y_2;
    
    Unions = sum(X(:,6));
    Intersects = sum(X(:,7));
    
    IOU = Intersects/Unions;
    
 
    
    if numel(y) == 0
       warning("NAN EXPECTED"); 
    end
    acc = sum(y)/numel(y);
    acc_2 = sum(y_2)/numel(y_2);
    acc_3 = sum(y_3)/numel(y_3);
    
 
    
    if isnan(acc) || isnan(acc_2)
       warning("NAN expected");
        X
    end
    
    fprintf("\n ======= ACC WITH DEV OF %f: %d percent || IOU Accuracy(dev: %d) : %d percent ||| NET ACC: %d =======\n",dev_value,(acc*100),iou_dev,(acc_2*100),(acc_3*100));
    res = [dev_value (acc*100) IOU]; 

end