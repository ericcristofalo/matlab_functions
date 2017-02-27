%--------------------------------------------------------------------------
%
% File Name:      clean.m
% Date Created:   2014/07/07
% Date Modified:  2015/06/24
%
% Author:         Eric Cristofalo
% Contact:        eric.cristofalo@gmail.com
%
% Description:    Clean clears the workspace, closes figures and clears the
%                 command window with some properties.
%
% Inputs:         ...,'Figures',#,...
%                    Figure handles to be cleared. 0 clears all figures.
%
%                 ...,'Except','string',...
%                    Clears all variables except variables listed in
%                    'string'.
%
% Outputs:        N/A
%
% Example:        clean
%
%--------------------------------------------------------------------------

function clean(varargin)

% Initialize Options
exception = 0;

% Check Function Input
if nargin == 0 % if no input is given, clean everything
   
   close all;
   
elseif  mod(length(varargin)/2,1)==0 % if number of arguments is even
   
   % Cycle Through Argument Options
   for argInd = 1:length(varargin)/2
      
      % Read First Set of Arguments
      option = varargin{2*argInd-1};
      value = varargin{2*argInd};
      
      % Figures Option ----------------------------------------------------
      if strcmp(option,'Figures')
         % Find Open Figures if No Input is Given
         if value == 0
            value = get(0,'Children');
         end
         % Clean Each Figure
         for valInd = 1:length(value)
            ind = value(valInd);
            figure(ind); clf('reset');
         end
      end
      
      % Do Not Clear Specifed Variables -----------------------------------
      % NOT FUNCTIONAL YET
      if strcmp(option,'Except')
         % Set Exception Variable
         exception = 1;
         exceptionVals = value;
      end
      
   end
   
else % invalid data arguments were given
   
   error('Invalid data argument');
   
end

% Clear Workspace
if exception~=1
   evalin('caller','clear');
else
	clearvars('-except',exceptionVals);
end

% Clear Command Window
clc;

end









