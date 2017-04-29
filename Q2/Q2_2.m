clear
close all

%Estimate fundamental matrix using list of correspondants from 1.2
Q1_2;

[F, inliers] = estimateFundamentalMatrix(matchedPoints1.Location,matchedPoints2.Location);

figure;
imshow(IA);
title('Inliers and Epipolar Lines in First Image'); hold on;
plot(matchedPoints1.Location(inliers,1),matchedPoints1.Location(inliers,2),'go')

epiLines = epipolarLine(F',matchedPoints2.Location(inliers,:));
points = lineToBorderPoints(epiLines,size(IA));
line(points(:,[1,3])',points(:,[2,4])');

figure;
imshow(IB);
title('Inliers and Epipolar Lines in Second Image'); hold on;
plot(matchedPoints2.Location(inliers,1),matchedPoints2.Location(inliers,2),'go')

epiLines = epipolarLine(F,matchedPoints1.Location(inliers,:));
points = lineToBorderPoints(epiLines,size(IB));
line(points(:,[1,3])',points(:,[2,4])');
truesize;

%Calculate Diparity map between image A and B

disparityMap = disparity(rgb2gray(IA),rgb2gray(IB),'BlockSize',...
    15);
figure
imshow(disparityMap,disparityRange);
title('Disparity Map');
colormap jet
colorbar

%Calculate depth Map
%We know the baseline and focal length


