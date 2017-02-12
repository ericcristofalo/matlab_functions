%--------------------------------------------------------------------------
%
% File Name:      acquireVideo.m
% Date Created:   2014/11/06
% Date Modified:  2014/11/06
%
% Author:         Eric Cristofalo
% Contact:        eric.cristofalo@gmail.com
%
% Description:    Acquire video from IP camera in MATLAB
%
% Inputs:         
%
% Outputs:        
%
% Example:        
%
%--------------------------------------------------------------------------

clean

%% Acquire Video

% Setup Optitrack
% addpath(genpath('/Users/ericcristofalo/Dropbox/BU/Shared/Dingjiang/kmel/eric/optitrackToMatlab'));
% frame = 'XY Plane'; % quadrotor coordinate system
% opti = optitrackSetup(3000);

% Set IP Address for Camera in Use
url = 'http://192.168.10.194/video/mjpg.cgi';
obj = videoinput('winvideo', 1);

for i = 1:100
   frame = getsnapshot(obj);
   figure(1); image(frame);
end

% Read Optitrack Coordinates
% opti = readOptitrack(opti,frame);
% pose(:,imageNum) = opti.pose;


%% Save Pose Information

% saveName = [fullPath,'poseHistory','.mat'];
% save(saveName,'pose');

