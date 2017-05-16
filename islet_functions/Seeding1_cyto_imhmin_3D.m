function seeds = Seeding1_cyto_imhmin_3D(cyto, cyto_smooth)
  %% FIND SEEDS (REGIONAL MIN CYTO)
  cyto_min=imhmin(cyto_smooth,.015); % suppresing local minima
  % figure('name','cyto_min','NumberTitle', 'off');imshow3D(cyto_min,[])
  [seeds]=imregionalmin(cyto_min);
  % Debug
  seed_rgb = cat(4, seeds, zeros(size(seeds)), zeros(size(seeds)));
  cyto_rgb = cat(4, cyto, cyto, cyto);
  overlay_seed_cyto = uint8(seed_rgb*200) + uint8(cyto_rgb*200);
  figure;imshow3Dfull(overlay_seed_cyto,[]);
end