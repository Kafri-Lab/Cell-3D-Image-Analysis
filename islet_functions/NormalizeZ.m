function zstack_out = NormalizeZ(zstack_in, percentile)
  %% NORMALIZE BRIGHTNESS IN Z-DIMENSION
  zstack_out = zeros(size(zstack_in));
  zstack_in_modified=zstack_in;
  zstack_in_modified(zstack_in_modified<10)=NaN; % don't incorporate background in 90th percentile
  prctile_stack=squeeze(prctile(prctile(zstack_in_modified,90,2),90,1)); % 90th percentile for each z-slice
  for i = 1:size(zstack_in,3)
    zstack_out(:,:,i) = zstack_in(:,:,i) ./ prctile_stack(i);
  end
  % figure('name','zstack', 'NumberTitle','off');imshow3D(zstack,[])
end
