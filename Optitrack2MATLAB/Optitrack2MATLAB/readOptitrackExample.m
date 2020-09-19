%--------------------------------------------------------------------------
%
% File Name:      readOptitrackExample.m
% Date Created:   2014/07/09
% Date Modified:  2014/08/13
%
% Author:         Eric Cristofalo
%                 Boston University, Boston 02215
% Contact:        eric.cristofalo@gmail.com
%
% Description:    Example script for obtaining Optitrack data in MATLAB.
%
% Instructions:   Script needs the following functions:
%                    optiTrackSetup.m, parseNatNet.m,
%                    readOptitrack.m, quatrn2rot.m, rot2ZYXeuler.m
%
% Inputs:         N/A
%
% Outputs:        N/A
%
% Example:        N/A
%
%--------------------------------------------------------------------------

clean;

% Select Inputs
% frame = 'Optitrack';
frame = 'XY Plane';

% Optitrack Initialization
opti = optitrackSetup(3000);

% Obtain Optitrack Data
for i = 1:10000
   opti = readOptitrack(opti,frame);
   % Euler angles in degrees
%    opti.pose(4:6,:) = rad2deg(opti.pose(4:6,:));
   opti.pose
   
   pause(0.1);
end



