function [r,c] = harrisCalculate(I, quality)

%Calculate derivatives of image
x_mask = [-1 0 1];
y_mask = x_mask';
A = imfilter(I,x_mask,'replicate','same','conv');
B = imfilter(I,y_mask,'replicate','same','conv');

%Remove Uneceesary gradients at border
A = A(2:end-1,2:end-1);
B = B(2:end-1,2:end-1);

%Square of derivatives
C = A .* B;
A = A .* A;
B = B .* B;

%Applying blur
blur =  [0.03 0.105 0.222 0.286 0.222 0.105 0.03];
%blur = fspecial('gaussian', 5,5/3);

A = imfilter(A,blur,'replicate','full','conv');
B = imfilter(B,blur,'replicate','full','conv');
C = imfilter(C,blur,'replicate','full','conv');

% Clip to image size
removed = max(0, (size(blur,1)-1) / 2 - 1);
A = A(removed+1:end-removed,removed+1:end-removed);
B = B(removed+1:end-removed,removed+1:end-removed);
C = C(removed+1:end-removed,removed+1:end-removed);

%Calculate Harris
k = 0.04; 
metric = (A .* B) - (C .^ 2) - k * ( A + B ) .^ 2;
maxharr = quality * max(metric(:));

location = (metric > imdilate(metric, [1 1 1; 1 0 1; 1 1 1]));
location(metric < maxharr) = 0;

% Exclude points on the border
location(1, :) = 0;
location(end, :) = 0;
location(:, 1) = 0;
location(:, end) = 0;
    
%Find Location of interest points
[r,c] = find(location);

end

[yA,xA] = harrisCalculate(grayIA,0.01);
harrisA = cornerPoints([xA,yA]);
