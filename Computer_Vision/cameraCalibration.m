%--------------------------------------------------------------------------
%
% File Name:      cameraCalibration.m
% Date Created:   2014/02/13
% Date Modified:  2014/09/02
%
% Author:         Eric Cristofalo
% Contact:        eric.cristofalo@gmail.com
%
% Description:    Calculates the camera matrix for camera given  multiple 
%                 images of the checkerboard calibration square.
%
% Inputs:         cameraName: Name of the output .mat file
%
%                 folderPath: The path of the folder (as a string) 
%                    containing several images of the checkerboard 
%                    calibration pattern.
%                    This function assumes input file names take the format
%                       image01.jpg, IMG_0001.gif, IM1.bmp, etc.
%
%                 imageSize: [1x2] matrix containing the dimensions of the
%                    images (in pixels) in the following format
%                       [height, width]
%
%                 sensorSize: OPTIONAL [1x2] matrix containing the
%                    dimensions of the camera's sensors (in millimeters) in
%                    the following format
%                       [height, width]
%                    Function will not output S if this is left empty, =[]. 
%
% Outputs:        cam: Structure containing the following properties:
%                    cameraMatrix: [3x3] camera calibration matrix
%                    distCoeffs: [1x5] lens distortion coefficients
%                    d: scalar output reprojection error
%                    rvecs: {1xn} cell with n [3x1] rotation vectors
%                    tvecs: {1xn} cell with n [3x1] translation vectors
%                    rotations: {nx1} cell with n [3x3] rotation matrices
%                    camMatrixValues: structure containing:
%                       fovx: output field of view in degrees along the 
%                             horizontal sensor axis.
%                       fovy: output field of view in degrees along the 
%                             vertical sensor axis.
%                       focalLength: focal length of the lens in mm
%                       principalPoint: principal point in pixels
%                       aspectRatio: f_x/f_y
%
%                 folderPath.mat: A MATLAB document containing the 
%                    same properties saved in camera. Read this file into
%                    other scripts that require camera properties
%                       
% Example:        Example for an iPhone 4
%                    cameraName = 'iPhone4_Calibration';
%                    folderPath = '/User/username/Desktop/iPhoneCal_2014-02-13';
%                    imageSize = [1936, 2592];	% pixels
%                    sensorSize = [3.42, 4.54]; % mm
%
%                    cam = cameraCalibration(cameraName,folderPath,imageSize,sensorSize)
%
%--------------------------------------------------------------------------


%% Camera Calibration

function cam = cameraCalibration(cameraName,folderPath,imageSize,...
   sensorSize)

% Prepare calibration patterns
files = dir(fullfile(folderPath,'*.jpg'));
mesh_size = [6,8];
[mesh_x,mesh_y] = ndgrid(1:mesh_size(1),1:mesh_size(2));
mesh_coord = num2cell([mesh_x(:),mesh_y(:),zeros(numel(mesh_x),1)],2)';

% Find coordinates
pts_o = cell(1,numel(files));
pts = cell(1,numel(files));
% imSize = [imageSize(2),imageSize(1)];
for i = 1:numel(files)
   disp(['Processing Image: ',num2str(i)]);
   im = imread(fullfile(folderPath,files(i).name));
   imG = cv.cvtColor(im, 'RGB2GRAY');
   pts_1 = cv.findChessboardCorners(im, mesh_size);
   % Check for Poor Calibration Images
   if ~isempty(pts_1)
      pts{i} = cv.cornerSubPix(imG,pts_1);
      pts_o{i} = mesh_coord;
      corners = cv.drawChessboardCorners(im, mesh_size, pts{i});
      figure(1),imshow(corners);
      imName = files(i).name;
      title(['Image: ',imName])
   end
end

% Remove Empty Cell Entries From Poor Calibration Images
pts_o = pts_o((cellfun('isempty',pts_o)==0));
pts = pts((cellfun('isempty',pts)==0));

% Single Image Calibration
fprintf('\nCalculating the Camera Calibration Matrix\n');
[cam.cameraMatrix, cam.distCoeffs, cam.d, cam.rvecs, cam.tvecs] = ...
   cv.calibrateCamera(pts_o, pts, [imageSize(2),imageSize(1)]);
   % image size input is [w,h]

cam.rotations = cell(length(cam.rvecs),1);
for i = 1:length(cam.rvecs)
   cam.rotations{i} = cv.Rodrigues(cam.rvecs{i});
end

if ~isempty(sensorSize)
   apertureWidth = sensorSize(2);
   apertureHeight = sensorSize(1);
   cam.camMatrixValues = cv.calibrationMatrixValues(cam.cameraMatrix, imageSize,...
      apertureWidth, apertureHeight);
end

% Save Camera Calibration Variables
saveName = [folderPath,'/',cameraName,'.mat'];
save(saveName,'cam');

fprintf('\nCalibration Complete\n');

end


%% Testing

% cameraName = 'iPhone4_Calibration';
% folderPath = '/Users/ericcristofalo/Desktop/test';
% imageSize = [1936, 2592]; % pixels
% sensorSize = [3.42, 4.54]; % mm
% sensorSize = [];

