%--------------------------------------------------------------------------
%
% File Name:      takeImage.m
% Date Created:   2014/07/22
% Date Modified:  2015/02/15
%
% Author:         Eric Cristofalo
% Contact:        eric.cristofalo@gmail.com
%
% Description:    Generates set of points in a virtual image given the 
%                 world coordinates of the points
%
% Inputs:         scenePoints: [4xn] output from generatePlane.m
%                 transformation: [4x4] transformation matrix of the form,
%                                 [R,-R*T; 0,0,0,1], where R is the 
%                                 3x3 rotation matrix from world to camera
%                                 coordinates and T is the position of the
%                                 camera in world coordinates.
%                 K: [3x3] camera calibration matrix
%                 imSize: [2x1] matrix with height and width of the desired
%                         output image.
%                         if size matrix is [0,0], the virtual image will
%                         be composed of image coordinates (world units)
%                         rather than pixels.
%
% Outputs:        pixelscenePoints: [4xn] array of points in the image scenePoints 
%                             with x,y pixel coordinates as well as the 
%                             corresponding unique ID number for each 
%                             point [x;y;1;ID].
%
% Example:        pixelPlane = takeImage(scenePoints, transformation, K, sizeIm);
%
%--------------------------------------------------------------------------

function pixelPlane = takeImage(scenePoints, transformation, K, imSize)

% World Coordinates to Camera Coordinates
ID = scenePoints(4,:);
scenePointsCoords = [scenePoints(1:3,:); ones(1,size(scenePoints,2))];
cameraPoints = transformation*scenePointsCoords;

% Ensure Image Points Lie In Front Of Camera
infrontCamera = cameraPoints(3,:)>0;
cameraPoints = cameraPoints(:,infrontCamera);
ID = ID(:,infrontCamera);

% Image Coordinates to Pixel Coordinates
pixelPlane = [K, [0;0;0]]*cameraPoints;

% Normalize Pixel Coordinates
N = size(pixelPlane,1);
for i=1:N
    pixelPlane(i,:) = pixelPlane(i,:) ./ pixelPlane(N,:);
end

% Ensure Pixels lie inside Image Size
if sum(imSize>0) % Only Normal Camera View
	inImage = (pixelPlane(1,:) >= 0) & (pixelPlane(1,:) <= imSize(2)) & ...
             (pixelPlane(2,:) >= 0) & (pixelPlane(2,:) <= imSize(1));
   pixelPlane = pixelPlane(:,inImage > 0);
   ID = ID(inImage > 0);
end

% Assign Final Pixel Array
pixelPlane = [pixelPlane;ID];

end

