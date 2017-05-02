function [dMap] = my_disparity(F,imA,imB, grain)

% for every patch and its centre
% find corresponding epipolar line on the second image
% for every point on that line calculate SSD between original patch and new
% patch store the euclidean distance info on the location of the patch
% filter and resize disparity map

%% Check input validity

[m1,n1] = size(imA);
[m2,n2] = size(imB);
if m2 ~= m1 || n2 ~= n1
    error('Images should have the same size')
end

if mod(grain,2) == 0
    error('Grain should be an odd number')
end

%% Find number of patches for the image A

patch_num_hor = floor(n1/grain); %length((grain+1)/2:grain:n1);
patch_num_ver = floor(m1/grain);
patch_num = patch_num_hor * patch_num_ver;

%% Find Patch Centres

pcentre_x(1:patch_num_hor,1) = (grain+1)/2:grain:n1-(grain-1)/2; % x centres
pcentre_x = repmat(pcentre_x,patch_num_ver,1); % pattern repeats for ever row
pcentre_y = [reshape( repmat( [0:patch_num_ver-1],patch_num_hor,1 ), 1, [] )*grain+(grain+1)/2]';
pcentre = [pcentre_x, pcentre_y, ones(patch_num,1)]';

%% For every patch_centre find corresponding epipolar line in image B

epiLine = F*pcentre; % CHECK IF THATS THE CORRECT ONE
% epiLine = F'*pcentre; OR THIS ONE

%% For every patch and its epipolar line find the closest matching patch

x = (grain+1)/2:n1-(grain-1)/2;

match_coord = zeros(patch_num,2);

for i = 1:patch_num
    a = epiLine(1,i);
    b = epiLine(2,i);
    c = epiLine(3,i);
    
    y = round((-a*x-c)/b);
    new_pcentre = [x', y'];

    patchA = imA(pcentre(2,i)-(grain-1)/2:pcentre(2,i)+(grain-1)/2,pcentre(1,i)-(grain-1)/2:pcentre(1,i)+(grain-1)/2);
    
    % remove centres that are outiside or too close to the image border
    new_pcentre(new_pcentre(:,2) < (grain+1)/2,:) = [];
    new_pcentre(new_pcentre(:,2) > m1-(grain-1)/2,:) = [];
   
    % construct patches
    num_tests = size(new_pcentre,1);
    SSD_Er = zeros(num_tests,1);
    for j = 1:num_tests
        patchB = imB(new_pcentre(j,2)-(grain-1)/2:new_pcentre(j,2)+(grain-1)/2,new_pcentre(j,1)-(grain-1)/2:new_pcentre(j,1)+(grain-1)/2);
        
        SSD = (patchA - patchB).^2;
        SSD_Er(j) = sum(SSD(:));
        
    end
    
    [~, match] = min(SSD_Er);
    
    if num_tests ~= 0
        match_coord(i,1:2) = new_pcentre(match,:);
    end
    
    disp(100*i/patch_num)
end

dispar = pcentre(1:2,:)' - match_coord;
dMap = [reshape(dispar(:,1),[patch_num_hor patch_num_ver])]';
dMap = medfilt2(dMap,[grain+2 grain+2]);
dMap = imresize(dMap,grain,'method','lanczos3');

end