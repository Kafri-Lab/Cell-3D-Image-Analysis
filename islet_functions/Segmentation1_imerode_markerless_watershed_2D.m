function labelled_cyto = Segmentation1_imerode_markerless_watershed_2D(cyto)
  %% METHOD: imerode + markerless 2D watershed

  %% SMOOTH CYTO
  cyto_smooth = imgaussfilt3(cyto,[4 4 4]);
  % figure('name','cyto_smooth','NumberTitle', 'off');imshow3D(cyto_smooth,[])

  %% CREATE MASK OF ENTIRE ISLET
  % Threshold
  islet = cyto_smooth>0.01;
  % figure('name','islet','NumberTitle', 'off');imshow3D(islet,[])
  % Fill holes
  islet2 = zeros(size(cyto));
  for i = 1:size(cyto, 3)
      islet2(:,:,i) = imfill(islet(:,:,i), 'holes');
  end
  % figure('name','islet2','NumberTitle', 'off');imshow3D(islet2,[])
  % Shrink to make better fit
  islet3 = zeros(size(cyto));
  for i = 1:size(cyto, 3)
      islet3(:,:,i) = imerode(islet2(:,:,i), strel('disk',6));
  end
  % figure('name','islet3','NumberTitle', 'off');imshow3D(islet3,[])
  islet = islet3;

  %% ERODE (enhances edges)
  cyto_erode = zeros(size(cyto));
  for i = 1:size(cyto, 3)
    cyto_erode(:,:,i) = imerode(cyto_smooth(:,:,i),strel('disk',5));
  end
  % figure('name','imerode', 'NumberTitle','off'); imshow3D(cyto_erode);
  
  %% WATERSHED
  cyto_erode(~islet)=-Inf; % KEEP ISLET AREA
  labelled_cyto = zeros(size(cyto));
  for i = 1:size(cyto, 3)
    labelled_cyto(:,:,i) = watershed(cyto_erode(:,:,i));
  end
  labelled_cyto=labelled_cyto-1; % minus one from all ids which removes the object with id 1 which is the background and keeps the ids starting at 1 which is good for region props
  labelled_cyto(labelled_cyto==-1)=0; % remove object which is the background
  % figure('name','cyto_watershed', 'NumberTitle','off'); imshow3D(labelled_cyto);

  %% DEBUG
  % cyto_overlay = zeros(size(cyto, 1), size(cyto, 2), size(cyto, 3), 3);
  % for i = 1:size(cyto, 3)
  %   all_ids = unique(labelled_cyto);
  %   labelled_by_size_color_fix=labelled_cyto(:,:,i);
  %   labelled_by_size_color_fix(end-length(all_ids)+1:end)=all_ids;
  %   cyto_overlay(:,:,i,:) = label2rgb(labelled_by_size_color_fix,'jet', 'k', 'shuffle'); 
  % end
  % nuc_rgb = cat(4, cyto, cyto, cyto);
  % cyto_overlay = uint8(cyto_overlay./15) + uint8(nuc_rgb) + 80;
  % % figure('name','cyto_overlay', 'NumberTitle','off');imshow3Dfull(uint8(cyto_overlay),[]);

  % %% SET UNIQUE IDS THROUGHOUT Z-STACK (because each slice was labelled independently)
  % labelled_cyto2 = zeros(size(cyto));
  % labelled_cyto2(:,:,1) = labelled_cyto(:,:,1);
  % for i = 2:size(cyto, 3)
  %   last_z_max = labelled_cyto2(:,:,i-1); % used to increase cyto labels as we loop through the stack
  %   last_z_max = max(last_z_max(:));
  %   last_z_max_matrix = ((labelled_cyto(:,:,i)>0) .* last_z_max); % matrix will be zero where there is no cyto and a value of last_z_max where there is cyto
  %   labelled_cyto2(:,:,i) = labelled_cyto(:,:,i) + last_z_max_matrix;
  % end
  % labelled_cyto = labelled_cyto2;
  % figure('name','labelled_cyto2', 'NumberTitle','off'); imshow3D(labelled_cyto);
end