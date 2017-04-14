function [corres] = nearestNeighbourMatching( descriptorA, descriptorB )

%returns a list of indexes corresponding to the x,y coordinates where the
%descriptors of A and B are pairs


%find nearest neighbour between image A and image B
neighboursA = knnsearch(descriptorB,descriptorA);
neighboursB = knnsearch(descriptorA,descriptorB);

%obtain a list of correspondences between image A and B. 

for i = 1:(size(neighboursA,1))
    
    if (i == neighboursB(neighboursA(i)) )
        corres(i,1) = i;
        corres(i,2) = neighboursA(i);
    end

end

corres(all(corres==0,2),:)=[];
