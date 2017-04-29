clear
Q1_2;

%Estimating Homography Matrix using Ransac Matlab method
H = findHomography(matchedPoints1.Location',matchedPoints2.Location');

%Estimate Fundamental Matrix
[F, inliers] = estimateFundamentalMatrix(matchedPoints1.Location,matchedPoints2.Location);

%projecting point coordinates from image B to A
figure;
ih = imagehomog(grayIB,H,'k');
imshow(uint8(ih));

%calculate HA
mP1 = [matchedPoints1.Location ones(size(matchedPoints1.Location,1),1)]';
mP2 = [matchedPoints2.Location ones(size(matchedPoints2.Location,1),1)]';

newPoints = H*mP1;
dist = newPoints(1:2,:) - mP2(1:2,:);
HA1 = mean(sqrt(abs(dist(1,:).^2 - dist(2,:).^2)));

%Calculate Epipolar Line
figure
imshow(grayIA,[])
hold all
plot(matchedPoints1.Location(inliers,1),matchedPoints1.Location(inliers,2),'go')
epiLines = epipolarLine(F',matchedPoints2.Location(inliers,:));
points = lineToBorderPoints(epiLines,size(grayIA));
line(points(:,[1,3])',points(:,[2,4])');
title('Epipolar Lines and Matched Points')

