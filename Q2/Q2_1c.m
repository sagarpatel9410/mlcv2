clear
A = imread('2.jpg');
B = imread('3.jpg');

grayA = im2single(rgb2gray(A));
grayB = im2single(rgb2gray(B));

[fa, da] = vl_sift(grayA) ;
[fb, db] = vl_sift(grayB) ;
[matches, scores] = vl_ubcmatch(da, db) ;

matchedPoints1 = fa(1:2,matches(1,:))';
matchedPoints2 = fb(1:2,matches(2,:))';

[r,~] = size(matchedPoints1);

for i = 1:20
    rng(i);
    for j = 4:r    

H = homographyRANSAC(matchedPoints1(1:j,:)',matchedPoints2(1:j,:)');
mP1 = [matchedPoints1 ones(size(matchedPoints1,1),1)]';
mP2 = [matchedPoints2 ones(size(matchedPoints1,1),1)]';

newPoints = H*mP1;
dist = newPoints(1:2,:) - mP2(1:2,:);
HA(i,j) = mean(sqrt(abs(dist(1,:).^2 - dist(2,:).^2)));

    end
end
