set(0,'DefaultFigureWindowStyle','docked')
inpath = '\\carbon.research.sickkids.ca\rkafri\YuvalDor\mouse islet z-stacks\images\3rd image set\Whole_mount_Islets_with_Torin_Cy5pdx_cy3E-cad_DAPI_080317';
addpath '\\carbon.research.sickkids.ca\rkafri\Miriam\Matlab function library'

%% 3rd set
% inpath = '\\carbon.research.sickkids.ca\rkafri\YuvalDor\mouse islet z-stacks\images\3rd image set\Whole_mount_Islets_with_Torin_Cy5pdx_cy3E-cad_DAPI_080317\';
% folders = { 
%             '\Control\0003\' ...
%             '\Control\0004\' ...
%             '\Control\0005\' ...
%             '\Torin\0000\' ...
%             '\Torin\0001\' ...
%             '\Torin\0002\' ...
%             '\Torin_wash\0000\' ...
%             '\Torin_wash\0001\' ...
%             '\Torin_wash\0002\'};

%% First drug screened
inpath = '\\carbon.research.sickkids.ca\rkafri\YuvalDor\mouse islet z-stacks\images\Whole_mount_Mifepristone_Cy2pdx_Cy3Ecad_DAPI_080617\';
folders = { 
      'Control/Control/1_0_TIFF' ...
      'Control/Control/10001_TIFF' ...
      'Control/Control/10003_TIFF' ...
      'Control/Control/10004_TIFF' ...
      'Control/Control/10006_TIFF' ...
      'Control/Control/10007_TIFF' ...
      'Control/Control/10008_TIFF' ...
      'Control/Control/10009_TIFF' ...
      'Mifepristone_0.1nM/Mifepristone_0.1nM/1_TIFF' ...
      'Mifepristone_0.1nM/Mifepristone_0.1nM/1002_TIFF' ...
      'Mifepristone_0.1nM/Mifepristone_0.1nM/1004_TIFF' ...
      'Mifepristone_0.1nM/Mifepristone_0.1nM/1005_TIFF' ...
      'Mifepristone_0.1nM/Mifepristone_0.1nM/1006_TIFF' ...
      'Mifepristone_0.1nM/Mifepristone_0.1nM/1007_TIFF' ...
      'Mifepristone_10nM/Mifepristone_10nM/1_TIFF' ...
      'Mifepristone_10nM/Mifepristone_10nM/1_000_TIFF' ...
      'Mifepristone_10nM/Mifepristone_10nM/1_002_TIFF' ...
      'Mifepristone_10nM/Mifepristone_10nM/1_003_TIFF' ...
      'Mifepristone_10nM/Mifepristone_10nM/1_004_TIFF' ...
      'Mifepristone_10nM/Mifepristone_10nM/1_005_TIFF' ...
      'Mifepristone_1nM/Mifepristone_1nM/1_TIFF' ...
      'Mifepristone_1nM/Mifepristone_1nM/1001_TIFF' ...
      'Mifepristone_1nM/Mifepristone_1nM/1003_TIFF' ...
      'Mifepristone_1nM/Mifepristone_1nM/1004_TIFF' ...
      'Mifepristone_1nM/Mifepristone_1nM/1005_TIFF' ...
      'Mifepristone_1nM/Mifepristone_1nM/1006_TIFF'};

for f=1:length(folders)
  folder = folders(f);
  nuc = im3dread([inpath char(folder)], '*.tif', 1); % DAPI
  cyto = im3dread([inpath char(folder)], '*.tif', 2); % e-cadherin
  insulin = im3dread([inpath char(folder)], '*.tif', 3); % insulin?

  %% AUTO-CROP CYTO
  padding = 30; % amount of padding around object to keep
  big_blob = imdilate(cyto>0,strel('disk',5));
  big_blob = imopen(big_blob,strel('disk',40));
  stats = regionprops(big_blob, 'BoundingBox');
  assert(length(stats) == 1, 'Error: Auto-crop failed. Expected only one large blob in z-stack but found %d\n', length(stats));
  boundingbox = cat(1, stats.BoundingBox);
  ymin = ceil(boundingbox(1)) - padding;
  if ymin < 1 % out of bounds check
    ymin = 1;
  end
  ymax = ceil(boundingbox(1)) + ceil(boundingbox(4)) + padding;
  if ymax > size(cyto,1) % out of bounds check
    ymax = size(cyto,1);
  end
  xmin = ceil(boundingbox(2)) - padding;
  if xmin < 1 % out of bounds check
    xmin = 1;
  end
  xmax = ceil(boundingbox(2)) + ceil(boundingbox(5)) + padding;
  if xmax > size(cyto,2) % out of bounds check
    xmax = size(cyto,2);
  end
  zmin = ceil(boundingbox(3));
  zmax = ceil(boundingbox(3)) + ceil(boundingbox(6)) - 1;
  cyto=cyto(xmin:xmax,ymin:ymax,zmin:zmax); % crop
  % figure('name','cyto_cropped','NumberTitle', 'off'); imshow3Dfull(cyto,[]);
  %% CROP NUC
  nuc=nuc(xmin:xmax,ymin:ymax,zmin:zmax); % crop;
  % figure('name','nuc_cropped','NumberTitle', 'off'); imshow3Dfull(nuc,[]);
  %% CROP INSULIN
  insulin=insulin(xmin:xmax,ymin:ymax,zmin:zmax); % crop
  % figure('name','insulin_cropped','NumberTitle', 'off'); imshow3Dfull(insulin,[]);

  nuc1 = nuc(:,:,2); % first
  nuc2 = nuc(:,:,floor(size(nuc,3)/2)); % middle
  nuc3 = nuc(:,:,end-1); % last

  cyto1 = cyto(:,:,2); % first
  cyto2 = cyto(:,:,floor(size(cyto,3)/2)); % middle
  cyto3 = cyto(:,:,end-1); % last

  insulin1 = insulin(:,:,2); % first
  insulin2 = insulin(:,:,floor(size(insulin,3)/2)); % middle
  insulin3 = insulin(:,:,end-1); % last

  label1 = text2im(int2str(2));
  label1 = imresize(label1 ,2);
  insulin1(end-size(label1,1)+1:end,1:size(label1,2))=label1*255; % overlay text

  label2 = text2im(int2str(floor(size(insulin,3)/2)));
  label2 = imresize(label2 ,2);
  insulin2(end-size(label2,1)+1:end,1:size(label2,2))=label2*255; % overlay text

  label3 = text2im(int2str(size(insulin,3)-1));
  label3 = imresize(label3 ,2);
  insulin3(end-size(label3,1)+1:end,1:size(label3,2))=label3*255; % overlay text

  all_nuc = [nuc1 nuc2 nuc3];
  all_cyto = [cyto1 cyto2 cyto3];
  all_insulin = [insulin1 insulin2 insulin3];
  all_images = [all_nuc; all_cyto; all_insulin];

  folder_short = strrep(char(folder),'\','-');
  folder_short = strrep(char(folder),'/','-');
  folder_image = text2im(folder_short);
  folder_image = imresize(folder_image ,2);

  % overlay folder name text text
  all_images(1:size(folder_image,1),1:size(folder_image,2))=folder_image*255;
  
  % normalize between 0 and 255
  all_images = (all_images-min(all_images(:)))./(max(all_images(:))-min(all_images(:))).*255;

  % figure('name','nuc','NumberTitle', 'off'); imshow(all_images,[]);

  imwrite(uint8(all_images), ['overview_images_drug1/' folder_short '.png']);
  
end