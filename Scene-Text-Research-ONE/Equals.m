function truth = Equals(matrixA,matrixB)

truth = 1;
for i = 1:numel(matrixA)
    if matrixA(i)~=matrixB(i)
        truth = 0;
        break;
    end
end