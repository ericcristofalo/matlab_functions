%--------------------------------------------------------------------------
%
% File Name:      objectSegmentation.m
% Date Created:   2015/11/05
% Date Modified:  2015/11/05
%
% Author:         Eric Cristofalo
%                 Boston University, Boston 02215
% Contact:        eric.cristofalo@gmail.com
%
% Description:    Segmenting an object of each specified color from an image
%
% Requirements:   OpenCV
%
% Inputs:         im: MATLAB image
%                 colorAvg: [d x numColors] 
%                           Array of channel averages for each color, 
%                           d is the number of channels in the image
%                 colorVar: [d x numColors]
%                           Array of channel variances for each color, 
%                           d is the number of channels in the image
%
% Outputs:        centroidList:
%
% Example:        [centroidList] = objectSegmentation(im,colorAvg,colorVar)
%
%--------------------------------------------------------------------------


function [centroidList] = objectSegmentation(im,colorAvg,colorVar)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Number of Colors to Segment
numColors = size(colorAvg,2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Color Identificaiton
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialize Integer Identification Image
[imH,imW,imD] = size(im);
imInteger = zeros(imH,imW);

for k = 1:numColors % each color
   colorCond = zeros(imH,imW,imD); % binary ID matrix
   
   for i = 1:imD % each image channel
      
      % Udpate Color ID Conditions
      colorCond(:,:,i) = (im(:,:,i)>(colorAvg(i,k)-colorVar(i,k)) & ...
                          im(:,:,i)<(colorAvg(i,k)+colorVar(i,k)));
                       
      % Write Condition to a String for Later Evaluation
      if i==1
         condition = ['colorCond(:,:,',num2str(i),')==1'];
      else
         condition = [condition,' & colorCond(:,:,',num2str(i),')==1'];
      end
   end
   
   % ID Colors That Fit the Individual Channel Conditions
   eval(['[row,col] = find(',condition,');']);
   
   % Generate Integer Output Image
   for i = 1:length(row)
      imInteger(row(i),col(i)) = k;
   end
   
end

% Display Integer Image
% figure(2); imagesc(imInteger);
% impixelinfo;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Locating Square Centroids for Each Color
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

centroidList = [];
for k = 1:numColors;
   
   % Create Temporary Binary Matrix for kth Color
   imBinary = (imInteger==k);
   
   % Find Contours
   contours = cv.findContours(imBinary);
   
   % Find Area of Each Contour
   numContours = size(contours,2); % number of total contours found
   contourArea = zeros(numContours,1);
   for i = 1:numContours;
      contourArea(i,1) = cv.contourArea(contours{i});
   end
   
   % Check if Contour is Large Enough to be Considered
   areaCheck = 1.0e+02;
   areaPass = contours(contourArea >= areaCheck); % number of 'good' contours
   
   % Calculate Centroids of Each Contour
   numPass = size(areaPass,2);
   centroids = zeros(numPass,2);
   for i = 1:numPass
      
      % Obatin List of Individual Points in Each Contour
      numCurPoints = size(areaPass{i},2); % number of points in current contour
      points = zeros(numCurPoints,2);
      for j = 1:numCurPoints
         points(j,:) = cell2mat(areaPass{i}(j));
      end
      
      % Calculate Centroid of Each Passing Contour as the Average of its x
      % and y Points in the Image
      centroids(i,:) = mean(points,1);
   end
   
   centroidList = [centroidList;[centroids,ones(size(centroids,1),1)*k]];
   
   % Display Contours
   %imContour=cv.drawContours(imBinary,contours);
   %figure(k+10); imshow(imContour);
   
end

% figure(2); imagesc(imInteger);
% hold on;
% scatter(centroidList(:,1),centroidList(:,2));
% hold off;

