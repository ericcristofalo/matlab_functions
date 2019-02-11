%--------------------------------------------------------------------------
%
% File Name:      scale2RGB.m
% Date Created:   2016/08/05
% Date Modified:  2018/01/02
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

% Define Image Colors Based on Color Map
addZeroValue = 0;
imZeroOut = zeros(size(imGray));
if ~isempty(valueBounds)
   imGrayMax = valueBounds(2);
   imGrayMin = valueBounds(1);
   % Add Color for Zero Values if There Are Values < imGrayMin or >
   % imGrayMax
   if (min(imGray(:))<imGrayMin || max(imGray(:))>imGrayMax)
      imZeroOut = (imGray<imGrayMin | imGray>imGrayMax);
      addZeroValue = 1;
   end
else
   imGrayMax = max(imGray(:));
   imGrayMin = min(imGray(:));
   % Add Color for Zero Values if There Are Values <=0
   if (imGrayMin<=0)
      imZeroOut = imGray<=0;
      addZeroValue = 1;
      imGrayMin = min(imGray(imGray>0));
   end
end
imGrayInt = linInt(double(imGrayMin),1,double(imGrayMax),colormapSize(1),double(imGray));
imGrayInt = round(imGrayInt);
if (addZeroValue)
   imGrayInt = imGrayInt+1;
   map = [0,0,0; map];
   imGrayInt(imZeroOut) = 1;
end

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

