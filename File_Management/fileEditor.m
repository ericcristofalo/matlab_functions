%--------------------------------------------------------------------------
%
% File Name:      fileEditor.m
% Date Created:   2014/06/23
% Date Modified:  2014/06/23
%
% Author:         Eric Cristofalo
% Contact:        eric.cristofalo@gmail.com
%
% Description:    Script for changing the names of multiple files.
%                 Currently only set up for image files in the following 
%                 format:
%                    'DSC_0001.JPG'
%
% Inputs:         N/A
%
% Outputs:        N/A
%
% Example:        N/A
%
%--------------------------------------------------------------------------

clean


%% INPUTS

% Path to Files
folderPath = '/Users/ericcristofalo/Desktop/temp';

% First File to be Changed
file1 = 'DSC_0001.JPG';

% Last File to be Changed
fileN = 'DSC_0284.JPG';


%% FUNCTION

% Add File Path to Current Directory
%addpath(genpath(folderPath));

% Create Number Indices
indStart  = str2double(file1(5:8));
indEnd    = str2double(fileN(5:8));

% Create Complete List of Files
files = dir(fullfile(folderPath,'DSC_*.JPG'));
fileFinal = files(end).name;
indFinal  = str2double(fileFinal(5:8));

% Create List of File to be Changed
indFile = 0;
count = 1;
changeList = [];
while indFile ~= indEnd;
   % Find Current File
   fileCur = files(count).name;
   indFile = str2double(fileCur(5:8));
   % Save to List
   changeList(count,1) = indFile;
   changeList(count,2) = indFinal+count;
   % Go to Next File
   count = count+1;
end

% Copy Change Files to New File Names
indTotal = length(changeList);
for i = 1:indTotal;
   % Indices
   indOrig = changeList(i,1);
   indCopy = changeList(i,2);
   % File Names
   strOrig = ['DSC_',num2str(indOrig,'%04d'),'.JPG'];
   strCopy = ['DSC_',num2str(indCopy,'%04d'),'.JPG'];
   % File Path
   fileOrig = fullfile(folderPath,strOrig);
   fileCopy = fullfile(folderPath,strCopy);
   % Copy File to New File Name
   copyfile(fileOrig,fileCopy);
   % Delete Original File
   delete(fileOrig);
   
end



