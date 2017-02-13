%--------------------------------------------------------------------------
%
% File Name:      iPhoneWallpaper.m
% Date Created:   2017/02/12
% Date Modified:  2017/02/12
%
% Author:         Eric Cristofalo
% Contact:        eric.cristofalo@gmail.com
%
% Description:    Create iPhone wallpaper given image
%
% Inputs:         
%
% Outputs:        
%
%--------------------------------------------------------------------------


%% 

% Read Image
im = imread('/Users/ericcristofalo/Desktop/2016-Porsche-911-GT3-RS-Exterior-Birds-Eye-View.jpg');
im = rot90(im,-1);
imSize = size(im);

% Crop Center of im
iPhoneSize = [1334,750];
yOff = 130;
xOff = 0;
yStart = (imSize(1)-iPhoneSize(1))/2+yOff;
yBox = yStart:(yStart+iPhoneSize(1)-1);
xStart = (imSize(2)-iPhoneSize(2))/2+xOff;
xBox = xStart:(xStart+iPhoneSize(2)-1);
imOut = im(yBox,xBox,:);

% Display Images
figure(1); clf(1); 
subplot(1,2,1); subimage(im);
subplot(1,2,2); subimage(imOut);
imwrite(imOut,'/Users/ericcristofalo/Desktop/image.jpg');


