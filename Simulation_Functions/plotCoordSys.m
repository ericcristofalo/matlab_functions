%--------------------------------------------------------------------------
%
% File Name:      plotCoordSys.m
% Date Created:   2014/11/15
% Date Modified:  2016/09/01
%
% Author:         Eric Cristofalo
% Contact:        eric.cristofalo@gmail.com
%
% Description:    Plots cartesian coordinate system given position w.r.t a
%                 global coordinate system.
%                 All inputs in meters. 
%
% Inputs:         pose: vector with the entires [x; y; z; phi; theta; psi]
%                       Pose is w.r.t. the world frame, angles are measured  
%                       in radians.
%                 diameter: diameter of centroid sphere
%                 color: vector denoting color of centroid sphere [0,0,0]
%                 arrowLength: desired arrow length.
%                 lineThick: desired line thickness.
%
% Outputs:        plot
%
% Example:        plotCoordSys([1; 1; -1; 0.1; 0.1; 0.7],100,[1,0,0],0.5,1);
%
%--------------------------------------------------------------------------

function plotCoordSys(pose, diameter , color, arrowLength, lineThick)

% Plot Coordinate System Orientation
R_wr = euler2rot(pose(4:6));
vecColor = [1,0,0; 0,1,0; 0,0,1];
for i = 1:3 % for each direction (x,y,z)
   dirVec = [0;0;0]; % current axis direction vector
   dirVec(i) = 1;
   dirVec = R_wr*dirVec;
   quiver3(pose(1),pose(2),pose(3),...
           dirVec(1),dirVec(2),dirVec(3),...
           arrowLength,'color',vecColor(i,:),...
           'LineWidth',lineThick);
end

% Plot Coordinate System Position
scatter3(pose(1,1),pose(2,1),pose(3,1),diameter,color,'Fill');

end

