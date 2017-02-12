%--------------------------------------------------------------------------
%
% File Name:      plotTesting.m
% Date Created:   2014/07/03
% Date Modified:  2014/07/07
%
% Author:         Eric Cristofalo
% Contact:        eric.cristofalo@gmail.com
%
% Description:    Function that automatically aligns some number of figures
%                 in a desired grid. Extremely helpful when looking at many
%                 figures.
%
% Inputs:         numFigures: number of figures to be arranged
%                 rows: number of rows in the grid
%                 cols: number of columns in the grid
%                 plotFormat: desired format of the figures
%                    'Default' - default setting, grid on, box on
%                    'Presentation' - presentation setting, box on
%                 dualScreens: toggle for screen to display figures
%                    'Primary' - primary screen
%                    'Secondary' - secondary screen
% Outputs:        N/A
%
% Example:        numFigures = 10; rows = 3; cols = 4;
%                 plotFormat = 'Default'; dualScreens = 'Primary';
%                 tileFigures(10,2,3,'Default','Secondary')
%                 Aligns 10 figures in a 2x3 grid on the secondary screen
%
%--------------------------------------------------------------------------

%% tileFigures

function tileFigures(numFigures,rows,cols,plotFormat,dualScreens)

% Set Figure Constants
width = 560;
height = 420;
total = rows*cols;
%displays = screenSize;
displays = [    1,   0, 1440, 900 ;
            -1919, 570, 1920, 1200];
figCount = 1;

% Calculate Figure Positions
switch dualScreens
   
   % Primary Screen Figure Locations
   case 'Primary'
      % Save Screen Data
      d.hor.start = displays(end,1);
      d.ver.start = displays(end,2);
      d.hor.end = displays(end,3);
      d.ver.end = displays(end,4);
      d.hor.testRange = (d.hor.end-d.hor.start);
      d.ver.testRange = (d.ver.end-d.ver.start);
      
   % Secondary Screen Figure Locations
   case 'Secondary'
      % Check for Secondary Screen First
      numScreens = size(displays);
      if numScreens(1) < 2
         error('Error: Secondary display does not exist.')
      end
      % Save Screen Data
      d.hor.start = displays(1,1);
      d.ver.start = displays(1,2);
      d.hor.end = 0;
      d.ver.end = displays(1,4)+d.ver.start+1;
      d.hor.testRange = (d.hor.end-d.hor.start);
      d.ver.testRange = (d.ver.end-d.ver.start);
      
   otherwise
      error('Error: Please enter an appropriate screen input.')
end

% Fill Position Matrix
testHeight = height+73; % account for headers on figures 
if rows*testHeight<=d.ver.testRange && cols*width<=d.hor.testRange % fill width and height normally
   normalMode = [1 1];
   d.hor.range = width;
   d.ver.range = testHeight;
elseif rows*testHeight<=d.ver.testRange && cols*width>d.hor.testRange % ONLY fill height normally
   normalMode = [0 1];
   d.hor.range = floor((d.hor.testRange-width)/(cols-1));
   d.ver.range = testHeight;
elseif rows*testHeight>d.ver.testRange && cols*width<=d.hor.testRange % ONLY fill width normally
   normalMode = [1 0];
   d.hor.range = width;
   d.ver.range = floor((d.ver.testRange-testHeight)/(rows-1));
else % fill width and height with constricted values
   normalMode = [0 0];
   d.hor.range = floor((d.hor.testRange-width)/(cols-1));
   d.ver.range = floor((d.ver.testRange-testHeight)/(rows-1));
end
position = cell(rows,cols);
for r = 1:rows
   for c = 1:cols
      rVal = r-1;
      cVal = c-1;
      if r==rows && c~=cols && normalMode(2)==0
         position{r,c} = [d.hor.start+cVal*d.hor.range, d.ver.start];
      elseif r~=rows && c==cols && normalMode(1)==0
         position{r,c} = [d.hor.end-width, d.ver.end-testHeight-rVal*d.ver.range];
      elseif r==rows && c==cols && normalMode(1)==0  && normalMode(2)==0
         position{r,c} = [d.hor.end-width, d.ver.start];
      else
         position{r,c} = [d.hor.start+cVal*d.hor.range, d.ver.end-testHeight-rVal*d.ver.range];
      end
   end
end
position = position'; % plots left to right instead of top to bottom

% Set Default Parameters and Figure Locations
for figNum = 1:numFigures
   
   figure(figNum); clf(figNum);
   set(figNum,'Units','pixels'); % keep units of each figure in pixels
   
   % Manage Figure Location
   if figCount == total+1;
      figCount = 1;
   end
   
   % Set Plot Settings
   switch plotFormat
      
      case 'Default'
         box on; grid on;
         %lineWidth = 1;
         
      case 'Presentation'
         box on;
         %lineWidth = 3;
         
      otherwise
         error('Error: Please select an appropriate plot format.')
         
   end
   
   % Position Figures Accordingly
   set(figNum,'Position',[position{figCount},width,height])
   % postion denoted as: [left bottom width height]
   % set(1,'Position',[-1919,570,width,height])
   
   % Update Figure Counter
   figCount = figCount+1;
   
end