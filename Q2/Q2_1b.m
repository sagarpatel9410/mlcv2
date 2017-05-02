clear
A = imread('2.jpg');
B = imread('3.jpg');

grayA = im2single(rgb2gray(A));
grayB = im2single(rgb2gray(B));

% 
% [fa, da] = vl_sift(grayA) ;
% [fb, db] = vl_sift(grayB) ;
% [matches, scores] = vl_ubcmatch(da, db) ;
% 
% matchedPoints1 = fa(1:2,matches(1,:))';
% matchedPoints2 = fb(1:2,matches(2,:))';
% 
% figure(1); showMatchedFeatures(A,B,matchedPoints1,matchedPoints2);
% 
% H = homographyRANSAC(matchedPoints1',matchedPoints2');
% mP1 = [matchedPoints1 ones(size(matchedPoints1,1),1)]';
% mP2 = [matchedPoints2 ones(size(matchedPoints2,1),1)]';
% 
% newPoints = H*mP1;
% dist1 = mP1(1:2,:) - mP2(1:2,:);
% dist = newPoints(1:2,:) - mP2(1:2,:);
% HA1 = mean(sqrt(abs(dist1(1,:).^2 - dist1(2,:).^2)));
% HA = mean(sqrt(abs(dist(1,:).^2 - dist(2,:).^2)));
% 


% 
% ha = detectHarrisFeatures(grayA);
% hb = detectHarrisFeatures(grayB);
% 
% [patchA,validPointsA] = extractFeatures(grayA,ha, 'Method', 'Block', 'BlockSize', 31);
% descriptorsA = hist(patchA',121)';
% 
% [patchB,validPointsB] = extractFeatures(grayB,hb, 'Method', 'Block', 'BlockSize', 31);
% descriptorsB = hist(patchB',121)';
% 
% %Match Features
% correspondance = matchFeatures(descriptorsA,descriptorsB, 'Unique', 1, 'MatchThreshold', 100);
% matchedPoints1 = validPointsA(correspondance(:,1),:);
% matchedPoints2 = validPointsB(correspondance(:,2),:);
% showMatchedFeatures(A,B,matchedPoints1,matchedPoints2);
% 
% H = findHomography(matchedPoints1.Location',matchedPoints2.Location');
% 
% mP1 = [matchedPoints1.Location ones(size(matchedPoints1.Location,1),1)]';
% mP2 = [matchedPoints2.Location ones(size(matchedPoints2.Location,1),1)]';
% 
% newPoints = inv(H)*mP2;
% removeU = find(newPoints(1,:) > 0);
% np = newPoints(:,removeU);
% removeU = find(np(2,:) > 0);
% np = np(:,removeU);
% 
% np = cornerPoints(np(1:2,:)');
% 
% dist = newPoints(1:2,:) - mP1(1:2,:);
% HA1 = mean(sqrt(abs(dist(1,:).^2 - dist(2,:).^2)));
% 
% figure;
% ih = imagehomog(rgb2gray(B),inv(H),'k');
% imshow(uint8(ih));


load('manual.mat');

matchedPoints1 = cornerPoints([xone;yone]');
matchedPoints2 = cornerPoints([xtwo;ytwo]');

imshow(A)
hold on
plot(matchedPoints1);

figure
imshow(B)
hold on
plot(matchedPoints2);



H = findHomography(matchedPoints1.Location',matchedPoints2.Location');
mP1 = [matchedPoints1.Location ones(size(matchedPoints1.Location,1),1)]';
mP2 = [matchedPoints2.Location ones(size(matchedPoints2.Location,1),1)]';

newPoints = H*mP1;
dist1 = mP1(1:2,:) - mP2(1:2,:);
dist = newPoints(1:2,:) - mP2(1:2,:);
HA1 = mean(sqrt(abs(dist1(1,:).^2 - dist1(2,:).^2)));
HA = mean(sqrt(abs(dist(1,:).^2 - dist(2,:).^2)));

% figure;
% ih = imagehomog(rgb2gray(B),inv(H),'k');
% imshow(uint8(ih));
