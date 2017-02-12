%--------------------------------------------------------------------------
%
% File Name:      colorCalibration.m
% Date Created:   2014/08/20
% Date Modified:  2014/11/05
%
% Author:         Eric Cristofalo
% Contact:        eric.cristofalo@gmail.com
%
% Description:    Calibrate n number of colors for the average and
%                 variances of each RGB color channel
%
% Inputs:         im: MATLAB image
%                 numColors: number of colors to be calibrated
%
% Outputs:        colorAvg: [d x numColors] 
%                           Array of channel averages for each color, 
%                           d is the number of channels in the image
%                 colorVar: [d x numColors]
%                           Array of channel variances for each color, 
%                           d is the number of channels in the image
%
% Example:        [colorAvg,colorVar] = colorCalibration(im,numColors)
%
%--------------------------------------------------------------------------

function [colorAvg,colorVar] = colorCalibration(im,numColors)

% Display Input Image to be Calibrated
figure(); imshow(im);
impixelinfo;

% Initialization
channel = size(im,3);
colorAvg = zeros(channel,numColors);
colorVar = zeros(channel,numColors);
% colorVar2 = zeros(channel,numColors);

for k = 1:numColors;
   
   % Obtain Area of Interest
   title(['Chose Vertices for Color ',num2str(k)]);
   [x,y] = ginput(4);
   region = im(min(y):max(y),min(x):max(x),:);
   region = double(region);
   [rH,rW,channel] = size(region);
   
   % Calculate Color Averages
   for i = 1:channel
      colorAvg(i,k) = mean(mean(region(:,:,i)));
   end
   
   % Calculate Color Variances
   for i = 1:rH
      for j = 1:rW
          for ch = 1:channel
             colorVar(ch,k) = colorVar(ch,k)+abs(region(i,j,ch)-colorAvg(ch,k));
          end
      end
   end
   colorVar(:,k) = colorVar(:,k)./(rH*rW);
%    for i = 1:channel
%       colorVar2(i,k) = var(reshape(region(:,:,i),rH*rW,1),0,1);
%    end

end

% Close Calibration Figure
close

end

