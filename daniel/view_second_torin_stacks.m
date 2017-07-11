set(0,'DefaultFigureWindowStyle','docked')
addpath '\\carbon.research.sickkids.ca\rkafri\Miriam\Matlab function library'
inpath = '\\carbon.research.sickkids.ca\rkafri\Miriam\New Experiments\10_7_2016 Mouse islet staining test\Second Torin treatment and recovery\Whole_mount_cy5pdx_cy3E-cad_DAPI_140217';

% Dim 55, lots happening
ctl_10000_1 = im3dread([inpath '\ctl_1-0000\ctl_1-0000\'], '*.tif', 1);
ctl_10000_2 = im3dread([inpath '\ctl_1-0000\ctl_1-0000\'], '*.tif', 2);
ctl_10000_3 = im3dread([inpath '\ctl_1-0000\ctl_1-0000\'], '*.tif', 3);
figure('name','ctl_10000_1','NumberTitle', 'off');imshow3Dfull(ctl_10000_1,[])
figure('name','ctl_10000_2','NumberTitle', 'off');imshow3Dfull(ctl_10000_2,[])
figure('name','ctl_10000_3','NumberTitle', 'off');imshow3Dfull(ctl_10000_3,[])
  % %% NORMALIZE INTENSITIES (so that the mean is 0 and the variance is 1)
  % im_norm = zeros(size(ctl_10000_2, 1), size(ctl_10000_2, 2), size(ctl_10004_2,3));
  % for i = 1:size(ctl_10004_2,3)
  %   im = ctl_10000_2(:,:,i);
  %   im_norm(:,:,i) = (im - mean(im(:))) ./ std(im(:));
  % end
  % im_norm(isnan(im_norm))=0;
  % figure('name','im_norm','NumberTitle', 'off');imshow3Dfull(im_norm,[])
  % %% SMOOTH
  % nuc_smooth = zeros(size(ctl_10000_2, 1), size(ctl_10000_2, 2), size(ctl_10004_2,3));
  % for i = 1:size(ctl_10004_2,3)
  %   nuc_smooth(:,:,i) = imfilter(im_norm(:,:,i),fspecial('gauss',15,5));
  % end
  % figure('name','smooth', 'NumberTitle','off');imshow3Dfull(nuc_smooth,[])

% Brighter but not much happening 46
ctl_10001_1 = im3dread([inpath '\ctl_1-0001\ctl_1-0001\'], '*.tif', 1);
ctl_10001_2 = im3dread([inpath '\ctl_1-0001\ctl_1-0001\'], '*.tif', 2);
ctl_10001_3 = im3dread([inpath '\ctl_1-0001\ctl_1-0001\'], '*.tif', 3);
figure('name','ctl_10001_1','NumberTitle', 'off');imshow3Dfull(ctl_10001_1,[])
figure('name','ctl_10001_2','NumberTitle', 'off');imshow3Dfull(ctl_10001_2,[])
figure('name','ctl_10001_3','NumberTitle', 'off');imshow3Dfull(ctl_10001_3,[])

% Dim 22
ctl_10002_1 = im3dread([inpath '\ctl_1-0002\ctl_1-0002\'], '*.tif', 1);
ctl_10002_2 = im3dread([inpath '\ctl_1-0002\ctl_1-0002\'], '*.tif', 2);
ctl_10002_3 = im3dread([inpath '\ctl_1-0002\ctl_1-0002\'], '*.tif', 3);
figure('name','ctl_10002_1','NumberTitle', 'off');imshow3Dfull(ctl_10002_1,[])
figure('name','ctl_10002_2','NumberTitle', 'off');imshow3Dfull(ctl_10002_2,[])
figure('name','ctl_10002_3','NumberTitle', 'off');imshow3Dfull(ctl_10002_3,[])

% Extremely dim (can it be corrected?) 41
ctl_10004_1 = im3dread([inpath '\ctl_1-0004\ctl_1-0004\'], '*.tif', 1);
ctl_10004_2 = im3dread([inpath '\ctl_1-0004\ctl_1-0004\'], '*.tif', 2);
ctl_10004_3 = im3dread([inpath '\ctl_1-0004\ctl_1-0004\'], '*.tif', 3);
figure('name','ctl_10004_1','NumberTitle', 'off');imshow3Dfull(ctl_10004_1,[])
figure('name','ctl_10004_2','NumberTitle', 'off');imshow3Dfull(ctl_10004_2,[])
figure('name','ctl_10004_3','NumberTitle', 'off');imshow3Dfull(ctl_10004_3,[])
    %% CROP
    % rect = [129  267  581  564];
    % ctl_10004_2_cropped = zeros(ceil(rect(4))+1, ceil(rect(3))+1, size(ctl_10004_2,3));
    % for i = 1:size(ctl_10004_2,3)
    %   ctl_10004_2_cropped(:,:,i) = imcrop(ctl_10004_2(:,:,i), rect);
    % end
    % figure('name','nuc','NumberTitle', 'off');imshow3Dfull(ctl_10004_2_cropped,[])
    % %% NORMALIZE INTENSITIES (so that the mean is 0 and the variance is 1)
    % im_norm = zeros(size(ctl_10004_2_cropped, 1), size(ctl_10004_2_cropped, 2), size(ctl_10004_2,3));
    % for i = 1:size(ctl_10004_2,3)
    %   im = ctl_10004_2_cropped(:,:,i);
    %   im_norm(:,:,i) = (im - mean(im(:))) ./ std(im(:));
    % end
    % im_norm(isnan(im_norm))=0;
    % figure('name','im_norm','NumberTitle', 'off');imshow3Dfull(im_norm,[])
    % %% SMOOTH
    % nuc_smooth = zeros(size(ctl_10004_2_cropped, 1), size(ctl_10004_2_cropped, 2), size(ctl_10004_2,3));
    % for i = 1:size(ctl_10004_2,3)
    %   nuc_smooth(:,:,i) = imfilter(im_norm(:,:,i),fspecial('gauss',15,5));
    % end
    % figure('name','smooth', 'NumberTitle','off');imshow3Dfull(nuc_smooth,[])

% Dim 35
ctl_10005_1 = im3dread([inpath '\ctl_1-0005\ctl_1-0005\'], '*.tif', 1);
ctl_10005_2 = im3dread([inpath '\ctl_1-0005\ctl_1-0005\'], '*.tif', 2);
ctl_10005_3 = im3dread([inpath '\ctl_1-0005\ctl_1-0005\'], '*.tif', 3);
figure('name','ctl_10005_1','NumberTitle', 'off');imshow3Dfull(ctl_10005_1,[])
figure('name','ctl_10005_2','NumberTitle', 'off');imshow3Dfull(ctl_10005_2,[])
figure('name','ctl_10005_3','NumberTitle', 'off');imshow3Dfull(ctl_10005_3,[])

% Dim 57, lots happening very blurry
Torin_10000_1 = im3dread([inpath '\Torin_1-0000\Torin_1-0000\'], '*.tif', 1);
Torin_10000_2 = im3dread([inpath '\Torin_1-0000\Torin_1-0000\'], '*.tif', 2);
Torin_10000_3 = im3dread([inpath '\Torin_1-0000\Torin_1-0000\'], '*.tif', 3);
figure('name','Torin_10000_1','NumberTitle', 'off');imshow3Dfull(Torin_10000_1,[])
figure('name','Torin_10000_2','NumberTitle', 'off');imshow3Dfull(Torin_10000_2,[])
figure('name','Torin_10000_3','NumberTitle', 'off');imshow3Dfull(Torin_10000_3,[])

% Dim 46
Torin_10003_1 = im3dread([inpath '\Torin_1-0003\Torin_1-0003\'], '*.tif', 1);
Torin_10003_2 = im3dread([inpath '\Torin_1-0003\Torin_1-0003\'], '*.tif', 2);
Torin_10003_3 = im3dread([inpath '\Torin_1-0003\Torin_1-0003\'], '*.tif', 3);
figure('name','Torin_10003_1','NumberTitle', 'off');imshow3Dfull(Torin_10003_1,[])
figure('name','Torin_10003_2','NumberTitle', 'off');imshow3Dfull(Torin_10003_2,[])
figure('name','Torin_10003_3','NumberTitle', 'off');imshow3Dfull(Torin_10003_3,[])

% Dim 47
Torin_10004_1 = im3dread([inpath '\Torin_1-0004\Torin_1-0004\'], '*.tif', 1);
Torin_10004_2 = im3dread([inpath '\Torin_1-0004\Torin_1-0004\'], '*.tif', 2);
Torin_10004_3 = im3dread([inpath '\Torin_1-0004\Torin_1-0004\'], '*.tif', 3);
figure('name','Torin_10004_1','NumberTitle', 'off');imshow3Dfull(Torin_10004_1,[])
figure('name','Torin_10004_2','NumberTitle', 'off');imshow3Dfull(Torin_10004_2,[])
figure('name','Torin_10004_3','NumberTitle', 'off');imshow3Dfull(Torin_10004_3,[])

% Dim 44
Torin_10005_1 = im3dread([inpath '\Torin_1-0005\Torin_1-0005\'], '*.tif', 1);
Torin_10005_2 = im3dread([inpath '\Torin_1-0005\Torin_1-0005\'], '*.tif', 2);
Torin_10005_3 = im3dread([inpath '\Torin_1-0005\Torin_1-0005\'], '*.tif', 3);
figure('name','Torin_10005_1','NumberTitle', 'off');imshow3Dfull(Torin_10005_1,[])
figure('name','Torin_10005_2','NumberTitle', 'off');imshow3Dfull(Torin_10005_2,[])
figure('name','Torin_10005_3','NumberTitle', 'off');imshow3Dfull(Torin_10005_3,[])
 
% Dim 52, extra dim center (looks like a doughnut)
Torin_10006_1 = im3dread([inpath '\Torin_1-0006\Torin_1-0006\'], '*.tif', 1);
Torin_10006_2 = im3dread([inpath '\Torin_1-0006\Torin_1-0006\'], '*.tif', 2);
Torin_10006_3 = im3dread([inpath '\Torin_1-0006\Torin_1-0006\'], '*.tif', 3);
figure('name','Torin_10006_1','NumberTitle', 'off');imshow3Dfull(Torin_10006_1,[])
figure('name','Torin_10006_2','NumberTitle', 'off');imshow3Dfull(Torin_10006_2,[])
figure('name','Torin_10006_3','NumberTitle', 'off');imshow3Dfull(Torin_10006_3,[])

% Jitter
Torin_wash_10000_1 = im3dread([inpath '\Torin_wash_1-0000\Torin_wash_1-0000\'], '*.tif', 1);
Torin_wash_10000_2 = im3dread([inpath '\Torin_wash_1-0000\Torin_wash_1-0000\'], '*.tif', 2);
Torin_wash_10000_3 = im3dread([inpath '\Torin_wash_1-0000\Torin_wash_1-0000\'], '*.tif', 3);
figure('name','Torin_wash_10000_1','NumberTitle', 'off');imshow3Dfull(Torin_wash_10000_1,[])
figure('name','Torin_wash_10000_2','NumberTitle', 'off');imshow3Dfull(Torin_wash_10000_2,[])
figure('name','Torin_wash_10000_3','NumberTitle', 'off');imshow3Dfull(Torin_wash_10000_3,[])

% Dim
Torin_wash_10001_1 = im3dread([inpath '\Torin_wash_1-0001\Torin_wash_1-0001\'], '*.tif', 1);
Torin_wash_10001_2 = im3dread([inpath '\Torin_wash_1-0001\Torin_wash_1-0001\'], '*.tif', 2);
Torin_wash_10001_3 = im3dread([inpath '\Torin_wash_1-0001\Torin_wash_1-0001\'], '*.tif', 3);
figure('name','Torin_wash_10001_1','NumberTitle', 'off');imshow3Dfull(Torin_wash_10001_1,[])
figure('name','Torin_wash_10001_2','NumberTitle', 'off');imshow3Dfull(Torin_wash_10001_2,[])
figure('name','Torin_wash_10001_3','NumberTitle', 'off');imshow3Dfull(Torin_wash_10001_3,[])

% Large (60), clear
Torin_wash_10002_1 = im3dread([inpath '\Torin_wash_1-0002\Torin_wash_1-0002\'], '*.tif', 1);
Torin_wash_10002_2 = im3dread([inpath '\Torin_wash_1-0002\Torin_wash_1-0002\'], '*.tif', 2);
Torin_wash_10002_3 = im3dread([inpath '\Torin_wash_1-0002\Torin_wash_1-0002\'], '*.tif', 3);
figure('name','Torin_wash_10002_1','NumberTitle', 'off');imshow3Dfull(Torin_wash_10002_1,[])
figure('name','Torin_wash_10002_2','NumberTitle', 'off');imshow3Dfull(Torin_wash_10002_2,[])
figure('name','Torin_wash_10002_3','NumberTitle', 'off');imshow3Dfull(Torin_wash_10002_3,[])

% Large (59), clear
Torin_wash_10003_1 = im3dread([inpath '\Torin_wash_1-0003\Torin_wash_1-0003\'], '*.tif', 1);
Torin_wash_10003_2 = im3dread([inpath '\Torin_wash_1-0003\Torin_wash_1-0003\'], '*.tif', 2);
Torin_wash_10003_3 = im3dread([inpath '\Torin_wash_1-0003\Torin_wash_1-0003\'], '*.tif', 3);
figure('name','Torin_wash_10003_1','NumberTitle', 'off');imshow3Dfull(Torin_wash_10003_1,[])
figure('name','Torin_wash_10003_2','NumberTitle', 'off');imshow3Dfull(Torin_wash_10003_2,[])
figure('name','Torin_wash_10003_3','NumberTitle', 'off');imshow3Dfull(Torin_wash_10003_3,[])


% Largest z-stack (72), over-exposed <36
Torin_wash_10004_1 = im3dread([inpath '\Torin_wash_1-0004\Torin_wash_1-0004\'], '*.tif', 1);
Torin_wash_10004_2 = im3dread([inpath '\Torin_wash_1-0004\Torin_wash_1-0004\'], '*.tif', 2);
Torin_wash_10004_3 = im3dread([inpath '\Torin_wash_1-0004\Torin_wash_1-0004\'], '*.tif', 3);
figure('name','Torin_wash_10004_1','NumberTitle', 'off');imshow3Dfull(Torin_wash_10004_1,[])
figure('name','Torin_wash_10004_2','NumberTitle', 'off');imshow3Dfull(Torin_wash_10004_2,[])
figure('name','Torin_wash_10004_3','NumberTitle', 'off');imshow3Dfull(Torin_wash_10004_3,[])

% Large (65), clear
Torin_wash_10005_1 = im3dread([inpath '\Torin_wash_1-0005\Torin_wash_1-0005\'], '*.tif', 1);
Torin_wash_10005_2 = im3dread([inpath '\Torin_wash_1-0005\Torin_wash_1-0005\'], '*.tif', 2);
Torin_wash_10005_3 = im3dread([inpath '\Torin_wash_1-0005\Torin_wash_1-0005\'], '*.tif', 3);
figure('name','Torin_wash_10005_1','NumberTitle', 'off');imshow3Dfull(Torin_wash_10005_1,[])
figure('name','Torin_wash_10005_2','NumberTitle', 'off');imshow3Dfull(Torin_wash_10005_2,[])
figure('name','Torin_wash_10005_3','NumberTitle', 'off');imshow3Dfull(Torin_wash_10005_3,[])

% \\carbon.research.sickkids.ca\rkafri\Miriam\New Experiments\10_7_2016 Mouse islet staining test\Second Torin treatment and recovery\Whole_mount_cy5pdx_cy3E-cad_DAPI_140217\ctl_1-0000\ctl_1-0000\1_0000z20.tif
% \\carbon.research.sickkids.ca\rkafri\Miriam\New Experiments\10_7_2016 Mouse islet staining test\Second Torin treatment and recovery\Whole_mount_cy5pdx_cy3E-cad_DAPI_140217\ctl_1-0001\ctl_1-0001\1_0001z20.tif
% \\carbon.research.sickkids.ca\rkafri\Miriam\New Experiments\10_7_2016 Mouse islet staining test\Second Torin treatment and recovery\Whole_mount_cy5pdx_cy3E-cad_DAPI_140217\ctl_1-0002\ctl_1-0002\1_0002z20.tif
% \\carbon.research.sickkids.ca\rkafri\Miriam\New Experiments\10_7_2016 Mouse islet staining test\Second Torin treatment and recovery\Whole_mount_cy5pdx_cy3E-cad_DAPI_140217\ctl_1-0004\ctl_1-0004\1_0004z20.tif
% \\carbon.research.sickkids.ca\rkafri\Miriam\New Experiments\10_7_2016 Mouse islet staining test\Second Torin treatment and recovery\Whole_mount_cy5pdx_cy3E-cad_DAPI_140217\ctl_1-0005\ctl_1-0005\1_0005z20.tif
% \\carbon.research.sickkids.ca\rkafri\Miriam\New Experiments\10_7_2016 Mouse islet staining test\Second Torin treatment and recovery\Whole_mount_cy5pdx_cy3E-cad_DAPI_140217\Torin_1-0000\Torin_1-0000\1_0000z20.tif
% \\carbon.research.sickkids.ca\rkafri\Miriam\New Experiments\10_7_2016 Mouse islet staining test\Second Torin treatment and recovery\Whole_mount_cy5pdx_cy3E-cad_DAPI_140217\Torin_1-0003\Torin_1-0003\1_0003z20.tif
% \\carbon.research.sickkids.ca\rkafri\Miriam\New Experiments\10_7_2016 Mouse islet staining test\Second Torin treatment and recovery\Whole_mount_cy5pdx_cy3E-cad_DAPI_140217\Torin_1-0004\Torin_1-0004\1_0004z20.tif
% \\carbon.research.sickkids.ca\rkafri\Miriam\New Experiments\10_7_2016 Mouse islet staining test\Second Torin treatment and recovery\Whole_mount_cy5pdx_cy3E-cad_DAPI_140217\Torin_1-0005\Torin_1-0005\1_0005z20.tif
% \\carbon.research.sickkids.ca\rkafri\Miriam\New Experiments\10_7_2016 Mouse islet staining test\Second Torin treatment and recovery\Whole_mount_cy5pdx_cy3E-cad_DAPI_140217\Torin_1-0006\Torin_1-0006\1_0006z20.tif
% \\carbon.research.sickkids.ca\rkafri\Miriam\New Experiments\10_7_2016 Mouse islet staining test\Second Torin treatment and recovery\Whole_mount_cy5pdx_cy3E-cad_DAPI_140217\Torin_wash_1-0000\Torin_wash_1-0000\1_0000z20.tif
% \\carbon.research.sickkids.ca\rkafri\Miriam\New Experiments\10_7_2016 Mouse islet staining test\Second Torin treatment and recovery\Whole_mount_cy5pdx_cy3E-cad_DAPI_140217\Torin_wash_1-0001\Torin_wash_1-0001\1_0001z20.tif
% \\carbon.research.sickkids.ca\rkafri\Miriam\New Experiments\10_7_2016 Mouse islet staining test\Second Torin treatment and recovery\Whole_mount_cy5pdx_cy3E-cad_DAPI_140217\Torin_wash_1-0002\Torin_wash_1-0002\1_0002z20.tif
% \\carbon.research.sickkids.ca\rkafri\Miriam\New Experiments\10_7_2016 Mouse islet staining test\Second Torin treatment and recovery\Whole_mount_cy5pdx_cy3E-cad_DAPI_140217\Torin_wash_1-0003\Torin_wash_1-0003\1_0003z20.tif
% \\carbon.research.sickkids.ca\rkafri\Miriam\New Experiments\10_7_2016 Mouse islet staining test\Second Torin treatment and recovery\Whole_mount_cy5pdx_cy3E-cad_DAPI_140217\Torin_wash_1-0004\Torin_wash_1-0004\1_0004z20.tif
% \\carbon.research.sickkids.ca\rkafri\Miriam\New Experiments\10_7_2016 Mouse islet staining test\Second Torin treatment and recovery\Whole_mount_cy5pdx_cy3E-cad_DAPI_140217\Torin_wash_1-0005\Torin_wash_1-0005\1_0005z20.tif


% cp "\\carbon.research.sickkids.ca\rkafri\Miriam\New Experiments\10_7_2016 Mouse islet staining test\Second Torin treatment and recovery\Whole_mount_cy5pdx_cy3E-cad_DAPI_140217\ctl_1-0001\ctl_1-0001\1_0001z20.tif" "C:\Users\daniel snider\Dropbox\Kafri\Code\images_temp"
% cp "\\carbon.research.sickkids.ca\rkafri\Miriam\New Experiments\10_7_2016 Mouse islet staining test\Second Torin treatment and recovery\Whole_mount_cy5pdx_cy3E-cad_DAPI_140217\Torin_wash_1-0005\Torin_wash_1-0005\1_0005z20.tif" "C:\Users\daniel snider\Dropbox\Kafri\Code\images_temp"
