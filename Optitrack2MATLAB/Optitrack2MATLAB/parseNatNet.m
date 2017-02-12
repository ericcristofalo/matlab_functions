%**************************************************************************
%   File Name     : parseNatNet.m
%   Author        : IML, MSL, Dingjiang Zhou
%                   Boston University, Boston, 02215
%   Create Time   :  
%   Last Modified : 2014/07/22 by Eric Cristofalo
%                   2016/05/06 by Eric Cristofalo to fix coordinate system for 
%                              new Optitrack software version 1.7+
%   Purpose       : This function parses the NatNet protocol. All returned 
%                   data is in 'double' format.
% NOTES: 
% THIS FILE SHOULD BE PROGRAMMED INTO C/MEX IN ORDER TO SAVE MORE
% CALCULATION TIME. -- ZDJ
%**************************************************************************
function [rigidBodies] = parseNatNet(data, bufferSize)

%Reset data index
dataIdx = 1;

% Message ID
byteSize = 2;
msgId = typecast(data(dataIdx:dataIdx+byteSize-1), 'int16');
dataIdx = dataIdx+byteSize;

if msgId ~= 7
	%OUT OF LAZINESS, I'M NOT DECODING HOW TO PARSE MESSAGE ID 7. ????
	error(['Message ID ~=7, instead is ' int2str(msgId) '.']);
end

%Byte count
byteSize = 2;
msgLength=double(typecast(data(dataIdx:dataIdx+byteSize-1), 'int16'));
dataIdx=dataIdx+byteSize;
if msgLength > bufferSize
	error(['Message is ', int2str(msgLength),...
        ' bytes long, which is bigger than buffer size! Increase buffer length.'])
end

%Frame #
byteSize = 4;
frameNum = double(typecast(data(dataIdx:dataIdx+byteSize-1), 'int32')); %THIS VALUE IS ALWAYS -1
dataIdx = dataIdx + byteSize;

%Number of markersets
byteSize = 4;
numMarkerSets=double(typecast(data(dataIdx:dataIdx+byteSize-1), 'int32'));
dataIdx = dataIdx + byteSize;
markerSets=struct('ID', {}, 'coords', {});
if numMarkerSets > 0
	markerSets(numMarkerSets).ID='';
end

for i=1:numMarkerSets
	%Markerset name
	byteSize=find(data(dataIdx:end)==0, 1, 'first');
	markerSets(i).ID=char(data(dataIdx:dataIdx+byteSize-1)');
	dataIdx=dataIdx+byteSize;
	
	%Num markers
	byteSize = 4;
	numMarkers=double(typecast(data(dataIdx:dataIdx+byteSize-1), 'int32'));
	dataIdx=dataIdx+byteSize;

	markerSets(i).coords=zeros(3,numMarkers);
	for j = 1:numMarkers
		byteSize = 4*3;
		markerSets(i).coords(:,j)=double(typecast(data(dataIdx:dataIdx+byteSize-1), 'single'));
		dataIdx=dataIdx+byteSize;
	end
end


%Unidentified markers
byteSize = 4;
numUnMarkers = double(typecast(data(dataIdx:dataIdx+byteSize-1), 'int32'));
dataIdx = dataIdx+byteSize;

%Unidentified marker position
unMarker = zeros(3,numUnMarkers);
for i = 1:numUnMarkers
	byteSize = 4*3;
	unMarker(:,i)=double(typecast(data(dataIdx:dataIdx+byteSize-1), 'single'));
	dataIdx=dataIdx+byteSize;
end

%Num rigid bodies
byteSize = 4;
numRigidBodies = double(typecast(data(dataIdx:dataIdx+byteSize-1), 'int32'));
dataIdx = dataIdx+byteSize;

% Initialize rigidBodies Structure
rigidBodies = struct('ID', zeros(1,numRigidBodies), 'SE3', zeros(7,numRigidBodies),...
                     'meanError', zeros(1,numRigidBodies));

%Process rigid bodies
for i = 1:numRigidBodies
	%Rigid body ID
	byteSize=4;
	rigidBodies.ID(:,i)=double(typecast(data(dataIdx:dataIdx+byteSize-1), 'int32'));
	dataIdx=dataIdx+byteSize;
	
	%Rigid body state: [x y z], and [q1 q2 q3 q0]
	byteSize=4*7;
	rigidBodies.SE3(:,i)=double(typecast(data(dataIdx:dataIdx+byteSize-1), 'single'));
	dataIdx=dataIdx+byteSize;
    
   %Number of rigid markers
	byteSize=4;
	numRigidMarkers=double(typecast(data(dataIdx:dataIdx+byteSize-1), 'int32'));
	dataIdx=dataIdx+byteSize;
    
   dataIdx = dataIdx + numRigidMarkers*20 + 4 +2; % added +2 fix for new Optitrack version
end

