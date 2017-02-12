%--------------------------------------------------------------------------
%
% File Name:      postProcessing.m
% Date Created:   2014/04/07
% Date Modified:  2016/12/03
%
% Author:         Eric Cristofalo
% Contact:        eric.cristofalo@gmail.com
%
% Description:    Image Rectification Function Given Euler Angles
%                 Uses MATLAB's image processing function, maketform 
%
% Inputs:         im: input image
%                 K: camera calibration matrix
%                 rotations: vector of Euler angles (in radians)
%                            [phi,theta,psi]
%
% Outputs:        imRect: rectified image
%
% Example:        imRect = imRect([640x480x3],[3x3],[0;0.1;0.1])
%
%--------------------------------------------------------------------------

function imRect = imRectify(im,K,rotations)

rotationMatrix = rotMat(rotations(3),'z')*rotMat(rotations(2),'y')*...
   rotMat(rotations(1),'x');
homography = K*(rotationMatrix)*inv(K);
transformation = maketform('projective', homography'); % note: homography 
   % must be the transpose in order for MATLAB's transformation to work
imRect = imtransform(im,transformation);

end