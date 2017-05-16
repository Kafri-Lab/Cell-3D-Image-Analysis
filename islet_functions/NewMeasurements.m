function newResults = NewMeasurements(cyto, nuc, reporter, labelled_cyto, folder)
  newResults = table();

  name_map = containers.Map;
  name_map('3rd image set\Whole_mount_Islets_with_Torin_Cy5pdx_cy3E-cad_DAPI_080317\Control\0003\') = 'Cont23';
  name_map('3rd image set\Whole_mount_Islets_with_Torin_Cy5pdx_cy3E-cad_DAPI_080317\Control\0005\') = 'Cont25';
  name_map('3rd image set\Whole_mount_Islets_with_Torin_Cy5pdx_cy3E-cad_DAPI_080317\Control\0004\') = 'Cont24';
  name_map('3rd image set\Whole_mount_Islets_with_Torin_Cy5pdx_cy3E-cad_DAPI_080317\Torin_wash\0000\') = 'Wash20';
  name_map('3rd image set\Whole_mount_Islets_with_Torin_Cy5pdx_cy3E-cad_DAPI_080317\Torin_wash\0002\') = 'Wash22';
  name_map('3rd image set\Whole_mount_Islets_with_Torin_Cy5pdx_cy3E-cad_DAPI_080317\Torin\0001\') = 'Tor21';
  name_map('3rd image set\Whole_mount_Islets_with_Torin_Cy5pdx_cy3E-cad_DAPI_080317\Torin\0000\') = 'Tor20';
  name_map('3rd image set\Whole_mount_Islets_with_Torin_Cy5pdx_cy3E-cad_DAPI_080317\Torin\0002\') = 'Tor22';
  name_map('2nd image set\Whole_mount_cy5pdx_cy3E-cad_DAPI_140217\ctl_1-0000\ctl_1-0000\') = 'Cont0';
  name_map('2nd image set\Whole_mount_cy5pdx_cy3E-cad_DAPI_140217\ctl_1-0001\ctl_1-0001\') = 'Cont1';
  name_map('2nd image set\Whole_mount_cy5pdx_cy3E-cad_DAPI_140217\ctl_1-0002\ctl_1-0002\') = 'Cont2';
  name_map('2nd image set\Whole_mount_cy5pdx_cy3E-cad_DAPI_140217\ctl_1-0004\ctl_1-0004\') = 'Cont4';
  name_map('2nd image set\Whole_mount_cy5pdx_cy3E-cad_DAPI_140217\ctl_1-0005\ctl_1-0005\') = 'Cont5';
  name_map('2nd image set\Whole_mount_cy5pdx_cy3E-cad_DAPI_140217\Torin_1-0000\Torin_1-0000\') = 'Tor0';
  name_map('2nd image set\Whole_mount_cy5pdx_cy3E-cad_DAPI_140217\Torin_1-0003\Torin_1-0003\') = 'Tor3';
  name_map('2nd image set\Whole_mount_cy5pdx_cy3E-cad_DAPI_140217\Torin_1-0004\Torin_1-0004\') = 'Tor4';
  name_map('2nd image set\Whole_mount_cy5pdx_cy3E-cad_DAPI_140217\Torin_1-0005\Torin_1-0005\') = 'Tor5';
  name_map('2nd image set\Whole_mount_cy5pdx_cy3E-cad_DAPI_140217\Torin_1-0006\Torin_1-0006\') = 'Tor6';
  name_map('2nd image set\Whole_mount_cy5pdx_cy3E-cad_DAPI_140217\Torin_wash_1-0000\Torin_wash_1-0000\') = 'Wash0';
  name_map('2nd image set\Whole_mount_cy5pdx_cy3E-cad_DAPI_140217\Torin_wash_1-0001\Torin_wash_1-0001\') = 'Wash1';
  name_map('2nd image set\Whole_mount_cy5pdx_cy3E-cad_DAPI_140217\Torin_wash_1-0002\Torin_wash_1-0002\') = 'Wash2';
  name_map('2nd image set\Whole_mount_cy5pdx_cy3E-cad_DAPI_140217\Torin_wash_1-0003\Torin_wash_1-0003\') = 'Wash3';
  name_map('2nd image set\Whole_mount_cy5pdx_cy3E-cad_DAPI_140217\Torin_wash_1-0004\Torin_wash_1-0004\') = 'Wash4';
  name_map('2nd image set\Whole_mount_cy5pdx_cy3E-cad_DAPI_140217\Torin_wash_1-0005\Torin_wash_1-0005\') = 'Wash5';

  %% Cell Size
  cyto_stats=regionprops(labelled_cyto,'Area');
  newResults.CellSize = cat(1,cyto_stats.Area);
  
  %% Solidity
  labelled_by_solidity = zeros(size(cyto));
  for i = 1:size(labelled_cyto,3)
    labelled_slice = bwlabel(labelled_cyto(:,:,i));
    stats=regionprops(labelled_slice,'Solidity');
    solidity = cat(1,stats.Solidity);
    for id=1:max(labelled_slice(:))
      labelled_slice(labelled_slice==id)=solidity(id);
    end
    labelled_by_solidity(:,:,i) = labelled_slice;
  end
  % figure('name','labelled_by_solidity','NumberTitle', 'off');imshow3D(labelled_by_solidity,[])
  mean_solidity_stats=regionprops(labelled_cyto,labelled_by_solidity,'MeanIntensity');
  newResults.Solidity = cat(1,mean_solidity_stats.MeanIntensity);

  % DAPI
  nuc_stats=regionprops(labelled_cyto,nuc,'MeanIntensity');
  newResults.DAPI = cat(1,nuc_stats.MeanIntensity);

  % REPORTER
  nuc_stats=regionprops(labelled_cyto,reporter,'MeanIntensity');
  newResults.ReporterIntensity = cat(1,nuc_stats.MeanIntensity);

   % CENTROID
  cyto_stats=regionprops(labelled_cyto,'Centroid');
  newResults.Centroid = cat(1,cyto_stats.Centroid);
  
  %% EDGE SCORE - SLOW
  % BWDIST ON PERIM (to help select edge)
  for i = 1:size(cyto, 3)
    cyto_perim(:,:,i) = bwperim(labelled_cyto(:,:,i));
    cyto_dist(:,:,i) = bwdist(cyto_perim(:,:,i));
  end  % CALC EDGE SCORES
  EDGE_WIDTH_PX = 6;
  EdgeScore = zeros(max(labelled_cyto(:)),1);
  for cell_id=1:max(labelled_cyto(:))
    Cell=cyto(labelled_cyto==cell_id);
    Cell_dist=cyto_dist(labelled_cyto==cell_id);
    Cell_edge=Cell_dist<6; % EDGE WIDTH IN PIXELS
    slope=corrcoef(Cell_dist(Cell_edge),Cell(Cell_edge));
    slope=slope(2,1);
    % plot(Cell_dist(Cell_edge),Cell(Cell_edge),'.')
    % title(num2str(slope)); drawnow; pause
    EdgeScore(cell_id)=slope;
  end
  newResults.EdgeScore = EdgeScore;
  
  % Miriam 4/5/17: Alternate Edge Score
%   Gmag=zeros(size(cyto));
%   for iter=1:size(cyto,3)
%   [Gmag(:,:,iter)] = imclose(imgradient(mat2gray(cyto(:,:,iter)),'Sobel'),strel('disk',2)); 
%   end
%   MedEdgeGrad = zeros(max(labelled_cyto(:)),1);
%   FracEdgeGrad = zeros(max(labelled_cyto(:)),1);
%   for cell_id=1:max(labelled_cyto(:))
%       disp(cell_id)
%     Cell_edge=cyto_dist<6 & (labelled_cyto==cell_id);
%     [~,~,kk]=ind2sub(size(labelled_cyto), find(labelled_cyto==cell_id)); %find z-plane containing cell    
% %     figure(200);imshow(imoverlay(Gmag(:,:,min(kk)),bwperim(Cell_edge(:,:,min(kk))),[1 0 0]));
% %     figure(250);imshow(imoverlay(mat2gray(cyto(:,:,min(kk))),bwperim(Cell_edge(:,:,min(kk))),[1 0 0]));
%     [ii,jj]=find(cyto_dist(:,:,min(kk))<1 & labelled_cyto(:,:,min(kk))==cell_id); %coordinates of cell border pixels
%     EdgeGrad=zeros(size(ii));
%     for iter2=1:length(ii)
%         Grad=improfile(Gmag(:,:,min(kk)),[jj(iter2) cyto_stats(cell_id).Centroid(1)],[ii(iter2) cyto_stats(cell_id).Centroid(2)]);
%         EdgeGrad(iter2)=mean(Grad(1:5)); % Change to max(Grad(1:5))?
%     end
% %     figure(300);hist(EdgeGrad,50);title(num2str(median(EdgeGrad)));pause
%     MedEdgeGrad(cell_id)=median(EdgeGrad);
%     FracEdgeGrad(cell_id)= sum(EdgeGrad>0.4)/length(EdgeGrad);
%   end
%   newResults.MedEdgeGrad=MedEdgeGrad;
%   newResults.FracEdgeGrad=FracEdgeGrad;
  
  % FOLDER NAME
  folder_name = cell(1, max(labelled_cyto(:)));
  folder_name(:) = {char(folder)};
  newResults.Folder = folder_name';

  % STACK NAME (pretty name)
  stack_name = cell(1, max(labelled_cyto(:)));
  stack_name(:) = { name_map(char(folder)) };
  newResults.Stack = stack_name';

  % EXPERIMANTAL CLASS (control, torin, or torin wash)
  if or(contains(char(folder),'\ctl'),contains(char(folder),'\Control'))
    experimental_class = 'Control'
  elseif contains(char(folder),'\Torin_wash')
    experimental_class = 'Wash'
  elseif contains(char(folder),'\Torin')
    experimental_class = 'Torin'
  else
    error('Error: did not recognized folder: %s', folder)
  end
  experiment_class = cell(1, max(labelled_cyto(:)));
  experiment_class(:) = { experimental_class };
  newResults.Experiment = experiment_class';
  
  % DISTANCE TO CENTER OF ISLET
  % NOTE(Dan): nearest x-y center only for now
  % NOTE(Dan): if more than one islet is in the zstack there should be two 
  % different islet centers but this isn't implemented
  islet_center = [size(cyto,1)/2 size(cyto,2)/2]; % islets are centered in frame
  centroids = newResults.Centroid(:,1:2);
  centroids = centroids - islet_center;
  [theta,rho] = cart2pol(centroids(:,2),centroids(:,1));
  newResults.DistToCenter = rho;
 
  % PIXEL INDICES FOR EACH CYTO
  cyto_stats=regionprops(labelled_cyto,'PixelIdxList');
  PixelIdxList = cell(1, length(cyto_stats));
  for id=1:max(labelled_cyto(:))
    PixelIdxList{id} = cyto_stats(id).PixelIdxList;
  end
  newResults.PixelIdxList = PixelIdxList';

end
