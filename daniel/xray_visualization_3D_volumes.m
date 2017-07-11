% Needed variables: labelled_cyto

addpath 'islet_functions'
addpath 'islet_functions\export_fig'


stats=regionprops(labelled_cyto,'area');
area = cat(1, stats.Area);
labelled_by_size = zeros(size(labelled_cyto));
for cell_id=1:max(labelled_cyto(:))
  labelled_by_size(labelled_cyto==cell_id)=area(cell_id);
end
COLOR_LIMIT = prctile(ResultsTable.CellSize,98);
labelled_by_size(labelled_by_size>COLOR_LIMIT)=COLOR_LIMIT; % make colors more beautiful by putting an upper limit
area(area>COLOR_LIMIT)=COLOR_LIMIT; % so that size_to_color_mapping is not accessed beyond its length
figure; imshow3Dfull(labelled_by_size,[])


size_to_color_mapping = linspace(1,255,COLOR_LIMIT);


% z-slices one at a time while 3d is rendered
Cmap=colormap(jet);
%Cmap=[Cmap;Cmap;Cmap;Cmap;Cmap;Cmap;Cmap;Cmap;Cmap;Cmap;Cmap];
slice_interval = 10
Zaxis=linspace(1,slice_interval,size(labelled_cyto,3));
[X,Y,Z]=meshgrid(1:size(labelled_cyto,2),1:size(labelled_cyto,1),Zaxis);
figure(4)
clf
set(gca,'xcolor',[0.8 0.8 0.8],'ycolor',[0.8 0.8 0.8],'zcolor',[0.8 0.8 0.8]);
set(gca,'xtick','','ytick','','ztick','')
box on
axis([1 size(labelled_cyto,1) 1 size(labelled_cyto,2) -0.1 size(labelled_cyto,3)/6])
set(gca,'color','k')
set(gcf,'color','k')
az = -68.7000;
el = 15.6000;
view(az,el);
light('Position',[200 20 -10],'Style','local')
for i=slice_interval+1:slice_interval:size(labelled_cyto,3)-1
    % draw a chunk of the visualization with size equal to slice_interval
    i
    V=labelled_cyto(:,:,i-slice_interval:i);
    X1=X(:,:,i-slice_interval:i);
    Y1=Y(:,:,i-slice_interval:i);
    Z1=Z(:,:,i-slice_interval:i);
    for cell_id=1:max(V(:))
        % draw each cell in this chunk of the visualization
        cell_id
        cell_shape = bwdist(bwperim(V==cell_id));
        if cell_shape(1) == Inf % skip cell if not in this chunk
            continue
        end
        Nuc_in=isosurface(X1,Y1,Z1,bwdist(bwperim(V==cell_id)),0);
        view(az,el)
        Nuc_in.FaceColor = Cmap(round(size_to_color_mapping(round(area(cell_id)))),:); % set color based on size
        Nuc_in.EdgeColor  = 'none';
        patch(Nuc_in)
        drawnow
    end
    export_fig(['3D_' int2str(i) '.png'], '-m2')
end