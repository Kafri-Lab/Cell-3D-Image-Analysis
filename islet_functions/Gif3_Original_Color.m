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
    PDX1 = im3dread([inpath folder], '*.tif', 3); % channel: pdx1

    %% AUTO-CROP CYTO
    [cyto, nuc, pdx1] = AutoCrop(ECad, DAPI, PDX1);

    rgb_stack = uint8(cat(4, nuc, cyto, pdx1));

    %% SAVE GIF TO DISK
    filename = [stack_name '_orig.gif'];
    for i = 1:size(rgb_stack,3)
        [imind,cm] = rgb2ind(squeeze(rgb_stack(:,:,i,:)),256);
        if i == 1;
          imwrite(imind,cm,filename,'gif', 'DelayTime',0.1, 'Loopcount',inf);
        else
          imwrite(imind,cm,filename,'gif', 'DelayTime',0.1, 'WriteMode','append');
        end
    end

end
