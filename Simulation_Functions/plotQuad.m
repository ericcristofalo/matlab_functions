%--------------------------------------------------------------------------
%
% File Name:      plotQuads.m
% Date Created:   2016/09/01
% Date Modified:  2016/09/01
%
% Author:         Eric Cristofalo
% Contact:        eric.cristofalo@gmail.com
%
% Description:    Plots quadrotor frame with coordinate system at origin.
%                 All inputs in meters. 
%
% Inputs:         pose: pose vector [x; y; z; phi; theta; psi]
%                       Pose is w.r.t. the world frame, angles are measured  
%                       in radians.
%                 offset: offset to quadrotor origin from rigid body pose
%                         [x; y; z; phi; theta; psi]
%                 length: length of quadrotor arm
%                 propRadius: radius of propeller
%                 color: color of centroid
%
% Outputs:        plot
%
% Example:        plotCoordSys([1; 1; -1; 0.1; 0.1; 0.7],100,[1,0,0],0.5,1);
%
%--------------------------------------------------------------------------

function plotQuad(pose, length, propRadius, color)

% Plot Coordinate System at Quadrotor Origin
diameter = 100;
arrowLength = length;
lineThick = 3;

% Plot Quadrotor Arms
R_wr = euler2rot(pose(4:6));
if arrowLength~=0
   % Plot Coordinate System Orientation
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
   % Plot Remaining Arms
   vecColor = [0,0,0];
   for i = 1:2 % for each direction (x,y,z)
      dirVec = [0;0;0]; % current axis direction vector
      dirVec(i) = -1;
      dirVec = R_wr*dirVec;
      quiver3(pose(1),pose(2),pose(3),...
         dirVec(1),dirVec(2),dirVec(3),...
         arrowLength,'color',vecColor,...
         'LineWidth',1);
   end
else
   length = 0.5;
end

% Plot Coordinate System Position
scatter3(pose(1,1),pose(2,1),pose(3,1),diameter,color,'Fill');

% Plot 3D Propellers
quadArmVec = R_wr*[length,0,0;
                0,length,0;
                -length,0,0;
                0,-length,0]';
dAngle = 0.8;
circleAngle = 0:0.5:(2*pi+dAngle);
num = size(circleAngle,2);
for i = 1:4
   circleOrigin = pose(1:3)+quadArmVec(:,i);
   circle = zeros(3,num);
   circle(1,:) = propRadius*cos(circleAngle);
   circle(2,:) = propRadius*sin(circleAngle);
   circle(3,:) = zeros(1,num);
   circle = repmat(circleOrigin,1,num)+R_wr*circle;
%    % Patch Propeller Color
%    patch(circle(1,:),circle(2,:),circle(3,:),'EdgeColor','none','FaceColor',[0;0;0.3]);
   % Fill Propeller Color
   circleOrigin2 = repmat(circleOrigin,1,num);
   circle2 = [circle(:,2:end),circle(:,1)];
   X = [circle(1,:);circle2(1,:);circleOrigin2(1,:)];
   Y = [circle(2,:);circle2(2,:);circleOrigin2(2,:)];
   Z = [circle(3,:);circle2(3,:);circleOrigin2(3,:)];
   fill3(X,Y,Z,repmat([1;1;0],1,num),'EdgeColor','none','FaceColor',color);
%    % Plot Circle Outline
%    plot3(circle(1,:),circle(2,:),circle(3,:),'k','LineWidth',lineThick);
end

end

