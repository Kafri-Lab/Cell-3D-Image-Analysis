function [DAPI, ECad, PDX1] = LoadImages(folder)
  if strfind(folder, '2nd image set') | strfind(folder, '3rd image set')
    DAPI = im3dread(folder, '*.tif', 1); % channel: DAPI
    ECad = im3dread(folder, '*.tif', 2); % channel: e-cadherin
    PDX1 = im3dread(folder, '*.tif', 3); % channel: pdx1
  % elseif contains(folder, 'NEW image set')
      % PUT IMAGE LOAD LOGIC FOR A NEW FOLDER HERE
  else
    error('Error: did not recognized folder: %s', folder)
  end
end