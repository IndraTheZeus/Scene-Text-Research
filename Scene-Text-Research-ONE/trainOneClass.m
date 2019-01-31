function [POS_ACCURACY,NEG_ACCURACY,Power,Theta] = trainOneClass(POS_DATA,NEG_DATA,MUL)
   
    multiplier = MUL;
    
   
   pos_m = size(POS_DATA,1); %TRAINING EXAMPLES
   neg_m = size(NEG_DATA,1);
  
 
   
   pos_X = featureNormalize(POS_DATA(:,2:end));  %Feature normalize normalizes each column
   neg_X = featureNormalize(NEG_DATA(:,2:end));
  %  Set options for fminunc
options = optimset('GradObj', 'on', 'MaxIter', 400);
min_val_cost_set = 0;
   for power = 1:8
       
       pos_X_poly = GetPolynomialFeatureVector(pos_X,power);
       neg_X_poly = GetPolynomialFeatureVector(neg_X,power);
        n = size(pos_X_poly,2); %NO. OF FEATURES INCLUDING BIAS
        if size(pos_X_poly,2)~= size(neg_X_poly,2)
           fprintf("\nError In Splitting"); 
        end
      for lambda = [0 0.001 0.003 0.01 0.03 0.1 0.3 1 3 10]
          
          avg_positive_accuracy = 0;
          avg_negative_accuracy = 0;
          avg_val_cost = 0;
          for itr = 1:3
             
             pos_perm_mask = randperm(pos_m);
             neg_perm_mask = randperm(neg_m);
             
             pos_train_data = pos_X_poly(pos_perm_mask(1:ceil(0.6*pos_m)),:);
              neg_train_data = neg_X_poly(neg_perm_mask(1:ceil(0.6*neg_m)),:);
              train_data = neg_train_data;
              train_y = zeros(size(train_data,1),1);
              
              pos_val_data = pos_X_poly(pos_perm_mask(ceil(0.6*pos_m)+1:ceil(0.8*pos_m)),:);
              neg_val_data = neg_X_poly(neg_perm_mask(ceil(0.6*neg_m)+1:ceil(0.8*neg_m)),:);
              val_data = neg_val_data;
               val_y = zeros(size(val_data,1),1);
             for i = 1:multiplier
                 train_data = [train_data;pos_train_data];
                 train_y =[train_y;ones(size(pos_train_data,1),1)];
                 val_data = [val_data;pos_val_data];
                 val_y =[val_y;ones(size(pos_val_data,1),1)];
             end
             
            % [train_y train_data]
             
            % [val_y val_data]
             
             test_data = [ pos_X_poly(pos_perm_mask(ceil(0.8*pos_m)+1:pos_m),:);neg_X_poly(neg_perm_mask(ceil(0.8*neg_m)+1:neg_m),:)];
             test_y = [ ones(size(pos_X_poly(pos_perm_mask(ceil(0.8*pos_m)+1:pos_m),:),1),1) ; zeros(size(neg_X_poly(neg_perm_mask(ceil(0.8*neg_m)+1:neg_m),:),1),1) ];
            %[test_y test_data]
            
             if size(test_y,1) ~= size(test_data,1)
                 
                fprintf("\nERROR!!! Test Data Dimension mistmatch\n"); 
             end
             
             
             initial_theta = zeros(n,1);
             

           %  Run fminunc to obtain the optimal theta
           %  This function will return theta and the cost 
            [theta, cost] = fminunc(@(t)(costFunctionReg(t, train_data, train_y,lambda)), initial_theta, options);
 
              if size(theta) ~= size(initial_theta)                 
                 fprintf("\nWRONG THETA RETURNED BY FMINUNC\n");
              end
              
              [val_cost,~] = costFunctionReg(theta,val_data,val_y,0);
              %[test_cost,~] = costFunctionReg(theta,test_data,test_y,0);
              avg_val_cost = avg_val_cost + val_cost;
              test_output = test_data*theta;
              test_output = (test_output >=0.5);
              %Calcualte Postive Accuracy and Negative Accuracy
              positive_rows = (test_y == 1);
             
              pos_test_output = test_output(positive_rows,1);
              neg_test_output = test_output(~positive_rows,1);
              avg_positive_accuracy = avg_positive_accuracy + (sum(pos_test_output)/sum(positive_rows));
              avg_negative_accuracy = avg_negative_accuracy + (sum(~neg_test_output)/sum(~positive_rows));
              
          end
          
          avg_val_cost = avg_val_cost/3;  %Find the average cost on validation set
          avg_positive_accuracy = avg_positive_accuracy/3; 
          avg_negative_accuracy = avg_negative_accuracy/3; 
          
          if min_val_cost_set == 0
             
             min_val_cost_set = 1;
        
             best_power = power;
             
             best_theta = theta;
             
             best_lambda = lambda;
             
             min_avg_val_cost = avg_val_cost;
             
             min_avg_positive_accuracy = avg_positive_accuracy;
             min_avg_negative_accuracy = avg_negative_accuracy;
             
          else
              if avg_val_cost < min_avg_val_cost 
                best_power = power;
             
                best_theta = theta;
             
                best_lambda = lambda;
                
                
             
                min_avg_val_cost = avg_val_cost; 
                
             min_avg_positive_accuracy = avg_positive_accuracy;
             min_avg_negative_accuracy = avg_negative_accuracy;
                  
              end
              
          end
          
          
      end      
   end
   
   Power = best_power;
   Theta = best_theta;
   POS_ACCURACY = min_avg_positive_accuracy;
   NEG_ACCURACY = min_avg_negative_accuracy;


end