%--------------------------------------------------------------------------
%
% File Name:      generatePlane.m
% Date Created:   2014/07/22
% Date Modified:  2014/07/24
%
% Author:         Eric Cristofalo
% Contact:        eric.cristofalo@gmail.com
%
% Description:    Generates a plan of points on a XY plane.
%
% Inputs:         corners: [xmin xmax ymin ymax]
%                 d: distance between each generated point
%
% Outputs:        plane: [4xn] array of points in the plane with x,y,z 
%                        coordinates as well as a unique ID number for each
%                        point [x;y;z;ID].
%
% Example:        plane = generatePlane([-2 2 -3 3],0.1)
%
%--------------------------------------------------------------------------

function plane = generatePlane(corners,d)

% Generate Point Coordinates
x = abs(corners(2)-corners(1));
y = abs(corners(4)-corners(3));
nX = x/d+1;
nY = y/d+1;
X = linspace(corners(1),corners(2),nX);
Y = linspace(corners(3),corners(4),nY);

plane = zeros(4,nX*nY);
ind = 1;
for i = 1:nY % for each row
   for j = 1:nX % for each column
      plane(:,ind) = [X(j);Y(i);0;ind];
      ind = ind+1;
   end
end

end