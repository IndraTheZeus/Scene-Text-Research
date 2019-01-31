function [BinSizes] = generateBins(MAX_DISTANCE)

      x = 0;
      BinSizes = zeros(1,12);
      BinSizes(1,1) = ceil(sqrt(MAX_DISTANCE - x));
      x = BinSizes(1,1);
      i = 2;
      while(x<MAX_DISTANCE/2)
         x = ceil(x+sqrt(MAX_DISTANCE - x)); 
         BinSizes(1,i) = x;
         i = i+1;
      end
end