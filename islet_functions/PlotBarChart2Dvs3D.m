function PlotBarChart2Dvs3D(ResultsTable2D, ResultsTable3D)
  % Bar chart (experimental classes) 2D vs 3D
  Means2D = grpstats(ResultsTable2D.CellSize,ResultsTable2D.Experiment,'mean');
  Stds2D = grpstats(ResultsTable2D.CellSize,ResultsTable2D.Experiment,'std');
  Lngth2D = grpstats(ResultsTable2D.CellSize,ResultsTable2D.Experiment,'numel');
  Means3D = grpstats(ResultsTable3D.CellSize,ResultsTable3D.Experiment,'mean');
  Stds3D = grpstats(ResultsTable3D.CellSize,ResultsTable3D.Experiment,'std');
  Lngth3D = grpstats(ResultsTable3D.CellSize,ResultsTable3D.Experiment,'numel');
  Means = [Means2D; Means3D];
  Stds = log(log([Stds2D; Stds3D]));
  Lngth = log(log([Lngth2D; Lngth3D]));
  figure
  bar(log(Means))
  hold on
  errorbar(log(Means),log(Stds./sqrt(Lngth)),'.r')
  ylabel('Log (Cell Area)', 'FontSize', 15);
  xlabel('2D            Experimental Average              3D', 'FontSize', 15);
  set(gca,'FontSize',13,'XTickLabel',unique(subsetTable.Experiment))
  for i=1:length(Means)
    text(i,log(Means(i))+.25,['Area: ' int2str(Means(i))],'FontSize',14,'HorizontalAlignment','center');
  end
  ScaledMeans = [Means2D./max(Means2D); Means3D./max(Means3D)];
  for i=1:length(ScaledMeans)
    text(i,log(Means(i))-.25,[num2str(ScaledMeans(i)*100) '%'],'Color','white','FontSize',14,'HorizontalAlignment','center');
  end
  ylim([6 12])
  set(gca,'YTick',[])

  % Bar chart (per stack) 2D vs 3D (ACTUAL SIZE)
  Means2D = grpstats(ResultsTable2D.CellSize,ResultsTable2D.Stack,'mean');
  Means3D = grpstats(ResultsTable3D.CellSize,ResultsTable3D.Stack,'mean');
  Means = [Means2D Means3D];
  figure
  bar(Means)
  ylabel('Relative Cell Area', 'FontSize', 15);
  xlabel('Islet', 'FontSize', 15);
  set(gca,'FontSize',13,'XTickLabel',unique(ResultsTable3D.Stack))
  legend('2D','3D')

  % Bar chart (per stack) 2D vs 3D (RELATIVE SIZE)
  Means2D = grpstats(ResultsTable2D.CellSize,ResultsTable2D.Stack,'mean');
  Means3D = grpstats(ResultsTable3D.CellSize,ResultsTable3D.Stack,'mean');
  ScaledMeans2D = Means2D./max(Means2D);
  ScaledMeans3D = Means3D./max(Means3D);
  ScaledMeans = [ScaledMeans2D, ScaledMeans3D];
  figure
  bar(ScaledMeans)
  ylabel('Relative Cell Area', 'FontSize', 15);
  xlabel('Islet', 'FontSize', 15);
  set(gca,'FontSize',13,'XTickLabel',unique(ResultsTable3D.Stack))
  legend('2D','3D')
  hold on
  plot(ScaledMeans2D)
  hold on
  plot(ScaledMeans3D,'color',[1,.5,0])
end