%--------------------------------------------------------------------------
%
% File Name:      linInt.m
% Date Created:   2014/12/08
% Date Modified:  2016/08/05
%
% Author:         Eric Cristofalo
% Contact:        eric.cristofalo@gmail.com
%
% Description:    The Simplest Linear Interpolation Function
%
% Inputs:         x1: first x value
%                 y1: first y value
%                 x2: second x value
%                 y2: second y value
%                 x:  desired value, as a scalar or vector or matrix
%
% Outputs:        y: interpolated answer
%
% Example:        y = linInt(10,100,20,200,12);
%                 y = 120
%
%--------------------------------------------------------------------------

function y = linInt(x1,y1,x2,y2,x)
   xSize = size(x);
   if (x1==x2)
      y = y1;
   else
      y = y1*ones(xSize)+(y2-y1)/(x2-x1)*(x-x1*ones(xSize));
   end
end