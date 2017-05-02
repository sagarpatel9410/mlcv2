clear

%Load images into struct
srcFiles = dir('Image-Data\tsukuba\*.ppm');
for i = 1:length(srcFiles)
  directory = strcat('Image-Data\tsukuba\', srcFiles(i).name);
  images{i} = imread(directory);
end

%Load 2 images 
IA = images{1};
grayIA = im2single(rgb2gray(IA));

IB = images{2};
grayIB = im2single(rgb2gray(IB));

%Detect Features using Harris corner detection

[yA,xA] = harrisCalculate(grayIA,0.01);
harrisA = cornerPoints([xA,yA]);

[yB,xB] = harrisCalculate(grayIB,0.01);
harrisB = cornerPoints([xB,yB]);

harrisA = detectHarrisFeatures(grayIA);
harrisB = detectHarrisFeatures(grayIB);

%Find Descriptors

[patchA,validPointsA] = extractFeatures(grayIA,harrisA, 'Method', 'Block', 'BlockSize', 31);
descriptorsA = hist(patchA',255)';

[patchB,validPointsB] = extractFeatures(grayIB,harrisB, 'Method', 'Block', 'BlockSize', 31);
descriptorsB = hist(patchB',255)';

%Match Features
correspondance = nearestNeighbourMatching(descriptorsA,descriptorsB);
matchedPoints1 = validPointsA(correspondance(:,1),:);
matchedPoints2 = validPointsB(correspondance(:,2),:);
showMatchedFeatures(IA,IB,matchedPoints1,matchedPoints2);

