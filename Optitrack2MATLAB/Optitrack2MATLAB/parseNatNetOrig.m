%**************************************************************************
%   File Name     : parseNatNet.m
%   Author        : IML, MSL, Dingjiang Zhou
%                   Boston University, Boston, 02215
%   Create Time   :  
%   Last Modified : Thu, Jun. 20th, 2013. 03:21:10 PM
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

rigidBodies = struct('ID', {}, 'SE3', {}, 'rigidMarkers', {}, 'meanError', {});
rigidBodies(1).rigidMarkers=struct('ID', {}, 'coords', {}, 'sizes', {});
rigidBodies(numRigidBodies).ID='';

%Process rigid bodies
for i = 1:numRigidBodies
	%Rigid body ID
	byteSize=4;
	rigidBodies(i).ID=double(typecast(data(dataIdx:dataIdx+byteSize-1), 'int32'));
	dataIdx=dataIdx+byteSize;
	
	%Rigid body state: [x y z], and [q1 q2 q3 q0]
	byteSize=4*7;
	rigidBodies(i).SE3=double(typecast(data(dataIdx:dataIdx+byteSize-1), 'single'));
	dataIdx=dataIdx+byteSize;

	%Number of rigid markers
	byteSize=4;
	numRigidMarkers=double(typecast(data(dataIdx:dataIdx+byteSize-1), 'int32'));
	dataIdx=dataIdx+byteSize;
	
	%Rigid marker data
	byteSize=numRigidMarkers*3*4;
	rigidBodies(i).rigidMarkers(1).coords=double(reshape(typecast(data(dataIdx:dataIdx+byteSize-1), 'single'),3,numRigidMarkers));
	dataIdx=dataIdx+byteSize;
	
	%Associated marker IDs
	byteSize=numRigidMarkers*4;
	rigidBodies(i).rigidMarkers.ID=double(typecast(data(dataIdx:dataIdx+byteSize-1), 'int32'));
	dataIdx=dataIdx+byteSize;
	
	%Associated marker byteSizes
	byteSize=numRigidMarkers*4;
	rigidBodies(i).rigidMarkers.sizes=double(typecast(data(dataIdx:dataIdx+byteSize-1), 'single'));
	dataIdx=dataIdx+byteSize;
    
    %Mean marker error
	byteSize=4;
	rigidBodies(i).meanError=double(typecast(data(dataIdx:dataIdx+byteSize-1), 'single'));
	dataIdx=dataIdx+byteSize;
	
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% THIS SECTION IS NOT USED (since it is for Skeletons? --zdj)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% even though, I never know if this section is used or not. 
% Associated marker IDs
% byteSize=4;
% numSkeletons=double(typecast(data(dataIdx:dataIdx+byteSize-1), 'int32'));
% dataIdx=dataIdx+byteSize;
% 
% for i=1:numSkeletons
% 	% OUT OF LAZINESS, I'M NOT DECODING HOW TO PARSE SKELETONS
% 	error('Skeletons parsing never programmed.')
% end
% 
% % Latency
% byteSize=4;
% latency=double(typecast(data(dataIdx:dataIdx+byteSize-1), 'single'));
% dataIdx=dataIdx+byteSize;
% 
% % End of data tag
% byteSize=4;
% eod=double(typecast(data(dataIdx:dataIdx+byteSize-1), 'single'));
% dataIdx=dataIdx+byteSize;

