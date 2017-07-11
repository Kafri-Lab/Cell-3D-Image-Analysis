stats=regionprops(labelled_cyto,'area');
area = cat(1, stats.Area);
labelled_by_size = zeros(size(labelled_cyto));
for cell_id=1:max(labelled_cyto(:))
  labelled_by_size(labelled_cyto==cell_id)=area(cell_id);
end
COLOR_LIMIT = prctile(ResultsTable.CellSize,98);
labelled_by_size(labelled_by_size>COLOR_LIMIT)=COLOR_LIMIT; % make colors more beautiful by putting an upper limit
figure; imshow3Dfull(labelled_by_size,[])
