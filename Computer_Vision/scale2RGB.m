%--------------------------------------------------------------------------
%
% File Name:      scale2RGB.m
% Date Created:   2016/08/05
% Date Modified:  2017/02/27
%
% Author:         Eric Cristofalo
% Contact:        eric.cristofalo@gmail.com
%
% Description:    Converts any 2D matrix of doubles to a scaled image for
%                 the Matlab function imwrite to accept.
%
% Inputs:         imGray: [h x w] double matrix
%                 valueBounds: OPTIONAL 
%                              [2 x 1] double matrix
%                 colorDirection: OPTIONAL
%                                 'blue2red' string
%                                 'red2blue' string
%
% Outputs:        im: [h x w x 3] uint8 matrix
%
% Example:        im = scale2RGB(imGray, [0,255], 'blue2red');
%
%--------------------------------------------------------------------------

function im = scale2RGB(varargin)

% Check for Logical Input Arguments
if (nargin==0 || nargin>3)
   error('Incorrect input arguments')
end

% Assign Inputs
imGray = varargin{1};
valueBounds = [];
colorDirection = [];
if nargin>=2
   if ~ischar(varargin{2})
      valueBounds = varargin{2};
   else
      colorDirection = varargin{2};
   end
end
if nargin==3
   if isempty(valueBounds)
      valueBounds = varargin{3};
   else
      colorDirection = varargin{3};
   end
end

% Define Colormap as uint8 Version of Default Colormap
map = round(255*jet(256));
map = uint8(map);
colormapSize = size(map);

% Flip Color Map
if strcmp(colorDirection,'red2blue')
   map = flipud(map);
end

% Add Zero Color
map = [0,0,0; map];

% Define Image Colors Based on Color Map
if ~isempty(valueBounds)
   imGrayMax = valueBounds(2);
   imGrayMin = valueBounds(1);
else
   imGrayMax = max(imGray(:));
   temp = imGray~=0;
   imGrayMin = min(imGray(:));
end
imGrayInt = linInt(double(imGrayMin),0,double(imGrayMax),colormapSize(1),double(imGray));
imGrayInt = ceil(imGrayInt)+1;

% Output Image
imGraySize = size(imGray);
im = uint8(zeros(imGraySize(1),imGraySize(2),3));

% Extract Channel Components
r = zeros(imGraySize);
b = zeros(imGraySize);
g = zeros(imGraySize);
r(:) = map(imGrayInt,1);
b(:) = map(imGrayInt,2);
g(:) = map(imGrayInt,3);
im(:,:,1) = r;
im(:,:,2) = b;
im(:,:,3) = g;

end

