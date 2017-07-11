function cyto_smooth = SmoothIslet(cyto, folder)
  if strfind(char(folder), '3rd image set')
    cyto_smooth = imgaussfilt3(cyto,[4 4 3]);
  elseif strfind(char(folder), '2nd image set')
      cyto_smooth = imgaussfilt(cyto,6);
  else
    error('Error: did not recognized folder: %s', folder)
  end
  %figure('name','cyto_smooth','NumberTitle', 'off');imshow3Dfull(cyto_smooth,[])
end