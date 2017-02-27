%--------------------------------------------------------------------------
%
% File Name:      popOffStack.m
% Date Created:   2012/09/01
% Date Modified:  2014/07/11
%
% Author:         Eric Cristofalo
% Contact:        eric.cristofalo@gmail.com
%
% Description:    Removes row vectors from existing matrices
%                 Apadpted from Professor Ani Hsieh
%                 Drexel Univeristy, Philadelphia, Pennsylvania
%
% Inputs:         originalStack: [nxm] matrix
%                 location: Determines the location of the removal
%                    'Top'
%                    'Bottom'
%
% Outputs:        outStack: [(N+1)xM] matrix
%                 outElement: [1xM] vector
%
% Example:        popOffStack([1 2 3;4 5 6;7 8 9], 'Bottom')
%                    outStack = [1 2 3;4 5 6];
%                    outElement = [7 8 9];
%
%--------------------------------------------------------------------------

function [outStack,outElement] = popOffStack(originalStack, location)

switch location
   case 'Top' % Add new stack to top of matrix
      outElement = originalStack(1,:);
      outStack = originalStack(2:end,:);
   case 'Bottom' % Add new stack to bottom of matrix
      outElement = originalStack(end,:);
      outStack = originalStack(1:end-1,:);
end
