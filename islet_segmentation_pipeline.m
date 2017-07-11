set(0,'DefaultFigureWindowStyle','docked')
addpath 'islet_functions'
addpath 'islet_functions\export_fig'
inpath = 'D:\SickKids\YuvalDor\mouse islet z-stacks\images\';

folders = { ...
% '3rd image set\Whole_mount_Islets_with_Torin_Cy5pdx_cy3E-cad_DAPI_080317\Control\0003\' ...
% '3rd image set\Whole_mount_Islets_with_Torin_Cy5pdx_cy3E-cad_DAPI_080317\Control\0005\' ...
% '3rd image set\Whole_mount_Islets_with_Torin_Cy5pdx_cy3E-cad_DAPI_080317\Control\0004\' ...
% '3rd image set\Whole_mount_Islets_with_Torin_Cy5pdx_cy3E-cad_DAPI_080317\Torin_wash\0000\' ...
% '3rd image set\Whole_mount_Islets_with_Torin_Cy5pdx_cy3E-cad_DAPI_080317\Torin_wash\0002\' ...
% '3rd image set\Whole_mount_Islets_with_Torin_Cy5pdx_cy3E-cad_DAPI_080317\Torin\0001\' ...
% '3rd image set\Whole_mount_Islets_with_Torin_Cy5pdx_cy3E-cad_DAPI_080317\Torin\0000\' ...
% '3rd image set\Whole_mount_Islets_with_Torin_Cy5pdx_cy3E-cad_DAPI_080317\Torin\0002\' ...
% ...
% '2nd image set\Whole_mount_cy5pdx_cy3E-cad_DAPI_140217\ctl_1-0000\ctl_1-0000\' ...
% '2nd image set\Whole_mount_cy5pdx_cy3E-cad_DAPI_140217\Torin_wash_1-0000\Torin_wash_1-0000\' ...
% '2nd image set\Whole_mount_cy5pdx_cy3E-cad_DAPI_140217\Torin_1-0006\Torin_1-0006\' ...
% '2nd image set\Whole_mount_cy5pdx_cy3E-cad_DAPI_140217\ctl_1-0001\ctl_1-0001\' ...
% '2nd image set\Whole_mount_cy5pdx_cy3E-cad_DAPI_140217\ctl_1-0002\ctl_1-0002\' ...
% '2nd image set\Whole_mount_cy5pdx_cy3E-cad_DAPI_140217\ctl_1-0004\ctl_1-0004\' ...
% '2nd image set\Whole_mount_cy5pdx_cy3E-cad_DAPI_140217\ctl_1-0005\ctl_1-0005\' ...
% '2nd image set\Whole_mount_cy5pdx_cy3E-cad_DAPI_140217\Torin_1-0000\Torin_1-0000\' ...
% '2nd image set\Whole_mount_cy5pdx_cy3E-cad_DAPI_140217\Torin_1-0003\Torin_1-0003\' ...
% '2nd image set\Whole_mount_cy5pdx_cy3E-cad_DAPI_140217\Torin_1-0004\Torin_1-0004\' ...
% '2nd image set\Whole_mount_cy5pdx_cy3E-cad_DAPI_140217\Torin_1-0005\Torin_1-0005\' ...
% '2nd image set\Whole_mount_cy5pdx_cy3E-cad_DAPI_140217\Torin_wash_1-0001\Torin_wash_1-0001\' ...
 % '2nd image set\Whole_mount_cy5pdx_cy3E-cad_DAPI_140217\Torin_wash_1-0002\Torin_wash_1-0002\' ...
% '2nd image set\Whole_mount_cy5pdx_cy3E-cad_DAPI_140217\Torin_wash_1-0003\Torin_wash_1-0003\' ...
'2nd image set\Whole_mount_cy5pdx_cy3E-cad_DAPI_140217\Torin_wash_1-0005\Torin_wash_1-0005\' ...
};

%% REJECTED ISLETS
% REJECT 1) BAD Z-RESOLVING:
%'2nd image set\Whole_mount_cy5pdx_cy3E-cad_DAPI_140217\Torin_wash_1-0004\Torin_wash_1-0004\' ... 

% REJECT 2)
% '3rd image set\Whole_mount_Islets_with_Torin_Cy5pdx_cy3E-cad_DAPI_080317\Torin_wash\0001\' ...
% Reason for rejection: Calculating the distance to center of islet is not supported for
% two islets, consider cropping the image into two seperate islet stacks.


ResultsTable = table(); % initialize empty table

for f=1:length(folders)
  folder = folders(f)
  %% LOAD IMAGES
  [DAPI, ECad, PDX1] = LoadImages([inpath char(folder)]);

  %% AUTO-CROP CYTO
  [cyto, nuc, pdx1] = AutoCrop(ECad, DAPI, PDX1);

  %% NORMALIZE BRIGHTNESS IN Z-DIMENSION
  cyto_norm = NormalizeZ(cyto, 90);
  nuc_norm = NormalizeZ(nuc, 90);
  pdx1_norm = NormalizeZ(pdx1, 90);
  % figure('name','ECad','NumberTitle', 'off'); imshow3Dfull(cyto_norm,[]);

  % SMOOTH
  cyto_smooth = SmoothIslet(cyto_norm, folder);

  %% SEEDS
  % Seeding algorithm #1: Find seeds in 3D using imhmin and imregionalmin on cytoplasm
  seeds = Seeding1_cyto_imhmin_3D(cyto_norm, cyto_smooth);
  % Alternative seeding algorithms go here:
  % seeds = Seeding2_YOUR_NEW_ALGORITHM(cyto_norm, cyto_smooth);

  %% SEGMENTATION
  % Segmentation algorithm #2: Simple seed based watershed 3D
  labelled_cyto = Segmentation2_watershed_3D(cyto_norm, cyto_smooth, seeds);
  % Alternative seeding algorithms go here:
  % Segmentation algorithm #1: enhance boundries with imerode then markerless 2D watershed
  % labelled_cyto = Segmentation1_imerode_markerless_watershed_2D(cyto_norm);

  %% MEASUREMENTS
  newResults = NewMeasurements(cyto_norm, nuc_norm, pdx1_norm, labelled_cyto, folder);

  % STORE RESULTS
  ResultsTable = [ResultsTable; newResults];
end

save('ResultsTable.mat', 'ResultsTable');
save('AllVars.mat');


load('ResultsTable.mat');
%load('ResultsTable2D.mat'); ResultsTable2D = ResultsTable;
%load('ResultsTable3D.mat'); ResultsTable3D = ResultsTable;

%%
%% FILTERING BAD DATA SECTION
%%

% % Filter by solidity
% solidity_thresholds = [0.75 0.75 0.75 0.75 0.85 0.75 0.85 0.75];
% subsetTable = table();
% for img_id=img_ids
%     newSubset = ResultsTable(find(strcmp(ResultsTable.Image,{['Image ', int2str(img_id)]})),:);
%     subset_ids=newSubset.Solidity>solidity_thresholds(img_id);
%     newSubset=newSubset(subset_ids,:);
%     subsetTable = [subsetTable; newSubset];
% end

% % Filter very big objects
% max_cell_size = 10000;
% subsetTable=subsetTable(subsetTable.CellSize<10000,:);

% % Filter by reporter
% insulin_thresholds = [12 4.6 40 14 33 31 9 9];
% insulinTable = table();
% for img_id=img_ids
%     subset_ids=subsetTable.ReporterIntensity>insulin_thresholds(img_id);
%     newSubset=subsetTable(subset_ids,:);
%     newSubset = newSubset(find(strcmp(newSubset.Image,{['Image ', int2str(img_id)]})),:);
%     insulinTable = [insulinTable; newSubset];
% end

% % Filter cells touching Z-bottom


%%
%% GRAPHICS SECTION (plots and images)
%%

subsetTable = ResultsTable;

% Anova table and boxplot
figure
[p,t,stats] = anova1(subsetTable.CellSize,subsetTable.Stack);
set(gca,'FontSize',19)


% Bar chart (per stack)
Means = grpstats(subsetTable.CellSize,subsetTable.Stack,'mean');
Stds = grpstats(subsetTable.CellSize,subsetTable.Stack,'std');
Lngth = grpstats(subsetTable.CellSize,subsetTable.Stack,'numel');
figure
bar(Means)
hold on
errorbar(Means,Stds./sqrt(Lngth),'.r')
ylabel('Cell Area (pixel count)', 'FontSize', 21);
for i=1:length(Means)
  text(i+0.06,Means(i)+30,int2str(Means(i)),'FontSize',20);
end
set(gca,'FontSize',19,'XTickLabel',unique(subsetTable.Stack))

% Bar chart (experimental classes)
Means = grpstats(subsetTable.CellSize,subsetTable.Experiment,'mean');
Stds = grpstats(subsetTable.CellSize,subsetTable.Experiment,'std');
Lngth = grpstats(subsetTable.CellSize,subsetTable.Experiment,'numel');
figure
bar(Means)
hold on
errorbar(Means,Stds./sqrt(Lngth),'.r')
ylabel('Cell Area (pixel count)', 'FontSize', 21);
for i=1:length(Means)
  text(i+0.06,Means(i)+30,int2str(Means(i)),'FontSize',20);
end
set(gca,'FontSize',19,'XTickLabel',unique(subsetTable.Experiment))


%% SAVE GIFS TO DISK
Gif1_RGB_on_Cyto(subsetTable, inpath);

%% PLOTTING 2D vs 3D
%PlotBarChart2Dvs3D(ResultsTable2D, ResultsTable3D); 