function [cyto, varargout] = AutoCrop(cyto, varargin)
  padding = 30; % amount of padding around object to keep

  big_blob = imopen(imgaussfilt(cyto,5)>1,strel('disk',20));
  stats = regionprops(big_blob, 'BoundingBox','Area');
  boundingbox = cat(1, stats.BoundingBox);
  area = cat(1, stats.Area);
  [num,max_index] = max(area);
  boundingbox = boundingbox(max_index,:);
  ymin = ceil(boundingbox(1)) - padding;
  if ymin < 1 % out of bounds check
    ymin = 1;
  end
  ymax = ceil(boundingbox(1)) + ceil(boundingbox(4)) + padding;
  if ymax > size(cyto,1) % out of bounds check
    ymax = size(cyto,1);
  end
  xmin = ceil(boundingbox(2)) - padding;
  if xmin < 1 % out of bounds check
    xmin = 1;
  end
  xmax = ceil(boundingbox(2)) + ceil(boundingbox(5)) + padding;
  if xmax > size(cyto,2) % out of bounds check
    xmax = size(cyto,2);
  end
  zmin = ceil(boundingbox(3));
  zmax = ceil(boundingbox(3)) + ceil(boundingbox(6)) - 1;
  cyto=cyto(xmin:xmax,ymin:ymax,zmin:zmax); % crop
  % figure('name','cyto_cropped','NumberTitle', 'off'); imshow3D(cyto,[]);

  % Crop additional stacks, if any
  for k = 1:length(varargin)
    varargout{k}=varargin{k}(xmin:xmax,ymin:ymax,zmin:zmax); % crop
  end
end
