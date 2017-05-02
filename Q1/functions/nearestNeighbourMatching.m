function [corres] = nearestNeighbourMatching( descriptorA, descriptorB )

%returns a list of indexes corresponding to the x,y coordinates where the
%descriptors of A and B are pairs

loopSize = size(descriptorA,1);
loopSize2 = size(descriptorB,1);

%normalise
descriptorA = descriptorA';
descriptorB = descriptorB';

descriptorA = normalize(descriptorA);
descriptorB = normalize(descriptorB);

descriptorA = descriptorA';
descriptorB = descriptorB';

for i = 1:loopSize
    for j = 1:loopSize2
        X = descriptorA(i,:) - descriptorB(j,:);
        dist(j) = sum(X(:).^2);
    end
     
    [metric, pair] = min(dist);
    dist(pair) = inf;
    metric2 = min(dist);
    corres(i,1) = i;
    corres(i,2) = pair;
    corres(i,3) = metric;
    corres(i,4) = metric2;
    
end

%Remove Ambiguous matches
%Handle divide by 0

zeroIdx = corres(:, 4) < 1e-6;
corres(zeroIdx,3:4) = 1;

ratio = corres(:, 3) ./ corres(:,4);
idx = ratio <= 0.6;

corres = corres(idx,:);


newcorres = zeros(1,4);

for i = 1:size(corres,1)
    
    duplicates = find(corres(:,2) == corres(i,2));
    v = corres(duplicates,3) == min(corres(duplicates,3));
    newcorres = [newcorres;corres(duplicates(v),:)];
end 

corres = unique(newcorres(:,:), 'rows');
corres(1,:) = [];

end

function X = normalize(X)
Xnorm = sqrt(sum(X.^2, 1));
X = bsxfun(@rdivide, X, Xnorm);

% Set effective zero length vectors to zero
X(:, (Xnorm <= eps(single(1))) ) = 0;

end