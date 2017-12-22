%--------------------------------------------------------------------------
%
% File Name:      skewSymMatInv.m
% Date Created:   2014/08/06
% Date Modified:  2017/08/29
%
% Author:         Eric Cristofalo
% Contact:        eric.cristofalo@gmail.com
%
% Description:    Decomposes a skew-symmetric matrix into a vector
%
% Inputs:         skew: [3x3] skew-symmetric matrix version of v
%
% Outputs:        v: [3, 1] vector v
%
% Example:        skew = rotMat( 
%                 v = skewSymMatInv(skew)
%                 v =
%                      0    -3     2
%                      3     0    -1
%                     -2     1     0
%
%--------------------------------------------------------------------------

function v = skewSymMatInv(skew)
   v = [-skew(2,3);skew(1,3);-skew(1,2)];
end