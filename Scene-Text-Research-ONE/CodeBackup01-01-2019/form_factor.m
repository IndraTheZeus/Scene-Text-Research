function factor = form_factor(matrix)

[row,col] = size(matrix);

 factor = max(row/col,col/row);


end