%--------------------------------------------------------------------------
%
% File Name:      euler2quatrn.m
% Date Created:   2016/05/16
% Date Modified:  2016/05/16
%
% Author:         Eric Cristofalo
% Contact:        eric.cristofalo@gmail.com
%
% Description:    Rotation matrix computed from 3 Euler angles.
%                 Adapted from Dingjiang Zhou.
%
% Inputs:         euler: [3x1] vector of euler angles
%
% Outputs:        q: [4x1] vector = [q0;q1;q2;q3];
%
% Example:        q = euler2quatrn(euler)
%
%--------------------------------------------------------------------------

function q = euler2rot(euler)

phi = euler(1)/2;
the = euler(2)/2;
psi = euler(3)/2;

q = zeros(4,1);
q(1,1) = cos(phi)*cos(the)*cos(psi)+sin(phi)*sin(the)*sin(psi);
q(2,1) = sin(phi)*cos(the)*cos(psi)-cos(phi)*sin(the)*sin(psi);
q(3,1) = cos(phi)*sin(the)*cos(psi)+sin(phi)*cos(the)*sin(psi);
q(4,1) = cos(phi)*cos(the)*sin(psi)-sin(phi)*sin(the)*cos(psi);
