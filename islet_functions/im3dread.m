% Load 3D picture.
function zpic = im3dread(folder, imgType, channel)
% Makes a 3D array containing a stack of images (confocal sections)
% OUTPUTS
% zpic = an mxnx3 array with the stack of all images from one channel

imgs = dir([folder '/' imgType]);
numImgs = size(imgs,1);
firstImg = imread([folder '/' imgs(1).name], 1);
x = size(firstImg, 1);
y = size(firstImg, 2);
zpic = zeros(x, y, numImgs+2);
zpic(:,:,1) = zeros(x,y);
for i = 1:numImgs
    apic = imread([folder '/' imgs(i).name], 1);
    zpic(:,:,i+1) = apic(:,:,channel);
end
zpic(:,:,end) = zeros(x,y);
