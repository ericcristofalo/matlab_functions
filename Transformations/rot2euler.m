%--------------------------------------------------------------------------
%
% File Name:      rot2euler.m
% Date Created:   2014/07/24
% Date Modified:  2014/07/24
%
% Author:         Eric Cristofalo
% Contact:        eric.cristofalo@gmail.com
%
% Description:    Calculates the Euler angles given a rotation matrix.
%                 Adapted from Dingjiang Zhou.
%
% Inputs:         R: rotation matrix [3x3]
%
% Outputs:        euler: vector of Euler angles [3x1]
%
% Example:        euler = rot2euler(R)
%
%--------------------------------------------------------------------------

function euler = rot2euler(R)

euler(1,1) = atan2(R(3,2),R(3,3));      % phi
euler(2,1) = asin(-R(3,1));             % theta
euler(3,1) = atan2(R(2,1),R(1,1));      % psi

end