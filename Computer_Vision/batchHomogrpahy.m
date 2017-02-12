%--------------------------------------------------------------------------
%
% File Name:      DfF.m
% Date Created:   2017/01/10
% Date Modified:  2017/01/12
%
% Author:         Eric Cristofalo
% Contact:        eric.cristofalo@gmail.com
%
% Description:    Compute relative perspective transformations for image
%                 sequence 
%
% Inputs:         folderPath: File directory containing folders of image
%                 sequences. Each image sequence is expected to have the 
%                 exact same number of images. 
%
% Outputs:        
%
%--------------------------------------------------------------------------

clean('Figures',0);


%% Initialization

folderPath = '/Users/ericcristofalo/Dropbox/PhD/Research/2017_Depth_From_Focus/Trials/';
folderList = {'20161206_01'};
imIndices = [1,30];
outputFolderPath1 = '/Users/ericcristofalo/Dropbox/PhD/Research/2017_Depth_From_Focus/Camera_Alignment/20170112_Nikon/H_12_size33.txt';
outputFolderPath2 = '/Users/ericcristofalo/Dropbox/PhD/Research/2017_Depth_From_Focus/Camera_Alignment/20170112_Nikon/H_i0_size33.txt';

% Total Indices Number
totalInd = diff(imIndices)+1;
totalTrials = size(folderList,2);

% Image Numbering Convention
imageName = 'img_';
imageExt = '.jpg';
imageDigists = 3;
imageDecimals = ['%0',num2str(imageDigists),'d'];


%% Compute Focus Measure

% Homography Initialization
matchType = 'BruteForce';
descriptorType = 'SIFT';
options = {'im1Warped','imMatches','imHomography'};
% options = {}; % no output image

% Initialization
imTotal = struct;
H_12 = zeros(3,3);
imTotal(1).H_12 = H_12;

for trialInd = 1:totalTrials;
   
   disp(['Processing trial ', num2str(trialInd), ' of ', num2str(totalTrials)]);

   folderName = [folderPath,folderList{trialInd},'/'];
   loopInd = 0;
   
for imInd = imIndices(1):imIndices(2)
   loopInd = loopInd+1;
   
   % Status Output
%    fprintf('\n\b\b\b\b');
%    perc = (imInd-imIndices(1))/(imIndices(2)-imIndices(1));
%    fprintf('%0.02f',perc);
   disp(['image ', num2str(imInd), ' of ', num2str(imIndices(2))]);
   
   % Read Current Image
   imPath = [folderName,imageName,num2str(imInd,imageDecimals),imageExt];
   im = imread(imPath);
   
   % Resize Image
   dSize = 1/3.3;
   imSize = size(im(:,:,1));
   imSize = ceil(dSize*imSize(1:2));
   im = cv.resize(im, [imSize(2),imSize(1)]);
   
   % Save Image
   if trialInd==1
      imTotal(loopInd).im = im;
   end
   
   % Align Images to First Image
   if imInd==imIndices(1)
   else
      % Compute Interimage Homography
      [H_12,outputs] = computeHomography(matchType, descriptorType,...
      	im, imTotal(loopInd-1).im, options);   
      % Save Data
      if trialInd==1
         imTotal(loopInd).H_12 = H_12;
      else
         imTotal(loopInd).H_12 = imTotal(loopInd).H_12 + H_12;
      end
   end

end

fprintf('\n');

end

% Average Homography Results
imTotal(1).H_i0 = eye(3);
for i = 1:totalInd
   imTotal(i).H_12 = imTotal(i).H_12./totalTrials;
   if i>1
      imTotal(i).H_i0 = imTotal(i).H_12*imTotal(i-1).H_i0;
   end
end

% Save Transformations to a Text File
H_12 = zeros(totalInd, 9);
H_i0 = zeros(totalInd, 9);
fileID1 = fopen(outputFolderPath1,'w');
fileID2 = fopen(outputFolderPath2,'w');
for i = 1:totalInd
   H_12(i,:) = reshape(imTotal(i).H_12,1,9);
   fprintf(fileID1,'%12.12f ',H_12(i,:));
   fprintf(fileID1,'\n');
   H_i0(i,:) = reshape(imTotal(i).H_i0,1,9);
   fprintf(fileID2,'%12.12f ',H_i0(i,:));
   fprintf(fileID2,'\n');
end
fclose(fileID1);
fclose(fileID2);

% Plot Final Transformation Results;
figure(1);
subplot(2,2,1); imshow(imTotal(1).im); title('Image 1');
subplot(2,2,2); imshow(imTotal(totalInd).im); title('Image n');
imWarped = cv.warpPerspective(imTotal(1).im, imTotal(1).H_i0);
subplot(2,2,3); imshow(imWarped); title('Total Warped Image 1');
imWarped = cv.warpPerspective(imTotal(totalInd).im, imTotal(totalInd).H_i0);
subplot(2,2,4); imshow(imWarped); title('Total Warped Image n');




