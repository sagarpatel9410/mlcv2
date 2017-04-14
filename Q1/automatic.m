clear

%get image data, store in images struct
srcFiles = dir('Image-Data\tsukuba\*.ppm');
for i = 1:length(srcFiles)
  directory = strcat('Image-Data\tsukuba\', srcFiles(i).name);
  images{i} = imread(directory);

end
%%
%Example of question 1b on how to run the functions. Only using images 1
%and 2

[y,x] = harrisCalculate(rgb2gray(images{1}),0.01);
points = cornerPoints([x,y]);
imshow(images{1})
hold on
plot(points);
figure
image1descriptors = findDescriptors(rgb2gray(images{1}), y, x);

[y,x] = harrisCalculate(rgb2gray(images{2}),0.01);
points = cornerPoints([x,y]);
imshow(images{1})
hold on
plot(points);

image2descriptors = findDescriptors(rgb2gray(images{2}), y, x);

%column 1 is image A index, column 2 is image B
correspondants = nearestNeighbourMatching(rgb2gray(images{1}), rgb2gray(images{2}));

%%