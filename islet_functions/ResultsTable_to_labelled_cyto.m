function labelled_cyto = Gif1_RGB_on_Cyto(ResultsTable, inpath)
  % Save an RGB segmentation overlay image for each stack

  nope, this function is not done. it doesn't support 
      % TODO
      while looping over each folder
        labelled_cyto = bwlabel(labelled_by_size);


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
    
  end

end
