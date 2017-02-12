%--------------------------------------------------------------------------
%
% File Name:      acquireImages.m
% Date Created:   2014/04/23
% Date Modified:  2014/11/04
%
% Author:         Eric Cristofalo
% Contact:        eric.cristofalo@gmail.com
%
% Description:    Take multiple images with quadrotor IP camera.
%
% Inputs:         
%
% Outputs:        
%
% Example:        
%
%--------------------------------------------------------------------------

clean

%% Taking Images

% Set Folder Location for New Images
path = [pwd];
folder = '/testing/';
fullPath = [path,folder];

% Create Folder If Necessary
if exist(fullPath,'file')~=7
   mkdir(fullPath);
end

% Set IP Address for Camera in Use
url = 'http://192.168.10.113/image/jpeg.cgi'; % JPEG snapshot read

% Helpful Countdown
count = 5;
for i = 1:count
   disp([num2str(count+1-i),'...'])
   pause(1);
   if i==count
      disp('Recording ...')
   end
end

% Take n Images
n = 3;
pose = zeros(6,n);
for i = 1:n
   % Read Image
   im = imread(url);
%    figure(1); image(im);

   % Save Image
   number = sprintf('%04.0f',i);
   imwrite(im,[fullPath,'/image_',number,'.jpg']);
   disp(number);
   disp(' ');
   
end

disp('... All Finished.');


%% Video Capture

% camera = cv.VideoCapture('http://192.168.10.192/video/mjpg.cgi?dummy=param.mjpg');
% for i = 1:100
% frame = camera.read;
% figure(1); image(frame);
% end
% delete(camera)

