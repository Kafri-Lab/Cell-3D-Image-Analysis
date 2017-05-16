function PlotViolin(subsetTable)

addpath '\\carbon.research.sickkids.ca\rkafri\DanielS\Violinplot-Matlab'
figure('Position', [100, 100, 900, 850]);
vs = violinplot(subsetTable.CellSize, subsetTable.Stack);
set(gca,'FontSize',19)
ylabel('Cell Area (pixel count)', 'FontSize', 21);

end