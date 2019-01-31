function PolyVector = GetPolynomialFeatureVector(X,power)

  %Input Needs to have data as row wise form
     %Features: 
    % 1. Del(No. of Pixels Bin i - Bin i + SubBin(i-1,i+1))/Total No. of Pixels
    % 2. Del(No. of Pixels Bin i - Bin(i,i+1,i-1))/Total No. of Pixels
    % 3. No. of Holes
    % 4. Del(No. of Holes Bin i - Bin i + SubBin(i-1,i+1))
    % 5. Del(No. of Holes Bin i - Bin i + Bin(i-1,i+1))
    % 6. Density 
    % 7. Del(Change of Density of Bin i - Bin i + SubBin(i-1,i+1))/Density
    % 8. Del(Change of Density of Bin i - Bin i + Bin(i,i-1,i+1))/Density
    % 9. Number of Pixels
    % 10. BinSize
    % 11.Lower Range Increment Check   (Eliminated)
    % 12. Higher Range Increment Check  (Eliminated)
    
    %13. 1. * 9.
    % 14. 2. * 9.
    %15. 1. / 10.
    % 16. 2. / 10.
    
    %%Normalized Feature Vectors with Polynomial and multiplied features
    
    X_mod = [X(:,1:10) X(:,1).*X(:,9) X(:,2).*X(:,9) X(:,1)./X(:,10) X(:,2)./X(:,10)];
    PolyVector = X_mod;
    
    for i = 2:power
        
       PolyVector = [PolyVector X_mod.^i]; 
    end
    
    PolyVector = [ones(size(PolyVector,1),1) PolyVector];
    

end