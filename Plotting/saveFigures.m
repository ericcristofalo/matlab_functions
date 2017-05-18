%--------------------------------------------------------------------------
%
% File Name:      saveFigures.m
% Date Created:   2014/07/03
% Date Modified:  2017/04/14
%
% Author:         Eric Cristofalo
% Contact:        eric.cristofalo@gmail.com
%
% Description:    Function that automatically saves each desired figure in
%                 the specified format. Useful when saving many images that
%                 need to be formatted in the same manner. Saves three 
%                 figures in the folder: 'pwd/Figures' as individual 
%                 .pdf files. 
%
% Inputs:         Inputs are all optional and must be specified in the
%                 following manner:
%                    saveFigures(...,'OptionName',option,...);
%
%                 FigureRange: range of figure handles to be saved
%                 Names: cell of strings that contains the names of
%                        each figure to be saved 
%                 Extension: string that contains the desired extension
%                 FigureSize: cell of [2x1] arrays of figure dimensions 
%                             [width,height]
%                 TextSize: cell of values for text size
%                 TextFont: string that contains desired font
%                 Transparency: array of binary flags indicating that the figure
%                               includes transparencies (only a problem 
%                               for .pdfs)
%                 imageResolution: integer used to set desired resolution 
%                                (dpi) of final graphic for .jpg or .png
%
% Outputs:        Figures are saved to the folder:
%                 'pwd/figures/'
%
% Example:        range = 1:3;
%                 names = {'test1','test2','test3'};
%                 exten = 'pdf';
%                 saveFigures('FigureRange',range,'Names',names,'Extension',exten)
%                 or
%                 saveFigures % executes with default settings
%
%--------------------------------------------------------------------------

%%  saveFigures

function saveFigures(varargin)

% Check for Logical Input Arguments
if mod(nargin,2) ~= 0
   error('Not enough input arguments')
end

% Create Specific Figure Filepath if None Exists in Current Directory
if exist([pwd,'/Figures'],'file')~=7
   mkdir('Figures')
end

% Set Options Depending on Number of Input Arguements
numOpts = nargin/2;
totalOptions = {'FigureRange',...   % 1
                'Names',...         % 2
                'Extension',...     % 3
                'FigureSize',...    % 4
                'TextSize',...      % 5
                'TextFont',...      % 6
                'Transparency',...  % 7
                'imageResolution'}; % 8
options = struct;
currentOptions = cell(1,numOpts);
for i = 1:numOpts
   currentOptions{i} = varargin{2*i-1};
   options(i).val = varargin{2*i};
end

% Generate Figure Handles if None are Provided
cond = strcmp(totalOptions{1},currentOptions);
if any(cond)
   [~,ind] = find(cond==1);
   figureRange = options(ind).val;
else % default
   figureRange = get(0,'Children')';
   figureRange = sort(figureRange);
end
numFigures = size(figureRange,2);

% Generate File Names if None are Provided
cond = strcmp(totalOptions{2},currentOptions);
if any(cond)
   [~,ind] = find(cond==1);
   generateNames = 0;
   names = options(ind).val;
else % default
   generateNames = 1;
   curTime = clock;
   curTime = [num2str(curTime(1)),sprintf('%02.0f',curTime(2)),...
      sprintf('%02.0f',curTime(3)),'_',sprintf('%02.0f',curTime(4)),...
      sprintf('%02.0f',curTime(5)),sprintf('%02.0f',curTime(6))];
end

% Set Figure Extension if None is Provided
cond = strcmp(totalOptions{3},currentOptions);
if any(cond)
   [~,ind] = find(cond==1);
   extension = options(ind).val;
else % default
   extension = 'pdf';
end

% Set Figure Size if None is Provided
cond = strcmp(totalOptions{4},currentOptions);
if any(cond)
   setFigureSize = 1;
   [~,ind] = find(cond==1);
   % Duplicate figureSize If There Are More Than One Figures Present
   if ~iscell(options(ind).val)
      figureSize = cell(1,numFigures);
      for i = 1:numFigures
         figureSize{i} = options(ind).val;
      end
   else
      figureSize = options(ind).val;
   end
else % default
   setFigureSize = 0;
end

% Set Figure Text Size if None is Provided
cond = strcmp(totalOptions{5},currentOptions);
if any(cond)
   [~,ind] = find(cond==1);
   textSize = options(ind).val;
   set(findall(figureRange,'-property','FontSize'),'FontSize',textSize);
else % default
end

% Set Figure Font if None is Provided
cond = strcmp(totalOptions{6},currentOptions);
if any(cond)
   [~,ind] = find(cond==1);
   font = options(ind).val;
   set(findall(figureRange,'-property','FontName'),'FontName',font)
else % default
end

% Determine if Transparencies are Used in Figure
cond = strcmp(totalOptions{7},currentOptions);
if any(cond)
   [~,ind] = find(cond==1);
   % Duplicate transparency If There Are More Than One Figures Present
   if size(options(ind).val,2)==1 && numFigures>1
      transparency = options(ind).val*ones(numFigures,1);
   else
      transparency = options(ind).val;
   end
else % default
   transparency = zeros(1,numFigures);
end

% Set .jpg Resolution if None is Provided
cond = strcmp(totalOptions{8},currentOptions);
if any(cond)
   [~,ind] = find(cond==1);
   resolution = options(ind).val;
else % default
   resolution = 200;
end

% Save All Specified Figures
figureInd = 1;
for i = figureRange
   
   % Ensure Figure Exists
   if ~ishandle(i) % if handle does not exist
      disp(['Error: Figure ',num2str(i),' does not exist.'])
      figureInd = figureInd+1; % increase figure index
      continue
   end
   
   % Select Current Figure
   figure(i);
   
   % Set Figure Dimensions
   currentPosition = get(i,'Position');
   if setFigureSize==1 % specify figure size
      set(i,'Position',[currentPosition(1:2),figureSize{figureInd}]);
   end
   
   % Set Figure Page Layout For Printing
   set(i,'Units','centimeters');
   set(i,'PaperUnits','centimeters');
   currentPosition = get(i,'Position');
   set(i,'Position',currentPosition,'PaperSize',currentPosition(3:4));
   set(i,'PaperPositionMode','auto');
	set(i,'InvertHardcopy', 'off');
   if transparency(figureInd)==0 % recommended only if there are no alphamaps
      set(i,'Renderer','painters');
   end

   % Set File Names
   if generateNames == 1
      curFigureName = [curTime,'_',num2str(i)];
   else
      curFigureName = names{figureInd};
   end
   
   % Save Figure with Extension Dependent Preferences
   path = [pwd,'/Figures/',curFigureName,'.'];
   if strcmp(extension,'pdf') && transparency(figureInd)==0
      set(gcf, 'color', 'none');
      set(gca, 'color', 'none');
      path = [path,extension];
      saveas(i,path);
   elseif strcmp(extension,'jpg')
      set(gca, 'color', 'w');
      set(gcf, 'color', 'w');
      path = [path,'jpg'];
      print(i,path,'-dpng',['-r',num2str(resolution)],'-opengl') %save file
   elseif strcmp(extension,'png') || ((strcmp(extension,'pdf') && transparency(figureInd)==1))
      if transparency(figureInd)==1
         set(gca, 'color', 'none');
%          set(gcf, 'color', 'none');
         set(gcf,'color','w');
      else
         set(gca, 'color', 'w');
         set(gcf, 'color', 'w');
      end
      path = [path,'png'];
      print(i,path,'-dpng',['-r',num2str(resolution)],'-opengl') %save file
   elseif strcmp(extension,'eps')
      set(gcf, 'color', 'none');
      set(gca, 'color', 'none');
      path = [path,extension];
      saveas(i,path);
   end
   
   % Increase Figure Counting Index
   figureInd = figureInd+1;
   
end

