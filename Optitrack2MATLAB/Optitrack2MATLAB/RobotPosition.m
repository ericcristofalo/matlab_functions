function position=RobotPosition()
% this function is used to get the coordination of the robot and the
% orientation of the robot from optitrack

%position is a 6 by 1 column vector, the first 3 entries are z x y
%coordinates(unit: meter) and the last 3 entris are the roll pitch and yaw
%(unit: radians);

% this function is written by Michael Marrazzo. Copyrights reserved.

trackedObjectID=1; %This corresponds to the Trackable ID set in Optitrack

%Create java socket
camIO.Socket = java.net.MulticastSocket(1511);
camIO.group = java.net.InetAddress.getByName('239.255.42.99');
camIO.Socket.joinGroup(camIO.group);

%Create a buffer to store the incoming data
camIO.buf = int8(zeros(1,1500));

%create an object to receive the data from the multicast stream
camIO.recv = java.net.DatagramPacket(camIO.buf, length(camIO.buf));

% Test sockets
display('Testing java socket to OptiTrack.')
warning('If this is taking more than 1 second, make you sure that OptiTrack is streaming data')

%Receive the data into a buffer
camIO.Socket.receive(camIO.recv)

%Pull the data from the buffer into a variable (column of bytes)
data = camIO.recv.getData();

%Parse data
[markerSets, rigidBodies]=parseNatNet_v2(data);

display('Java socket to OptiTrack cameras established.')

%Prepare the program persistent memory
finalTime=30*60; 
delT=1/120;
loopCnt=0;

Z_out=zeros(ceil(finalTime/delT),6);


%Receive the data into a buffer
camIO.Socket.receive(camIO.recv)
		
%Pull the data from the buffer into a variable (column of bytes)
data = camIO.recv.getData();
		
%Parse data
[markerSets, rigidBodies]=parseNatNet_v2(data);
		
for i=1:length(trackedObjectID)
    trackedRigidBodyID=find([rigidBodies.ID]==trackedObjectID(i));
	
	%Bookkeeping to bring TrackingTools coordinates into world frame
	xc=-rigidBodies(trackedRigidBodyID).SE3(3);
    yc=-rigidBodies(trackedRigidBodyID).SE3(1);
    zc=rigidBodies(trackedRigidBodyID).SE3(2);

    q1=rigidBodies(trackedRigidBodyID).SE3(4);
    q2=rigidBodies(trackedRigidBodyID).SE3(6); %NOTE: This is odd because of the messed up TrackingTools world axes, and the fact that according to the website it outputs left-hand data
    q3=rigidBodies(trackedRigidBodyID).SE3(5); %NOTE: This is odd because of the messed up TrackingTools world axes, and the fact that according to the website it outputs left-hand data
    q0=rigidBodies(trackedRigidBodyID).SE3(7);

    %Turn quaternions into Tait-Bryan angles
    r=atan2(2*q2*q3+2*q0*q1, q3^2-q2^2-q1^2+q0^2);
    p=-asin(2*q1*q3-2*q0*q2);
    y=atan2(2*q1*q2+2*q0*q3, q1^2+q0^2-q3^2-q2^2);

    SE3(:,i)=[xc; -yc; -zc; -p; r; -y]; %Prepare coordinates to NED, by replacing
    
    z=[SE3 zeros(size(SE3))];

    %Check if trackable is seen. If not, set data to NaN
    if ~any(SE3~=0)
        SE3=SE3+NaN; %Set data as NaN so that it doesn't show up in the plots\
    else
        z=[SE3 ones(size(SE3))];
    end
end


%save variables of interest
loopCnt=loopCnt+1;
Z_out(loopCnt,:)=z(:,1)';

%get the position
virtual_pos=z(:,1);
virtual_pos=[-virtual_pos(1);virtual_pos(2:5);-virtual_pos(6)];
position=virtual_pos;
%position=z(:,1)
% data format (unit: meter)
% x:   z(2,1);
% z: - z(1,1);
% y: - z(3,1);
% Rx:  z(5,1); (unit:radians)                 rotate about x axis
% Ry - z(6,1); yaw ranges from -pi to pi, that is, -180---180
% Rz - z(4,1)  

%Removes excess zeros
Z_out=Z_out(1:loopCnt,:);