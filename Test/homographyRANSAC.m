function H = homographyRANSAC(xypt,xybpt)

% xypt = matchedPoints1.Location';
% xybpt = matchedPoints2.Location';

attempts = 20;
datapts = cell(1,attempts);

%Function created with aid of http://6.869.csail.mit.edu/fa12/lectures/lecture13ransac/lecture13ransac.pdf

for i = 1:attempts
    %Select 4 random points 
    pts = randperm(size(xypt,2),4);
    xy = xypt(:,pts);
    xyb = xybpt(:,pts);
    %Compute Homography
    for j = 1:size(xy,2)
        
        A(2*j-1,:) = [xy(1,j), xy(2,j), 1, 0, 0,0,-xy(1,j)*xyb(1,j), -xyb(1,j)*xy(2,j), -xyb(1,j)];
        A(2*j,:) = [0,0,0, xy(1,j), xy(2,j),1, -xy(1,j)*xyb(2,j),-xyb(2,j)*xy(2,j), -xyb(2,j)];
        
    end
    
    [u,d,v] = svd(A'*A);
     h = v(:,9);
     H = reshape(h,3,3)';
     H = H/H(end);
     
     %Compute Inliers
     mP1 = [xypt' ones(size(xypt,2),1)]';
     np = H*mP1;
     
     np = np(1:2,:)./repmat(np(3,:),2,1);
     dist = sum((xybpt-np).^2,1);
     inliers = find(dist < 4);
     inl(i) = length(inliers);
   	 datapts{i} = inliers;

end
max(inl)
%Use iteration with most number of inliers
inli = max(inl)
index = find(inl == max(inl));
pts = datapts{index};
xy = xypt(:,pts);
xyb = xybpt(:,pts);
%Compute Homography
for j = 1:size(xy,2)

    A(2*j-1,:) = [xy(1,j), xy(2,j), 1, 0, 0,0,-xy(1,j)*xyb(1,j), -xyb(1,j)*xy(2,j), -xyb(1,j)];
    A(2*j,:) = [0,0,0, xy(1,j), xy(2,j),1, -xy(1,j)*xyb(2,j),-xyb(2,j)*xy(2,j), -xyb(2,j)];

end

[u,d,v] = svd(A'*A);
 h = v(:,9);
 H = reshape(h,3,3)';
 H = H/H(end);

end

