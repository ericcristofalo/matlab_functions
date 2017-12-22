%--------------------------------------------------------------------------
%
% File Name:      skewSymMat.m
% Date Created:   2014/08/06
% Date Modified:  2014/08/06
%
% Author:         Eric Cristofalo
% Contact:        eric.cristofalo@gmail.com
%
% Description:    Creates a skew-symmetric matrix given a vector
%
% Inputs:         v: [3x1] vector
%
% Outputs:        skew: [3x3] skew-symmetric matrix version of v
%
% Example:        v = [1;2;3]
%                 skew = skewSymMat(v)
%                 skew =
%                      0    -3     2
%                      3     0    -1
%                     -2     1     0
%
%--------------------------------------------------------------------------

function skew = skewSymMat(v)
% d = length(v);
% skew = zeros(d,d);
skew = [    0  -v(3)   v(2) ;
         v(3)      0  -v(1) ;
        -v(2)   v(1)      0 ];
end