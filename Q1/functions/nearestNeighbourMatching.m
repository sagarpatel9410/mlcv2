function [corres] = nearestNeighbourMatching( descriptorA, descriptorB, threshold )

%returns a list of indexes corresponding to the x,y coordinates where the
%descriptors of A and B are pairs

loopSize = size(descriptorA,1);
loopSize2 = size(descriptorB,1);

for i = 1:loopSize
    for j = 1:loopSize2
        dist(j) = norm(descriptorA(i,:) - descriptorB(j,:));
    end
       
    [metric, pair] = min(dist);
    corres(i,1) = i;
    corres(i,2) = pair;
    corres(i,3) = metric;
    
end
end
