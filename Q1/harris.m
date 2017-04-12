function locations = harris(image, alpha, threshold)

image = im2single(image);
%find image derivative

dx = imfilter(image,[-1 0 1] ,'replicate','same','conv');
dy = imfilter(image,[-1 0 1]','replicate','same','conv');

%square of image derivatives
XSqu = dx.^2;
YSqu = dy.^2;
XY = dx .* dy;

%apply blur filter
blur_mask =  repmat([0.03 0.105 0.222 0.286 0.222 0.105 0.03], 7,1)./7;

gX = imfilter(XSqu,blur_mask,'replicate','same','conv');
gY =  imfilter(YSqu,blur_mask,'replicate','same','conv');
gXY =  imfilter(XY,blur_mask,'replicate','same','conv');

%Harris calculation
harr = (gX.*gY) - (gXY.^2) - alpha*(gX + gY).^2;

%find locations
%Not to sure how to implement this, the chosen method gives best results
locations = vision.internal.findPeaks(harr, 0.01);

