zim = cyto;
zcount = size(cyto,3);
addpath export_fig
rmdir('gif')
mkdir('gif')
figure
% Save pictures
for i = 1:zcount
    if i < 10
        prenum = '00';
    elseif i < 100
        prenum = '0';
    else
        prenum = '';
    end
    imshow(uint8(squeeze(zim(:,:,i,:))),[])
    axis off
    set(gca, 'color','none')
    set(gcf, 'color',[1 1 1])
    export_fig(strcat(gif, '/', prenum, num2str(i), '.png'), '-a1');
end
% Make gif
imgs = dir('gif/*.png');
filename = strcat('gif.gif');
for i = 1:size(imgs,1)
    disp(i)
    [frame, map, alp] = imread([gif '/' imgs(i).name]);
    rgbImage = cat(3, frame, frame, frame);
    [imind,cm] = rgb2ind(rgbImage,256);
    if i == 1;
      imwrite(imind,cm,filename,'gif', 'DelayTime',0.1, 'Loopcount',inf);
    else
      imwrite(imind,cm,filename,'gif', 'DelayTime',0.1, 'WriteMode','append');
    end
end
