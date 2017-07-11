function labelled_cyto = Segmentation2_watershed_3D(cyto, cyto_smooth, seeds)
  %% CREATE MASK OF ENTIRE ISLET
  % Threshold
  islet = cyto_smooth>0.01;
  % figure('name','islet','NumberTitle', 'off');imshow3Dfull(islet,[])
  % Fill holes
  islet2 = zeros(size(cyto));
  for i = 1:size(cyto, 3)
      islet2(:,:,i) = imfill(islet(:,:,i), 'holes');
  end
  % figure('name','islet2','NumberTitle', 'off');imshow3Dfull(islet2,[])
  % Shrink to make better fit
  islet3 = zeros(size(cyto));
  for i = 1:size(cyto, 3)
      islet3(:,:,i) = imerode(islet2(:,:,i), strel('disk',6));
  end
  % figure('name','islet3','NumberTitle', 'off');imshow3Dfull(islet3,[])
  islet = islet3;

  %% WATERSHED
  cyto_min = imimposemin(cyto_smooth, seeds);
  cyto_min(~islet)=-Inf; % KEEP ISLET AREA ONLY
  labelled_cyto = watershed(cyto_min);
  labelled_cyto=labelled_cyto-1; % minus one from all ids which removes the object with id 1 which is the background and keeps the ids starting at 1 which is good for region props
  labelled_cyto(labelled_cyto==-1)=0; % remove object which is the background
  % figure('name','labelled_cyto', 'NumberTitle','off');imshow3Dfull(labelled_cyto,[])

  % LABEL BY SIZE (for debugging only)
  cells = regionprops(labelled_cyto);
  sizes = [cells.Area];
  labelled_by_size = zeros(size(labelled_cyto));
  for cell_index=1:max(labelled_cyto(:))
    labelled_by_size(labelled_cyto==cell_index)=sizes(cell_index);
  end
  figure('name','labelled_by_size','NumberTitle', 'off');imshow3Dfull(labelled_by_size,[])
 
  % DEBUG (3D rgb overlay)
  boundries_rgb = zeros(size(cyto, 1), size(cyto, 2), size(cyto, 3), 3);
  for i = 1:size(cyto, 3)
    labelled_by_size_color_fix=labelled_by_size(:,:,i);
    labelled_by_size_color_fix(1)=min(sizes);
    labelled_by_size_color_fix(2)=10000;
    boundries_rgb(:,:,i,:) = label2rgb(labelled_by_size_color_fix,'jet', 'k'); 
  end
  cyto_rgb = cat(4, cyto, cyto, cyto);
  seed_rgb = cat(4, seeds, zeros(size(seeds)), zeros(size(seeds)));
  overlay_cyto = ... % uint8(seed_rgb*200) ...           % seeds
               + uint8(boundries_rgb./4)  ...  % segmented boundries
               + uint8(cyto_rgb*200);              % original cyto
  figure;imshow3Dfull(overlay_cyto,[]);
end