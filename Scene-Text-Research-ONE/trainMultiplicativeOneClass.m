function  [POS_ACCURACY,NEG_ACCURACY,Power,Theta] = trainMultiplicativeOneClass(PosTrainingData,NegTrainingData,MULTIPLIER)

   multiplier = MULTIPLIER;
  % pos_acc_values = zeros(1,1);
  % neg_acc_values = zeros(1,1);
   m_pos = size(PosTrainingData,1);
   m_neg = size(NegTrainingData,1);
   
  
       
       pos_perm_mask = randperm(m_pos);
       neg_perm_mask = randperm(m_neg);
       
       %We Remove the Labels(first column) and split into positive label
       %and negative label matrices
       PosTrainingData(2:end) = featureNormalize(PosTrainingData(2:end)')';
       PosTrainingData(2:end) = featureNormalize(PosTrainingData(2:end)')';
       
       
       pos_train_data = PosTrainingData(pos_perm_mask(1:ceil(0.6*m_pos)),2:end);
       neg_train_data = NegTrainingData(neg_perm_mask(1:ceil(0.6*m_neg)),2:end);
       
       pos_val_data = PosTrainingData(pos_perm_mask(ceil(0.6*m_pos)+1:ceil(0.8*m_pos)),2:end);
       neg_val_data = NegTrainingData(neg_perm_mask(ceil(0.6*m_neg)+1:ceil(0.8*m_neg)),2:end);
       
       pos_test_data = PosTrainingData(pos_perm_mask(ceil(0.6*m_pos)+1:ceil(0.8*m_pos)),2:end);
    %   pos_test_y = PosTrainingData(pos_perm_mask(ceil(0.6*m_pos)+1:ceil(0.8*m_pos)),1);
       neg_test_data = NegTrainingData(neg_perm_mask(ceil(0.8*m_neg)+1:ceil(m_neg)),2:end);
    %    neg_test_y = NegTrainingData(neg_perm_mask(ceil(0.6*m_neg)+1:ceil(0.8*m_neg)),1);
       
       options = optimset('GradObj', 'on', 'MaxIter', 400);
       min_cost_set = 0;
       for power = 1:4
           
           train_X_pos = GetPolynomialFeatureVector(transpose(pos_train_data),power);
           train_X_neg = GetPolynomialFeatureVector(transpose(neg_train_data),power);
              n = size(train_X_pos,1);  %Number of features without the 1 
              
     if size(train_X_pos,1) ~= size(train_X_neg,1)
         
        fprintf("Error,Negative Matrix and Positive Matrix not equal in size "); 
     end
           
           val_X_pos = GetPolynomialFeatureVector(transpose(pos_val_data),power);
           val_X_neg = GetPolynomialFeatureVector(transpose(neg_val_data),power);
          
 
          
        
           
           for lambda = [0 0.001 0.003 0.01 0.03 0.1 0.3 1 3 10]
               
               

          %  Run fminunc to obtain the optimal theta
          %  This function will return theta and the cost 
          initial_theta = zeros(n , 1);
         [theta, ~] = fminunc(@(t)(MultiplicativeCostFunction(t, train_X_pos, train_X_neg,lambda,multiplier)), initial_theta, options);
         [J,~] = MultiplicativeCostFunction(theta, val_X_pos, val_X_neg,0,multiplier);
         if min_cost_set == 0
             min_cost = J;
            best_power = power;
            best_theta = theta;
         else
             if J<min_cost
               min_cost = J;
               best_power = power;
               best_theta = theta;  
                 
             end
         end

               
           end
       end
       
           test_X_pos = GetPolynomialFeatureVector(transpose(pos_test_data),best_power);
           test_X_neg = GetPolynomialFeatureVector(transpose(neg_test_data),best_power);
         

           
           
           pos_result = transpose(best_theta)*test_X_pos;
           neg_result = transpose(best_theta)*test_X_neg;
           
           pos_result
           
           neg_result
           
           pos_result = (pos_result >= 0.5);
           neg_result = (neg_result >= 0.5);
           

           
           POS_ACCURACY = (sum(pos_result == 1)/numel(pos_result));  %Calculate Accuracy
           NEG_ACCURACY = (sum(neg_result == 0)/numel(neg_result));
           
         
  
 
end