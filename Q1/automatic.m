clear

%get image data, store in images struct
srcFiles = dir('Image-Data\tsukuba\*.ppm');
for i = 1:length(srcFiles)
  directory = strcat('Image-Data\tsukuba\', srcFiles(i).name);
  images{i} = imread(directory);

  %convert image to grayscale
  images{i} = rgb2gray(images{i});
end
% 
%   points = cornerPoints(harris(images{1},0.04,0.01));
%   imshow(images{1})
%   hold on
%   plot(points);
  
  
