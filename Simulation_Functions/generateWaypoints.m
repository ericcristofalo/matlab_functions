%--------------------------------------------------------------------------
%
% File Name:      generateTestFlightPath.m
% Date Created:   2015/07/13
% Date Modified:  2015/07/13
%
% Author:         Eric Cristofalo
% Contact:        eric.cristofalo@gmail.com
%
% Description:    Generate 'lawnmower' flight path waypoints for quadrotor
%
% Inputs:
%
% Outputs:
%
% Example:
%
%--------------------------------------------------------------------------

% Define Grid Parameters
% startPos = [0.4;1.46;-1.8;0;0;0]; 
% gridSize = [2,2]; % [x-direction, y-direction]
% startPos = [0.9;1.96;-1.8;0;0;0]; 
% gridSize = [1,1]; % [x-direction, y-direction]
startPos = [1.0;2.00;-0.6;0;0;-pi/4]; 
gridSize = [0.8,1]; % [x-direction, y-direction]

nx = 6; % number of waypoints in x-direction
ny = 8; % number of waypoints in y-direction
stepx = gridSize(1)/(nx-1); % step size in x-direction
stepy = gridSize(2)/(ny-1); % step size in y-direction

% Calculate All Waypoints
waypoints = zeros(6,nx*ny);
ind = 1;
dir = 1;
for i = 1:nx
   for j = 1:ny
      % Start Location
      if j==1
         if i==1
            waypoints(:,ind) = startPos;
         else
            waypoints(:,ind) = waypoints(:,ind-1)+[stepx;0;0;0;0;0];
         end
      else
         waypoints(:,ind) = waypoints(:,ind-1)+dir*[0;stepy;0;0;0;0];
      end
      ind = ind+1;
   end
   dir = -dir;
end

% Display Waypoints
figure(1); plot(waypoints(2,:),waypoints(1,:),'b*-');
xlabel('Y-Axis'); ylabel('X-Axis');
axis([startPos(2)-1,startPos(2)+gridSize(2)+1,...
   startPos(1)-1,startPos(1)+gridSize(1)+1]);

% Assign Waypoints to Text File
fileID = fopen('/Users/ericcristofalo/Desktop/waypointList.txt','w');
for i = 1:size(waypoints,2)
   for j = 1:size(waypoints,1)
      curText = waypoints(j,i)';
      fprintf(fileID,'%0.3f ',curText);
   end
   fprintf(fileID,'\n');
end
fclose(fileID);












