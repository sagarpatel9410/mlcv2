clear

%Load images into struct

srcFiles = dir('Image-Data\tsukuba\*.ppm');
for i = 1:length(srcFiles)
  directory = strcat('Image-Data\tsukuba\', srcFiles(i).name);
  images{i} = imread(directory);
end

figure(1);
imshow(images{1});
title('Image 1')
figure(2);
imshow(images{2});
title('Image 2')

%Select K interest points
K = 10;
for i = 1:K
    figure(1)
    [xone(i),yone(i)] = ginput(1);
    hold all;
    scatter(xone(i),yone(i),'o','filled')
    
    figure(2)
    [xtwo(i),ytwo(i)] = ginput(1);
    hold all;
    scatter(xtwo(i),ytwo(i),'o','filled')
end