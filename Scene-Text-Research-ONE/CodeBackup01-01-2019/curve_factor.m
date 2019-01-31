function factor = curve_factor(matrix)

 curve_threshold = 0.1; %Reduce to include more 
  
 B = bwboundaries(matrix,'noholes');
 
 x = B(1);
 
 y = freemancc(x{:});
 
 factor = Curvitivity(y.ChainCode,curve_threshold);
 
 
end