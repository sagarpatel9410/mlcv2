A = imread('1.jpg');
B = imread('2.jpg');

grayA = single(rgb2gray(A));
grayB = single(rgb2gray(B));

ha = detectHarrisFeatures(grayA);
hb = detectHarrisFeatures(grayB);

[patchA,validPointsA] = extractFeatures(grayA,ha, 'Method', 'Block', 'BlockSize', 31);
descriptorsA = hist(patchA',121)';

[patchB,validPointsB] = extractFeatures(grayB,hb, 'Method', 'Block', 'BlockSize', 31);
descriptorsB = hist(patchB',121)';

%Match Features
correspondance = matchFeatures(descriptorsA,descriptorsB, 'Unique', 1, 'MatchThreshold', 100);
matchedPoints1 = validPointsA(correspondance(:,1),:);
matchedPoints2 = validPointsB(correspondance(:,2),:);
showMatchedFeatures(A,B,matchedPoints1,matchedPoints2);

H = findHomography(matchedPoints1.Location',matchedPoints2.Location');

%projecting point coordinates from image B to A
figure;
ih = imagehomog(rgb2gray(B),H,'k');
imshow(uint8(ih));



