%--------------------------------------------------------------------------
%
% File Name:      subsampleImages.m
% Date Created:   2015/08/09
% Date Modified:  2015/08/09
%
% Author:         Eric Cristofalo
% Contact:        eric.cristofalo@gmail.com
%
% Description:    
%
% Inputs:         
%
% Outputs:        
%                       
% Example:        
%
%--------------------------------------------------------------------------

clean

%% User Inputs

numImages = 50;   % desired number of images in subsample
numSamples = 5;   % desired number of subsample folders to be created

folderPath = '/Users/ericcristofalo/Dropbox/Cloud/Documents/BU_local/Research/p2005_30';
fileExt = 'tif';

newFolderName = 'Sampled_Images';


%% Subsample Images in Folder

% Find Images
imageList = dir(fullfile(folderPath,['*.',fileExt]));
curImageList = 1:size(imageList,1);

% Cycle Through Subsamples
for i = 1:numSamples
   
   % Create New Folder If Needed
   curFolderName = [newFolderName,'_',num2str(i)];
   curDirectory = [folderPath,'/',curFolderName];
   if exist(curDirectory,'file')~=7
      mkdir(curDirectory);
   end
   disp(' ');
   disp(['New folder created: ',curFolderName]);
   disp(' ');
   
   % Subsample images
   newImageList = randsample(curImageList,numImages);
   
   % Save New Images to New Folder
   for j = 1:numImages
      curImInd = newImageList(j);
      curImageName = imageList(curImInd).name;
      curImage = [folderPath,'/',curImageName];
      newImage = [curDirectory,'/',curImageName];
      copyfile(curImage,newImage);
      
      percentage = ((i-1)*numImages+j)/(numImages*numSamples)*100;
      disp(['Percentage complete: ',sprintf('%0.0f',percentage)]);
      
   end
   
end

