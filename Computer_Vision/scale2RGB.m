%--------------------------------------------------------------------------
%
% File Name:      scale2RGB.m
% Date Created:   2016/08/05
% Date Modified:  2016/12/03
%
% Author:         Eric Cristofalo
% Contact:        eric.cristofalo@gmail.com
%
% Description:    Converts any 2D matrix of doubles to a scaled image for
%                 the Matlab function imwrite to accept.
%
% Inputs:         imGray: [h x w] double matrix
%                 valueBounds: OPTIONAL [2 x 1] double matrix
%
% Outputs:        im: [h x w x 3] uint8 matrix
%
% Example:        im = scale2RGB(imGray, [0,255]);
%
%--------------------------------------------------------------------------

function im = scale2RGB(varargin)

% Check for Logical Input Arguments
if (nargin==0 || nargin>2)
   error('Incorrect input arguments')
end

% Assign Inputs
imGray = varargin{1};
if nargin==2
   valueBounds = varargin{2};
end

% Define Colormap as uint8 Version of Default Colormap
%colormap default;
%map = colormap;
map = ...
[  0    0  144;
   0    0  160;
   0    0  176;
   0    0  192;
   0    0  208;
   0    0  224;
   0    0  240;
   0    0  255;
   0   16  255;
   0   32  255;
   0   48  255;
   0   64  255;
   0   80  255;
   0   96  255;
   0  112  255;
   0  128  255;
   0  144  255;
   0  160  255;
   0  176  255;
   0  192  255;
   0  208  255;
   0  224  255;
   0  240  255;
   0  255  255;
   16  255  240;
   32  255  224;
   48  255  208;
   64  255  192;
   80  255  176;
   96  255  160;
   112  255  144;
   128  255  128;
   144  255  112;
   160  255   96;
   176  255   80;
   192  255   64;
   208  255   48;
   224  255   32;
   240  255   16;
   255  255    0;
   255  240    0;
   255  224    0;
   255  208    0;
   255  192    0;
   255  176    0;
   255  160    0;
   255  144    0;
   255  128    0;
   255  112    0;
   255   96    0;
   255   80    0;
   255   64    0;
   255   48    0;
   255   32    0;
   255   16    0;
   255    0    0;
   240    0    0;
   224    0    0;
   208    0    0;
   192    0    0;
   176    0    0;
   160    0    0;
   144    0    0;
   128    0    0];
map = uint8(map);
colormapSize = size(map);

% Define Image Colors Based on Color Map
if nargin==2
   imGrayMax = valueBounds(2);
   imGrayMin = valueBounds(1);
else
   imGrayMax = max(max(imGray));
   imGrayMin = min(min(imGray(imGray~=0)));
end
imGrayInt = linInt(imGrayMin,0,imGrayMax,colormapSize(1),imGray);
imGrayInt = ceil(imGrayInt);

% Output Image
imGraySize = size(imGray);
im = uint8(zeros(imGraySize(1),imGraySize(2),3));
for i = 1:imGraySize(1)
   for j = 1:imGraySize(2)
      ind = imGrayInt(i,j);
      if (ind>0)
         mapTemp = map(ind,:);
         im(i,j,1) = mapTemp(1,1);
         im(i,j,2) = mapTemp(1,2);
         im(i,j,3) = mapTemp(1,3);
      end
   end
end

end