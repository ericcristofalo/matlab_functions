%--------------------------------------------------------------------------
%
% File Name:      cleanFigs.m
% Date Created:   2015/02/09
% Date Modified:  2015/02/09
%
% Author:         Eric Cristofalo
% Contact:        eric.cristofalo@gmail.com
%
% Description:    Cleans the contents of each desired figure.  
%
% Inputs:         figHandles: vector of figure indices
%
% Outputs:        N/A
%
% Example:        clean
%
% REPLACED BY 'clean.m' AS OF 2016/09/07
%
%--------------------------------------------------------------------------

function cleanFigs(figHandles)

% Find Open Figures if No Input is Given
if nargin == 0
   figHandles = get(0,'Children');
end

% Clean Each Figure
for i = 1:length(figHandles)
   ind = figHandles(i);
   figure(ind); clf('reset');
end

end