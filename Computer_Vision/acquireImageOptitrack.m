%--------------------------------------------------------------------------
%
% File Name:      acquireImages.m
% Date Created:   2014/11/04
% Date Modified:  2015/02/05
%
% Author:         Eric Cristofalo
% Contact:        eric.cristofalo@gmail.com
%
% Description:    Take multiple images with quadrotor IP camera and save
%                 cooresponding Optitrack quadrotor pose if desired.
%
% Inputs:         
%
% Outputs:        
%
% Example:        
%
%--------------------------------------------------------------------------

clean

% Add Path Optitrack2Matlab
addpath(genpath('/Users/ericcristofalo/Dropbox/BU/Shared/Dingjiang/kmel/eric/optitrackToMatlab'));


%% Acquire Images

for imageNum = 1:20
   
   % Wait For Key Press
   key = 0;
   while key ~=1
      key = waitforbuttonpress;
   end
   
   % Set Folder Location for New Images
   folder = '/NEW_IMAGES';
   fullPath = [pwd,folder];
   
   % Create Folder If Necessary
   if exist(fullPath,'file')~=7
      mkdir(fullPath);
   end
   
   % Set IP Address for Camera in Use
   url = 'http://192.168.10.104/image/jpeg.cgi'; % JPEG snapshot read
   
   % Read Optitrack Coordinates
   frame = 'XY Plane'; % quadrotor coordinate system
   opti = optitrackSetup(3000);
   opti = readOptitrack(opti,frame);
   
   % Read Image
   im = imread(url);
   figure(1); image(im);
   
   % Save Pose to Matrix
   pose(:,imageNum) = opti.pose(:,1);
   
   % Save Image
   number = sprintf('%04.0f',imageNum);
   imwrite(im,[fullPath,'/image_',number,'.jpg']);
   disp(number);
   disp(pose(:,imageNum));
   disp(' ');
   
   % Kill Optitrack To Clear Buffer
   clear opti;
   
end

% Save Pose Information
saveName = [fullPath,'/poseHistory','.mat'];
save(saveName,'pose');

