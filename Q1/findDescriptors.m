function descriptors = findDescriptors(I, y, x)

descriptors = zeros(size(y,1), 256);

for i = 1:size(y,1)
    
    patch = crop_patch(I, y(i), x(i));
    descriptors(i,:) = imhist(patch)';
    
end

end

function patch = crop_patch(I, y, x)

[r,c] = size(I);

if x <= 15 
    x = 16;
end
if x > c - 16
    x = c - 16;
end
if y <= 15
   y = 16;
end
if y > r - 16
    y = r - 16;
end

patch = I(y-15:y+16, x-15:x+16);

end