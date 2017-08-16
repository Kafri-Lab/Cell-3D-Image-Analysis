%% Find cell sizes
labelled_cyto=S;
cells = regionprops(labelled_cyto);
sizes = [cells.Area];
cells_bysize = zeros(size(labelled_cyto));
for cell_index=1:max(labelled_cyto(:))
  cells_bysize(labelled_cyto==cell_index)=sizes(cell_index);
end
figure('name','cells_bysize','NumberTitle', 'off');imshow3D(cells_bysize,[])
[sorted_sizes,sorted_cell_indexes] = sort(sizes); % used for visualizing size


%% Isosurface (coloured by size)
figure('name','isosurface','NumberTitle', 'off');
for cell_index=1:max(labelled_cyto(:))
  single_cell = zeros(size(labelled_cyto));
  single_cell(find(labelled_cyto==sorted_cell_indexes(cell_index)))=cell_index+0.5;
  if sorted_sizes(cell_index) < 1400 % skip if cell size is too small
    continue
  end
  if sorted_sizes(cell_index) > 1000000 % skip if cell size is too large
    continue
  end
  %single_cell = smooth3(single_cell,'gaussian',3); % smooth cell shape
  isosurface(single_cell, cell_index);
  progress = cell_index
%   if cell_index > 50 % only operate on subset for quick testing
%     break
%   end
end
daspect([1,1,1]) % tighter
axis off
axis vis3d % disable strech-to-fill
set(gca, 'color','none')
set(gcf, 'color',[1 1 1])
alpha(.7)
view([0, 90])
set(gca,'xlim',[0 size(labelled_cyto, 2)], 'ylim',[0 size(labelled_cyto, 1)], 'zlim',[0 size(labelled_cyto, 3)])
colormap(jet)
%colorbar


%% Create gif
% Rotate around the thing to take pictures.
view([0, 90])
disp('Take pictures')
addpath 'islet_functions/export_fig'

rotAngle = 3;
temp_images_dir = 'temp_images';
mkdir(temp_images_dir)

for i = 1:360/rotAngle
    disp(i)
    if i < 10
        prenum = '00';
    elseif i < 100
        prenum = '0';
    else
        prenum = '';
    end
    camorbit(rotAngle,0,'data',[-1 1 0])
    export_fig(strcat(temp_images_dir, '/', prenum, num2str(i), '.png'), ...
               '-a1', '-nocrop');
end


%% Make gif.
disp('Create gif')
imgs = dir([temp_images_dir '/*.png']);
filename = 'isosurface.gif';

for i = 1:size(imgs,1)
    disp(i)
    [frame, map, alp] = imread([temp_images_dir '/' imgs(i).name]);
    frame=frame(250:750,700:1200,:);
    [imind,cm] = rgb2ind(frame,256);
    if i == 1;
      imwrite(imind,cm,filename,'gif', 'DelayTime',0.05, 'Loopcount',inf);
    else
      imwrite(imind,cm,filename,'gif', 'DelayTime',0.05, 'WriteMode','append');
    end
end