function cyto_smooth = SmoothIslet(cyto, folder)
  if contains(folder, '3rd image set')
    cyto_smooth = imgaussfilt3(cyto,[4 4 3]);
  elseif contains(folder, '2nd image set')
      cyto_smooth = imgaussfilt(cyto,6);
  else
    error('Error: did not recognized folder: %s', folder)
  end
  %figure('name','cyto_smooth','NumberTitle', 'off');imshow3D(cyto_smooth,[])
end