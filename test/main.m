
clear all
addpath(genpath(pwd))
xyRes=0.16;
zRes=[0.09,0.09,0.12,0.09,0.09,0.09];
parset=struct('maxWidth',8,'maxNS',20,'bkGaussR',5,'bkOpenR',20,'hmaxThresh',0.04,...
    'nucGauss',[4,6,9],'logThresh',0.04);
parset.nucOptions = ...
    struct('ScaleRange', [4 7], 'ScaleRatio', 1, ...
    'Alpha', 0.2,'Gamma',0.1,...
     'TargetSize',10,'verbose',true,'BlackWhite',true);
parset.plateOptions = ...
    struct('ScaleRange', [1 3], 'ScaleRatio', 1,  'Alpha', 0.1, ...
    'Beta', 0.1,'Gamma',0.03,'verbose',true,'BlackWhite',true);
parset.lineOptions = ...
    struct('FrangiScaleRange', [1 3], 'FrangiScaleRatio', 1, ...
    'FrangiBetaOne', 0.2, 'FrangiBetaTwo', 0.08, 'verbose',0,'BlackWhite',0);


pathName = uigetdir;
pathlist=dir(pathName);
folderNames = {pathlist.name}';
FOLDER_NAME=@(str) cellfun(@(c) ~isempty(c), regexp(folderNames, str, 'once'));
expNames=folderNames(FOLDER_NAME('_TIFF'));

num_frames=zeros(length(expNames),1);

for i=1:length(expNames)
    temp = fullfile(pathName,expNames(i));
    filelist = dir([temp{1} filesep '*.tif']);    
    fileNames =fullfile(temp{1}, {filelist.name}');
    num_frames(i) = (numel(filelist));
    if num_frames(i)<1
        warning('empty folder')
        continue;
    end
    imInfo=imfinfo(fileNames{1});
    imStack=zeros(imInfo.Height,imInfo.Width,length(imInfo.BitsPerSample),...
        num_frames(i),getImDatatype(imInfo.MaxSampleValue(1)));
    for j=1:num_frames(i)
        imStack(:,:,:,j)=imread(fileNames{j});
    end
    S=process3d(imStack,xyRes,zRes(i),parset);
end