% THIS WAS TAKEN FROM OLD CODE

set(0,'DefaultFigureWindowStyle','docked')
addpath 'Matlab function library'
f = funcs;
inpath = 'Islet_whole_mount_cy2pdx_cy3E-cad_cy5SE_DAPI_141116\Tiff_7_Dapi_cy3_cy2';
 
data.sections = [];
 
%% Load 3d image from folder.
% tiff images with 3 channels: e-cadherin, protein marker and pdx1
disp('Loading image..')
zpic_DAPI = f.im3dread(inpath, '*.tif', 3); %Blue channel: DAPI
zpic_ECad = f.im3dread(inpath, '*.tif', 1); %Red channel: e-cadherin
 
% figure('name','nuc','NumberTitle', 'off');imshow3Dfull(zpic_DAPI,[])
 
 
% Remove background, create bw.
im_c = imclose(zpic_DAPI, f.strelball(1));
% figure('name','im_c','NumberTitle', 'off');imshow3D(im_c,[])
im_o = imopen(im_c, strel('disk',25));
% figure('name','im_o','NumberTitle', 'off');imshow3D(im_o,[])
bw_sub = zpic_DAPI - im_o;
% figure('name','bw_sub','NumberTitle', 'off');imshow3D(bw_sub,[])
 
%% THRESHOLDING
thr=130;
BW_Nuc=zpic_DAPI>thr; %Threshold each image separately?
% figure('name','thresh','NumberTitle', 'off');imshow3Dfull(BW_Nuc,[])
 
imcnt = size(zpic_DAPI, 3);
 
% remove small particles
bw_clean = zeros(size(BW_Nuc, 1), size(BW_Nuc, 2), imcnt);
for i = 1:imcnt
    bw_clean(:,:,i) = bwareaopen(BW_Nuc(:,:,i), 65);
end
% figure('name','open', 'NumberTitle','off');imshow3Dfull(bw_clean,[])
 
label = bwlabeln(bw_clean);
% figure('name','label', 'NumberTitle','off');imshow3Dfull(label,[])
 
 
for cell_index=1:length(unique(label))-1
  single_cell = zeros(size(label));
  single_cell(find(label==cell_index))=1;
  % figure('name','single_cell', 'NumberTitle','off');imshow3Dfull(single_cell,[])
 
  idilate = imdilate(single_cell,strel('disk',5));
  % figure('name','idilate', 'NumberTitle','off');imshow3Dfull(idilate,[])
 
  stats = regionprops(idilate, 'BoundingBox');
  bounding_box = [stats.BoundingBox];
 
  x_min = bounding_box(1);
  x_max = bounding_box(1) + bounding_box(4);
  y_min = bounding_box(2);
  y_max = bounding_box(2) + bounding_box(5);
  z_periphery = 2; % number of z-slices above and below cell to display
  z_min = round(bounding_box(3))-z_periphery;
  z_max = round(bounding_box(3)) + bounding_box(6)+z_periphery;
 
  if z_min < 1
    z_min = 1;
  end
  if z_max > size(idilate,3);
    z_max = size(idilate,3);
  end
 
  zdist = z_max - z_min;
 
  cropped_cell = zeros(bounding_box(5)+1,bounding_box(4)+1,zdist);
  transparency_map = zeros(bounding_box(5)+1,bounding_box(4)+1,zdist);
  cropped_threshold = zeros(bounding_box(5)+1,bounding_box(4)+1,zdist);
  %% Create image
  i = 1;
  for z=z_min:z_max-1
    cropped_cell(:,:,i) = zpic_DAPI(y_min:y_max,x_min:x_max,z);
    transparency_map(:,:,i) = idilate(y_min:y_max,x_min:x_max,z);
    cropped_threshold(:,:,i) = single_cell(y_min:y_max,x_min:x_max,z);
    i=i+1;
  end
 
  true_z_min = round(bounding_box(3));
  true_z_max = round(bounding_box(3)) + bounding_box(6);
  for z=1:z_periphery
    if true_z_min - z > 0
      transparency_map(:,:,z) = idilate(y_min:y_max,x_min:x_max,true_z_min);
    end
    if true_z_max + z <= size(idilate,3)
      transparency_map(:,:,zdist + 1 - z) = idilate(y_min:y_max,x_min:x_max,true_z_max-1);
    end
  end
 
  section = {};
  section.title = ['Pancreatic Cell ID #' int2str(cell_index)];
  images = [];
   
 
  %% Display Image
  figure('Position', [100, 100, 400, 1000]); hs = slice(cropped_cell,[],[],1:zdist);
  shading interp; colormap hsv;
  for n=1:length(hs) %% Apply transparency mask
    hs(n).AlphaData = transparency_map(:,:,n);
    hs(n).FaceAlpha = 'interp'; 
  end
  az = -68.7000;
  el = 15.6000;
  view(az,el);
  saveas(gcf,['../public/img/HSV' int2str(cell_index) '.png'])
  im.title = ['HSV'];
  im.filename = ['HSV' int2str(cell_index) '.png'];
  images = [images im];
 
 
  %% Display Image
  figure('Position', [100, 100, 400, 1000]); hs = slice(cropped_cell,[],[],1:zdist);
  shading interp; colormap gray;
  for n=1:length(hs) %% Apply transparency mask
    hs(n).AlphaData = transparency_map(:,:,n);
    hs(n).FaceAlpha = 'interp'; 
  end
  az = -68.7000;
  el = 15.6000;
  view(az,el);
  saveas(gcf,['../public/img/Gray' int2str(cell_index) '.png'])
  im.title = ['Gray'];
  im.filename = ['Gray' int2str(cell_index) '.png'];
  images = [images im];
 
 
  %% Display Image
  figure('Position', [100, 100, 400, 1000]); hs = slice(cropped_threshold,[],[],1:zdist);
  shading interp; colormap hsv;
  for n=1:length(hs) %% Apply transparency mask
    hs(n).AlphaData = cropped_threshold(:,:,n);
    hs(n).FaceAlpha = 'interp'; 
  end
  az = -68.7000;
  el = 15.6000;
  view(az,el);
  saveas(gcf,['../public/img/Threshold' int2str(cell_index) '.png'])
  im.title = ['Threshold'];
  im.filename = ['Threshold' int2str(cell_index) '.png'];
  images = [images im];
 
  section.images = images;
  data.sections = [data.sections section];
  % break
  % pause;
  close all;
  % if cell_index > 1
  %   break
  % end
end
 
addpath('jsonlab')
savejson('',data,'FileName','data.json')
fprintf('Finished.\n');