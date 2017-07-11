addpath 'islet_functions'
addpath 'islet_functions\export_fig'

big_blob = imopen(imgaussfilt(cyto,5)>1,strel('disk',20));

slice_interval=1;
slices_to_visualize = 1:slice_interval:size(cyto_norm,3);
figure('Position', [100, 100, 400, 1000]); slice_figures = slice(cyto_norm,[],[],slices_to_visualize);
shading interp; colormap gray;
for n=1:length(slice_figures) %% Apply transparency mask
  slice_figures(n).AlphaData = big_blob(:,:,slices_to_visualize(n));
  slice_figures(n).FaceAlpha = 'interp'; 
end
az = -68.7000;
el = 15.6000;
view(az,el);
axis([1 size(cyto_norm,1) 1 size(cyto_norm,2) -0.1 size(cyto_norm,3)])
set(gca,'xcolor',[0.8 0.8 0.8],'ycolor',[0.8 0.8 0.8],'zcolor',[0.8 0.8 0.8]);
set(gca,'xtick','','ytick','','ztick','')
set(gca,'color','k')
set(gcf,'color','k')
box on

  %saveas(gcf,['../public/img/Gray.png'])

% make slices appear 1 by 1
for n=1:length(slice_figures) 
  slice_figures(n).Visible='off';
end
for n=1:length(slice_figures) 
  slice_figures(n).Visible='on';
  export_fig(['xray_' int2str(n) '.png'], '-m2')
end

% make slices appear 1 by 1 then skip a few by count=spacing
spacing = 10;
for n=1:length(slice_figures) 
  slice_figures(n).Visible='off';
end
% slice_figures(1).Visible='on';
for n=2:length(slice_figures) 
  slice_figures(n).Visible='on';
  %export_fig(['xray_' int2str(n) '.png'], '-m2')
  if mod(n,spacing) ~= 0
      slice_figures(n).Visible='off';
  end
end


