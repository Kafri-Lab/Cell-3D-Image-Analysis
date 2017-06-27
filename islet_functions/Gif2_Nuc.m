function CreateGif(ResultsTable)
  inpath = '\\carbon.research.sickkids.ca\rkafri\YuvalDor\mouse islet z-stacks\images\';

  folders = unique(ResultsTable.Folder);
  stacks = unique(ResultsTable.Stack);

  for folder_id=1:length(folders)
    folder = folders{folder_id};
    stack_name = stacks{folder_id};

    %% LOAD CYTO IMAGE
    DAPI = im3dread([inpath folder], '*.tif', 1); % channel: DAPI
    ECad = im3dread([inpath folder], '*.tif', 2); % channel: e-cadherin

    %% AUTO-CROP CYTO
    [cyto, nuc] = AutoCrop(ECad, DAPI);

    %% SAVE GIF TO DISK
    filename = [stack_name '_nuc.gif'];
    imgs = uint8(nuc);
    for t=1:size(imgs,3)
        if t==1;
          imwrite(imgs(:,:,t),filename,'gif', 'DelayTime',0.1, 'Loopcount',inf);
        else
          imwrite(imgs(:,:,t),filename,'gif', 'DelayTime',0.1, 'WriteMode','append');
        end
    end

end
