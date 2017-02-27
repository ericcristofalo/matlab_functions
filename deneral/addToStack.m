%--------------------------------------------------------------------------
%
% File Name:      addToStack.m
% Date Created:   2012/09/01
% Date Modified:  2014/07/11
%
% Author:         Eric Cristofalo
% Contact:        eric.cristofalo@gmail.com
%
% Description:    Adds row vectors to existing matrices
%                 Apadpted from Professor Ani Hsieh
%                 Drexel Univeristy, Philadelphia, Pennsylvania
%
% Inputs:         originalStack: [NxM] matrix
%                 newElement: [1xM] matrix
%                 location: Determines the location of the new element
%                    'Top'
%                    'Bottom'
%                    'Right'
%                    'Left'
%
% Outputs:        outStack: [(N+1)xM] matrix
%
% Example:        [1 2 3;
%                  4 5 6;  = addToStack([1 2 3;4 5 6], [7 8 9], 'Bottom')
%                  7 8 9]
%
%--------------------------------------------------------------------------

function outStack = addToStack(originalStack, newElement, location)

switch location
   case 'Top' % Add new stack to top of matrix
      outStack = [newElement; originalStack];
   case 'Bottom' % Add new stack to bottom of matrix
      outStack = [originalStack; newElement];
   case 'Right' % Add new stack to right of matrix
      outStack = [originalStack, newElement];
   case 'Left' % Add new stack to left of matrix
      outStack = [newElement, originalStack];
end
