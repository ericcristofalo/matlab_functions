%--------------------------------------------------------------------------
%
% File Name:      euler2rot.m
% Date Created:   2014/06/27
% Date Modified:  2014/06/27
%
% Author:         Eric Cristofalo
% Contact:        eric.cristofalo@gmail.com
%
% Description:    Rotation matrix computed from 3 Euler angles.
%                 Adapted from Dingjiang Zhou.
%
% Inputs:         euler: [3x1] vector of euler angles
%
% Outputs:        R: [3x3] rotation matrix
%
% Example:        R = euler2rot(euler)
%
%--------------------------------------------------------------------------

function R = euler2rot(euler)

phi = euler(1);
the = euler(2);
psi = euler(3);

R = rotMat(psi,'z')*rotMat(the,'y')*rotMat(phi,'x');