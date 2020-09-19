%--------------------------------------------------------------------------
%
% File Name:      stlLibrary.m
% Date Created:   2015/02/17
% Date Modified:  2015/02/17
%
% Author:         Eric Cristofalo
% Contact:        eric.cristofalo@gmail.com
%
% Description:    Library function that contains necessary rotation and
%                 scale information for every .stl file I have used.
%
% Inputs:
%
% Outputs:
%
% Example:
%
%--------------------------------------------------------------------------

function [stl, obj] = stlLibrary(stl, obj)   

% Read in 3D .stl Geometry
[stl.v, stl.f, stl.n, stl.c, stl.stltitle] = stlread(stl.filepath);

% Choose Correct Number of Points of Interest
if obj.sample==0 
   % Display All Nodes
   obj.v = stl.v';
   obj.f = stl.f;
   stl.numPts = length(stl.v);
else
   % Randomly Sample Points
   obj.v = stl.v(randsample(1:size(stl.v,1),obj.sample),:)'; % only consider stl.numPts points
   stl.numPts = obj.sample;
end

% Set Orientation of Object
switch stl.filename
   
   case 'r2d2'
      % Object Scale
      obj.v = obj.v.*0.0100;
      % Rotate Object
      obj.v(:,:) = rotMat(deg2rad(-90),'x')*obj.v(1:3,:);
      % Shifting Mass of Points to Origin
      obj.v(:,:) = obj.v(1:3,:)+ ...
                   [-mean(obj.v(1,:)),0,0; ...
                    0,-mean(obj.v(2,:)),0; ...
                    0,0,-max(obj.v(3,:))]*ones(3,size(obj.v,2));
      
   case 'roman_colosseum'
      % Object Scale
      obj.v = obj.v.*0.0555;
      obj.v = obj.v.*0.1;
      % Rotate Object
      obj.v(:,:) = rotMat(pi/2,'z')*rotMat(pi,'x')*obj.v(1:3,:);
      % Shifting Mass of Points to Origin
      obj.v(:,:) = obj.v(1:3,:)+ ...
                   [-mean(obj.v(1,:)),0,0; ...
                    0,-mean(obj.v(2,:)),0; ...
                    0,0,-max(obj.v(3,:))]*ones(3,size(obj.v,2));
      obj.v(3,:) = obj.v(3,:)-1*ones(1,size(obj.v,2));
      
   case 'p2005_30_Turkey_30000'
      % Object Scale
      obj.v = obj.v.*6.5;
      % Rotate Object
      obj.v(:,:) = rotMat(deg2rad(5),'x')*rotMat(deg2rad(90),'z')*obj.v(1:3,:);
      % Shifting Points to Origin According to Max and Min X,Y Values
      obj.v(1:3,:) = obj.v(1:3,:)+ ...    % shifting mass of points to origin
         [abs(max(obj.v(1,:))-min(obj.v(1,:)))/2-max(obj.v(1,:)),0,0; ...
         0,abs(max(obj.v(2,:))-min(obj.v(2,:)))/2-max(obj.v(2,:)),0; ...
         0,0,-max(obj.v(3,:))]*ones(3,size(obj.v,2));
      obj.v(3,:) = obj.v(3,:)-1*ones(1,size(obj.v,2));
      
   case 'p2005_30_Turkey_5000'
      % Object Scale
      obj.v = obj.v.*6.5;
      % Rotate Object
      obj.v(:,:) = rotMat(deg2rad(5),'x')*rotMat(deg2rad(90),'z')*obj.v(1:3,:);
      % Shifting Points to Origin According to Max and Min X,Y Values
      obj.v(1:3,:) = obj.v(1:3,:)+ ...    % shifting mass of points to origin
         [abs(max(obj.v(1,:))-min(obj.v(1,:)))/2-max(obj.v(1,:)),0,0; ...
         0,abs(max(obj.v(2,:))-min(obj.v(2,:)))/2-max(obj.v(2,:)),0; ...
         0,0,-max(obj.v(3,:))]*ones(3,size(obj.v,2));
      obj.v(3,:) = obj.v(3,:)-1*ones(1,size(obj.v,2));
      
   case 'p2005_30_Turkey_Cropped_1000'
      % Object Scale
      obj.v = obj.v.*6.5;
      % Rotate Object
      obj.v(:,:) = rotMat(deg2rad(5),'x')*rotMat(deg2rad(90),'z')*obj.v(1:3,:);
      % Shifting Points to Origin According to Max and Min X,Y Values
      obj.v(1:3,:) = obj.v(1:3,:)+ ...    % shifting mass of points to origin
         [abs(max(obj.v(1,:))-min(obj.v(1,:)))/2-max(obj.v(1,:)),0,0; ...
         0,abs(max(obj.v(2,:))-min(obj.v(2,:)))/2-max(obj.v(2,:)),0; ...
         0,0,-max(obj.v(3,:))]*ones(3,size(obj.v,2));
      obj.v(3,:) = obj.v(3,:)-1*ones(1,size(obj.v,2));
      
end

% Apply Point Indices
obj.v = [obj.v; linspace(1,stl.numPts,stl.numPts)];

end

