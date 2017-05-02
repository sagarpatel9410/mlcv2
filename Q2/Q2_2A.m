clear
A = imread('OwnImages/1_1.jpg');
B = imread('OwnImages/2_6.jpg');

grayA = single(rgb2gray(A));
grayB = single(rgb2gray(B));

[fa, da] = vl_sift(grayA) ;
[fb, db] = vl_sift(grayB) ;
[matches, scores] = vl_ubcmatch(da, db) ;

matchedPoints1 = fa(1:2,matches(1,:))';
matchedPoints2 = fb(1:2,matches(2,:))';

figure(1); showMatchedFeatures(A,B,matchedPoints1,matchedPoints2);

[F, inliers] = estimateFundamentalMatrix(matchedPoints1,matchedPoints2);

figure
imshow(A);
title('Inliers and Epipolar Lines in Image A'); hold on;
plot(matchedPoints1(inliers,1),matchedPoints1(inliers,2),'go')

%Calculate epipolar lines for IA
nPts = size(matchedPoints2(inliers,:), 1);
lines = [matchedPoints2(inliers,:), ones(nPts, 1)] * F';
points = lineToBorderPoints(lines,size(A));
line(points(:,[1,3])',points(:,[2,4])');

figure
imshow(B);
title('Inliers and Epipolar Lines in Image B'); hold on;
plot(matchedPoints2(inliers,1),matchedPoints2(inliers,2),'go')

nPts = size(matchedPoints1(inliers,:), 1);
lines = [matchedPoints1(inliers,:), ones(nPts, 1)] * F;
points = lineToBorderPoints(lines,size(B));
line(points(:,[1,3])',points(:,[2,4])');
truesize;

%% Disparity Map
%For each pixel in Image A 
close all
disp = disparityMap(A,B, 64,7);
focal = 0.0028;
dist = 0.20;
depthMap = focal*dist./disp;
depthMap(find(depthMap(:) > 10^4)) = 0;
depthMap(find(depthMap(:) < -10^4)) = 0;
surf(depthMap,'edgecolor','none')



