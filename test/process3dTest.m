% clear all
load('dat2.mat');
xyRes=0.16;
zRes=0.1;
maxWidth=8;
maxNS=20;
bkGaussR=5;
bkOpenR=20;
hmaxThresh=0.04;
logThresh=0.04;
nucOptions = ...
    struct('ScaleRange', [4 6], 'ScaleRatio', 1, ...
    'Alpha', 0.2, 'Beta', 16,'Gamma',0.1,...
    'TargetSize',10,'verbose',true,'BlackWhite',true);
plateOptions = ...
    struct('ScaleRange', [1 3], 'ScaleRatio', 1,  'Alpha', 0.1, ...
    'Beta', 0.1,'Gamma',0.03,'verbose',true,'BlackWhite',true);
lineOptions = ...
    struct('FrangiScaleRange', [1 3], 'FrangiScaleRatio', 1, ...
    'FrangiBetaOne', 0.2, 'FrangiBetaTwo', 0.08, 'verbose',0,'BlackWhite',0);
nucGauss=[4,6,9];


sepFactors=1.5;
rsRate=sepFactors*zRes/xyRes;
c1=squeeze(imStack(:,:,1,:));
c2=squeeze(imStack(:,:,2,:));
c3=squeeze(imStack(:,:,3,:));
disp('preprocess...')
%rc1=single(c1);rc2=single(c2);rc3=single(c3);
rc1=interp1(1:size(c1,3),single(permute(c1,[3,1,2])),linspace(1,size(c1,3),size(c1,3)*rsRate),'pchip');
rc1=permute(rc1,[2,3,1]);
rc2=interp1(1:size(c2,3),single(permute(c2,[3,1,2])),linspace(1,size(c2,3),size(c2,3)*rsRate),'pchip');
rc2=permute(rc2,[2,3,1]);
rc3=interp1(1:size(c3,3),single(permute(c3,[3,1,2])),linspace(1,size(c3,3),size(c3,3)*rsRate),'pchip');
rc3=permute(rc3,[2,3,1]);
rc2=rc2+rc3;
clear c1 c2 c3 imStack rc3
disp('islet cropping...')
bkMask=imgaussfilt3(rc1+rc2,bkGaussR);
for i=1:size(rc1,3)
    
    bk=imopen(bkMask(:,:,i),strel('disk',bkOpenR));
    th=multithresh(bk,2);
    bkMask(:,:,i)=imbinarize(bk,th(1));
    rc1(:,:,i)=rc1(:,:,i).*bkMask(:,:,i);
    rc2(:,:,i)=rc2(:,:,i).*bkMask(:,:,i);
    
    
end
% zz=[];
% for i=1:size(rc1,3)
%     temp=rc2(:,:,i);
% zz(:,i)=hist(temp(:),100);
% end
% 
disp('normalization...')
for i=1:size(rc1,3)
    rc1(:,:,i)=medfilt2(rc1(:,:,i));
%    temp=rc1(:,:,i);
%    rc1(:,:,i)=single(rc1(:,:,i))./single(prctile(temp(:),99));
%    rc1(:,:,i)=single(rc1(:,:,i))./single(max(temp(:)));
    rc1(:,:,i)=single(rc1(:,:,i));
    rc1(:,:,i)=rc1(:,:,i)./max(rc1(:));
    rc1(:,:,i)=imgaussfilt(rc1(:,:,i)-imopen(rc1(:,:,i),strel('disk',maxWidth)),1);
    rc2(:,:,i)=medfilt2(rc2(:,:,i));
%    temp=rc2(:,:,i);
%    rc1(:,:,i)=single(rc1(:,:,i))./single(prctile(temp(:),99));
%    rc2(:,:,i)=single(rc2(:,:,i))./single(max(temp(:)));
    rc2(:,:,i)=single(rc2(:,:,i))./single(max(rc2(:)));
    rc2(:,:,i)=rc2(:,:,i)-imopen(rc2(:,:,i),strel('disk',maxNS));
    
    %single(prctile(temp(:),99.5))
    %imshowpair(~im2bw(bk,th(1))>0,rc1(:,:,i))
end
disp('nucleus enhancing...')
[blobI,~]=BlobFilter3D(rc2,nucOptions);
n1=imgaussfilt3(blobI,nucGauss(1));
n2=imgaussfilt3(blobI,nucGauss(2));

n2=max(n1-n2,...
    n2-imgaussfilt3(blobI,n(3)));
seeds=(n2>logThresh);
%clear rc2
%seeds=imextendedmax(n1,hmaxThresh);
disp('membrane enhancing...')
[plateI,~,Vx,Vy,Vz]=PlateFilter3D(rc1,blobI,plateOptions);
%clear blobI
disp('tensor voting...')
VotingField= CalcVotingField(plateI, Vx, Vy, Vz);

pc2=plateI;
for i=1:3
  pc2=imclose(pc2,strel('sphere',i));  
end
disp('line detection...')
pieceI=zeros(size(blobI),'single');
for i=1:size(rc1,3)  
    pieceI(:,:,i)=FrangiFilter2D(rc1(:,:,i),lineOptions);
    for j=1:3
        pieceI(:,:,i)=imclose(pieceI(:,:,i),strel('disk',j));
    end
    
    disp(i)
end


S=watershed(imimposemin(pieceI+pc2+VotingField-blobI,seeds|~bkMask));

