function Gif1_RGB_on_Cyto(ResultsTable, inpath)
  % Save an RGB segmentation overlay image for each stack

  folders = unique(ResultsTable.Folder);
  stacks = unique(ResultsTable.Stack);

  % make colors more beautiful by setting an upper limit on size, where cells larger
  % than the limit won't display color differences
  COLOR_LIMIT = prctile(ResultsTable.CellSize,98);

  for folder_id=1:length(folders)
    folder = folders{folder_id};
    stack_name = stacks{folder_id};

    %% LOAD CYTO IMAGE
    ECad = im3dread([inpath folder], '*.tif', 2); % channel: e-cadherin

    %% AUTO-CROP CYTO
    cyto = AutoCrop(ECad);

    %% LABEL BY SIZE
    labelled_by_size = zeros(size(cyto));
    stack_ResultsTable = ResultsTable(find(strcmp(ResultsTable.Folder,{folder})),:);
    for i=1:height(stack_ResultsTable)
      PixelIdxList = cell2mat(stack_ResultsTable{i,{'PixelIdxList'}});
      labelled_by_size(PixelIdxList)=stack_ResultsTable{i,'CellSize'};
    end
    labelled_by_size(labelled_by_size>COLOR_LIMIT)=COLOR_LIMIT; % make colors more beautiful by putting an upper limit
    
    %% 1) RGB segmentation overlay BY SIZE (useful for seeing size)
    boundries_rgb = zeros(size(cyto, 1), size(cyto, 2), size(cyto, 3), 3);
    for i = 1:size(cyto, 3)
      labelled_by_size_color_fix=labelled_by_size(:,:,i);
      labelled_by_size_color_fix(1)=min(ResultsTable.CellSize);
      labelled_by_size_color_fix(2)=COLOR_LIMIT;
      boundries_rgb(:,:,i,:) = label2rgb(round(labelled_by_size_color_fix),'jet', 'k');
    end
    cyto_rgb = cat(4, cyto, cyto, cyto);
    cyto_overlay = uint8(boundries_rgb./6) ... % segmented boundries
                 + uint8(cyto_rgb);           % original cyto
    % figure('name','cyto_overlay', 'NumberTitle','off');imshow3Dfull(uint8(cyto_overlay),[]);
    
    %% SAVE GIF TO DISK
    filename = [stack_name '.gif'];
    for i = 1:size(cyto_overlay,3)
        [imind,cm] = rgb2ind(squeeze(cyto_overlay(:,:,i,:)),256);
        if i == 1;
          imwrite(imind,cm,filename,'gif', 'DelayTime',0.1, 'Loopcount',inf);
        else
          imwrite(imind,cm,filename,'gif', 'DelayTime',0.1, 'WriteMode','append');
        end
    end

    %% 2) RGB segmentation overlay SHUFFLED (more useful for seeing segmentation)
    boundries_rgb = zeros(size(cyto, 1), size(cyto, 2), size(cyto, 3), 3);
    for i = 1:size(cyto, 3)
      labelled_by_size_color_fix=labelled_by_size(:,:,i);
      labelled_by_size_color_fix(1)=min(ResultsTable.CellSize);
      labelled_by_size_color_fix(2)=COLOR_LIMIT;
      boundries_rgb(:,:,i,:) = label2rgb(round(labelled_by_size_color_fix),'jet', 'k', 'shuffle'); % SHUFFLE
    end
    cyto_rgb = cat(4, cyto, cyto, cyto);
    cyto_overlay = uint8(boundries_rgb./6) ... % segmented boundries
                 + uint8(cyto_rgb);           % original cyto
    % figure('name','cyto_overlay', 'NumberTitle','off');imshow3Dfull(uint8(cyto_overlay),[]);

    %% SAVE GIF TO DISK
    filename = ['colorshuffle_' stack_name '.gif'];
    for i = 1:size(cyto_overlay,3)
        [imind,cm] = rgb2ind(squeeze(cyto_overlay(:,:,i,:)),256);
        if i == 1;
          imwrite(imind,cm,filename,'gif', 'DelayTime',0.1, 'Loopcount',inf);
        else
          imwrite(imind,cm,filename,'gif', 'DelayTime',0.1, 'WriteMode','append');
        end
    end
  end
end
