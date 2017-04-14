function loc = harrisCalculate(I, quality)

I = im2single(I);

%Calculate derivatives of image
x_mask = repmat([-1 0 1], 3,1);
y_mask = x_mask';
A = conv2(I, x_mask, 'same');
B = conv2(I, y_mask, 'same');

%Remove Uneceesary gradients at border
A = A(2:end-1,2:end-1);
B = B(2:end-1,2:end-1);

%Square of derivatives
C = A .* B;
A = A .* A;
B = B .* B;

%Applying blur
% blur =  [0.03 0.105 0.222 0.286 0.222 0.105 0.03];
blur = fspecial('gaussian', 5,5/3);

A = conv2(A, blur, 'same');
B = conv2(B, blur, 'same');
C = conv2(C, blur, 'same');

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
idx = find(location);
[loc(:, 2), loc(:, 1)] = ind2sub(size(location), idx);
end