%--------------------------------------------------------------------------
%
% File Name:      renameFiles.m
% Date Created:   2014/09/02
% Date Modified:  2015/08/20
%
% Author:         Eric Cristofalo
% Contact:        eric.cristofalo@gmail.com
%
% Description:    Renames all files in a folder to take the specified
%                 file naming convention.
%                 This function assumes input file names take the format
%                    image_001.jpg, doc1.txt, DSC5001.pdf, etc.
%                 where characters preceed numbers.
%
% Inputs:         folderPath: (string) the path of the folder 
%                    containing several files.
%
%                 currentFileFormat: (string) the file formate of files to
%                    look for.
%
%                 desiredName: (string) desired naming convention of the 
%                    files. The number in the desired name will be the
%                    starting point of the newly numbered files.
%
% Outputs:        N/A
%                       
% Example:        
%
%--------------------------------------------------------------------------


%% User Inputs

% Directory of Files
folderPath = '/Users/ericcristofalo/Desktop/Images';

% Current File Format
currentFileFormat = 'jpg';

% Desired New File Names
% Includes: new file name prefix, new starting number index, 
%           and new file format
desiredName = 'image_0010.jpg';


%% Rename Files

% Determine Desired Naming Convention Properties
numLoc = zeros(1,length(desiredName));
for i = 1:length(desiredName)
   check = str2double(desiredName(i));
   if ~isnan(check) && isreal(check) % is character is a number
      numLoc(i)=1;
   end
end
[out,numInd] = find(numLoc==1);
newPrefix = desiredName(1:numInd(1)-1);
newNumber = str2double(desiredName(numInd));
newSuffix = desiredName(numInd(end)+1:end);
numberDecimals = ['%0',num2str(length(numInd)),'d'];

% Find Files in Directory
list = dir(fullfile(folderPath,['*.',currentFileFormat]));
numFiles = size(list,1);

% Rename Files
for i = 1:numFiles
   
   % Set File Variables
   curFile = list(i).name;
   newFile = [newPrefix,num2str(newNumber,numberDecimals),newSuffix];
   
   % Increase Number Index
   newNumber = newNumber+1;
   
   % File Path
   curFile = fullfile(folderPath,curFile);
   newFile = fullfile(folderPath,newFile);
   
   % Copy File to New File Name
   copyfile(curFile,newFile);
   
   % Delete Original File
   delete(curFile);
   
end

