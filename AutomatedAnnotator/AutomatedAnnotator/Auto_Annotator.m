% Manual Skin - Automated Fine and coarse Wrinkles annotation with Depth
% Map
% 
% 
% Main Program
%
% Author: Moi Hoon Yap
% Date:  14 March 2018
% email: moihoon at gmail dot com
%
%% parameters setting
close all;
clear all;

clc; clear all; close all;
addpath(genpath('Library'));
fileno = 'test';
filejpg = ['Images/' fileno '.jpg'];
gt = load(['Images/' fileno '.mat']);
wrinklejpg = ['Images/' fileno '_mask.jpg'];
input = imread(filejpg);
BW_wrinkle = im2bw(imread(wrinklejpg));

%% Auto probabilitic map
fmask = wrinkleMask(input,1,8,0.2,1);
se = strel('line',5,90);
sev = strel('disk',5);
mask0 = fmask(:,:,3);
mask0(~BW_wrinkle)=0;
Prob_map = mask0;
mask1 = imdilate(mask0, se);

Morg = im2bw(mask1,0.05); %horizontal
vmask = wrinkleMask(input,1,8,0.2,2);
maskv = vmask(:,:,3);
maskv(~BW_wrinkle)=0;
Prob_map = Prob_map+maskv;
maskv = imdilate(maskv, sev);
Morgv = im2bw(maskv,0.3); %vertical line

Morg = Morg + Morgv;
Morg(~BW_wrinkle)=0;
Wmask = im2bw(Morg, 0.2);

% Save Probabilitic Map
mask = im2uint8(Prob_map);
colorMapForSaving = imresize(jet,[256, 3], 'nearest');
rgbImage = ind2rgb(mask, colorMapForSaving);
% filename = '0149_03_map.png'
% imwrite(rgbImage, filename);

%% Wrinkles
% fine lines
maskH2 = produceLines(input,1,0.1,2,3);
maskV2 = produceLines(input,2,0.2,2,3);
% maskH2 = produceLines(input,1,0.1,1,2);
% maskV2 = produceLines(input,2,0.2,1,2);

maskL2 = maskH2 + maskV2;
maskL2(~BW_wrinkle) = 0;
maskL2 = im2bw(maskL2,0.2);
% coarse lines
maskH5 = produceLines(input,1,0.1,5,6);
maskV5 = produceLines(input,2,0.2,5,6);
% maskH5 = produceLines(input,1,0.1,3,4);
% maskV5 = produceLines(input,2,0.2,3,4);

maskL5 = maskH5 + maskV5;
maskL5(~BW_wrinkle) = 0;
maskL5 = im2bw(maskL5,0.2);
[mask1 dummy1] = SplitLines(maskL2, maskL5);
[dummy2 mask2] = SplitLines(maskL5, maskL2);

% figure;
% subplottight(1,5,1); imshow(rgbImage,'border','tight'); title('L1');
% subplottight(1,5,2); imshow(maskL2,'border','tight'); title('L2');
% subplottight(1,5,3); imshow(maskL5,'border','tight'); title('L3');
% subplottight(1,5,4); imshow(mask1,'border','tight'); title('L4');
% subplottight(1,5,5); imshow(mask2,'border','tight'); title('L5');

% for high resolution only!!!!!
% se = strel('disk',1);
% mask2 = imdilate(mask2, se);

coarseline = mask2;
% fineline = mask1;

%coarseline = dummy1+mask2;

% in dummy 1 not in mask2 + mask1
temp = dummy1 - mask2;
temp(~dummy1)=0;
fineline = temp+mask1;

coarseline = im2bw(coarseline,0.2);
fineline = im2bw(fineline,0.2);

% remove small regions 
[L num] = bwlabel(fineline,4);
s = regionprops(L,'Area');
area_values = [s.Area];
idx = find(50 <= area_values);
bw1 = ismember(L, idx);
fineline = bw1;

im1 = imoverlay(input, coarseline,[0 1 1]);
im2 = imoverlay(input, fineline,[0 1 0]);
im3 = imoverlay(im1, fineline,[0 1 0]);

figure;
subplottight(1,5,1); imshow(input,'border','tight'); title('Input Image');
subplottight(1,5,2); imshow(rgbImage,'border','tight'); title('Probabilistic Map');
subplottight(1,5,3); imshow(im1,'border','tight'); title('Coarse Wrinkles');
subplottight(1,5,4); imshow(im2,'border','tight'); title('Fine Wrinkles');
subplottight(1,5,5); imshow(im3,'border','tight'); title('Combined Wrinkles');

mapjpg = ['output/' fileno '_map.jpg'];
finejpg = ['output/' fileno '_fine.jpg'];
coarsejpg = ['output/' fileno '_coarse.jpg'];
combinejpg = ['output/' fileno '_combine.jpg'];
imwrite(rgbImage, mapjpg);
imwrite(im1, coarsejpg);
imwrite(im2, finejpg);
imwrite(im3, combinejpg);

%plot groundtruth

figure; hold on;
subplottight(1,2,1); imshow(input); title('Original Image');
subplottight(1,2,2); imshow(im3); title('Detected regions vs manual annotation ');
hold on;

% plot 1st wrinkles
[allRegion,nofRegion] = bwlabel(gt.logicmask,8);
for i = 1: nofRegion
   lines = ismember(allRegion, i); 
   [y x] = find(lines);
   a = plot(x,y,'r*','MarkerSize',1);
end
%legend(a, ['Number of Lines = ' num2str(nofRegion)]);
legend(a, ['Red line: Ground Truth']);

cwCentroid1 = regionprops(allRegion, 'Centroid');




