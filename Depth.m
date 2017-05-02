A = imread('OwnImages/1_1.jpg');
B = imread('OwnImages/2_6.jpg');

disp = disparityMap(A,B, 64,7);

%%
load('Disparity.mat')
focal = 0.0036;
dist = 0.20;
dMap2 = (disp - min(disp(:)))/(max(disp(:)) - min(disp(:)));
d = focal*dist./dMap2;
figure(5)
surf(depth,'edgecolor','none')
zlim auto
caxis auto
colormap('jet')