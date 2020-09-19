%--------------------------------------------------------------------------
%
% File Name:      acquireImage.m
% Date Created:   2014/09/07
% Date Modified:  2014/11/04
%
% Author:         Eric Cristofalo
% Contact:        eric.cristofalo@gmail.com
%
% Description:    Take quick image with IP camera.
%
% Inputs:         
%
% Outputs:        
%
% Example:        
%
%--------------------------------------------------------------------------


%% Acquire Single Image

% Camera Setup
url = 'http://192.168.10.194/image/jpeg.cgi'; % JPEG snapshot read

% Take Image
im = imread(url);

% Display Image
figure(1); image(im);

% Change Image Name
% imwrite(im,'im_09.jpg')














