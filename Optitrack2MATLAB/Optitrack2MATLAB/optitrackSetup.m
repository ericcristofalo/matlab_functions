%**************************************************************************
%   File Name     : optitrackSetup.m
%   Author        : IML, MSL, Dingjiang Zhou
%                   Boston University, Boston, 02215
%   Email         : zhoudingjiang@gmail.com
%
%   Last Modified : 2014/07/16 by Eric Cristofalo
%   Purpose       : Setup the optiTrack system, so that the matlab can
%                   read  the data from it.
%
%   Notes:        : Make sure Optitrack is running, at least one rigid 
%                   is created, and Optitrack is streaming data. 
%                   To the streaming ports in Optitrack, go to 
%                   Optitrack and select:
%                       View -> Streaming Pane
%                       Check 'Broadcast Frame Data'
%                       Under Network Options:
%                           Select 'Multicast' as the Type
%
%                   Increase the buffer size if prompted.
%
%**************************************************************************

function [opti] = optitrackSetup(bufSize)
opti.bufSize = bufSize;

% Create java socket
opti.camIO.Socket = java.net.MulticastSocket(1511);
opti.camIO.group  = java.net.InetAddress.getByName('239.255.42.99');
opti.camIO.Socket.joinGroup(opti.camIO.group);

% Create a buffer to store the incoming data
opti.camIO.buf = int8(zeros(1,bufSize));

% Create an object to receive the data from the multicast stream
opti.camIO.recv = java.net.DatagramPacket(opti.camIO.buf,...
                    length(opti.camIO.buf));

% Test sockets
disp('Testing java socket to OptiTrack.');
disp(' ');

% Receive the data into a buffer
opti.camIO.Socket.receive(opti.camIO.recv);

% Pull the data from the buffer into a variable (column of bytes)
socketData = opti.camIO.recv.getData();

% Parse data: opti.rigidBodies.ID may not in the 1,2,3 sequence, depending
% on in what sequence the rigid bodies were created.
[opti.rigidBodies] = parseNatNet(socketData,bufSize);
% [opti.rigidBodies] = parseNatNetMex(socketData,bufSize); % LINUX MACHINES ONLY

% rigid body numbers, used in the other code
opti.rigidBdyNum = length([opti.rigidBodies.ID]);

% Initialize Manipulated Optitrack Data
opti.pose = zeros(6,opti.rigidBdyNum);

% job done
disp('Java socket to OptiTrack system established.');
disp(' ');

