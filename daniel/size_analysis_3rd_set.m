%load 'Z:\DanielS\old\pancreatic_islets\ResultsTable_3rdSet_3D.mat'
%load 'Z:\DanielS\old\pancreatic_islets\ResultsTable.mat'
% load 'Z:\DanielS\old\pancreatic_islets\ResultsTable3D.mat'
load 'Z:\YuvalDor\mouse islet z-stacks\code\ResultTables\ResultsTable_3rdSet_3D.mat'
unique(ResultsTable.Stack)

% Store the z-resolution that each stack was imaged at
stack_z_resolutions = containers.Map;
stack_z_resolutions('Cont23') = 0.15; % microns
stack_z_resolutions('Cont24') = 0.05; % microns
stack_z_resolutions('Cont25') = 0.1; % microns
stack_z_resolutions('Wash20') = 0.15; % microns
stack_z_resolutions('Wash22') = 0.1; % microns
stack_z_resolutions('Tor21') = 0.15; % microns
stack_z_resolutions('Tor20') = 0.12; % microns
stack_z_resolutions('Tor22') = 0.15; % microns
max_z_resolution = max(cell2mat(stack_z_resolutions.values));

% Filter out bad cells (upper and lower outliers)
subsetTable=ResultsTable(ResultsTable.CellSize<prctile(ResultsTable.CellSize,80),:);

% Scale cell sizes according to z-resolution (this does not calculate actual volume)
stack_names = unique(subsetTable.Stack,'stable');
for i=1:length(stack_names)
    stack_names(i)
    stack_size_scale_factor = max_z_resolution/stack_z_resolutions(char(stack_names(i)))
    temp = subsetTable(strcmp(subsetTable.Stack,stack_names(i)),:);
    subsetTable.CellSize(strcmp(subsetTable.Stack,stack_names(i))) = temp.CellSize / stack_size_scale_factor;
end

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
set(gca,'FontSize',19,'XTickLabel',unique(subsetTable.Stack,'stable'))   

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
set(gca,'FontSize',19,'XTickLabel',unique(subsetTable.Experiment,'stable'))
