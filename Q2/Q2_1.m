clear

%% Load images into struct
srcFiles = dir('Image-Data\tsukuba\*.ppm');
for i = 1:length(srcFiles)
  directory = strcat('Image-Data\tsukuba\', srcFiles(i).name);
  images{i} = imread(directory);
end

%Load images 2 images
IA = images{1};
IA = double(rgb2gray(IA));

IB = images{2};
IB = double(rgb2gray(IB));

%% Q2_1_A still to do.

%% Q2_1_B 
    
%Select Manual Interest Points
figure(1)
subplot(211)
imshow(IA,[])
subplot(212)
imshow(IB,[])
        
N = 20;

for i = 1:N
    subplot(211)
    title('Select a Point Here')
    [x1(i),y1(i)] = ginput(1);
    hold all
    scatter(x1(i),y1(i),'o','filled')
    title('')

    subplot(212)
    title('Select a Point Here')
    [x2(i),y2(i)] = ginput(1);
    hold all
    scatter(x2(i),y2(i),'o','filled')
    title('')
end

p1 = [y1 ; x1];
p2 = [y2 ; x2];

%Estimate Manual homography
[HMAN] = findHomography(p1,p2);
[ihMAN]=imagehomog(imB,HMAN);
imshow(uint8(ihMAN));
title('Manual Homography')

%Automatic Homography

harrisA = detectHarrisFeatures(IA);
harrisB = detectHarrisFeatures(IB);

%Find Descriptors

[patchA,validPointsA] = extractFeatures(IA,harrisA, 'Method', 'Block', 'BlockSize', 31);
descriptorsA = hist(patchA',255)';

[patchB,validPointsB] = extractFeatures(IB,harrisB, 'Method', 'Block', 'BlockSize', 31);
descriptorsB = hist(patchB',255)';

%Match Features
correspondance = matchFeatures(descriptorsA,descriptorsB,'Method','Approximate','MatchThreshold',100,'Unique',true);
matchedPoints1 = validPointsA(correspondance(:,1),:);
matchedPoints2 = validPointsB(correspondance(:,2),:);

HAUTO = findHomography(matchedPoints1.Location',matchedPoints2.Location');
[ihAUTO]=imagehomog(imB,HAUTO);
imshow(uint8(ihAUTO));
title('Auto Homography')

%% Q2_1_C

harrisA = detectHarrisFeatures(IA);
harrisB = detectHarrisFeatures(IB);

%Find Descriptors

[patchA,validPointsA] = extractFeatures(IA,harrisA, 'Method', 'Block', 'BlockSize', 31);
descriptorsA = hist(patchA',255)';

[patchB,validPointsB] = extractFeatures(IB,harrisB, 'Method', 'Block', 'BlockSize', 31);
descriptorsB = hist(patchB',255)';


%Match Features 
corr = matchFeatures(descriptorsA,descriptorsB,'Method','Approximate','MatchThreshold',100,'Unique',true);

for i = 3:length(corr)
    correspondance = corr(1:i,:);
    matchedPoints1 = validPointsA(correspondance(:,1),:);
    matchedPoints2 = validPointsB(correspondance(:,2),:);

    H = findHomography(matchedPoints1.Location',matchedPoints2.Location');

    %calculate HA
    mP1 = [matchedPoints1.Location ones(size(matchedPoints1.Location,1),1)]';
    mP2 = [matchedPoints2.Location ones(size(matchedPoints2.Location,1),1)]';

    newPoints = H*mP1;
    dist = newPoints(1:2,:) - mP2(1:2,:);
    HA1(i-2) = mean(sqrt(abs(dist(1,:).^2 - dist(2,:).^2)));
    
end

