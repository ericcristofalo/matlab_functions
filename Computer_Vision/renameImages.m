%--------------------------------------------------------------------------
%
% File Name:      renameImages.m
% Date Created:   2014/09/02
% Date Modified:  2014/09/02
%
% Author:         Eric Cristofalo
% Contact:        eric.cristofalo@gmail.com
%
% Description:    Renames all images in a folder to take the specified
%                 image naming convention.
%                 This function assumes input file names take the format
%                    image01.jpg, IMG_0001.gif, IM1.bmp, etc.
%                 where character preceed numbers.
%                 File type is of no concern.
%
% Inputs:         folderPath: (string) the path of the folder 
%                    containing several images
%                 desiredName: (string) desired naming convention of the 
%                    images
%
% Outputs:        N/A
%                       
% Example:        
%
%--------------------------------------------------------------------------


%% renameImage

function renameImages(folderPath, desiredName)

% Determine Desired Naming Convention
numLoc = zeros(1,length(desiredName));
for i = 1:length(desiredName)
   check = str2double(desiredName(i));
   if ~isnan(check) && isreal(check) % is character is a number
      numLoc(i)=1;
   end
end
[out,nameInd] = find(numLoc==1);
namePrefix = desiredName(1:nameInd(1)-1);
nameSuffix = desiredName(nameInd(end)+1:end);

% Find Images in Folder
list = dir(fullfile(folderPath,'*.jpg'));
numImages = size(list,1);
numberDecimals = ['%0',num2str(length(nameInd)),'d'];
for i = 1:numImages
   % Set Image Variables
   curImage = list(i).name;
   newImage = [namePrefix,num2str(i,numberDecimals),nameSuffix];
   % File Path
   curImage = fullfile(folderPath,curImage);
   newImage = fullfile(folderPath,newImage);
   % Copy File to New File Name
   copyfile(curImage,newImage);
   % Delete Original File
   delete(curImage);
end

end

