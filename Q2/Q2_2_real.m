IA = imread('1_9.jpg');
IB = imread('2_1.jpg');

grayIA = im2single(rgb2gray(IA));
grayIB = im2single(rgb2gray(IB));

harrisA = detectHarrisFeatures(grayIA);
harrisB = detectHarrisFeatures(grayIB);

%Find Descriptors

[patchA,validPointsA] = extractFeatures(grayIA,harrisA, 'Method', 'Block', 'BlockSize', 31);
descriptorsA = hist(patchA',121)';

[patchB,validPointsB] = extractFeatures(grayIB,harrisB, 'Method', 'Block', 'BlockSize', 31);
descriptorsB = hist(patchB',121)';

%Match Features
correspondance = matchFeatures(descriptorsA,descriptorsB, 'Unique', 1, 'MatchThreshold' ,100);
matchedPoints1 = validPointsA(correspondance(:,1),:);
matchedPoints2 = validPointsB(correspondance(:,2),:);
showMatchedFeatures(IA,IB,matchedPoints1,matchedPoints2);


