clear

%get image data, store in images struct
srcFiles = dir('Image-Data\tsukuba\*.ppm');
for i = 1:length(srcFiles)
  directory = strcat('Image-Data\tsukuba\', srcFiles(i).name);
  images{i} = imread(directory);

end


[y,x] = harrisCalculate(rgb2gray(images{1}),0.01);
points = cornerPoints([x,y]);
imshow(images{1})
hold on
plot(points);

findDescriptors(rgb2gray(images{1}), y, x)