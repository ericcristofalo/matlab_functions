
%--------------------------------------------------------------------------
%
% File Name:      displaySTL.m
% Date Created:   2015/01/23
% Date Modified:  2015/08/11
%
% Author:         Eric Cristofalo
% Contact:        eric.cristofalo@gmail.com
%
% Description:    Script that displays an .stl file in MATLAB
%
% Inputs:
%
% Outputs:
%
% Example:
%
%--------------------------------------------------------------------------

% clean
cleanFigs; 


%% Display .stl File

stl.numPoints = 0;   % number of points making the 3D model 
                        % (not including ground plane)

% Read in 3D Geometry
[stl.v, stl.f, stl.n, stl.c, stl.stltitle] = ...
   stlread('p2005_30_Turkey_Cropped_1000.stl');

if stl.numPoints==0 
   % Display All Nodes
   obj.v = stl.v;
   obj.f = stl.f;
   stl.numPoints = length(stl.v);
else
   % Randomly Sample Points
   obj.v = stl.v(randsample(1:size(stl.v,1),stl.numPoints),:); % only consider stl.numPoints points
end

% Orient Point Cloud
obj.v = obj.v.*6.5; % arbitrarily set scale of model
obj.v = [obj.v'; ...
   linspace(1,stl.numPoints,stl.numPoints)];
obj.v(1:3,:) = rotMat('x',deg2rad(5))*rotMat('z',deg2rad(90))*obj.v(1:3,:);
obj.v(1:3,:) = obj.v(1:3,:)+ ...    % shifting mass of points to origin
   [abs(max(obj.v(1,:))-min(obj.v(1,:)))/2-max(obj.v(1,:)),0,0; ...
   0,abs(max(obj.v(2,:))-min(obj.v(2,:)))/2-max(obj.v(2,:)),0; ...
   0,0,-max(obj.v(3,:))]*ones(3,size(obj.v,2));

% Random Noise
% obj.v(1:3,:) = obj.v(1:3,:)+normrnd(0,1,3,size(obj.v,2));

% min(obj.v(3,:));

% World Scene Plotting Volume
post.plotV(1,1) = abs(max(obj.v(1,:)))+10;
post.plotV(2,1) = abs(max(obj.v(2,:)))+10;
post.plotV(3,1) = -abs(min(obj.v(3,:)))-10;

% % Plot Object Scene in World Environment
% figure(1); subplot(1,2,1);
% hold on;
% rotate3d on;
% box on;
% plot3(obj.v(1,:),obj.v(2,:),obj.v(3,:),'b.');
% title('Object Vertices');
% xlabel('x-axis (m)'); ylabel('y-axis (m)'); zlabel('z-axis (m)');
% axis equal;
% axis([-post.plotV(1,1) post.plotV(1,1) -post.plotV(2,1) post.plotV(2,1) post.plotV(3,1) 0]);
% view([1,1,1]); % view([-0.3,1,0.4]);
% set(gca,'XDir','reverse');
% set(gca,'ZDir','reverse');
% 
% % Surface Mesh Using Patches
% figure(1); subplot(1,2,2);
rotate3d on;
obj.vPlot = obj.v(1:3,:)';
P = patch('faces',obj.f,'vertices',obj.vPlot);
set(P,'FaceColor','b','FaceAlpha',0.5);
set(P,'EdgeColor','k','LineWidth',1);
title('Object Mesh');
xlabel('x-axis (m)'); ylabel('y-axis (m)'); zlabel('z-axis (m)');
axis equal;
axis([-post.plotV(1,1) post.plotV(1,1) -post.plotV(2,1) post.plotV(2,1) post.plotV(3,1) 0]);
view([1,1,1]); % view([-0.3,1,0.4]);
set(gca,'XDir','reverse');
set(gca,'ZDir','reverse');









