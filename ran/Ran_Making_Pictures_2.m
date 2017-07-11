set(0,'DefaultFigureWindowStyle','docked')
inpath = 'D:\SickKids\DanielS\pancreatic_islets\images\set2\Torin_wash_1-0005\Torin_wash_1-0005';
addpath 'Matlab function library'

%% LOAD NUC IMAGES
% tiff images with 3 channels: e-cadherin, protein marker and pdx1
disp('Loading image...')
zpic_DAPI = im3dread(inpath, '*.tif', 1); %Blue channel: DAPI
zcount = size(zpic_DAPI, 3);
% figure('name','nuc','NumberTitle', 'off');imshow3Dfull(zpic_DAPI,[])

%% LOAD CYTO IMAGES
% tiff images with 3 channels: e-cadherin, protein marker and pdx1
disp('Loading image...')
zpic_ECad = im3dread(inpath, '*.tif', 2); %Red channel: e-cadherin
imcnt = size(zpic_ECad, 3);
% figure('name','cyto','NumberTitle', 'off');imshow3Dfull(zpic_ECad,[])

%% AUTO-CROP CYTO
padding = 30; % amount of padding around object to keep
big_blob = imdilate(zpic_ECad>0,strel('disk',5));
big_blob = imopen(big_blob,strel('disk',40));
stats = regionprops(big_blob, 'BoundingBox');
assert(length(stats) == 1, 'Error: Auto-crop failed. Expected only one large blob in z-stack but found %d\n', length(stats));
boundingbox = cat(1, stats.BoundingBox);
ymin = ceil(boundingbox(1)) - padding;
if ymin < 1 % out of bounds check
  ymin = 1;
end
ymax = ceil(boundingbox(1)) + ceil(boundingbox(4)) + padding;
if ymax > size(zpic_ECad,1) % out of bounds check
  ymax = size(zpic_ECad,1);
end
xmin = ceil(boundingbox(2)) - padding;
if xmin < 1 % out of bounds check
  xmin = 1;
end
xmax = ceil(boundingbox(2)) + ceil(boundingbox(5)) + padding;
if xmax > size(zpic_ECad,2) % out of bounds check
  xmax = size(zpic_ECad,2);
end
zmin = ceil(boundingbox(3));
zmax = ceil(boundingbox(3)) + ceil(boundingbox(6)) - 1;
zpic_cyto=zpic_ECad(xmin:xmax,ymin:ymax,zmin:zmax); % crop
zcount = size(zpic_cyto, 3);
% figure('name','cyto_cropped','NumberTitle', 'off');imshow3Dfull(zpic_cyto,[])

%% CROP NUC
zpic_nuc=zpic_DAPI(xmin:xmax,ymin:ymax,zmin:zmax); % crop
zcount = size(zpic_nuc, 3);
% figure('name','nuc_cropped','NumberTitle', 'off');imshow3Dfull(zpic_nuc,[])

%% NORMALIZE NUC BRIGHTNESS IN Z-DIMENSION
%  Apply to each z-slice a division of the 90th percentile of the z-slice
nuc_norm = zeros(size(zpic_nuc, 1), size(zpic_nuc, 2), zcount);
% Apr 4 comment: B = imhistmatch(A,ref)
for i=1:size(zpic_nuc,3)
    Pcs(i)=prctile(reshape(zpic_nuc(:,:,i),1,prod(size(zpic_nuc(:,:,1)))),95);
end

for i = 1:zcount
  nuc_norm(:,:,i) = zpic_nuc(:,:,i) ./ Pcs(i);
end

%% NORMALIZE CYTO BRIGHTNESS IN Z-DIMENSION
%  Apply to each z-slice a division of the mean of the z-slice
im_norm = zeros(size(zpic_cyto, 1), size(zpic_cyto, 2), zcount);

for i=1:size(zpic_nuc,3)
    Pcs(i)=prctile(reshape(zpic_cyto(:,:,i),1,prod(size(zpic_cyto(:,:,1)))),92);
end

for i = 1:zcount
  im_norm(:,:,i) = zpic_cyto(:,:,i) ./ Pcs(i);
end
% figure('name','smooth', 'NumberTitle','off');imshow3Dfull(im_norm,[])

%% THRESHOLD NUC
thr=0.4;
BW_Nuc=nuc_norm>thr;
% figure('name','thresh','NumberTitle', 'off');imshow3Dfull(BW_Nuc,[])

%% findings LabeledSeeds Ran
SmoothedIm = imgaussfilt3(nuc_norm,[6 6 2]);
LabeledSeeds=imdilate(imregionalmax(SmoothedIm) & nuc_norm>0.9,strel('sphere',3));

%% WATERSHED nucleii
nuc_smooth = nuc_norm;
nuc_min=imimposemin(imcomplement(nuc_smooth),LabeledSeeds);
nuc_ws=watershed(nuc_min);
nuc_ws2 = BW_Nuc & nuc_ws;

%% Cleaning Up
labelled_nuc=bwareaopen(nuc_ws2>0,50);
% labelled_nuc=imclearborder(labelled_nuc);
labelled_nuc=bwlabeln(labelled_nuc);

%% labeling LabeledSeeds
LabeledLabeledSeeds=zeros(size(LabeledSeeds));
LabeledSeeds=double(LabeledSeeds);
for j=1:max(labelled_nuc(:))
    LabeledLabeledSeeds(labelled_nuc==j&LabeledSeeds)=j;
end

% coordinating numbering (id's) of nuc and cyt
Cytoplasm=watershed(imimposemin(im_norm,labelled_nuc>0));
Cytoplasm2=double(Cytoplasm>0);
for i=1:max(labelled_nuc(:))
    v=Cytoplasm(labelled_nuc==i);
    v=round(mean(v));
    Cytoplasm2(Cytoplasm==v)=i;
end
Cytoplasm=Cytoplasm2;
clear Cytoplasm2


%
% im_norm_c=imcomplement(im_norm);
% im_norm_c(nuc_norm<0.05)=0;
% nuc_norm>0.05;
% im_norm(nuc_norm<0.05)

% data analysis
R=randperm(length(im_norm(:)));
figure
plot(im_norm(R(1:50000)),nuc_norm(R(1:50000)),'.')


%% Plotting

% calculate a surface around the whole islet
BoundingSurface=zeros(size(labelled_nuc));
for i=1:size(labelled_nuc,3)
    BoundingSurface(:,:,i)=~bwperim(bwconvhull(double((labelled_nuc(:,:,i)>0))));
end
BoundingSurf=isosurface(bwdist(BoundingSurface),0);
BoundingSurf.FaceColor=[0.7 0.7 0.7];
BoundingSurf.EdgeColor='none';
BoundingSurf.facealpha=0.2;


PlotPos=[...
    0.02 0.5 0.5 0.45;...
    0.53 0.5 0.45 0.45;...
    0.02 0.02 0.31 0.44;...
    0.33 0.02 0.31 0.44;...
    0.64 0.02 0.31 0.44];

stats=regionprops(labelled_nuc,'area','boundingbox','centroid');
stats2=regionprops(Cytoplasm,'area','boundingbox');

Cmap=colormap(lines);
Cmap2=colormap(prism);


for i=1:max(labelled_nuc(:))
    clf
    %     [ind]=find(LabeledSeeds==i);
    %     [x,y,z]=ind2sub(size(LabeledSeeds),ind);
    
    
    Nuc_i=isosurface(bwdist(bwperim(labelled_nuc==i)),0);
    Cell_i=isosurface(bwdist(bwperim(Cytoplasm==i)),0);
    
    figure(2)
    Nuc_in=isosurface(bwdist(bwperim(labelled_nuc>0)),0);
    Nuc_in.FaceColor = [0.8 0.8 0.8];
    Nuc_in.EdgeColor  = 'none';
    Nuc_in.facealpha  = 0.2;
    patch(Nuc_in)
    set(gca,'xcolor',[0.8 0.8 0.8],'ycolor',[0.8 0.8 0.8],'ycolor',[0.9 0.9 0.9]);
    set(gca,'xtick','','ytick','','ztick','')
    box on
    set(gca,'color','k')
      
    Nuc_i.FaceColor = 'red';
    Nuc_i.facealpha = 1;
    Nuc_i.EdgeColor  = 'none';
    patch(Nuc_i)
       
    camlight
    disp(i)
    view([80 60])
    
    figure(3)
    seed_i=isosurface(bwdist(bwperim(LabeledSeeds==i)),0);
    seed_i.FaceColor = Cmap2(3,:);
    seed_i.EdgeColor  = 'none';
    patch(seed_i)
    Nuc_i.facealpha  = 0.1;
    Nuc_i.FaceColor='red';
    patch(Nuc_i)
    set(gca,'xcolor',[0.8 0.8 0.8],'ycolor',[0.8 0.8 0.8],'ycolor',[0.8 0.8 0.8]);
    set(gca,'xtick','','ytick','','ztick','')
    box on
    set(gca,'color','k')
    view([25 -8])
    
    figure(4)
    Nuc_i.facealpha  = 1;
    Nuc_i.FaceColor='blue';
    patch(Nuc_i)
    Cell_i.facealpha  = 0.3;
    Cell_i.FaceColor='red';
    Cell_i.EdgeColor='none';
    patch(Cell_i)
    set(gca,'xcolor',[0.8 0.8 0.8],'ycolor',[0.8 0.8 0.8],'ycolor',[0.8 0.8 0.8]);
    set(gca,'xtick','','ytick','','ztick','')
    box on
    set(gca,'color','k')
    view([25 -8])
    
    
    set(gcf,'color','k')
    
    figure(5)
    B=round(stats(i).BoundingBox);
    
    %     increasing the size of bounding box
    IncWidth=40;
    IncWidth2=12;
    B=[max(B(1)-IncWidth/2,1) ...
        max(B(2)-IncWidth/2,1) ...
        max(B(3)-IncWidth2/2,1) ...
        min(B(1)+B(4)+IncWidth, size(nuc_norm,1))-B(1) ...
        min(B(2)+B(5)+IncWidth, size(nuc_norm,2))-B(2) ...
        min(B(3)+B(6)+IncWidth2, size(nuc_norm,3))-B(3)];
    
    CellIm=subvolume(nuc_norm,[B(1) B(1)+B(4) B(2) B(2)+B(5) B(3) B(3)+B(6)]);
%     slice(CellIm,[round(size(CellIm,1)/2)],[round(size(CellIm,2)/2)],[round(size(CellIm,3)/2)]); shading flat; colormap gray
    slice(CellIm,[],[],[round(size(CellIm,3)/2)]); shading flat; colormap gray
    CellSurface=bwdist(bwperim(labelled_nuc==i));
    CellSurface=subvolume(CellSurface,[B(1) B(1)+B(4) B(2) B(2)+B(5) B(3) B(3)+B(6)]);
    CellSurface=isosurface(CellSurface,0);
    CellSurface.FaceColor = 'red';
    CellSurface.facealpha = 0.3;
    CellSurface.EdgeColor  = 'none';
    hold on
    patch(CellSurface)
    
    LabeledSeedsurface=bwdist(bwperim(LabeledSeeds>0));
    LabeledSeedsurface=subvolume(LabeledSeedsurface,[B(1) B(1)+B(4) B(2) B(2)+B(5) B(3) B(3)+B(6)]);
    LabeledSeedsurface=isosurface(LabeledSeedsurface,0);
    LabeledSeedsurface.FaceColor = 'blue';
    LabeledSeedsurface.facealpha = 0.3;
    LabeledSeedsurface.EdgeColor  = 'none';
    hold on
    patch(LabeledSeedsurface)
    view([35 30])
    set(gca,'color','k')
    
    figure(1) %%%%%
    CellIm=subvolume(im_norm,[B(1) B(1)+B(4) B(2) B(2)+B(5) B(3) B(3)+B(6)]);
%     slice(CellIm,[round(size(CellIm,1)/2)],[round(size(CellIm,2)/2)],[round(size(CellIm,3)/2)]); shading flat; colormap gray
    slice(CellIm,[],[],[round(size(CellIm,3)/2)]); shading flat; colormap gray
    CellSurface=bwdist(bwperim(Cytoplasm==i));
    CellSurface=subvolume(CellSurface,[B(1) B(1)+B(4) B(2) B(2)+B(5) B(3) B(3)+B(6)]);
    CellSurface=isosurface(CellSurface,0);
    CellSurface.FaceColor = 'red';
    CellSurface.facealpha = 0.3;
    CellSurface.EdgeColor  = 'none';
    hold on
    patch(CellSurface)
    
%     CellSurface=bwdist(bwperim(labelled_nuc==i));
%     CellSurface=subvolume(CellSurface,[B(1) B(1)+B(4) B(2) B(2)+B(5) B(3) B(3)+B(6)]);
%     CellSurface=isosurface(CellSurface,0);
%     CellSurface.FaceColor = 'blue';
%     CellSurface.facealpha = 0.8;
%     CellSurface.EdgeColor  = 'none';
%     hold on
%     patch(CellSurface)
    view([35 30])
    set(gca,'color','k')
    
    
    fig = gcf;
    fig.InvertHardcopy = 'off';
    disp(i)
    saveas(gcf,['BetaCellFigures\Nuc_v5_' num2str(i)  '.png'])
end
% %
% %
% make movie

Cmap=colormap(lines);
Zaxis=linspace(1,10,63);
[X,Y,Z]=meshgrid(1:410,1:424,Zaxis);
for i=10:50
    figure(3)
    clf
    slice(X,Y,Z,nuc_norm,[],[],[Zaxis([1:5:(i-1) i])]); shading interp; colormap gray
    axis([1 424 1 410 -0.1 10.1])
    view([-40 10])
    set(gca,'xcolor',[0.8 0.8 0.8],'ycolor',[0.8 0.8 0.8],'ycolor',[0.8 0.8 0.8]);
    set(gca,'xtick','','ytick','','ztick','')
    set(gca,'color',[0.15 0.1 0.2])
    set(gcf,'color','k')
    box on
    drawnow

    figure(4)
    clf
    V=labelled_nuc(:,:,1:i);
    X1=X(:,:,1:i);
    Y1=Y(:,:,1:i);
    Z1=Z(:,:,1:i);
    for k=1:max(V(:))
        Nuc_in=isosurface(X1,Y1,Z1,bwdist(bwperim(V==k)),0);
        Nuc_in.FaceColor = Cmap(k,:);
        Nuc_in.EdgeColor  = 'none';
        patch(Nuc_in)
    end
    set(gca,'xcolor',[0.8 0.8 0.8],'ycolor',[0.8 0.8 0.8],'ycolor',[0.8 0.8 0.8]);
    set(gca,'xtick','','ytick','','ztick','')
    box on
    axis([1 424 1 410 -0.1 10.1])
    set(gca,'color','k')
    set(gcf,'color','k')
    view([-40 10])
    light('Position',[200 20 -10],'Style','local')
    drawnow
end
% %
% %
% %
% %
% %
% %
% %
% %
