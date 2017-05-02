function Disparity = disparityMap(A,B, disparityRange,blockSize)

    Agray = mean(A, 3);
    Bgray = mean(B, 3);
    Disparity = zeros(size(Agray), 'single');
    [row, col] = size(Agray);
    for r = 1:row
       
        lowerBoundFrameRow = max(1, r - (blockSize-1)/2);
        upperBoundFrameRow = min(row, r + (blockSize-1)/2);
        for c = 1:col
            lowerBoundCol = max(1, c - (blockSize-1)/2);
            upperBoundCol = min(col, c + (blockSize-1)/2);

            maxdisparity = min(disparityRange, col - upperBoundCol);

            template = Bgray(lowerBoundFrameRow:upperBoundFrameRow, lowerBoundCol:upperBoundCol);

            numBlocks = maxdisparity + 1;
            blockDiffs = zeros(numBlocks, 1);
            for (i = 0 : maxdisparity)
                block = Agray(lowerBoundFrameRow:upperBoundFrameRow, (lowerBoundCol + i):(upperBoundCol + i));
                blockIndex = i + 1;
                 X = template - block;
                blockDiffs(blockIndex, 1) = sum(X(:).^2);
            end

           [~, IDX] = min(blockDiffs);

            d = IDX - 1;

            Disparity(r, c) = d;

        end

    end

end

