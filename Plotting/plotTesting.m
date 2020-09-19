%--------------------------------------------------------------------------
%
% File Name:      plotTesting.m
% Date Created:   2014/07/03
% Date Modified:  2014/07/07
%
% Author:         Eric Cristofalo
% Contact:        eric.cristofalo@gmail.com
%
% Description:    Testing various plotting features in MATLAB to make two
%                 awesome plotting and figure saving programs.
%
% Inputs:
% Outputs:
%
% Example:
%
%--------------------------------------------------------------------------

close all; clear all; clc;

%% Generate Test Figures

numFigures = 6;
for i = 1:numFigures;
   X = 1:10;
   Y = rand(10,1)*10;
   figure(i); plot(X,Y,'LineWidth',2)
end


%% tileFigures

% Inputs
numFigures = 6;
rows = 2;
cols = 3;
total = rows*cols;
% plotFormat = 'Default';
plotFormat = 'Presentation';
% dualScreens = 'Primary';
dualScreens = 'Secondary';


% FUNCTION: tileFigures(10,2,3,'Default','Secondary')

% Set Figure Defaults
width = 560;
height = 420;
% height = 200;
displays = screenSize;
figCount = 1;

% Calculate Figure Positions
switch dualScreens
   
   % Primary Screen Figure Locations
   case 'Primary'
      % Save Screen Data
      d.hor.start = displays(1,1);
      d.ver.start = displays(1,2);
      d.hor.end = displays(1,3);
      d.ver.end = displays(1,4);
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
      d.hor.start = displays(2,1);
      d.ver.start = displays(2,2);
      d.hor.end = 0;
      d.ver.end = displays(2,4)+d.ver.start+1;
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
   
   figure(figNum);
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
   
   % Update Figure Counter
   figCount = figCount+1;
   
end



% Original Algorithm 2014/07/06
% for r = 1:rows
%    for c = 1:cols
%       cVal = c-1;
%       rVal = rows-r;
%       if r == 1 && c~=cols
%          position{r,c} = [d.hor.start+cVal*d.hor.range, d.ver.end-height];
%       elseif r ~= 1 && c == cols
%          position{r,c} = [d.hor.end-width, d.ver.start+rVal*d.ver.range];
%       elseif r == 1 && c == cols
%          position{r,c} = [d.hor.end-width, d.ver.end-height];
%       else
%          position{r,c} = [d.hor.start+cVal*d.hor.range, d.ver.start+rVal*d.ver.range];
%       end
%    end
% end

% OTHER
% ratio = 8/6;            % magic width/height ratio
% height = 14.8;          % cm
% width = height*ratio;   % cm

% set(1,'Units','pixels')
% currentPosition = get(1,'Position');


%%  saveFigures

% Inputs:
figureNames = {'test1';'test2';'test3';'test4';'test5';...
   'test6'};%;'test7';'test8';'test9';'test10'};
figureHandleRange = 1:8;
extension = 'pdf';

% FUNCTION: saveFigures(figureHandleRange,figureNames,extension)

% Create Specific Figure Filepath
if exist('figures','file')~=7
   mkdir('figures')
end

figureInd = 1;
% Save All Specified Figures
for i = figureHandleRange
   
   % Ensure Figure Exists
   if ~ishandle(i) % if handle does not exist
      disp(['Error: Figure ',num2str(i),' does not exist.'])
      figureInd = figureInd+1; % increase figure index
      continue % skip current loop
   end
   
   figure(i);
   set(i,'Units','centimeters');
   currentPosition = get(i,'Position');
   set(i,'PaperUnits','centimeters');
   set(i,'Position',currentPosition,...
      'PaperSize',currentPosition(3:4),...
      'PaperPositionMode','auto',...
      'InvertHardcopy', 'off',...
      'Renderer','painters'); % recommended if there are no alphamaps
%    set(gca,'fontsize',20);
   set(gca, 'color', 'none');
   set(gcf, 'color', 'none');
   
   % Save Figure
   path = [pwd,'/figures/',figureNames{figureInd},'.',extension];
   saveas(i,path);
   
   figureInd = figureInd+1; % increase figure index
   
end

