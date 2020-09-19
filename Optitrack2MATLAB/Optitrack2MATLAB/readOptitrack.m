%--------------------------------------------------------------------------
%
% File Name:      readOptitrack.m
% Date Created:   2014/07/09
% Date Modified:  2015/08/12
%                 2016/05/06 by Eric Cristofalo to fix coordinate system for 
%                            new Optitrack software version 1.7+
%
% Author:         Eric Cristofalo
%                 Boston University, Boston 02215
% Contact:        eric.cristofalo@gmail.com
%
% Description:    Obtaining Optitrack data in MATLAB.
%                 Adpated from Dingjiang Zhou.
%
% Instructions:   Optitrack MUST be running first.
%                 At least one rigid body MUST be created in Optitrack
%                 Optitrack MUST be streaming data:
%                     View -> Streaming Pane
%                     Check 'Broadcast Frame Data'
%                     Under Network Options:
%                         Select 'Multicast' as the Type
%
% Inputs:         opti: Original opti structure
%                 frame: 'Optitrack' - Exports position in Optitrack's
%                                      calibration coordinate system
%                                      (x-z ground plane, y up)
%                        'XY Plane' - Exports position with new
%                                     plane coordinate system
%                                     (x-y ground plane, z down)
%
% Outputs:        opti: structure containing all Optitrack output
%                       information
%                 Access position and Euler angles in opti.pose
%                     pose is in meters and radians
%                 Raw Optitrack data available in opti.rigidBodies.SE3
%
% Example:        opti = readOptitrack(opti,'XY Plane')
%
%--------------------------------------------------------------------------


%% Function
function opti = readOptitrack(opti,frame)

% Create java socket (fixes problem with pauses in main code)
opti.camIO.Socket = java.net.MulticastSocket(1511);
opti.camIO.group  = java.net.InetAddress.getByName('239.255.42.99');
opti.camIO.Socket.joinGroup(opti.camIO.group);

% Receive Data
opti.camIO.Socket.receive(opti.camIO.recv);

% Store in Buffer
socketData = opti.camIO.recv.getData();
bufSize    = length(socketData);

% Parse Data
% opti.rigidBodies.ID may not in the 1,2,3,... sequence,
% depending on in what sequence the rigid bodies were created.
[opti.rigidBodies] = parseNatNet(socketData,bufSize);
% [markerSets, opti.rigidBodies] = parseNatNet_v2(socketData); % Zijian's version
% [opti.rigidBodies] = parseNatNetMex(socketData,bufSize); % LINUX MACHINES ONLY

% Convert Optitrack's Quaternions from YZX to ZYX angles
% Quaternion variables position changing to have [q0,q1,q2,q3] sequence
% q2 is set to -q2 to get obtain ZYX angles.
temp                      = opti.rigidBodies.SE3(7,:); % save q0
opti.rigidBodies.SE3(7,:) = opti.rigidBodies.SE3(5,:); % q3 done
opti.rigidBodies.SE3(5,:) = opti.rigidBodies.SE3(4,:); % q1 done
opti.rigidBodies.SE3(4,:) = temp;                      % q0 done
opti.rigidBodies.SE3(6,:) = -opti.rigidBodies.SE3(6,:); % q2 = -q2

% Still require an Euler angle transformation to desired frame
eulerAngleTrans = [1 0 0;0 0 1;0 -1 0];

% Coordinate Frame Case Statements
switch frame
   case 'Optitrack' % Keep raw position data
      opti.pose(1:3,:) = opti.rigidBodies.SE3(1:3,:);
      
   case 'XY Plane' % Convert to x-y ground plane coordinate system
      transformation = [1 0 0; 0 0 1; 0 -1 0]; % -90 degree rotation about x
      % Include rotation fix for new Optitrack software version
      transFix = [-1 0 0; 0 -1 0; 0 0 1]; % 180 degree rotation about z
      opti.pose(1:3,:) = ...
         transFix*transformation * opti.rigidBodies.SE3(1:3,:);
      % Convert Euler angles to x-y gound plane frame (90 rotation)
      eulerAngleTrans = eulerAngleTrans*transformation;
end

% Convert quaternions to Euler angles
euler = zeros(3,opti.rigidBdyNum);
for i = 1:opti.rigidBdyNum
   % Calculate Rotation Matrix from Quaternions
   rotationMatrix = quatrn2rot(opti.rigidBodies.SE3(4:7,i));
   euler(:,i) = rot2ZYXeuler(rotationMatrix);
end

% Assign Euler Angles to Pose
opti.pose(4:6,:) = eulerAngleTrans*euler;

end

